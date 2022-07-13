//
//  SoldProductCollectionManager.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/2.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class SoldProductCollectionManager: ObservableObject {
    let db = Firestore.firestore()

    @Published var fetchSettleData = [ProductSoldCollectionDataModel]()
    @Published var soldDataSet = [SoldProductDataModel]()
    @Published var fetchComplete = false

    func postSoldInfo(
        gui: String,
        productUID: String,
        sold product: SoldProductDataModel
    ) async throws {
        let soldRef = db.collection("ProductsProvider").document(gui).collection("Products").document(productUID).collection("SoldProducts")
        _ = try await soldRef.addDocument(data: [
            "soldDate" : Date(),
            "productName" : product.productName,
            "productUID" : product.productUID,
            "buyerUID" : product.buyerUID,
            "productPrice" : product.productPrice,
            "soldAmount" : product.soldAmount
        ])
    }

    func loopInProducts(
        gui: String
    ) async throws {
        var tempHolder = [ProductDM]()
        let productRef = db.collection("ProductsProvider").document(gui).collection("Products")
        let getDocuments = try await productRef.getDocuments().documents
        tempHolder = getDocuments.compactMap { queryDocumentSnapshot in
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
        for holder in tempHolder {
            try await fetchPostSoldInfo(
                gui: holder.providerGUI,
                productUID: holder.productUID
            )
            print(soldDataSet)
        }
    }

    @MainActor
    func fetchPostSoldInfo(
        gui: String,
        productUID: String
    ) async throws {
        var tempHolder = [SoldProductDataModel]()
        let soldRef = db.collection("ProductsProvider").document(gui).collection("Products").document(productUID).collection("SoldProducts")
        let document = try await soldRef.getDocuments().documents
        tempHolder = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: SoldProductDataModel.self)
            }
            switch result {
            case let .success(data):
                return data
            case let .failure(error):
                print(error.localizedDescription)
            }
            return nil
        }
        fetchingProcess(input: tempHolder) {
            fetchComplete = true
        }
    }

    func fetchingProcess(input: [SoldProductDataModel], completion: () -> Void) {
        for input in input {
            soldDataSet.append(input)
            print("Array count: \(soldDataSet.count)")
        }
        completion()
        print("Fetch status: \(fetchComplete)")
    }

    func summitSettleProducIncome(
        gui: String,
        product: SoldProductDataModel
    ) async throws {
        let settlementMonthlyIncomeRef = db.collection("Stores").document(gui).collection("MonthlySettlement")
        _ = try await settlementMonthlyIncomeRef.addDocument(data: [
            "soldDate" : Date(),
            "productName" : product.productName,
            "productUID" : product.productUID,
            "buyerUID" : product.buyerUID,
            "productPrice" : product.productPrice,
            "soldAmount" : product.soldAmount
        ])
    }

    @MainActor
    func fetchSettleData(providerUidPath: String, docID: String) async throws {
        let settlementMonthlyIncomeRef = db.collection("users").document(providerUidPath).collection("MonthlySettlement").document(docID).collection("MonthlyIncome")
        let document = try await settlementMonthlyIncomeRef.getDocuments().documents
        fetchSettleData = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: ProductSoldCollectionDataModel.self)
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
