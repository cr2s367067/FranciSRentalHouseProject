//
//  FirestoreForFurnitureOrder.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/28.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreForProducts: ObservableObject {
    
    @Published var productsDataSet = [ProductProviderDataModel]()
    @Published var productUID = ""
    
    let db = Firestore.firestore()
    
    func productIDGenerator() -> String {
        let productID = UUID().uuidString
        return productID
    }
    
    func summitFurniture(uidPath: String, productImage: String, providerName: String, productPrice: String, productDescription: String, productUID: String, productName: String, productFrom: String, productAmount: String, isSoldOut: Bool) async throws {
        let furnitureProviderRef = db.collection("ProductsProvider").document(uidPath).collection("Products")
        _ = try await furnitureProviderRef.addDocument(data: [
            "productUID" : productUID,
            "productImage" : productImage,
            "providerName" : providerName,
            "productPrice" : productPrice,
            "productDescription" : productDescription,
            "productName": productName,
            "productFrom" : productFrom,
            "providerUID" : uidPath,
            "productAmount" : productAmount,
            "isSoldOut" : isSoldOut
        ])
        
        let furniturePublicRef = db.collection("ProductsPublic")
        _ = try await furniturePublicRef.addDocument(data: [
            "productUID" : productUID,
            "productImage" : productImage,
            "providerName" : providerName,
            "productPrice" : productPrice,
            "productDescription" : productDescription,
            "productName": productName,
            "productFrom" : productFrom,
            "providerUID" : uidPath,
            "productAmount" : productAmount,
            "isSoldOut" : isSoldOut
        ])
    }
    
    func listeningFurnitureInfo() {
        let furniturePublicRef = db.collection("ProductsPublic")
        furniturePublicRef.addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot?.documents else { return }
            self.productsDataSet = document.compactMap({ queryDocumentSnapshot in
                let result = Result {
                    try queryDocumentSnapshot.data(as: ProductProviderDataModel.self)
                }
                switch result {
                case .success(let data):
                    return data
                case .failure(let error):
                    print("error eccure: \(error)")
                }
                return nil
            })
        }
    }
    
}


extension FirestoreForProducts {
    func makeOrder() async throws {
        
    }
}
