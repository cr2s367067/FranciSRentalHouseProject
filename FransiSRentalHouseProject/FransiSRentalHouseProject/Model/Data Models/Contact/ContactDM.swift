//
//  ContactDM.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct ContactDM: Identifiable, Codable {
    @DocumentID var id: String?
    var description: String
    @ServerTimestamp var sendDate: Timestamp?
}
