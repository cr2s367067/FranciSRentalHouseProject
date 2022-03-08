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
    
    @Published var isSummitRoomImage = false
    @Published var representedRoomImageURL = ""
    
    let roomImageStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "roomImage")
    
    func uploadRoomImage(uidPath: String, image: UIImage, roomID: String) {
        let imageUUID = UUID().uuidString
        guard let roomImageData = image.jpegData(compressionQuality: 0.5) else { return }
        let roomImageRef = roomImageStorageAddress.child("\(uidPath)/\(roomID)/\(imageUUID).jpg")
        roomImageRef.putData(roomImageData, metadata: nil) { metaData, error in
            if let _error = error {
                print("Fail to push room image to storage: \(_error)")
            }
            roomImageRef.downloadURL { url, error in
                if let _error = error {
                    print("Fail to download: \(_error)")
                } else {
                    guard let _url = url else {
                        return
                    }
                    self.representedRoomImageURL = _url.absoluteString
                    print("Success to upload: \(_url.absoluteString)")
                }
            }
        }
    }
    
    
    func representStorageRoomImage(uidPath: String, imgUID: String) -> some View {
        var urlHolder = ""
        let roomImageRef = roomImageStorageAddress.child("\(uidPath)/\(imgUID).jpg")
        roomImageRef.downloadURL { url, error in
            if let _error = error {
                print("Fail to download: \(_error)")
            } else {
                guard let _url = url else { return }
                urlHolder = _url.absoluteString
            }
        }
        return WebImage(url: URL(string: urlHolder))
    }

}
