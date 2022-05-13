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
        case cancel = "Cancel"
        case orderBuilt = "Order Built"
        case orderConfrim = "Order Confirm"
        case shipped = "Shipped"
        case deliveried = "Deliveried"
    }
    
    @Published var fetchOrderedDataSet = [UserOrderProductsDataModel]()
    @Published var markedProducts = [MarkedProductsDataModel]()
    @Published var productsDataSet = [ProductProviderDataModel]()
    @Published var productUID = ""
    @Published var storesDataSet: StoreDataModel = .empty
    @Published var storeLocalData: StoreDataModel = .empty
    
    @Published var uploadingHolder: ProductProviderDataModel = .empty
    
    @Published var storeProductsDataSet = [ProductProviderDataModel]()
    
    @Published var purchasedUserDataSet = [PurchasedUserDataModel]()
    @Published var cartListDataSet = [PurchasedOrdedProductDataModel]()
    
    @Published var userOrderedDataSet = [OrderedDataModel]()
    
    @Published var productCommentAndRatting = [ProductCommentRattingDataModel]()
    
    @Published var shippingMethod: ShippingMethod = .convenienceStore
    @Published var shippingStatus: ShippingStatus = .orderBuilt
    
    let db = Firestore.firestore()
    
    func productIDGenerator() -> String {
        let productID = UUID().uuidString
        return productID
    }
    
    func summitFurniture(uidPath: String, productImage: String, providerName: String, productPrice: String, productDescription: String, productUID: String, productName: String, productFrom: String, productAmount: String, isSoldOut: Bool, productType: String) async throws {
        let furnitureProviderRef = db.collection("ProductsProvider").document(uidPath).collection("Products").document(productUID)
        _ = try await furnitureProviderRef.setData([
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
            "productType" : productType,
            "postDate" : Date()
        ])
    }
    
    @MainActor
    func getUploadintData(uidPath: String, productUID: String) async throws -> ProductProviderDataModel {
        let furnitureProviderRef = db.collection("ProductsProvider").document(uidPath).collection("Products").document(productUID)
        print("get uid Path: \(uidPath)")
        print("get product uid: \(productUID)")
        uploadingHolder = try await furnitureProviderRef.getDocument(as: ProductProviderDataModel.self)
        print("data: \(uploadingHolder)")
        return uploadingHolder
    }
    
    func postProductOnPublic(data: ProductProviderDataModel, productUID: String) async throws {
        let furniturePublicRef = db.collection("ProductsPublic").document(productUID)
        _ = try await furniturePublicRef.setData([
            "productUID" : data.productUID,
            "productImage" : data.productImage,
            "providerName" : data.providerName,
            "productPrice" : data.productPrice,
            "productDescription" : data.productDescription,
            "productName": data.productName,
            "productFrom" : data.productFrom,
            "providerUID" : data.providerUID,
            "productAmount" : data.productAmount,
            "isSoldOut" : data.isSoldOut,
            "productType" : data.productType,
            "postDate" : data.postDate?.dateValue() ?? Date()
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
    
    func makeOrder(uidPath: String, productName: String, productPrice: Int, providerUID: String, productUID: String, orderAmount: String, productImage: String, buyDate: Date = Date(), comment: String?, ratting: Int?, userName: String, userMobileNumber: String, shippingAddress: String, shippingStatus: String, paymentStatus: String, shippingMethod: String, orderID: String, subTotal: Int) async throws {
        
        let orderRef = db.collection("users").document(uidPath).collection("ProductOrdered").document(orderID)
        _ = try await orderRef.setData([
            "orderID" : orderID,
            "orderDate" : buyDate,
            "shippingAddress" : shippingAddress,
            "paymentStatus" : paymentStatus,
            "subTotal" : subTotal,
            "shippingStatus" : shippingStatus,
            "providerUID" : providerUID,
            "productUID" : productUID,
            "orderAmount" : orderAmount
        ])
        
        let productDetailRef = orderRef.collection("ProductList")
        _ = try await productDetailRef.addDocument(data: [
            "productImage" : productImage,
            "productName" : productName,
            "productPrice" : productPrice,
            "providerUID" : providerUID,
            "productUID" : productUID,
            "isUploadComment" : false,
            "orderAmount" : orderAmount,
            "comment" : comment ?? "",
            "ratting" : ratting ?? 0,
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
            "subTotal" : subTotal,
            "userUidPath" : uidPath
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
    
    func updateAmount(providerUidPath: String, productID: String, netAmount: String) async throws {
        let productRef = db.collection("ProductsProvider").document(providerUidPath).collection("Products").document(productID)
        try await productRef.updateData([
            "productAmount" : netAmount
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
                print(error.localizedDescription)
            }
            return nil
        })
    }
    
    func userToSummitProductComment(uidPath: String, comment: String, ratting: Int, docID: String, isUploadComment: Bool, listID: String) async throws {
        let commentRef = db.collection("users").document(uidPath).collection("ProductOrdered").document(docID).collection("ProductList").document(listID)
        _ = try await commentRef.updateData([
            "isUploadComment" : isUploadComment,
            "comment" : comment,
            "ratting" : ratting
        ])
    }
    
//    func receiveOrder(uidPath: String, orderUID: String, orderShippingAddress: String, orderName: String, orderAmount: String, productUID: String, productImage: String, productPrice: String) async throws {
//        let receiveOrderRef = db.collection("ProductsProvider").document(uidPath).collection("Orders")
//        _ = try await receiveOrderRef.addDocument(data: [
//            "orderUID" : orderUID,
//            "orderShippingAddress" : orderShippingAddress,
//            "orderName" : orderName,
//            "orderAmount" : orderAmount,
//            "productUID" : productUID,
//            "productImage" : productImage,
//            "productPrice" : productPrice
//        ])
//    }
//
//    func providerReceiveProductsComment(uidPath: String, comment: String, ratting: String, productUID: String, buyerUID: String, buyerDisplayName: String) async throws {
//        let commentRef = db.collection("ProductsProvider").document(uidPath).collection("Orders")
//        _ = try await commentRef.addDocument(data: [
//            "comment" : comment,
//            "ratting" : ratting,
//            "productUID" : productUID,
//            "buyerDisplayName" : buyerDisplayName,
//            "buyerUID" : buyerUID
//        ])
//    }
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
    
    func updateProfilePic(uidPath: String, profileImage: String) async throws {
        let storeRef = db.collection("Stores").document(uidPath)
        _ = try await storeRef.updateData([
            "providerProfileImage" : profileImage
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
    func fetchStore(providerUidPath: String) async throws -> StoreDataModel {
        let storeRef = db.collection("Stores").document(providerUidPath)
        let document = try await storeRef.getDocument(as: StoreDataModel.self)
        storesDataSet = document
        return storesDataSet
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
    
    func updateShippingStatus(update shippingStatus: String, uidPath: String, orderID: String, userUidPath: String) async throws {
        //MARK: Provider Side
        let shippingRef = db.collection("users").document(uidPath).collection("ShippingList").document(orderID)
        try await shippingRef.updateData([
            "shippingStatus" : shippingStatus
        ])
        
        //MARK: Customer Side
        let userOrderRef = db.collection("users").document(userUidPath).collection("ProductOrdered").document(orderID)
        
        try await userOrderRef.updateData([
            "shippingStatus" : shippingStatus
        ])
        
    }
    
}


extension FirestoreForProducts {
    
    func summitCommentAndRatting(providerUidPath: String, productID: String, ratting: Int, comment: String, summitUserDisplayName: String) async throws {
        let commentRef = db.collection("ProductsProvider").document(providerUidPath).collection("Products").document(productID).collection("CommentAndRating")
        _ = try await commentRef.addDocument(data: [
            "comment" : comment,
            "ratting" : ratting,
            "uploadTimestamp" : Date(),
            "summitUserDisplayName" : summitUserDisplayName
        ])
    }
    
    
    @MainActor
    func fetchProductCommentAndRating(providerUidPath: String, productID: String) async throws {
        let commentRef = db.collection("ProductsProvider").document(providerUidPath).collection("Products").document(productID).collection("CommentAndRating")
        let document = try await commentRef.getDocuments().documents
        productCommentAndRatting = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: ProductCommentRattingDataModel.self)
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
    //MARK: Update product data in public when it calls
    
    func updatePublicAmountData(docID: String, providerUidPath: String, productID: String) async throws {
        let productRef = db.collection("ProductsProvider").document(providerUidPath).collection("Products").document(productID)
        let newAmount = try await productRef.getDocument(as: ProductProviderDataModel.self).productAmount
        let furniturePublicRef = db.collection("ProductsPublic").document(docID)
        try await furniturePublicRef.updateData([
            "productAmount" : newAmount
        ])
    }
}

extension FirestoreForProducts {
    //MARK: For provider update product description and product amount
    func updateProductAmountAndDesciption(uidPaht: String, productID: String, newProductAmount: String, newProductDescription: String) async throws {
        let productRef = db.collection("ProductsProvider").document(uidPaht).collection("Products").document(productID)
        try await productRef.updateData([
            "productAmount" : newProductAmount,
            "productDescription" : newProductDescription
        ])
        
        let furniturePublicRef = db.collection("ProductsPublic").document(productID)
        try await furniturePublicRef.updateData([
            "productAmount" : newProductAmount,
            "productDescription" : newProductDescription
        ])
    }
}

extension FirestoreForProducts {
    
    //MARK: UserCancelOrder
    func userCancelOrder(shippingStatus: ShippingStatus, providerUID: String, customerUID: String, orderID: String, productID: String, orderAmount: Int) async throws {
        if shippingStatus == .shipped || shippingStatus == .deliveried {
            throw BillError.shippedError
        }
        
        let shippingRef = db.collection("users").document(providerUID).collection("ShippingList").document(orderID)
        print("set bill shipping status: \(shippingStatus.rawValue)")
        try await shippingRef.updateData([
            "shippingStatus" : shippingStatus.rawValue
        ])
        let userOrderRef = db.collection("users").document(customerUID).collection("ProductOrdered").document(orderID)
        try await userOrderRef.updateData([
            "shippingStatus" : shippingStatus.rawValue
        ])
        
        
        //MARK: Update product Amount
        let productRef = db.collection("ProductsProvider").document(providerUID).collection("Products").document(productID)
        
        let currentAmount = try await productRef.getDocument(as: ProductProviderDataModel.self).productAmount
        print("current amount: \(currentAmount)")
        let convertInt = Int(currentAmount) ?? 0
        let restoreAmount = orderAmount + convertInt
        let converString = String(restoreAmount)
        print("new amount: \(converString)")
        try await productRef.updateData([
            "productAmount" : converString
        ])
    }
    
}

extension FirestoreForProducts {
    //MARK: Create function to store the ordered history for presenting in bar chart
    //MARK: Also create the data model to encode data
}
