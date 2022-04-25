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
    
    enum PaymentMethodStatus {
        case creditCard
    }
    
    enum ShippingMethod: String {
        case convenienceStore = "711"
        case homeDelivery = "Home Delivery"
        case personalDelivery = "Personal Delivery"
    }
    
    
    
    enum ShippingStatus: String {
        case orderBuilt = "Order Built"
        case orderConfrim = "Order Confirm"
        case shipped = "Shipped"
        case deliveried = "Deliveried"
    }
    
    @Published var fetchOrderedDataSet = [UserOrderProductsDataModel]()
    @Published var markedProducts = [MarkedProductsDataModel]()
    @Published var productsDataSet = [ProductProviderDataModel]()
    @Published var productUID = ""
    @Published var storesDataSet = [StoreDataModel]()
    @Published var storeLocalData: StoreDataModel = .empty
    @Published var storeProductsDataSet = [ProductProviderDataModel]()
    
    @Published var purchasedUserDataSet = [PurchasedUserDataModel]()
    @Published var cartListDataSet = [PurchasedOrdedProductDataModel]()
    
    @Published var userOrderedDataSet = [OrderedDataModel]()
    
    @Published var shippingMethod: ShippingMethod = .convenienceStore
    @Published var shippingStatus: ShippingStatus = .orderBuilt
    
    let db = Firestore.firestore()
    
    func productIDGenerator() -> String {
        let productID = UUID().uuidString
        return productID
    }
    
    func summitFurniture(uidPath: String, productImage: String, providerName: String, productPrice: String, productDescription: String, productUID: String, productName: String, productFrom: String, productAmount: String, isSoldOut: Bool, productType: String) async throws {
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
            "isSoldOut" : isSoldOut,
            "productType" : productType
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
            "isSoldOut" : isSoldOut,
            "productType" : productType
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
    
    func initOrderID() -> String {
        return UUID().uuidString
    }
    
    func makeOrder(uidPath: String, productName: String, productPrice: Int, providerUID: String, productUID: String, orderAmount: String, productImage: String, buyDate: Date = Date(), comment: String?, rating: Int?, userName: String, userMobileNumber: String, shippingAddress: String, shippingStatus: String, paymentStatus: String, shippingMethod: String, orderID: String, subTotal: Int) async throws {
        
        let orderRef = db.collection("users").document(uidPath).collection("ProductOrdered").document(orderID)
        _ = try await orderRef.setData([
            "orderID" : orderID,
            "orderDate" : buyDate,
            "shippingAddress" : shippingAddress,
            "paymentStatus" : paymentStatus,
            "subTotal" : subTotal,
            "shippingStatus" : shippingStatus
        ])
        
        let productDetailRef = orderRef.collection("ProductList")
        _ = try await productDetailRef.addDocument(data: [
            "productImage" : productImage,
            "productName" : productName,
            "productPrice" : productPrice,
            "providerUID" : providerUID,
            "productUID" : productUID,
            "orderAmount" : orderAmount,
            "comment" : comment ?? "",
            "rating" : rating ?? 0,
            "buyDate" : buyDate
        ])
        
        let shippingRef = db.collection("users").document(providerUID).collection("ShippingList").document(orderID)
        //store user basic info include shipping info
        _ = try await shippingRef.setData([
            "userName" : userName,
            "userMobileNumber" : userMobileNumber,
            "userAddress" : shippingAddress,
            "shippingStatus" : shippingStatus,
            "shippingMethod" : shippingMethod,
            "paymentStatus" : paymentStatus,
            "createTimestamp" : buyDate,
            "subTotal" : subTotal
        ])
        let cartRef = shippingRef.collection("CartContain")
        //auto doc id with products info
        _ = try await cartRef.addDocument(data: [
            "productImageURL" : productImage,
            "productName" : productName,
            "productPrice" : productPrice,
            "orderAmount" : orderAmount,
            "createTimestamp" : buyDate
        ])
        
    }
    
    @MainActor
    func fetchOrderedDataUserSide(uidPath: String) async throws {
        let orderRef = db.collection("users").document(uidPath).collection("ProductOrdered")
        print("get ref: \(orderRef)")
        let document = try await orderRef.getDocuments().documents
        print("get doc: \(document)")
        userOrderedDataSet = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: OrderedDataModel.self)
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
    
    @MainActor
    func fetchOrdedDataProviderSide(uidPath: String) async throws {
        let shippingRef = db.collection("users").document(uidPath).collection("ShippingList").order(by: "createTimestamp", descending: false)
        print("Find ref: \(shippingRef)")
        let purchasedUsers = try await shippingRef.getDocuments().documents
        print("try get doc: \(purchasedUsers)")
        purchasedUserDataSet = purchasedUsers.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: PurchasedUserDataModel.self)
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
    
    @MainActor
    func fetchOrdedDataInCartList(uidPath: String, docID: String) async throws {
        let cartListRef = db.collection("users").document(uidPath).collection("ShippingList").document(docID).collection("CartContain")
        print("find document path: \(cartListRef)")
        let cartList = try await cartListRef.getDocuments().documents
        print("try get contain: \(cartList)")
        cartListDataSet = cartList.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: PurchasedOrdedProductDataModel.self)
            }
            print("try to get result: \(result)")
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print(error.localizedDescription)
            }
            return nil
        })
    }
    
    @MainActor
    func fetchOrderedData(uidPath: String, docID: String) async throws {
        let orderRef = db.collection("users").document(uidPath).collection("ProductOrdered").document(docID).collection("ProductList")
        let document = try await orderRef.getDocuments().documents
        self.fetchOrderedDataSet = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: UserOrderProductsDataModel.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print("error: \(error)")
            }
            return nil
        })
    }
    
    func userToSummitProductComment(uidPath: String, comment: String, rating: String, docID: String, isUploadComment: Bool) async throws {
        let commentRef = db.collection("users").document(uidPath).collection("ProductOrder").document(docID)
        _ = try await commentRef.updateData([
            "isUploadComment" : isUploadComment,
            "comment" : comment,
            "rating" : rating
        ])
    }
    
    func receiveOrder(uidPath: String, orderUID: String, orderShippingAddress: String, orderName: String, orderAmount: String, productUID: String, productImage: String, productPrice: String) async throws {
        let receiveOrderRef = db.collection("ProductsProvider").document(uidPath).collection("Orders")
        _ = try await receiveOrderRef.addDocument(data: [
            "orderUID" : orderUID,
            "orderShippingAddress" : orderShippingAddress,
            "orderName" : orderName,
            "orderAmount" : orderAmount,
            "productUID" : productUID,
            "productImage" : productImage,
            "productPrice" : productPrice
        ])
    }
    
    func providerReceiveProductsComment(uidPath: String, comment: String, rating: String, productUID: String, buyerUID: String, buyerDisplayName: String) async throws {
        let commentRef = db.collection("ProductsProvider").document(uidPath).collection("Orders")
        _ = try await commentRef.addDocument(data: [
            "comment" : comment,
            "rating" : rating,
            "productUID" : productUID,
            "buyerDisplayName" : buyerDisplayName,
            "buyerUID" : buyerUID
        ])
    }
}

extension FirestoreForProducts {
    
    // MARK: For user to mark the product that they like
    func bookMark(uidPath: String, productUID: String, providerUID: String, productName: String, productPrice: String, productImage: String, productFrom: String, isSoldOut: Bool, productAmount: String, productDescription: String, providerName: String) async throws {
        let bookMarkRef = db.collection("users").document(uidPath).collection("MarkedProducts")
        _ = try await bookMarkRef.addDocument(data: [
            "productUID" : productUID,
            "providerUID" : providerUID,
            "productName" : productName,
            "productPrice" : productPrice,
            "productImage" : productImage,
            "productFrom" : productFrom,
            "isSoldOut" : isSoldOut,
            "productAmount" : productAmount,
            "productDescription" : productDescription,
            "providerName" : providerName
        ])
    }
    
    func updateBookMarkInfo(uidPath: String, productUID: String, providerUID: String, productName: String, productPrice: String, productImage: String, productFrom: String, isSoldOut: Bool, productAmount: String, productDescription: String, providerName: String, docID: String) async throws {
        let bookMarkRef = db.collection("users").document(uidPath).collection("MarkedProducts").document(docID)
        _ = try await bookMarkRef.updateData([
            "productUID" : productUID,
            "providerUID" : providerUID,
            "productName" : productName,
            "productPrice" : productPrice,
            "productImage" : productImage,
            "productFrom" : productFrom,
            "isSoldOut" : isSoldOut,
            "productAmount" : productAmount,
            "productDescription" : productDescription,
            "providerName" : providerName
        ])
    }
    
    @MainActor
    func fetchMarkedProducts(uidPath: String) async throws {
        let bookMarkRef = db.collection("users").document(uidPath).collection("MarkedProducts")
        let document = try await bookMarkRef.getDocuments().documents
        self.markedProducts = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: MarkedProductsDataModel.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
            return nil
        })
    }
    
    func unSignBookMarked(uidPath: String, id: String) async throws {
        let bookMarkRef = db.collection("users").document(uidPath).collection("MarkedProducts").document(id)
        try await bookMarkRef.delete()
    }
}


extension FirestoreForProducts {
    func createStore(uidPath: String, provideBy: String, providerDisplayName: String, providerProfileImage: String, providerDescription: String, storeChatDocID: String) async throws {
        let storeRef = db.collection("Stores").document(uidPath)
        _ = try await storeRef.setData([
            "provideBy" : provideBy,
            "providerDisplayName" : providerDisplayName,
            "providerProfileImage" : providerProfileImage,
            "providerDescription" : providerDescription,
            "storeBackgroundImage" : "",
            "storeChatDocID" : storeChatDocID
        ])
    }
    
    func updateStoreInfo(uidPath: String, providerDescription: String) async throws {
        let storeRef = db.collection("Stores").document(uidPath)
        _ = try await storeRef.updateData([
            "providerDescription" : providerDescription
        ])
    }
    
    
    
    @MainActor
    func fetchStoreInLocal(uidPath: String) async throws -> StoreDataModel {
        let storeRef = db.collection("Stores").document(uidPath)
        storeLocalData = try await storeRef.getDocument(as: StoreDataModel.self)
        return storeLocalData
    }
    
    
    @MainActor
    func fetchStore() async throws {
        let storeRef = db.collection("Stores")
        let document = try await storeRef.getDocuments().documents
        storesDataSet = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: StoreDataModel.self)
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

extension FirestoreForProducts {
    @MainActor
    func fetchStoreProduct(uidPath: String) async throws {
        let productRef = db.collection("ProductsProvider").document(uidPath).collection("Products")
        let document = try await productRef.getDocuments().documents
        storeProductsDataSet = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: ProductProviderDataModel.self)
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

extension FirestoreForProducts {
    
    func updateShippingStatus(update shippingStatus: String, uidPath: String, orderID: String) async throws {
        let shippingRef = db.collection("users").document(uidPath).collection("ShippingList").document(orderID)
        try await shippingRef.updateData([
            "shippingStatus" : shippingStatus
        ])
    }
    
}


