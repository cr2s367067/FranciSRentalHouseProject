//
//  FurnitureDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct FurnitureDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var furnitureImage: String
    var furnitureName: String
    var furniturePrice: Int
}
