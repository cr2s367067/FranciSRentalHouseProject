//
//  FirestoreForFurnitureOrder.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/28.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SwiftUI

class FirestoreForProducts: ObservableObject {
    let db = Firestore.firestore()

    // MARK: - Name Enum

    enum PaymentMethodStatus: String {
        case creditCard = "Credit Card"
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

    //MARK: - Fetch products in provider side
    
    @Published var productProviderSide = [ProductDM]()
    
    
    
    
    // MARK: - Public product collectino

    @Published var publicProductDataSet = [ProductDM]()

    @Published var uploadingHolder: ProductDM = .empty

    
    
    // MARK: - Fetch user order data

    @Published var userOrderedDataSet = [OrderedListUserSide]()

    // MARK: - Fetch user's order list contain

    @Published var fetchOrderedDataSet = [OrderedItem]()

    // MARK: - Fetch provider receive order

    @Published var purchasedUserDataSet = [OrderedListProviderSide]()

    // MARK: - Fetch provder receiv order contain

    @Published var cartListDataSet = [OrderListContain]()

    // MARK: - User marked their focusing product

    @Published var markedProducts = [CustomerMarkedProduct]()

    @Published var getMarkedProductDetail = [ProductDM]()

    // MARK: - Holder creating product's uid

    @Published var productUID = ""
//    @Published var storesDataSet: StoreDataModel = .empty

    // MARK: - Products comments and ratting

    
    @Published var productCommentAndRatting = [ProductCommentRatting]()

    //MARK: - shipping and payment information
    @Published var shippingMethod: ShippingMethod = .convenienceStore
    @Published var shippingStatus: ShippingStatus = .orderBuilt
    @Published var paymentMethod: PaymentMethodStatus = .creditCard

    func productIDGenerator() -> String {
        return UUID().uuidString
    }

    // MARK: - Provider creates and upload new product

    @MainActor
    func summitProduct(
        gui: String,
        product config: ProductDM
    ) async throws {
        let productRef = db.collection("ProductsProvider").document(gui).collection("Products").document(config.productUID)
        _ = try await productRef.setData([
            "providerUID": config.providerUID,
            "providerGUI" : gui,
            "productUID": config.productUID,
            "productName": config.productName,
            "productPrice": config.productPrice,
            "productDescription": config.productDescription,
            "productFrom": config.productFrom,
            "productAmount": config.productAmount,
            "isSoldOut": config.isSoldOut,
            "productType": config.productType,
            "coverImage": config.coverImage,
            "postDate": Date()
        ])
        uploadingHolder = try await productRef.getDocument(as: ProductDM.self)
    }

    //MARK: - Fetch product in provider side
    @MainActor
    func getProductsProviderSide(
        gui: String
    ) async throws {
        let productRef = db.collection("ProductsProvider").document(gui).collection("Products")
        let document = try await productRef.getDocuments().documents
        productProviderSide = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: ProductDM.self)
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
    
    // MARK: - Get uploading data then publish whole data to public

    @MainActor
    func getUploadintData(gui: String, productUID: String) async throws {
        let productRef = db.collection("ProductsProvider").document(gui).collection("Products").document(productUID)
        uploadingHolder = try await productRef.getDocument(as: ProductDM.self)
    }

    // MARK: - Publish product in public collection

    func productPublishOnPublic(
        procut config: ProductDM
    ) async throws {
        let productPublicRef = db.collection("ProductsPublic").document(config.productUID)
        _ = try await productPublicRef.setData([
            "providerUID": config.providerUID,
            "providerGUI" : config.providerGUI,
            "productUID": config.productUID,
            "productName": config.productName,
            "productPrice": config.productPrice,
            "productDescription": config.productDescription,
            "productFrom": config.productFrom,
            "productAmount": config.productAmount,
            "isSoldOut": config.isSoldOut,
            "productType": config.productType,
            "coverImage": config.coverImage,
            "postDate": Date()
        ])
    }

    // MARK: - Fetch products from public collection

    func listeningProduct() {
        let productPublicRef = db.collection("ProductsPublic")
        productPublicRef.addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot?.documents else { return }
            self.publicProductDataSet = document.compactMap { queryDocumentSnapshot in
                let result = Result {
                    try queryDocumentSnapshot.data(as: ProductDM.self)
                }
                switch result {
                case .success(let data):
                    return data
                case .failure(let error):
                    print("error eccure: \(error.localizedDescription)")
                }
                return nil
            }
        }
    }
}

extension FirestoreForProducts {
    func initOrderID() -> String {
        return UUID().uuidString
    }

    // MARK: - User make order

    func makeOrder(
        uidPath: String,
//        product config: ProductDM,
        userMake order: OrderedListUserSide,
        list item: OrderedItem,
        provider shippingList: OrderedListProviderSide,
        order contain: OrderListContain
    ) async throws {
        // MARK: Store User's order in user side

        let orderRef = db.collection("User").document(uidPath).collection("ProductOrdered").document(order.orderUID)
        _ = try await orderRef.setData([
            "orderDate": Date(),
            "orderUID" : order.orderUID,
            "paymentMethod" : order.paymentMethod,
            "shippingMethod" : order.shippingMethod,
            "shippingAddress" : order.shippingAddress,
            "shippingStatus" : order.shippingStatus,
            "subTotal" : order.subTotal
        ])

        // MARK: Presenting each item in order list

        let productDetailRef = orderRef.collection("ProductList").document(item.productUID)
        _ = try await productDetailRef.setData([
            "shippingStatus" : item.shippingStatus,
            "providerUID" : item.providerUID,
            "providerGUI" : item.providerGUI,
            "productUID" : item.productUID,
            "orderProductPrice" : item.orderProductPrice,
            "productImage" : item.productImage,
            "productName" : item.productName,
            "orderAmount" : item.orderAmount
        ])

        // MARK: Each provider could get their product order

        let shippingRef = db.collection("Stores").document(item.providerGUI).collection("ShippingList").document(order.orderUID)
        // store user basic info include shipping info
        _ = try await shippingRef.setData([
            "orderUID": shippingList.orderUID,
            "orderAmount": shippingList.orderAmount,
            "shippingStatus": shippingList.shippingStatus,
            "shippingAddress": shippingList.shippingAddress,
            "orderName": shippingList.orderName,
            "orderPersonUID": uidPath,
            "shippingMethod": shippingList.shippingMethod,
        ])

        // MARK: Provider ships their product

        let cartRef = shippingRef.collection("ListContain").document(contain.productUID)
        // auto doc id with products info
        _ = try await cartRef.setData([
            "productUID": contain.productUID,
            "productName": contain.productName,
            "productPrice": contain.productPrice,
            "productImageURL": contain.productImageURL,
            "productOrderAmount": contain.productOrderAmount,
            "isPrepare": contain.isPrepare,
        ])
    }
    

    // MARK: - When user made order that will update product amount

    func updateAmount(
        gui: String,
        productUID: String,
        netAmount: String
    ) async throws {
        let productRef = db.collection("ProductsProvider").document(gui).collection("Products").document(productUID)
        try await productRef.updateData([
            "productAmount": netAmount,
        ])
    }

    // MARK: - Fetch user order data

    @MainActor
    func fetchOrderedDataUserSide(uidPath: String) async throws {
        let orderRef = db.collection("User").document(uidPath).collection("ProductOrdered")
        print("get ref: \(orderRef)")
        let document = try await orderRef.getDocuments().documents
        print("get doc: \(document)")
        userOrderedDataSet = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: OrderedListUserSide.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print(error.localizedDescription)
            }
            return nil
        }
    }

    // MARK: - Fetch provider receives order

    @MainActor
    func fetchOrdedDataProviderSide(uidPath: String) async throws {
        let shippingRef = db.collection("Stores").document(uidPath).collection("ShippingList").order(by: "createTimestamp", descending: false)
        print("Find ref: \(shippingRef)")
        let purchasedUsers = try await shippingRef.getDocuments().documents
        print("try get doc: \(purchasedUsers)")
        purchasedUserDataSet = purchasedUsers.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: OrderedListProviderSide.self)
            }
            switch result {
            case let .success(data):
                return data
            case let .failure(error):
                print(error.localizedDescription)
            }
            return nil
        }
    }

    // MARK: - Fetch provider receives order contain

    @MainActor
    func fetchOrdedDataInCartList(provider uidPath: String, orderUID: String) async throws {
        let cartListRef = db.collection("Stores").document(uidPath).collection("ShippingList").document(orderUID).collection("ListContain")
        print("find document path: \(cartListRef)")
        let cartList = try await cartListRef.getDocuments().documents
        print("try get contain: \(cartList)")
        cartListDataSet = cartList.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: OrderListContain.self)
            }
            print("try to get result: \(result)")
            switch result {
            case let .success(data):
                return data
            case let .failure(error):
                print(error.localizedDescription)
            }
            return nil
        }
    }

    // MARK: - Fetch User's orderList contain

    @MainActor
    func fetchOrderedData(uidPath: String, orderID: String) async throws {
        let orderRef = db.collection("User").document(uidPath).collection("ProductOrdered").document(orderID).collection("ProductList")
        let document = try await orderRef.getDocuments().documents
        fetchOrderedDataSet = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: OrderedItem.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print(error.localizedDescription)
            }
            return nil
        }
    }

    // MARK: - User leave product comment and ratring

    func userToSummitProductComment(
        productData: OrderedItem,
        comment: ProductCommentRatting
    ) async throws {
        let commentRef = db.collection("ProductsPublic").document(productData.productUID).collection("CommentAndRatting")
        debugPrint("Get productUID")
        _ = try await commentRef.addDocument(data: [
            "productUID" : comment.productUID,
            "providerUID" : comment.providerUID,
            "comment" : comment.comment,
            "ratting" : comment.ratting,
            "uploadUserID" : comment.uploadUserID,
            "customerDisplayName" : comment.customerDisplayName,
            "uploadTimestamp" : Date()
        ])
    }
}

extension FirestoreForProducts {
    // MARK: - For user to mark the product that they like

    func bookMark(
        user uidPath: String,
        marked product: CustomerMarkedProduct
    ) async throws {
        let bookMarkRef = db.collection("User").document(uidPath).collection("MarkedProducts")
        _ = try await bookMarkRef.addDocument(data: [
            "isMark": product.isMark,
            "providerUID": product.providerUID,
            "productUID": product.productUID,
        ])
    }

    // MARK: - Fetch user marked product

    @MainActor
    func fetchMarkedProducts(uidPath: String) async throws {
        let bookMarkRef = db.collection("User").document(uidPath).collection("MarkedProducts")
        let document = try await bookMarkRef.getDocuments().documents
        markedProducts = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: CustomerMarkedProduct.self)
            }
            switch result {
            case let .success(data):
                return data
            case let .failure(error):
                print("error: \(error.localizedDescription)")
            }
            return nil
        }
    }

    // MARK: -  Try to get marked product from public newest data

    @MainActor
    func getMarkedProductFromPublish(
        marked productUIDSet: [String]
    ) async throws {
        for productUID in productUIDSet {
            let productPublicRef = db.collection("ProductsPublic").whereField(productUID, isEqualTo: productUID)
            let document = try await productPublicRef.getDocuments().documents
            getMarkedProductDetail = document.compactMap { queryDocumentSnapshot in
                let result = Result {
                    try queryDocumentSnapshot.data(as: ProductDM.self)
                }
                switch result {
                case let .success(data):
                    return data
                case let .failure(error):
                    print(error.localizedDescription)
                }
                return nil
            }
        }
    }

    // MARK: - User unmarked their focued products

    func unSignBookMarked(
        uidPath: String,
        id: String
    ) async throws {
        let bookMarkRef = db.collection("User").document(uidPath).collection("MarkedProducts").document(id)
        try await bookMarkRef.delete()
    }
}

extension FirestoreForProducts {
    // MARK: - Updating shipping status

    func updateShippingStatus(
        update shippingStatus: String,
        provider uidPath: String,
        orderUID: String,
        customer userUID: String
    ) async throws {
        // MARK: Provider Side

        let shippingRef = db.collection("Stores").document(uidPath).collection("ShippingList").document(orderUID)
        try await shippingRef.updateData([
            "shippingStatus": shippingStatus,
        ])

        // MARK: Customer Side

        let userOrderRef = db.collection("User").document(userUID).collection("ProductOrdered").document(orderUID)
        try await userOrderRef.updateData([
            "shippingStatus": shippingStatus,
        ])
    }
}

extension FirestoreForProducts {
//    func summitCommentAndRatting(
//        providerUidPath: String,
//        productID: String,
//        ratting: Int,
//        comment: String,
//        summitUserDisplayName: String
//    ) async throws {
//        let commentRef = db.collection("ProductsProvider").document(providerUidPath).collection("Products").document(productID).collection("CommentAndRating")
//        _ = try await commentRef.addDocument(data: [
//            "comment" : comment,
//            "ratting" : ratting,
//            "uploadTimestamp" : Date(),
//            "summitUserDisplayName" : summitUserDisplayName
//        ])
//    }

    // MARK: - Fetch products comment and ratting

    @MainActor
    func fetchProductCommentAndRatting(productUID: String) async throws {
        let commentRef = db.collection("ProductsPublic").document(productUID).collection("CommentAndRatting")
        let document = try await commentRef.getDocuments().documents
        productCommentAndRatting = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: ProductCommentRatting.self)
            }
            switch result {
            case let .success(data):
                return data
            case let .failure(error):
                print(error.localizedDescription)
            }
            return nil
        }
    }
    
}

// extension FirestoreForProducts {
//    //MARK: Update product data in public when it calls
//    func updatePublicAmountData(
//        docID: String,
//        providerUidPath: String,
//        productID: String
//    ) async throws {
//        let productRef = db.collection("ProductsProvider").document(providerUidPath).collection("Products").document(productID)
//        let newAmount = try await productRef.getDocument(as: ProductProviderDataModel.self).productAmount
//        let furniturePublicRef = db.collection("ProductsPublic").document(docID)
//        try await furniturePublicRef.updateData([
//            "productAmount" : newAmount
//        ])
//    }
// }

extension FirestoreForProducts {
    // MARK: For provider update product description and product amount

    func updateProductAmountAndDesciption(
        product config: ProductDM
    ) async throws {
        let productRef = db.collection("ProductsProvider").document(config.providerGUI).collection("Products").document(config.productUID)
        try await productRef.updateData([
            "providerUID": config.providerUID,
            "providerGUI" : config.providerGUI,
            "productUID": config.productUID,
            "productName": config.productName,
            "productPrice": config.productPrice,
            "productDescription": config.productDescription,
            "productFrom": config.productFrom,
            "productAmount": config.productAmount,
            "isSoldOut": config.isSoldOut,
            "productType": config.productType,
            "coverImage": config.coverImage,
            "postDate": Date()
        ])
        
        
        
        let furniturePublicRef = db.collection("ProductsPublic").document(config.productUID)
        try await furniturePublicRef.updateData([
            "providerUID": config.providerUID,
            "providerGUI" : config.providerGUI,
            "productUID": config.productUID,
            "productName": config.productName,
            "productPrice": config.productPrice,
            "productDescription": config.productDescription,
            "productFrom": config.productFrom,
            "productAmount": config.productAmount,
            "isSoldOut": config.isSoldOut,
            "productType": config.productType,
            "coverImage": config.coverImage,
            "postDate": Date()
        ])
    }
}

extension FirestoreForProducts {
    // MARK: UserCancelOrder

    func userCancelOrder(
        shippingStatus: ShippingStatus,
        gui: String,
        customerUID: String,
        orderID: String,
        productUID: String,
        orderAmount: Int
    ) async throws {
        if shippingStatus == .shipped || shippingStatus == .deliveried {
            throw BillError.shippedError
        }

        // MARK: Provider side

        let shippingRef = db.collection("Stores").document(gui).collection("ShippingList").document(orderID)
        print("set bill shipping status: \(shippingStatus.rawValue)")
        try await shippingRef.updateData([
            "shippingStatus": shippingStatus.rawValue,
        ])

        // MARK: User side
        let userOrderRef = db.collection("User").document(customerUID).collection("ProductOrdered").document(orderID)
        try await userOrderRef.updateData([
            "shippingStatus" : shippingStatus.rawValue
        ])
        let userOrderItemRef = userOrderRef.collection("ProductList").document(productUID)
        try await userOrderItemRef.updateData([
            "shippingStatus": shippingStatus.rawValue
        ])

        // MARK: - Update product Amount

        // MARK: Provider side

        let productRef = db.collection("ProductsProvider").document(gui).collection("Products").document(productUID)

        let currentAmount = try await productRef.getDocument(as: ProductDM.self).productAmount
        print("current amount: \(currentAmount)")
        let currentAmountConvertInt = Int(currentAmount) ?? 0
        let restoreAmount = orderAmount + currentAmountConvertInt
        print("new amount: \(restoreAmount)")
        try await productRef.updateData([
            "productAmount": restoreAmount
        ])

        // MARK: Public Side

        let productPublicRef = db.collection("ProductsPublic").document(productUID)

        let currentAmountP = try await productPublicRef.getDocument(as: ProductDM.self).productAmount
        let currentAmountPConvertInt = Int(currentAmountP) ?? 0
        let restoreAmountP = orderAmount + currentAmountPConvertInt
        try await productPublicRef.updateData([
            "productAmount": restoreAmountP,
        ])
    }
}

extension FirestoreForProducts {
    // MARK: Create function to store the ordered history for presenting in bar chart

    // MARK: Also create the data model to encode data
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

//    func updateBookMarkInfo(uidPath: String, productUID: String, providerUID: String, productName: String, productPrice: String, productImage: String, productFrom: String, isSoldOut: Bool, productAmount: String, productDescription: String, providerName: String, docID: String) async throws {
//        let bookMarkRef = db.collection("User").document(uidPath).collection("MarkedProducts").document(docID)
//        _ = try await bookMarkRef.updateData([
//            "productUID" : productUID,
//            "providerUID" : providerUID,
//            "productName" : productName,
//            "productPrice" : productPrice,
//            "productImage" : productImage,
//            "productFrom" : productFrom,
//            "isSoldOut" : isSoldOut,
//            "productAmount" : productAmount,
//            "productDescription" : productDescription,
//            "providerName" : providerName
//        ])
//    }
