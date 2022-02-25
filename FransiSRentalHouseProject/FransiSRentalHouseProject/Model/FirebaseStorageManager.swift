//
//  FirebaseStorageManager.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import Firebase
import UIKit

class FirebaseStorageManager: ObservableObject {
    
    let fetchFireStore = FetchFirestore()
    
    let storageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/")
    
    
    
    func uploadImage(uidPath: String, image: UIImage) {
        let storageRef = storageAddress.reference(withPath: uidPath)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let imagesRef = storageRef.child("\(image).jpg")
        imagesRef.putData(imageData, metadata: nil) { metadata, error in
            if let _error = error {
                print("Fail to push image to storage: \(_error)")
            }
            imagesRef.downloadURL { url, error in
                if let _error = error {
                    print("Fail to retrieve download URL: \(_error)")
                } else {
                    print("Successfully sotred image with url: \(url?.absoluteString ?? "")")
                }
            }
        }
        
    }
    
}
