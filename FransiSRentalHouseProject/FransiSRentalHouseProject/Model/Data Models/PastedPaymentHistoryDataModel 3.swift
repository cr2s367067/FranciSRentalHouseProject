//
//  PastedPaymentHistoryDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/27.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct PastedPaymentHistoryDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var paidRentalPrice: String
    @ServerTimestamp var paymentDate: Timestamp?
}
