//
//  PurchaseUserDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

<<<<<<< HEAD
//MARK: - User make, cancel, update order
struct PurchasedUserDataModel:Identifiable, Codable {
=======
struct PurchasedUserDataModel: Identifiable, Codable {
>>>>>>> PodsAdding
    @DocumentID var id: String?
    var userName: String
    var userMobileNumber: String
    var userAddress: String
    var shippingStatus: String
    var shippingMethod: String
    var paymentStatus: String
    var subTotal: Int
    var userUidPath: String
    @ServerTimestamp var createTimestamp: Timestamp?
}

//MARK: - fetch order data provider side
struct PurchasedOrdedProductDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var productImageURL: String
    var productName: String
    var productPrice: Int
    var orderAmount: String
    @ServerTimestamp var createTimestamp: Timestamp?
}

<<<<<<< HEAD

//MARK: - fetch order data user side
=======
>>>>>>> PodsAdding
struct OrderedDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var orderID: String
    var orderDate: Date
    var shippingAddress: String
    var paymentStatus: String
    var subTotal: Int
    var shippingStatus: String
    var providerUID: String
    var productUID: String
    var orderAmount: String
}
