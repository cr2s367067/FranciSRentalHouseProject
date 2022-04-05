//
//  StorageForRoomsImage.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

class StorageForRoomsImage: ObservableObject {
    
    let localData = LocalData()
    
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
    func uploadRoomImageAsync(uidPath: String, image: UIImage, roomID: String, imageUID: String) async throws {
        guard let roomImageData = image.jpegData(compressionQuality: 0.5) else { return }
        let roomImageRef = roomImageStorageAddress.child("\(uidPath)/\(roomID)/\(imageUID).jpg")
        _ = try await roomImageRef.putDataAsync(roomImageData)
        let url = try await roomImageRef.downloadURL()
        DispatchQueue.main.async {        
            self.representedRoomImageURL = url.absoluteString
        }
    }
    
    
}
