//
//  StorageForRoomsImage.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore

class StorageForRoomsImage: ObservableObject {
    
    let localData = LocalData()
    let db = Firestore.firestore()
    
    @Published var isSummitRoomImage = false
    @Published var representedRoomImageURL = ""
    @Published var imageUUID = ""
    
    let roomImageStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "roomImage")
    
    func imagUUIDGenerator() -> String {
        let _imageUUID = UUID().uuidString
        imageUUID = _imageUUID
        return imageUUID
    }
}

extension StorageForRoomsImage {
    func uploadRoomCoverImage(uidPath: String, image: UIImage, roomID: String, imageUID: String) async throws {
        guard let roomImageData = image.jpegData(compressionQuality: 0.5) else { return }
        let roomImageRef = roomImageStorageAddress.child("\(uidPath)/\(roomID)/\(imageUID).jpg")
        _ = try await roomImageRef.putDataAsync(roomImageData)
        let url = try await roomImageRef.downloadURL().absoluteString
        self.representedRoomImageURL = url
//        try await summitRoomInfoAsync(docID: docID, uidPath: uidPath, holderName: holderName, mobileNumber: mobileNumber, roomAddress: roomAddress, town: town, city: city, zipCode: zipCode, roomArea: roomArea, rentalPrice: rentalPrice, someoneDeadInRoom: someoneDeadInRoom, waterLeakingProblem: waterLeakingProblem, roomImageURL: url, providerDisplayName: providerDisplayName, providerChatDocId: providerChatDocId)
    }
}

extension StorageForRoomsImage {
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
            let roomPublicRef = db.collection("RoomsForPublic").document(docID).collection("RoomImages")
            _ = try await roomPublicRef.addDocument(data: [
                "imageURL" : url.absoluteString
            ])
        }
    }
}


/*
 , docID: String, holderName: String, mobileNumber: String, roomAddress: String, town: String, city: String, zipCode: String, roomArea: String, rentalPrice: String, someoneDeadInRoom: String, waterLeakingProblem: String, roomImageURL: String, isRented: Bool = false, rentedBy: String = "", providerDisplayName: String, providerChatDocId: String
*/
