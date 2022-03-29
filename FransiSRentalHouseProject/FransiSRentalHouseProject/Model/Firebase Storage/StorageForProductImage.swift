//
//  StorageForProductImage.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import Foundation
import SDWebImageSwiftUI
import Firebase


class StorageForProductImage: ObservableObject {
    
    @Published var representedProductImageURL = ""
    @Published var productImageUUID = ""
    
    let productImageStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "productImages")
    
    
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
        self.representedProductImageURL = url.absoluteString
    }
    
}
