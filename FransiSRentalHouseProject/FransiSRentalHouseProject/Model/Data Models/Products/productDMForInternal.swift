//
//  productDM.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct ProductDM: Identifiable, Codable {
    @DocumentID var id: String?
    var providerUID: String
    var providerGUI: String
    var productUID: String
    var productName: String
    var productPrice: String
    var productDescription: String
    var productFrom: String
    var productAmount: String
    var isSoldOut: Bool
    var productType: String
    var coverImage: String
    @ServerTimestamp var postDate: Timestamp?
}

extension ProductDM {
    static let empty = ProductDM(
        providerUID: "",
        providerGUI: "",
        productUID: "",
        productName: "",
        productPrice: "",
        productDescription: "",
        productFrom: "",
        productAmount: "",
        isSoldOut: false,
        productType: "",
        coverImage: ""
    )

    static func productPublish(
        defaultWithInput source: ProductDM,
        providerUID: String,
        productUID: String
    ) -> ProductDM {
        return ProductDM(
            providerUID: providerUID,
            providerGUI: source.providerGUI,
            productUID: productUID,
            productName: source.productName,
            productPrice: source.productPrice,
            productDescription: source.productDescription,
            productFrom: source.productFrom,
            productAmount: source.productAmount,
            isSoldOut: false,
            productType: source.productType,
            coverImage: ""
        )
    }
}

//    var productImageSet: [ProductImageSet]

struct ProductCommentRatting: Identifiable, Codable {
    @DocumentID var id: String?
    var productUID: String
    var providerUID: String
    var comment: String
    var ratting: Int
    var uploadUserID: String
    var customerDisplayName: String
    @ServerTimestamp var uploadTimestamp: Timestamp?
}

extension ProductCommentRatting {
    static let empty = ProductCommentRatting(
        productUID: "",
        providerUID: "",
        comment: "",
        ratting: 0,
        uploadUserID: "",
        customerDisplayName: ""
    )
}

struct ProductImageSet: Identifiable, Codable {
    @DocumentID var id: String?
    var productImageURL: String
    @ServerTimestamp var uploadTime: Timestamp?
}

struct CustomerMarkedProduct: Codable {
    @DocumentID var id: String?
    var isMark: Bool
    var providerUID: String
    var productUID: String
}

// MARK: - Local product cart

struct ProductCartDM: Identifiable, Codable {
    var id = UUID()
    var product: ProductDM
    var orderAmount: Int
}

extension ProductCartDM {
    static let empty = ProductCartDM(product: .empty, orderAmount: 1)
}


//MARK: - Store sold item

class SoldProductDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var soldDate: Timestamp?
    var productName: String
    var productUID: String
    var buyerUID: String
    var productPrice: Int
    var soldAmount: Int
    
    
    init(
        id: String? = nil,
        soldDate: Timestamp? = nil,
        productName: String,
        productUID: String,
        buyerUID: String,
        productPrice: Int,
        soldAmount: Int
    ) {
        self.id = id
        self.soldDate = soldDate
        self.productName = productName
        self.productUID = productUID
        self.buyerUID = buyerUID
        self.productPrice = productPrice
        self.soldAmount = soldAmount
    }
}

extension SoldProductDataModel {
    static let empty = SoldProductDataModel(
        productName: "",
        productUID: "",
        buyerUID: "",
        productPrice: 0,
        soldAmount: 0
    )
}


