//
//  RoomCommentAndRattingDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/1.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct RoomCommentAndRattingDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var isPost: Bool
    var userDisplayName: String
    var trafficRate: Int
    var convenienceRate: Int
    var pricingRate: Int
    var neighborRate: Int
    var comment: String
    @ServerTimestamp var postTimestamp: Timestamp?
}

extension RoomCommentAndRattingDataModel {
    static let empty = RoomCommentAndRattingDataModel(isPost: false, userDisplayName: "", trafficRate: 0, convenienceRate: 0, pricingRate: 0, neighborRate: 0, comment: "")
}
