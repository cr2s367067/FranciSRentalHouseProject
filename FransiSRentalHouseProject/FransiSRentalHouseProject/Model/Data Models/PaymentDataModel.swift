//
//  PaymentDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/11.
//

import Foundation

enum EcPTest: String {
    case token = "3002607"
    case languageZH = "zh-TW"
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
