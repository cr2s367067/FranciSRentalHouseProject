//
//  PastedPaymentHistoryDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/27.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PastedPaymentHistoryDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var paidRentalPrice: String
    @ServerTimestamp var paymentDate: Timestamp?
}
