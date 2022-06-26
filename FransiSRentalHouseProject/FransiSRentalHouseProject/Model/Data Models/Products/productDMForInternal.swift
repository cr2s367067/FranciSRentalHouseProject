//
//  productDM.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct ProductDM: Identifiable, Codable {
    @DocumentID var id: String?
    var providerUID: String
    var productUID: String
    var productName: String
    var productPrice: Int
    var productDescription: String
    var productFrom: String
    var productAmount: Int
    var isSoldOut: Bool
    var productType: String
    var coverImage: String
    @ServerTimestamp var postDate: Timestamp?
}

//    var productImageSet: [ProductImageSet]

struct ProductCommentRatting: Identifiable, Codable {
    @DocumentID var id: String?
    var productUID: String
    var providerUID: String
    var comment: String
    var ratting: Int
    var customerDisplayName: String
    @ServerTimestamp var uploadTimestamp: Timestamp?
}

struct ProductImageSet: Identifiable, Codable {
    @DocumentID var id: String?
    var productImageURL: String
}


struct CustomerMarkedProduct: Codable {
    @DocumentID var id: String?
    var isMark: Bool
    var providerUID: String
    var productUID: String
}
