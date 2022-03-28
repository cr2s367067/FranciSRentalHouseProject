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

class FirestoreForFurniture: ObservableObject {
    
    @Published var furnitureDataSet = [FurnitureProviderDataModel]()
    
    let db = Firestore.firestore()
    
    func summitFurniture(uidPath: String, productImage: String, providerName: String, productPrice: Int, productDescription: String) async throws {
        let furnitureProviderRef = db.collection("FurnitureProvider").document(uidPath).collection("FurnitureProducts")
        _ = try await furnitureProviderRef.addDocument(data: [
            "productImage" : productImage,
            "providerName" : providerName,
            "productPrice" : productPrice,
            "productDescription" : productDescription
        ])
        
        let furniturePublicRef = db.collection("FurniturePublic")
        _ = try await furniturePublicRef.addDocument(data: [
            "productImage" : productImage,
            "providerName" : providerName,
            "productPrice" : productPrice,
            "productDescription" : productDescription
        ])
        
        
        
    }
    
    func listeningFurnitureInfo() {
        let furniturePublicRef = db.collection("FurniturePublic")
        furniturePublicRef.addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot?.documents else { return }
            self.furnitureDataSet = document.compactMap({ queryDocumentSnapshot in
                let result = Result {
                    try queryDocumentSnapshot.data(as: FurnitureProviderDataModel.self)
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
