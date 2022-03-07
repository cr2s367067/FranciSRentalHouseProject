//
//  ContactDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/5/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct ContactDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var connectDescription: String?
}

extension ContactDataModel {
    static let empty = ContactDataModel(connectDescription: "")
}
