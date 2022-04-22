//
//  PurchaseUserDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct PurchasedUserDataModel:Identifiable, Codable {
    @DocumentID var id: String?
    var userName: String
    var userMobileNumber: String
    var userAddress: String
    var shippingStatus: String
    var shippingMethod: String
    var paymentStatus: String
    @ServerTimestamp var createTimestamp: Timestamp?
}

struct PurchasedOrdedProductDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var productImageURL: String
    var productName: String
    var productPrice: Int
    var orderAmount: String
    @ServerTimestamp var createTimestamp: Timestamp?
}
