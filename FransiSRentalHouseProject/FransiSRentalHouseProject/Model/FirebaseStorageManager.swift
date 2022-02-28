//
//  FirebaseStorageManager.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import Firebase
import SwiftUI


class FirebaseStorageManager: ObservableObject {
    
    @Published var isSummitImage = false
    @Published var representedImageURL = ""
    
    let fetchFireStore = FetchFirestore()
    
    let storageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "profileImage")
    
    
    func uploadImage(uidPath: String, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let imagesRef = storageAddress.child("\(uidPath).jpg")
        imagesRef.putData(imageData, metadata: nil) { metadata, error in
            if let _error = error {
                print("Fail to push image to storage: \(_error)")
            }
//            self.isSummitImage = true
//            imagesRef.downloadURL { url, error in
//                if let _error = error {
//                    print("Fail to retrieve download URL: \(_error)")
//                } else {
//                    print("Successfully sotred image with url: \(url?.absoluteString ?? "")")
//                }
//            }
        }
    }
    
    func deleteImagebyUID(uidPath: String) {
        let storageRef = storageAddress.child("\(uidPath).jpg")
        storageRef.delete { error in
            if let _error = error {
                print("fail to delete: \(_error)")
            } else {
                print("Deleted successfully")
            }
        }
    }
    
//    func databaseChecker()
    
    func representStorageImage(uidPath: String) -> String {
//        var imageURlString = ""
        let pathRef = storageAddress.child("\(uidPath).jpg")
        pathRef.downloadURL { url, error in
            if let _error = error {
                print("Fail to download: \(_error)")
            } else {
                guard let _url = url else { return }
                self.representedImageURL = _url.absoluteString
                self.isSummitImage = true
            }
        }
        return representedImageURL
    }
    
    
}
