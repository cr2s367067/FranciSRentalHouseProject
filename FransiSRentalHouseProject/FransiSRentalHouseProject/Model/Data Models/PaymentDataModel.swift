//
//  PaymentDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/11.
//

import Foundation
import CryptoKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HTTPContent: String {
    case contentType = "application/json"
}

enum EnvPath: String {
    case realEnv = "https://ecpg.ecpay.com.tw/Merchant/GetTokenbyTrade"
    case testEnv = "https://ecpg-stage.ecpay.com.tw/Merchant/GetTokenbyTrade/"
}

enum RememberCard: Int {
    case no = 0
    case yes = 1
}

enum PaymentUIType: Int {
    case creditCardAmountSplit = 0
    case paymentChosingList = 2
}

enum ChosePaymentList: String {
    case allMethod = "0"
    case creditOncetime = "1"
    case creditSplit = "2"
    case applePay = "7"
}

enum Redeem: String {
    case notUse = "0"
    case user = "1"
}

enum PeriodType: String {
    case day = "D"
    case month = "M"
    case year = "Y"
}

struct PaymentDataModel: Codable {
    //MARK: For credit card payment data
    var providerUID: String
    var cardName: String
    var cardNumber: Int
    var cvs: Int
    var exp: String
}

/*
 1. initial sdk()
 2. initial data
 3. call provider token --> our token
 4. auth provider token
 5. get provider token
 6. create payment
 7. init payment view
 8. create trade
 9. trading 3d authentication
 10. go 3d authenticaiton view
 11. authenticate
 12. send auth result to bank
 13. show payment result
 14. createPayment call back
 15. send received result to provider
*/

//: MARK: - General
struct GerenalDataModel: Codable {
    var MerchantID: String
    var RqHeader: RqHeaderDM?
    var Data: String
}

extension GerenalDataModel {
    static let empty = GerenalDataModel(MerchantID: "", RqHeader: RqHeaderDM(Timestamp: 0, Revision: ""), Data: "")
}

//MARK: - ServerIdentity

struct RqHeaderDM: Codable {
    var Timestamp: Int
    var Revision: String
}

struct DataDM: Codable {
    var MerchantID: String
    var RememberCard: Int?
    var PaymentUIType: Int?
    var ChosePaymentList: [String]?
    var OrderInfo: [OrderInfoDM]?
    var CardInfo: [CardInfoDM]?
    var ConsumerInfo: [ConsumerInfoDM]
}

struct OrderInfoDM: Codable {
    var MerchantTradeDate: String
    var MerchantTradeNo: String
    var TotalAmount: Int
    var ReturnURL: String
    var TradeDesc: String
    
    //Split by #
    var ItemName: String
}

struct CardInfoDM: Codable {
    var Redeem: String?
    var PeriodAmount: Int?
    var PeriodType: String?
    
    /*
     至少要大於等於 1 次以上。
     當 PeriodType 設為 D 時，最多可設 1~365(天)。
     當 PeriodType 設為 M 時，最多可設 1~12 (月)。
     當 PeriodType 設為 Y 時，最多可設 1。
    */
    var Frequency: Int?
    
    /*
     至少要大於 1 次以上。
     當 PeriodType 設為 D 時，最多可設 999 次。
     當 PeriodType 設為 M 時，最多可設 99 次。
     當 PeriodType 設為 Y 時，最多可設 9 次。
    */
    var ExecTimes: Int?
    var OrderResultURL: String
    var PeriodReturnURL: String?
    var CreditInstallment: String?
    var FlexibleInstallment: String?
}

struct ConsumerInfoDM: Codable {
    var MerchantMemberID: String?
    var Email: String?
    var Phone: String?
    var Name: String?
    var CountryCode: String?
    var Address: String?
}

//MARK: - Delete Credit Card

//struct DataDM: Codable {
//    var MerchantID: String
//    var ConsumerInfo: [ConsumerInfoDM]
//}

//MARK: - Return Server Data
struct ReturnServerDM: Codable {
    var MerchantID: String
    var RqHeader: [ReturnRqHeaderDM]
    var TransCode: Int
    var TransMsg: String
    var Data: String
}

extension ReturnServerDM {
    static let empty = ReturnServerDM(MerchantID: "", RqHeader: [ReturnRqHeaderDM(Timestamp: 0)], TransCode: 0, TransMsg: "", Data: "")
}

struct ReturnRqHeaderDM: Codable {
    var Timestamp: Int
}

struct ReturnDataDM: Codable {
    var RtnCode: Int
    var RtnMsg: String
    var MerchantID: String
    var Token: String
    var TokenExpireDate: String
}
