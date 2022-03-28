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
//    @DocumentID var id: String?
    var id = UUID()
    var furnitureImage: String
    var furnitureName: String
    var furniturePrice: Int
    var orderName: String?
    var orderShippingAddress: String?
}

struct FurnitureProviderDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var furnitureImage: String
    var furnitureName: String
    var furniturePrice: Int
    var productDescription: String
    var shippingFrom: String
    var providerName: String
}
