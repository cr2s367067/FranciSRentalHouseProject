//
//  TextingDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct ChatUserUIDDataModel: Codable {
    let chatDocId: String
}

extension ChatUserUIDDataModel {
    static let empty = ChatUserUIDDataModel(chatDocId: "")
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
}

struct ChatCenterDataModel: Identifiable, Codable {
    var id: String?
    var contact1docID: String
    var contact2docID: String
}

struct MessageContainDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var sendingImage: String?
    var senderProfileImage: String?
    var senderDocID: String
    var text: String
    @ServerTimestamp var sendingTimestamp: Timestamp?
}
