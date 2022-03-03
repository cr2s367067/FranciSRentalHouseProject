//
//  SummaryItemDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI


struct SummaryItemHolder: Identifiable, Codable {
    var id = UUID()
    var itemName: String
    var itemPrice: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case itemName
        case itemPrice
    }
}
