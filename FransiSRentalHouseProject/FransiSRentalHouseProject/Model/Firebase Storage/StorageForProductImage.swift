//
//  StorageForProductImage.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import Foundation
import SDWebImageSwiftUI
import Firebase
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class StorageForProductImage: ObservableObject {
    
    let db = Firestore.firestore()
    
    
    @Published var representedProductImageURL = ""
    @Published var productImageUUID = ""
    @Published var productImageSet = [ProductProviderImageDateModel]()
    
    
    let productImageStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "productImages")
    
    let backgroundImageStorageAddress = Storage.storage(url: "gs://francisrentalhouseproject.appspot.com/").reference(withPath: "backgroundImage")
    
    
    func imagUUIDGenerator() -> String {
        let _imageUUID = UUID().uuidString
        return _imageUUID
    }
    
    
//    @MainActor
//    func uploadProductImage(uidPath: String, image: UIImage, productID: String, imageUID: String) async throws {
//        guard let productImageData = image.jpegData(compressionQuality: 0.5) else { return }
//        let productImageRef = productImageStorageAddress.child("\(uidPath)/\(productID)/\(imageUID).jpg")
//        _ = try await productImageRef.putDataAsync(productImageData)
//        let url = try await productImageRef.downloadURL()
//        self.representedProductImageURL = url.absoluteString
//    }
    
    func uploadProductImage(uidPath: String, image: [TextingImageDataModel], productUID: String) async throws {
        for image in image {
            guard let proImageData = image.image.jpegData(compressionQuality: 0.5) else { return }
            let imageUID = UUID().uuidString
            let imageRef = productImageStorageAddress.child("\(uidPath)/\(productUID)/\(imageUID).jpg")
            _ = try await imageRef.putDataAsync(proImageData)
            let url = try await imageRef.downloadURL().absoluteString
            let productImageRef = db.collection("ProductsProvider").document(uidPath).collection("Products").document(productUID).collection("ProductImages")
            _ = try await productImageRef.addDocument(data: [
                "productDetialImage" : url,
                "uploadTime" : Date()
            ])
        }
    }
    
    @MainActor
    func getFirstImageStringAndUpdate(uidPath: String, productUID: String) async throws {
        var firstUrl = ""
        let productImageRef = db.collection("ProductsProvider").document(uidPath).collection("Products").document(productUID).collection("ProductImages").order(by: "uploadTime", descending: false)
        let document = try await productImageRef.getDocuments().documents
        productImageSet = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: ProductProviderImageDateModel.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print(error.localizedDescription)
            }
            return nil
        }
        if let first = productImageSet.first {
            firstUrl = first.productDetialImage
        }
        let productRef = db.collection("ProductsProvider").document(uidPath).collection("Products").document(productUID)
        _ = try await productRef.updateData([
            "productImage" : firstUrl
        ])
    }
    
    @MainActor
    func uploadAndUpdateStoreImage(uidPath: String, images: [TextingImageDataModel], imageID: String) async throws {
        if let image = images.first {
            guard let bkImageData = image.image.jpegData(compressionQuality: 0.5) else { return }
            let backgroundImageRef = backgroundImageStorageAddress.child("\(uidPath)/\(imageID).jpg")
            _ = try await backgroundImageRef.putDataAsync(bkImageData)
            let url = try await backgroundImageRef.downloadURL().absoluteString
            let storeRef = db.collection("Stores").document(uidPath)
            try await storeRef.updateData([
                "storeBackgroundImage" : url
            ])
        }
    }
    
    @MainActor
    func getProductImages(providerUidPath: String, productUID: String) async throws {
        let imageRef = db.collection("ProductsProvider").document(providerUidPath).collection("Products").document(productUID).collection("ProductImages")
        let document = try await imageRef.getDocuments().documents
        productImageSet = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: ProductProviderImageDateModel.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print(error.localizedDescription)
            }
            return nil
        })
    }
    
}


//extension StorageForProductImage {
//
//    func uploadProductVideo(movie: URL) async throws {
//        
//        
//    }
//
//}
