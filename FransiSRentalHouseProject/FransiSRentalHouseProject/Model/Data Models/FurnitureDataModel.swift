//
//  FurnitureDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI

struct FurnitureDataModel: Identifiable, Codable {
    var id = UUID()
    var furnitureImage: String
    var furnitureName: String
    var furniturePrice: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case furnitureImage
        case furnitureName
        case furniturePrice
    }
}
