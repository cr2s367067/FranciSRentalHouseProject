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
    
    // MARK: remove after testing
//    func uploadRoomImage(uidPath: String, image: UIImage, roomID: String, imageUID: String) {
////        let imageUUID = UUID().uuidString
//        guard let roomImageData = image.jpegData(compressionQuality: 0.5) else { return }
//        let roomImageRef = roomImageStorageAddress.child("\(uidPath)/\(roomID)/\(imageUID).jpg")
//        roomImageRef.putData(roomImageData, metadata: nil) { metaData, error in
//            if let _error = error {
//                print("Fail to push room image to storage: \(_error)")
//            }
//            roomImageRef.downloadURL { url, error in
//                if let _error = error {
//                    print("Fail to download: \(_error)")
//                } else {
//                    guard let _url = url else {
//                        return
//                    }
//                    self.representedRoomImageURL = _url.absoluteString
//                    
//                }
//            }
//        }
//    }
    
//    func representStorageRoomImage(uidPath: String, imgUID: String) -> some View {
//        var urlHolder = ""
//        let roomImageRef = roomImageStorageAddress.child("\(uidPath)/\(imgUID).jpg")
//        roomImageRef.downloadURL { url, error in
//            if let _error = error {
//                print("Fail to download: \(_error)")
//            } else {
//                guard let _url = url else { return }
//                urlHolder = _url.absoluteString
//            }
//        }
//        return WebImage(url: URL(string: urlHolder))
//    }

}

extension StorageForRoomsImage {
    func uploadRoomImageAsync(uidPath: String, image: UIImage, roomID: String, imageUID: String) async throws {
        guard let roomImageData = image.jpegData(compressionQuality: 0.5) else { return }
        let roomImageRef = roomImageStorageAddress.child("\(uidPath)/\(roomID)/\(imageUID).jpg")
        _ = try await roomImageRef.putDataAsync(roomImageData)
        let url = try await roomImageRef.downloadURL()
        self.representedRoomImageURL = url.absoluteString
    }
}
