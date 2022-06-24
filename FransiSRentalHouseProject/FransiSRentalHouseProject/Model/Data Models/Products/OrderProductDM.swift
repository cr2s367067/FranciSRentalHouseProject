//
//  OrderProductDM.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


//MARK: - User have one order list that could contain different item
struct OrderedListUserSide: Identifiable, Codable {
    @DocumentID var id: String?
    var orderUID: String
    @ServerTimestamp var orderDate: Timestamp?
    var paymentMetho: String
    var subTotal: Int
}

//MARK: - Present item in list
struct OrderedItem: Codable {
    var shippingStatus: String
    var providerUID: String
    var productUID: String
    var orderProductPrice: Int
    var orderAmount: Int
}

//MARK: - Different provider could receive order from user by same orderUID
struct OrderedListProviderSide: Identifiable, Codable {
    @DocumentID var id: String?
    var orderUID: String
    var productUID: String
    var orderAmount: String
    var shippingStatus: String
}
