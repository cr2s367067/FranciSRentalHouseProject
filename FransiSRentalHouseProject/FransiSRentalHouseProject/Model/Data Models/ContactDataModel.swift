//
//  ContactDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/5/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore

struct ContactDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var contactDescription: String
    @ServerTimestamp var sentDate: Timestamp?
}

extension ContactDataModel {
    static let empty = ContactDataModel(contactDescription: "")
}
