//
//  StorageForMessageImage.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/15.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import UIKit

class StorageForMessageImage: ObservableObject {
    let db = Firestore.firestore()

    let messageImageStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "messageImage")

    func sendingImage(images: [UIImage], chatRoomUID: String, senderDocID: String, sendingTimestamp: Date = Date()) async throws {
        guard !images.isEmpty else { return }
        for image in images {
            guard let messageImageData = image.jpegData(compressionQuality: 0.4) else { return }
            let imageUID = UUID().uuidString
            let messageImageRef = messageImageStorageAddress.child("\(chatRoomUID)/\(senderDocID)/\(imageUID).jpg")
            _ = try await messageImageRef.putDataAsync(messageImageData)
            let url = try await messageImageRef.downloadURL().absoluteString
            let messageContainRef = db.collection("ChatCenter").document(chatRoomUID).collection("MessageContain")
            _ = try await messageContainRef.addDocument(data: [
                "sendingImage": url,
                "senderDocID": senderDocID,
                "text": "",
                "sendingTimestamp": sendingTimestamp,
            ])
        }
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
