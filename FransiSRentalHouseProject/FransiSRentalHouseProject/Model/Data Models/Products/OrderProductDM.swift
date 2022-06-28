//
//  OrderProductDM.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

// MARK: - User have one order list that could contain different item

struct OrderedListUserSide: Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var orderDate: Timestamp?
    var orderUID: String
    var paymentMethod: String
    var shippingMethod: String
    var shippingAddress: String
    var subTotal: Int
}

// MARK: - Present item in list

struct OrderedItem: Identifiable, Codable {
    @DocumentID var id: String?
    var shippingStatus: String
    var providerUID: String
    var productUID: String
    var orderProductPrice: Int
    var productImage: String
    var productName: String
    var orderAmount: Int
}

// MARK: - Different provider could receive order from user by same orderUID

struct OrderedListProviderSide: Identifiable, Codable {
    @DocumentID var id: String?
    var orderUID: String
    var orderAmount: String
    var shippingStatus: String
    var shippingAddress: String
    var orderName: String
    var orderMobileNumber: String
    var orderPersonUID: String
    var shippingMethod: String
    @ServerTimestamp var createTimestamp: Timestamp?
}

struct OrderListContain: Identifiable, Codable {
    @DocumentID var id: String?
    var productUID: String
    var productName: String
    var productPrice: String
    var productImageURL: String
    var productOrderAmount: Int
    var isPrepare: Bool
}
