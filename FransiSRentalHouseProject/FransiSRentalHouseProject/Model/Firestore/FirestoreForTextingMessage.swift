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

class FirestoreForTextingMessage: ObservableObject {
    
    @Published var textContainer = [MessageTextingDataModel]()
//    @Published var textContainer = [TextingDataModel]()
    
    let firebaseAuth = FirebaseAuth()
    let db = Firestore.firestore()
    // Method for renter to send message to firestore
//    func sendingTextMessageRenter(senderUID: String, receiveUID: String, receiveDisplayName: String, senderDisplayName: String, textContain: String, timestamp: Data = Data()) async throws {
//        let senderRef = db.collection("ChatMessage").document(senderUID).collection(senderUID)
////        let receiveRef = db.collection("ChatMessage").document(receiveUID).collection(receiveUID)
//
//        _ = try await senderRef.addDocument(data: [
//            "senderID" : senderUID,
//            "senderDisplayName" : senderDisplayName,
//            "receiveID" : receiveUID,
//            "receiveDisplayName" : receiveDisplayName,
//            "textContain" : textContain,
//            "sendingTimestamp" : timestamp
//        ])
//    }
    
    //Create conversation - renter side
    func creatAndSendTextingSessionS(senderUID: String, receiveUID: String, receiveDisplayName: String, senderDisplayName: String, textContain: String, timestamp: Date = Date()) async throws {
        let senderRef = db.collection("ChatMessage").document("chat1").collection(senderUID)
        let receiveRef = db.collection("ChatMessage").document("chat1").collection(receiveUID)
        
        //For renter to receive
        _ = try await senderRef.addDocument(data: [
            "senderID" : senderUID,
            "senderDisplayName" : senderDisplayName,
            "receiveID" : receiveUID,
            "receiveDisplayName" : receiveDisplayName,
            "textContain" : textContain,
            "sendingTimestamp" : timestamp
        ])
        
        //For provider to receive
        _ = try await receiveRef.addDocument(data: [
            "senderID" : senderUID,
            "senderDisplayName" : senderDisplayName,
            "receiveID" : receiveUID,
            "receiveDisplayName" : receiveDisplayName,
            "textContain" : textContain,
            "sendingTimestamp" : timestamp
        ])
    }
    
    
    func listeningTexingMessage(uidPath: String) async throws -> MessageTextingDataModel {
        let messageRef = db.collection("ChatMessage").document(uidPath).collection(uidPath).order(by: "sendingTimestamp", descending: false)
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<MessageTextingDataModel, Error>) in
            messageRef.addSnapshotListener { querySnapshot, error in
                guard let document = querySnapshot?.documents else { return }
                self.textContainer = document.map { queryDocumentSnapshot -> MessageTextingDataModel in
                    let data = queryDocumentSnapshot.data()
                    let docID = queryDocumentSnapshot.documentID
                    let providerID = data["providerID"] as? String ?? ""
                    let providerDisplayName = data["providerDisplayName"] as? String ?? ""
                    let senderID = data["senderID"] as? String ?? ""
                    let senderDisplayName = data["senderDisplayName"] as? String ?? ""
                    let textContain = data["textContain"] as? String ?? ""
                    let sendingTimestamp = data["sendingTimestamp"] as? Timestamp
                    return MessageTextingDataModel(docID: docID, receiveID: providerID, receiveDisplayName: providerDisplayName, senderUID: senderID, senderDisplayName: senderDisplayName, textContain: textContain, sendingTimestamp: sendingTimestamp)
                }
            }
        })
    }
}
