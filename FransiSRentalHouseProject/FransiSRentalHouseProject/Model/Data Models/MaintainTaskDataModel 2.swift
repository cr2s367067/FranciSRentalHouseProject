//
//  MaintainTaskDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct MaintainTaskHolder: Identifiable, Codable {
    @DocumentID var id: String?
    var description: String
    var appointmentDate: Date
    var isFixed: Bool
    var itemImageURL: String
}

extension MaintainTaskHolder {
    static let empty = MaintainTaskHolder(description: "", appointmentDate: Date(), isFixed: false, itemImageURL: "")
}
