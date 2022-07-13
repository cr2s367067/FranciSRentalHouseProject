//
//  StorageForMaintainImage.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/12.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import Foundation
import SDWebImageSwiftUI

class StorageForMaintainImage: ObservableObject {
    let db = Firestore.firestore()

    @Published var itemImageURL = ""

    let maintainImageStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "maintainItemImage")

    @MainActor
    func uploadFixItemImage(uidPath: String, image: UIImage, roomUID: String) async throws {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let imageUID = UUID().uuidString
        let fixingItemRef = maintainImageStorageAddress.child("\(uidPath)/\(roomUID)/\(imageUID).jpg")
        _ = try await fixingItemRef.putDataAsync(imageData)
        let url = try await fixingItemRef.downloadURL().absoluteString
        itemImageURL = url
    }
}
