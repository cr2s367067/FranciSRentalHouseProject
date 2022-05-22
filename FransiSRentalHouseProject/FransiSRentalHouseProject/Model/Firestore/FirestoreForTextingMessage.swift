//
//  FirestoreForTextingMessage.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
//import simd

class FirestoreForTextingMessage: ObservableObject {
    
    let firebaseAuth = FirebaseAuth()
    let db = Firestore.firestore()
    
    @Published var senderUIDPath: ChatUserUIDDataModel = .empty
    @Published var chatManager = [ChatCenterDataModel]()
    @Published var chatUserData: ChatUserInfoDataModel = .empty
    @Published var messagesContainer = [MessageContainDataModel]()
    @Published var contactMember = [ContactUserDataModel]()
    
    
    func createAndStoreContactUser(uidPath: String) async throws {
        let id = UUID().uuidString
        let contactUserSetRef = db.collection("ChatUsserUIDSet").document(uidPath)
        _ = try await contactUserSetRef.setData([
            "chatDocId" : id
        ])
    }
    
    func storeSenderUserInfo(uidPath: String, userDocID: String, displayName: String, displayProfileImage: String? = "") async throws {
        let chatUserInfoRef = db.collection("ChatUserInfo").document(userDocID)
        _ = try await chatUserInfoRef.setData([
            "senderMailUidPath" : uidPath,
            "senderDisplayName" : displayName,
            "senderProfileImage" : displayProfileImage ?? ""
        ])
    }
    
    func storeContactUserInfo(contactPersonDocID: String, contactPersonUidPath: String , senderUserDocID: String, contactWithdisplayName: String, contactPersondisplayProfileImage: String? = "", chatRoomUID: String) async throws {
        let contacterUserInfoRef = db.collection("ChatUserInfo").document(senderUserDocID).collection("ContactWith").document(contactPersonDocID)
        _ = try await contacterUserInfoRef.setData([
            "contacterMailUidPath" : contactPersonUidPath,
            "contacterPlayName" : contactWithdisplayName,
            "contacterProfileImage" : contactPersondisplayProfileImage ?? "",
            "chatRoomUID" : chatRoomUID,
            "lastMessageTimestamp" : Date()
        ])
    }
    
    func createChatRoom(contact1docID: String, contact2docID: String, chatRoomUID: String) async throws {
        let chatCenterRef = db.collection("ChatCenter").document(chatRoomUID)
        _ = try await chatCenterRef.setData([
            "contact1docID" : contact1docID,
            "contact2docID" : contact2docID,
        ])
    }
    
    func sendingMessage(text: String, sendingImage: String?, senderProfileImage: String, senderDocID: String, sendingTimestamp: Date = Date(), chatRoomUID: String) async throws {
        let messageContainRef = db.collection("ChatCenter").document(chatRoomUID).collection("MessageContain")
        _ = try await messageContainRef.addDocument(data: [
            "sendingImage" : sendingImage ?? "",
            "senderDocID" : senderDocID,
            "text" : text,
            "sendingTimestamp" : sendingTimestamp
        ])
    }
    
    func listenChatCenterMessageContain(chatRoomUID: String) {
        let chatCenterContainMessagesRef = db.collection("ChatCenter").document(chatRoomUID).collection("MessageContain").order(by: "sendingTimestamp", descending: false)
        chatCenterContainMessagesRef.addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            self.messagesContainer = document.compactMap { queryDocumentSnapshot in
                let result = Result {
                    try queryDocumentSnapshot.data(as: MessageContainDataModel.self)
                }
                switch result {
                case .success(let data):
                    return data
                case .failure(let error):
                    print("some error eccure: \(error)")
                }
                return nil
            }
        }
    }
    
    func updateLastMessageTime(userDocID: String, contactPersonID: String) async throws {
        let contactPersonRef = db.collection("ChatUserInfo").document(userDocID).collection("ContactWith").document(contactPersonID)
        try await contactPersonRef.updateData([
            "lastMessageTimestamp" : Date()
        ])
    }
    
    @MainActor
    func fetchChatingMember(userDocID: String) async throws {
        let contactPersonRef = db.collection("ChatUserInfo").document(userDocID).collection("ContactWith")
        let document = try await contactPersonRef.getDocuments().documents
        self.contactMember = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: ContactUserDataModel.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print("some error: \(error)")
            }
            return nil
        }
    }
    
    
    @MainActor
    func fetchChatUserInfo(userDocID: String) async throws -> ChatUserInfoDataModel {
        let chatUserInfoRef = db.collection("ChatUserInfo").document(userDocID)
        let data = try await chatUserInfoRef.getDocument(as: ChatUserInfoDataModel.self)
        self.chatUserData = data
        return chatUserData
    }
    
    @MainActor
    func fetchStoredUserData(uidPath: String) async throws -> ChatUserUIDDataModel {
        let contactUserSetRef = db.collection("ChatUsserUIDSet").document(uidPath)
        let data = try await contactUserSetRef.getDocument(as: ChatUserUIDDataModel.self)
        self.senderUIDPath = data
        return senderUIDPath
    }
}

extension FirestoreForTextingMessage {
    @MainActor
    func fetchChatCenter() async throws {
        let chatCenterRef = db.collection("ChatCenter")
        let document = try await chatCenterRef.getDocuments().documents
        self.chatManager = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: ChatCenterDataModel.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print("some error: \(error)")
            }
            return nil
        }
    }
}


extension FirestoreForTextingMessage {
    func getProviderProfileImage(provideBy: String) async throws -> String {
        let imageRef = db.collection("users").document(provideBy)
        let document = try await imageRef.getDocument(as: UserDataModel.self)
        return document.profileImageURL
    }
}
