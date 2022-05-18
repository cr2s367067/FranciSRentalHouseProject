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

    let ecp = ECPayPaymentGatewayManager()
    
    func computePaymentMonth(from currentDate: Date) -> Date {
        let cal = Calendar.current
        let oneMonth: Double = (60*60*24)*30
        let currentDateAddOneMonth = cal.dateComponents([.year, .month, .day], from: currentDate.addingTimeInterval(oneMonth))
        return cal.date(from: currentDateAddOneMonth) ?? Date()
    }
    
    func testEcFunc() {
        
    }
    
    
    
}
