//
//  TextingDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

//struct TextingDataModel: Identifiable, Codable {
//    @DocumentID var docID: String?
//    var id = UUID()
//    var textContain: String
//    @ServerTimestamp var sendingTimestamp: Timestamp?
//}

struct MessageTextingDataModel:Identifiable, Codable {
    @DocumentID var docID: String?
    var id = UUID()
    var receiveID: String
    var receiveDisplayName: String
    var senderUID: String
    var senderDisplayName: String
    var textContain: String
    @ServerTimestamp var sendingTimestamp: Timestamp?
}
