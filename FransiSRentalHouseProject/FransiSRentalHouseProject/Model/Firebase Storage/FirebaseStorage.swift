//
//  FirebaseStorageManager.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import Firebase
import SwiftUI
import SDWebImageSwiftUI


class FirebaseStorage: ObservableObject {
    
    let storageUserProfile = StorageForUserProfile()
    let storageRoomsImage = StorageForRoomsImage()
    
    @Published var imageUIDHolder = ""
        
    
    func imgUIDGenerator() -> String {
        let imageUUID = UUID().uuidString
        imageUIDHolder = imageUUID
        return imageUIDHolder
    }
  
}
