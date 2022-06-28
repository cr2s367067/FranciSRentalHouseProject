//
//  StorageForRoomsImage.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import SDWebImageSwiftUI
import SwiftUI

class StorageForRoomsImage: ObservableObject {
    let localData = LocalData()
    let db = Firestore.firestore()

    @Published var isSummitRoomImage = false
    @Published var representedRoomImageURL = ""
    @Published var imageUUID = ""

    let roomImageStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "roomImage")

    let roomVideoStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "roomVideo")

    func imagUUIDGenerator() -> String {
        let _imageUUID = UUID().uuidString
        imageUUID = _imageUUID
        return imageUUID
    }
}

extension StorageForRoomsImage {
    @MainActor
    func uploadRoomCoverImage(uidPath: String, image: UIImage, roomID: String, imageUID: String) async throws {
        guard let roomImageData = image.jpegData(compressionQuality: 0.5) else { return }
        let roomImageRef = roomImageStorageAddress.child("\(uidPath)/\(roomID)/\(imageUID).jpg")
        _ = try await roomImageRef.putDataAsync(roomImageData)
        let url = try await roomImageRef.downloadURL().absoluteString
        representedRoomImageURL = url
    }
}

extension StorageForRoomsImage {
    func uploadImageSet(uidPath: String, images: [TextingImageDataModel], roomID: String) async throws {
        guard !images.isEmpty else { return }
        for image in images {
            guard let roomImageData = image.image.jpegData(compressionQuality: 0.5) else { return }
            let imageUID = UUID().uuidString
            let roomImageRef = roomImageStorageAddress.child("\(uidPath)/\(roomID)/\(imageUID).jpg")
            _ = try await roomImageRef.putDataAsync(roomImageData)
            let url = try await roomImageRef.downloadURL()
            let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection("Rooms").document(roomID)
                .collection("RoomImages")
            _ = try await roomOwerRef.addDocument(data: [
                "imageURL": url.absoluteString,
            ])
        }
    }
}

extension StorageForRoomsImage {
    func uploadRoomVideo(movie: URL, uidPath: String, roomID: String, docID: String) async throws {
        debugPrint("comming url: \(movie)")
        let videoID = UUID().uuidString
        let videoRef = roomVideoStorageAddress.child("\(uidPath)/\(roomID)/\(videoID).mp4")
        debugPrint("video Ref: \(videoRef.fullPath)")
        guard let convertVideoToData = try? Data(contentsOf: movie) else { return }
        _ = try await videoRef.putDataAsync(convertVideoToData)
        let url = try await videoRef.downloadURL()
        let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID).collection("RoomVideo").document("video")
        _ = try await roomOwerRef.setData([
            "videoURL": url.absoluteString,
        ])
    }
}
