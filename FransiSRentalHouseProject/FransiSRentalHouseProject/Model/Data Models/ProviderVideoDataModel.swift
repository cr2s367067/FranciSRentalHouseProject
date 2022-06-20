//
//  ProviderVideoDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct ProviderVideoDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var uploadDate: Timestamp?
    var providerUID: String
    var providerProfileImageURL: String
    var providerDisplayName: String
}
