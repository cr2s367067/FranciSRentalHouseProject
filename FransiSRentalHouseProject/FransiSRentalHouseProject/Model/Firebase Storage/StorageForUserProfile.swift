//
//  StorageForUserProfile.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import Firebase
import SDWebImageSwiftUI

class StorageForUserProfile: ObservableObject {
    
    @Published var representedProfileImageURL = ""
    @Published var isSummitImage = false
    
    let profileImageStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "profileImage")
    
    // MARK: remove after testing
//    func uploadImage(uidPath: String, image: UIImage) {
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
//        let imagesRef = profileImageStorageAddress.child("\(uidPath).jpg")
//        imagesRef.putData(imageData, metadata: nil) { metadata, error in
//            if let _error = error {
//                print("Fail to push image to storage: \(_error)")
//            }
//        }
//    }
    
    // MARK: remove after testing
//    func deleteImagebyUID(uidPath: String) {
//        let storageRef = profileImageStorageAddress.child("\(uidPath).jpg")
//        storageRef.delete { error in
//            if let _error = error {
//                print("fail to delete: \(_error)")
//            } else {
//                print("Deleted successfully")
//            }
//        }
//    }
    
    // MARK: remove after testing
//    func representStorageImage(uidPath: String) -> String {
//        let pathRef = profileImageStorageAddress.child("\(uidPath).jpg")
//        pathRef.downloadURL { url, error in
//            if let _error = error {
//                print("Fail to download: \(_error)")
//            } else {
//                guard let _url = url else { return }
//                self.representedProfileImageURL = _url.absoluteString
//                self.isSummitImage = true
//            }
//        }
//        return representedProfileImageURL
//    }
    
}

extension StorageForUserProfile {
    func uploadImageAsync(uidPath: String, image: UIImage) async throws {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let imagesRef = profileImageStorageAddress.child("\(uidPath).jpg")
        _ = try await imagesRef.putDataAsync(imageData)
        DispatchQueue.main.async {
            self.isSummitImage = true
        }
    }
    
    func deleteImagebyUIDAsync(uidPath: String) async throws {
        let storageRef = profileImageStorageAddress.child("\(uidPath).jpg")
        try await storageRef.delete()
    }
    
    func representStorageImageAsync(uidPath: String) async throws -> String {
        let pathRef = profileImageStorageAddress.child("\(uidPath).jpg")
        let url = try await pathRef.downloadURL()
        DispatchQueue.main.async {        
            self.representedProfileImageURL = url.absoluteString
            self.isSummitImage = true
        }
        return representedProfileImageURL
    }
}
