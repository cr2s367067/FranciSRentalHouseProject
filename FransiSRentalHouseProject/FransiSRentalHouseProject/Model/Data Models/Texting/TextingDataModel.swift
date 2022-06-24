//
//  TextingDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift



struct ChatUserUIDDataModel: Codable {
    let chatDocId: String
    let userToken: String
}
extension ChatUserUIDDataModel {
    static let empty = ChatUserUIDDataModel(chatDocId: "", userToken: "")
}

struct ChatUserInfoDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var senderMailUidPath: String
    var senderDisplayName: String
    var senderProfileImage: String
//    var chatRoomUID: String
}

extension ChatUserInfoDataModel {
    static let empty = ChatUserInfoDataModel(senderMailUidPath: "", senderDisplayName: "", senderProfileImage: "")
}

struct ContactUserDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var contacterMailUidPath: String
    var contacterPlayName: String
    var contacterProfileImage: String
    var chatRoomUID: String
    @ServerTimestamp var lastMessageTimestamp: Timestamp?
}



struct ChatCenterDataModel: Codable {
    var contact1docID: String
    var contact2docID: String
}

extension ChatCenterDataModel {
    static let empty = ChatCenterDataModel(contact1docID: "", contact2docID: "")
}

struct MessageContainDataModel:Identifiable, Codable {
    @DocumentID var id: String?
    var sendingImage: [String]?
    var senderProfileImage: String?
    var senderDocID: String
    var contactWith: String
    var text: String
    @ServerTimestamp var sendingTimestamp: Timestamp?
}
