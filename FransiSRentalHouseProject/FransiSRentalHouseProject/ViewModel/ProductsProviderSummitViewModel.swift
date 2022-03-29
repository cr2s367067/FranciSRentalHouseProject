//
//  FurnitureProviderSummitViewModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/28.
//

import Foundation

class ProductsProviderSummitViewModel: ObservableObject {
    
    let firestoreForFurniture = FirestoreForProducts()
    let storageForProductImage = StorageForProductImage()
    
    @Published var productName = ""
    @Published var productPrice = ""
    @Published var productDescription = ""
    @Published var productFrom = ""
    @Published var holderTosAgree = false
    @Published var productAmount = ""
    @Published var isSoldOut = false
    
    func resetView() {
        productFrom = ""
        productName = ""
        productPrice = ""
        productDescription = ""
        productAmount = ""
        firestoreForFurniture.productUID = firestoreForFurniture.productIDGenerator()
        storageForProductImage.productImageUUID = storageForProductImage.imagUUIDGenerator()
        holderTosAgree = false
    }
}
