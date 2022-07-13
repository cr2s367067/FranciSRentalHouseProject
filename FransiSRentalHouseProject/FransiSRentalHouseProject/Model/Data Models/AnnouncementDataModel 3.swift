//
//  AnnouncementDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/27.
//

import FirebaseFirestoreSwift
import Foundation

struct AnnouncementDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var announcement: String?
}
