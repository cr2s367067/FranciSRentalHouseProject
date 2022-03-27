//
//  AnnouncementDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/27.
//

import Foundation
import FirebaseFirestoreSwift


struct AnnouncementDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var announcement: String?
}
