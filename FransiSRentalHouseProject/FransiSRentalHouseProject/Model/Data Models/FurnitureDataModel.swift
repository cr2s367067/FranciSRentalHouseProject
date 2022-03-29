//
//  FurnitureDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

//MARK: For user to order products
struct FurnitureDataModel: Identifiable, Codable {
//    @DocumentID var id: String?
    var id = UUID()
    var furnitureImage: String
    var furnitureName: String
    var furniturePrice: Int
    var orderName: String?
    var orderShippingAddress: String?
    @ServerTimestamp var buyDate: Timestamp?
}


//MARK: For provider to upload their product
struct ProductProviderDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var productUID: String
    var productImage: String
    var productName: String
    var productPrice: String
    var productDescription: String
    var productFrom: String
    var providerName: String
    var providerUID: String
    var productAmount: String
    var isSoldOut: Bool
}


//MARK: For user to provider their comment
struct ProductUsingCommentDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var user: String
    var comment: String
    var rating: String
}
