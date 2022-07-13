//
//  StorageForProductImage.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SDWebImageSwiftUI
import SwiftUI

class StorageForProductImage: ObservableObject {
    let db = Firestore.firestore()

    @Published var representedProductImageURL = ""
    @Published var productImageUUID = ""

    let productImageStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "productImages")

    let backgroundImageStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "backgroundImage")

    func imagUUIDGenerator() -> String {
        let _imageUUID = UUID().uuidString
        return _imageUUID
    }

    @MainActor
    func uploadProductImage(uidPath: String, image: UIImage, productID: String, imageUID: String) async throws {
        guard let productImageData = image.jpegData(compressionQuality: 0.5) else { return }
        let productImageRef = productImageStorageAddress.child("\(uidPath)/\(productID)/\(imageUID).jpg")
        _ = try await productImageRef.putDataAsync(productImageData)
        let url = try await productImageRef.downloadURL()
        representedProductImageURL = url.absoluteString
    }

    @MainActor
    func uploadAndUpdateStoreImage(uidPath: String, images: [UIImage], imageID: String) async throws {
        if let image = images.first {
            guard let bkImageData = image.jpegData(compressionQuality: 0.5) else { return }
            let backgroundImageRef = backgroundImageStorageAddress.child("\(uidPath)/\(imageID).jpg")
            _ = try await backgroundImageRef.putDataAsync(bkImageData)
            let url = try await backgroundImageRef.downloadURL().absoluteString
            let storeRef = db.collection("Stores").document(uidPath)
            try await storeRef.updateData([
                "storeBackgroundImage": url,
            ])
        }
    }
}
