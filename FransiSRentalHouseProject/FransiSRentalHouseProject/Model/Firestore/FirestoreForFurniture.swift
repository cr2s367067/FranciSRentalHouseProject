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
    
    func summitFurniture(uidPath: String, furnitureImage: String, furnitureName: String, furniturePrice: Int, productDescription: String, shippingFrom: String, providerName: String) async throws {
        let furnitureProviderRef = db.collection("FurnitureProvider").document(uidPath).collection("FurnitureProducts")
        _ = try await furnitureProviderRef.addDocument(data: [
            "furnitureImage" : furnitureImage,
            "furnitureName" : furnitureName,
            "furniturePrice" : furniturePrice,
            "productDescription" : productDescription,
            "shippingFrom" : shippingFrom
        ])
        
        let furniturePublicRef = db.collection("FurniturePublic")
        _ = try await furniturePublicRef.addDocument(data: [
            "furnitureImage" : furnitureImage,
            "furnitureName" : furnitureName,
            "furniturePrice" : furniturePrice,
            "productDescription" : productDescription,
            "shippingFrom" : shippingFrom
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
