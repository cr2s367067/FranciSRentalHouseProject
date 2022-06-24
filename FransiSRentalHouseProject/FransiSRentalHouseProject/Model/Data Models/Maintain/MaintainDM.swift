//
//  MaintainDM.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MaintainDM: Identifiable, Codable {
    @DocumentID var id: String?
    var maintainDescription: String
    var appointmentDate: Date
    var itemImageURL: String
    var isFixed: Bool
    @ServerTimestamp var publishDate: Timestamp?
}
