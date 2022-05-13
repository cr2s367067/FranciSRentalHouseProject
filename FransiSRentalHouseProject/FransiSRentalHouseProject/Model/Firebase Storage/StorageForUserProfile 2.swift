//
//  StorageForUserProfile.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import Firebase
import SDWebImageSwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class StorageForUserProfile: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var representedProfileImageURL = ""
    @Published var isSummitImage = false
    
    let profileImageStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "profileImage")

    
}

extension StorageForUserProfile {
    func uploadImageAsync(uidPath: String, image: UIImage) async throws {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let imagesRef = profileImageStorageAddress.child("\(uidPath).jpg")
        _ = try await imagesRef.putDataAsync(imageData)
        let url = try await imagesRef.downloadURL().absoluteString
        let userRef = db.collection("users").document(uidPath)
        try await userRef.updateData([
            "profileImageURL" : url
        ])
    }
    
//    func deleteImagebyUIDAsync(uidPath: String) async throws {
//        let storageRef = profileImageStorageAddress.child("\(uidPath).jpg")
//        try await storageRef.delete()
//    }
    
//    func representStorageImageAsync(uidPath: String) async throws -> String {
//        let pathRef = profileImageStorageAddress.child("\(uidPath).jpg")
//        let url = try await pathRef.downloadURL()
//        DispatchQueue.main.async {
//            self.representedProfileImageURL = url.absoluteString
//            self.isSummitImage = true
//        }
//        return representedProfileImageURL
//    }
}
