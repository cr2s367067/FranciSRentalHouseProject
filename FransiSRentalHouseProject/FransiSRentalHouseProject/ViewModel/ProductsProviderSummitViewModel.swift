//
//  FurnitureProviderSummitViewModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/28.
//

import Foundation
import UIKit
import SwiftUI

class ProductsProviderSummitViewModel: ObservableObject {
    
    let firestoreForFurniture = FirestoreForProducts()
    let storageForProductImage = StorageForProductImage()
    
    @Published var productName = ""
    @Published var productPrice = ""
    @Published var productDescription = ""
    @Published var productFrom = ""
    @Published var holderTosAgree = false
    @Published var productAmount = ""
    @Published var productType = ""
    @Published var isSoldOut = false
    
    @Published var showSummitAlert = false
    @Published var images = [TextingImageDataModel]()
    @Published var productVideo: URL?
    @Published var showSheet = false
    @Published var tosSheetShow = false
    @Published var isSummitProductPic = false
    
    @Published var showProgressView = false
    
    
    
    var image: UIImage {
        var temp = UIImage()
        if let firstImage = images.first {
            temp = firstImage.image
        }
        return temp
    }
    
    var serviceFee: Double {
        let convertDou = Double(productPrice) ?? 0
        let multiTwoPercent = convertDou * 0.02
        return multiTwoPercent
    }
    
    var paymentFee: Double {
        let convertDou = Double(productPrice) ?? 0
        let multiResult = convertDou * 0.0275
        return multiResult
    }
    var totalCost: Double {
        let convert1 = Double(serviceFee)
        let convert2 = Double(paymentFee)
        let result = convert1 + convert2
        return result
    }
    
    func resetView() {
        productFrom = ""
        productName = ""
        productPrice = ""
        productDescription = ""
        productAmount = ""
        firestoreForFurniture.productUID = firestoreForFurniture.productIDGenerator()
        storageForProductImage.productImageUUID = storageForProductImage.imagUUIDGenerator()
        holderTosAgree = false
        productType = ""
        images.removeAll()
    }
    
    func checker(productName: String, productPrice: String, productFrom: String, images: [TextingImageDataModel], holderTosAgree: Bool, productAmount: String, productType: String) throws {
        guard !productName.isEmpty && !productPrice.isEmpty && !productFrom.isEmpty && !images.isEmpty && holderTosAgree == true else {
            throw ProviderSummitError.blankError
        }
        guard productAmount != "0" else {
            throw ProviderSummitError.productAmountError
        }
        guard productPrice != "0" else {
            throw ProviderSummitError.productPriceError
        }
        guard !productType.isEmpty else {
            throw ProviderSummitError.productTypeError
        }
    }
}
