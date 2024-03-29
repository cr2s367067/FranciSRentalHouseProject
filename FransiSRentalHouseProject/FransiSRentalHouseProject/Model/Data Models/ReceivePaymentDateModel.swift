//
//  ReceivePaymentDateModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/13.
//

import Foundation
import FirebaseFirestoreSwift

struct ReceivePaymentDateModel: Identifiable, Codable {
    @DocumentID var id: String?
    var isSettle: Bool
    var isFetchHistoryData: Bool
    var settlementDate: Date
    var settlementAmount: Int
}
