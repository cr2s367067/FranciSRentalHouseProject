//
//  ProductSoldCollectionDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/2.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class ProductSoldCollectionDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var soldDate: Timestamp?
    var productName: String
    var productPrice: Int
    var soldAmount: Int
}
