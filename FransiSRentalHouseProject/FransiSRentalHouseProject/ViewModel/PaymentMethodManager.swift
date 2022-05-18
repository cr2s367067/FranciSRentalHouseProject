//
//  PaymentMethodManager.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/11.
//

import Foundation
import ECPayPaymentGatewayKit

enum PaymentProcessStatus {
    case payMonthlyRentalBill
    case rentRoom
    case rentRoomAndBuyProduct
    case payProductBill
}


class PaymentMethodManager: ObservableObject {

    let ecp = ECPayPaymentGatewayManager.sharedInstance()
    
    
//    func createPayment(token: EcPTest) {
//        ecp.createPayment(token: token.rawValue, merchantID: token.rawValue, useResultPage: 1, appStoreName: "Test Store", language: "zh-TW") { callBack in
//            if let state = callBack as? CreatePaymentCallbackState {
//                print("rtnCode: \(state.RtnCode)")
//                print(state.OrderInfo ?? "no data")
//            }
//            switch callBack.callbackStateStatus {
//            case .Fail:
//                print("fail")
//            case .Success:
//                print("success")
//            case .Cancel:
//                print("cancel")
//            case .Exit:
//                print("exit")
//            case .Unknown:
//                print("unknown issue")
//            }
//        }
//    }
    
//    func test() {
//        ecp.testToGetTestingTradeToken(paymentUIType: <#T##Int#>, is3D: <#T##Bool#>, merchantID: <#T##String#>, aesKey: <#T##String#>, aesIV: <#T##String#>, parameters: <#T##[String : Any]?#>, callback: <#T##CallbackFunction##CallbackFunction##(CallbackState) -> Void#>)
//    }
    
 
    
    func computePaymentMonth(from currentDate: Date) -> Date {
        let cal = Calendar.current
        let oneMonth: Double = (60*60*24)*30
        let currentDateAddOneMonth = cal.dateComponents([.year, .month, .day], from: currentDate.addingTimeInterval(oneMonth))
        return cal.date(from: currentDateAddOneMonth) ?? Date()
    }
    
    
    
}
