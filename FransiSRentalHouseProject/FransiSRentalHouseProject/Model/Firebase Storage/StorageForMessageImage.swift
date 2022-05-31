//
//  StorageForMessageImage.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/15.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import FirebaseStorage
import UIKit

class StorageForMessageImage: ObservableObject {
    
    @Published var isUploading = false
    
    let db = Firestore.firestore()
    let fireMessage = FirestoreForTextingMessage()
    
    let messageImageStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "messageImage")
    
    @MainActor
    func sendingImageAndMessage(images: [TextingImageDataModel], chatRoomUID: String, senderDocID: String, sendingTimestamp: Date = Date(), contactWith: String, text: String, senderProfileImage: String) async throws {
        var tempUrlHolder = [String]()
        if !images.isEmpty {
            isUploading = true
            for image in images {
                guard let messageImageData = image.image.jpegData(compressionQuality: 0.4) else { return }
                let imageUID = UUID().uuidString
                let messageImageRef = messageImageStorageAddress.child("\(chatRoomUID)/\(senderDocID)/\(imageUID).jpg")
                _ = try await messageImageRef.putDataAsync(messageImageData)
                let url = try await messageImageRef.downloadURL().absoluteString
                tempUrlHolder.append(url)
            }
            isUploading = false
        }
        try await fireMessage.sendingMessage(text: text, sendingImage: tempUrlHolder, senderProfileImage: senderProfileImage, senderDocID: senderDocID, chatRoomUID: chatRoomUID, contactWith: contactWith)
        tempUrlHolder.removeAll()
    }
    
}


/*
 func uploadImageSet(uidPath: String, images: [UIImage], roomID: String, docID: String) async throws {
     guard !images.isEmpty else { return }
     for image in images {
         guard let roomImageData = image.jpegData(compressionQuality: 0.5) else { return }
         let imageUID = UUID().uuidString
         let roomImageRef = roomImageStorageAddress.child("\(uidPath)/\(roomID)/\(imageUID).jpg")
         _ = try await roomImageRef.putDataAsync(roomImageData)
         let url = try await roomImageRef.downloadURL()
         let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID)
             .collection("RoomImages")
         _ = try await roomOwerRef.addDocument(data: [
             "imageURL" : url.absoluteString
         ])
     }
 }
*/
