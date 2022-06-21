//
//  ProductsDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

//MARK: For user to add the product in loacl cart
struct UserOrderProductsDataModel: Identifiable, Codable {
    @DocumentID var id = UUID().uuidString
    var productImage: String
    var productName: String
    var productPrice: Int
    var providerUID: String
    var productUID: String
    var orderAmount: String
    var comment: String
    var isUploadComment: Bool
    var ratting: Int
    @ServerTimestamp var buyDate: Timestamp?
}


//MARK: For provider to upload their product
struct ProductProviderDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var postDate: Timestamp?
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
    var productType: String
}

extension ProductProviderDataModel {
    static let empty = ProductProviderDataModel(productUID: "", productImage: "", productName: "", productPrice: "", productDescription: "", productFrom: "", providerName: "", providerUID: "", productAmount: "", isSoldOut: false, productType: "")
}

struct ProductProviderImageDateModel: Identifiable, Codable {
    @DocumentID var id = UUID().uuidString
    var productDetialImage: String
    @ServerTimestamp var uploadTime: Timestamp?
}

struct ProductProviderIntroVideoDataModel: Codable {
    var videoURL: String
}

extension ProductProviderIntroVideoDataModel {
    static let empty = ProductProviderIntroVideoDataModel(videoURL: "")
}

//MARK: For provider to track who ordered products
//struct ProductsOrderedDataModel: Identifiable, Codable {
//    @DocumentID var id: String?
//    var productUID: String
//    var productImage: String
//    var productName: String
//    var productPrice: String
//    var orderAmount: String
//    var orderName: String
//    var orderShippingAddress: String
//    var orderUID: String
//    @ServerTimestamp var buyDate: Timestamp?
//}

//MARK: For provider to show user's comment
//struct ProductCommentRecivingDataModel: Identifiable, Codable {
//    @DocumentID var id: String?
//    var buyerUID: String
//    var buyDisplayName: String
//    var comment: String
//    var rating: String
//    var productUID: String
//}

//MARK: To store the bookmark temperary
struct MarkedProductsDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var productUID: String
    var providerUID: String
    var productName: String
    var productPrice: String
    var productImage: String
    var productFrom: String
    var isSoldOut: Bool
    var productAmount: String
    var productDescription: String
    var providerName: String
}


//MARK: Store information for each store and presneting in searchview
struct StoreDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var provideBy: String
    var providerDisplayName: String
    var providerProfileImage: String
    var providerDescription: String
//    var providerCredit: Int
    var storeBackgroundImage: String
    var storeChatDocID: String
    
}

extension StoreDataModel {
    static let empty = StoreDataModel(provideBy: "", providerDisplayName: "", providerProfileImage: "", providerDescription: "", storeBackgroundImage: "", storeChatDocID: "")
}

//MARK: Store the comment and rating in provider side
struct ProductCommentRattingDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var comment: String
    var ratting: Int
    var summitUserDisplayName: String
    @ServerTimestamp var uploadTimestamp: Timestamp?
}
