//
//  PaymentMethodManager.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/11.
//

import Foundation
import ECPayPaymentGatewayKit
import Alamofire
import CryptoSwift

enum PaymentProcessStatus {
    case payMonthlyRentalBill
    case rentRoom
    case rentRoomAndBuyProduct
    case payProductBill
}

class PaymentMethodManager: ObservableObject {
    
    @Published var testToken = ""
    
    @Published var serverToken: ReturnServerDM = .empty
    
    @Published var getResultHolder = ""

    let ecp = ECPayPaymentGatewayManager.sharedInstance()
    
    func test() {
        let encodeHashKey = "pwFHCqoQZGmho4w6"
        let hasKey: [UInt8] = Array(encodeHashKey.utf8)
        print("hasKey: \(hasKey)")
        let encodeHashIV = "EkRm7iFT261dpevs"
        let hashIV: [UInt8] = Array(encodeHashIV.utf8)
        print("hashIV: \(hashIV)")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let testData: DataDM = DataDM(MerchantID: "3002607",
                                  ConsumerInfo: [ConsumerInfoDM(Email: "testuser@test.com",
                                                                Phone: "886987878787",
                                                                Name: "test",
                                                                CountryCode: "",
                                                                Address: "test")])
        let encodeData = try! encoder.encode(testData)
//        print(String(data: encodeData, encoding: .utf8)!)
        let convertString = String(data: encodeData, encoding: .utf8)
        guard let convertURLencode = convertString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
//        let convertStringInData = Data(convertURLencode.utf8)
        let convertStringInArray: [UInt8] = Array(convertURLencode.utf8)
        guard let encryptAES = try? AES(key: hasKey, blockMode: CBC(iv: hashIV), padding: .pkcs7) else {
            print("fail to build aes")
            return
        }
        guard let encryptData = try? encryptAES.encrypt(convertStringInArray) else {
            print("fail to encrypt")
            return
        }
        print("encrypt result: \(encryptData.toBase64())")
        let encrypt64String = encryptData.toBase64()
        let encrypt64StringToData = Data(base64Encoded: encrypt64String) ?? Data()
        guard let decryptData = try? encryptAES.decrypt(encrypt64StringToData.bytes) else { return }
        let deConveretString = String(decoding: decryptData, as: UTF8.self)
        print("decrypt result: \(deConveretString)")
        let deConvertURL = deConveretString.removingPercentEncoding
        print("final result: \(String(describing: deConvertURL))")
    }
    
    func decryptData(inputBase64: String) -> String {
        var holdingData = ""
        let encodeHashKey = "pwFHCqoQZGmho4w6"
        let hasKey: [UInt8] = Array(encodeHashKey.utf8)
        print("hasKey: \(hasKey)")
        let encodeHashIV = "EkRm7iFT261dpevs"
        let hashIV: [UInt8] = Array(encodeHashIV.utf8)
        print("hashIV: \(hashIV)")
//        let jsonDecoder = JSONDecoder()
        do {
            let encrypt64Data = Data(base64Encoded: inputBase64) ?? Data()
            let aes = try AES(key: hasKey, blockMode: CBC(iv: hashIV), padding: .pkcs7)
            let decryptData = try aes.decrypt(encrypt64Data.bytes)
            let decryptString = String(decoding: decryptData, as: UTF8.self)
            holdingData = decryptString.removingPercentEncoding ?? ""
            print("get decode data: \(holdingData)")
        } catch {
            print("fail to decrypt")
        }
        return holdingData
    }
    
    func encryptData(rememberCard: RememberCard, paymentUIT: PaymentUIType, orderInfo: OrderInfoDM, cardInfo: CardInfoDM, consumerInfo: ConsumerInfoDM) -> String {
        var base64 = ""
        var chosePL = [String]()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if paymentUIT == .paymentChosingList {
            let paymentMethod = ["1", "2", "7"]
            chosePL = paymentMethod
        } else {
            chosePL = ["0"]
        }
        let encodeHashKey = "pwFHCqoQZGmho4w6"
        let hasKey: [UInt8] = Array(encodeHashKey.utf8)
        let encodeHashIV = "EkRm7iFT261dpevs"
        let hashIV: [UInt8] = Array(encodeHashIV.utf8)
        let currentDate = Date().getFormatterDate(format: "yyyy-mm-dd HH:mm:ss")
        let datas: DataDM = DataDM(MerchantID: "3002607",
                                  RememberCard: 0,
                                  PaymentUIType: 2,
                                  ChosePaymentList: chosePL,
                                  OrderInfo: [OrderInfoDM(MerchantTradeDate: currentDate,
                                                          MerchantTradeNo: "3002607",
                                                          TotalAmount: 500,
                                                          ReturnURL: "",
                                                          TradeDesc: "test",
                                                          ItemName: "test")],
                                  CardInfo: [CardInfoDM(Redeem: "0",
                                                        OrderResultURL: "https://www.ecpay.com.tw",
                                                        CreditInstallment: "3")],
                                  ConsumerInfo: [ConsumerInfoDM(Email: "testuser@test.com",
                                                                Phone: "886987878787",
                                                                Name: "test",
                                                                CountryCode: "158",
                                                                Address: "testAddress")])
        
        /*
         DataDM(MerchantID: "3002607",
                                   RememberCard: rememberCard.rawValue,
                                   PaymentUIType: paymentUIT.rawValue,
                                   ChosePaymentList: chosePL,
                                   OrderInfo: [OrderInfoDM(MerchantTradeDate: orderInfo.MerchantTradeDate,
                                                           MerchantTradeNo: orderInfo.MerchantTradeDate,
                                                           TotalAmount: orderInfo.TotalAmount,
                                                           ReturnURL: orderInfo.ReturnURL,
                                                           TradeDesc: orderInfo.TradeDesc,
                                                           ItemName: orderInfo.ItemName)],
                                   CardInfo: [CardInfoDM(OrderResultURL: "")],
                                   ConsumerInfo: [ConsumerInfoDM(Email: "testuser@test.com",
                                                                 Phone: "886987878787",
                                                                 Name: "test",
                                                                 CountryCode: "",
                                                                 Address: "test")])
        */
        do {
            let jsonEncode = try encoder.encode(datas)
            guard let convertJsonString = String(data: jsonEncode, encoding: .utf8) else { return ""}
            guard let urlEncode = convertJsonString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return ""}
            let convertStringInUint8Array: [UInt8] = Array(urlEncode.utf8)
            let aes = try AES(key: hasKey, blockMode: CBC(iv: hashIV), padding: .pkcs7)
            let encryptData = try aes.encrypt(convertStringInUint8Array)
            print("base64: \(encryptData.toBase64())")
            base64 = encryptData.toBase64()
        } catch {
            print("error occure")
        }
        return base64
    }
    
    func callServerToken(envPath: EnvPath, httpMethod: HTTPMethod, httpContent: HTTPContent, rememberCard: RememberCard, paymentUIT: PaymentUIType, orderInfo: OrderInfoDM, cardInfo: CardInfoDM, consumerInfo: ConsumerInfoDM) async throws {
        print("start to get server token")
        guard let url = URL(string: envPath.rawValue) else {
            return
        }
        print("getting url: \(url.absoluteString)")
        let date = Date()
        let unixTime: Int = Int(date.timeIntervalSince1970)
        print("unitTimestamp: \(unixTime)")
        let currentVersion = "1.3.24"
        print("current version: \(currentVersion)")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
//        let header: HTTPHeaders = ["Content-Type" : httpContent.rawValue]
//        var request = try URLRequest(url: url.asURL(), method: .post, headers: header)
        do {
            var request = URLRequest(url: url)
//            request.httpMethod = httpMethod.rawValue
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            print("Start to encrypt data")
            let encodeData = encryptData(rememberCard: rememberCard, paymentUIT: paymentUIT, orderInfo: orderInfo, cardInfo: cardInfo, consumerInfo: consumerInfo)
            let rawBody: GerenalDataModel = GerenalDataModel(MerchantID: "3002607",
                                                          RqHeader: RqHeaderDM(Timestamp: unixTime,
                                                                               Revision: currentVersion),
                                                          Data: encodeData)
            let encodeDataInJson = try encoder.encode(rawBody) 
            print("Convert json result: \(String(describing: String(data: encodeDataInJson, encoding: .utf8)))")
            let (data, response) = try await URLSession.shared.upload(for: request, from: encodeDataInJson)
            let hResponse = response as? HTTPURLResponse
            print(hResponse?.statusCode ?? 0)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw ECpayAPIError.invalidServerResponse
            }
            request.httpBody = data
            print("post complete...!!")
            try await getServerToken(url: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func testapi() {
        ecp.testToGetTestingUserToken(merchantID: "3002607", aesKey: "pwFHCqoQZGmho4w6", aesIV: "EkRm7iFT261dpevs") { state in
            let callState = state.callbackStateStatus
            let state_ = state as! TestingTokenCallbackState
            
            switch callState {
            case .Fail:
                print(state.callbackStateMessage)
            case .Success:
                self.testToken = state_.Token
                print(self.testToken)
                if let state2 = state as? CreatePaymentCallbackState {
                    print("state2: \(state2)")
                }
            case .Cancel:
                print("Cancel")
            case .Exit:
                print("Exit")
            case .Unknown:
                print("unknow error")
            @unknown default:
                print("unknow error")
            }
        }
    }
    
    func createPayment(token: String, merchantID: String, language: Language) {
        ecp.createPayment(token: token, merchantID: merchantID, useResultPage: 1, appStoreName: "Testing Store", language: language.rawValue) { callback in
            let callbackStatus = callback.callbackStateStatus
            let state_ = callback as? CreatePaymentCallbackState
            if let card = state_?.CardInfo {
                print("\(card)")
            }
            switch callbackStatus {
            case .Success:
                print("success")
//                CreatePaymentCallbackState_CardInfoResponseModel(MerchantTradeNo: "", TradeNo)
                
            case .Fail:
                print("fail")
            case .Cancel:
                print("cancel")
            case .Exit:
                print("exit")
            case .Unknown:
                print("unkown")
            @unknown default:
                fatalError("Unknown fatal error")
            }
        }
    }
    
    
    
    
    @MainActor
    func getServerToken(url: URL) async throws {
//        var request = try URLRequest(url: url)
//        request.httpMethod = httpMethod.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ECpayAPIError.invalidServerResponse
        }
//        guard let jsonData = data else {
//            throw ECpayAPIError.invalidFetchingJsonData
//        }
        print("Start to decode json: \(data)")
        print(String(decoding: data, as: UTF8.self))
        getResultHolder = String(decoding: data, as: UTF8.self)
//        if let decodeResponse = try? JSONDecoder().decode(ReturnServerDM.self, from: data) {
//            print("receive data: \(decodeResponse)")
//            let encryptData = decodeResponse.Data
//            let tempHolding = decryptData(inputBase64: encryptData)
//            print(tempHolding.removingPercentEncoding ?? "")
//        }
    }
    
    func computePaymentMonth(from currentDate: Date) -> Date {
        let cal = Calendar.current
        let oneMonth: Double = (60*60*24)*30
        let currentDateAddOneMonth = cal.dateComponents([.year, .month, .day], from: currentDate.addingTimeInterval(oneMonth))
        return cal.date(from: currentDateAddOneMonth) ?? Date()
    }
    
    
    
}


extension Date {
    func getFormatterDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
