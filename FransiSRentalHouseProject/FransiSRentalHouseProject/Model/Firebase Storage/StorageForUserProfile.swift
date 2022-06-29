//
//  StorageForUserProfile.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import Foundation
import SDWebImageSwiftUI

class StorageForUserProfile: ObservableObject {
    let db = Firestore.firestore()

    @Published var representedProfileImageURL = ""
    @Published var isSummitImage = false

    let profileImageStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "profileImage")
    
    let providerStoreprofileImageStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "providerStoreProfileImage")
}

extension StorageForUserProfile {
    func uploadImageAsync(uidPath: String, image: UIImage) async throws {
//        for image in images {
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            let imagesRef = profileImageStorageAddress.child("\(uidPath).jpg")
            _ = try await imagesRef.putDataAsync(imageData)
            let url = try await imagesRef.downloadURL().absoluteString
            let userRef = db.collection("User").document(uidPath)
            try await userRef.updateData([
                "profileImageURL": url,
            ])
//        }
    }
    
    func providerStoreImage(
        gui: String,
        images: [TextingImageDataModel]
    ) async throws {
        if let image = images.first {
            guard let imageData = image.image.jpegData(compressionQuality: 0.5) else { return }
            let imageRef = providerStoreprofileImageStorageAddress.child("\(gui).jpg")
            _ = try await imageRef.putDataAsync(imageData)
            let url = try await imageRef.downloadURL().absoluteString
            let storeRef = db.collection("Stores").document(gui).collection("StoreData").document(gui)
            _ = try await storeRef.updateData([
                "companyProfileImage" : url
            ])
        }
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
