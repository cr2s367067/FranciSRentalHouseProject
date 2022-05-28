//
//  SoldProductCollectionManager.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/2.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class SoldProductCollectionManager: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var fetchSettleData = [ProductSoldCollectionDataModel]()
    @Published var soldDataSet = [ProductSoldCollectionDataModel]()
    @Published var fetchComplete = false
    
    func postSoldInfo(providerUidPath: String, proDocID: String, productName: String, productPrice: Int, soldAmount: Int) async throws {
        let soldRef = db.collection("ProductsProvider").document(providerUidPath).collection("Products").document(proDocID).collection("SoldProducts")
        _ = try await soldRef.addDocument(data: [
            "soldDate" : Date(),
            "productName" : productName,
            "productPrice" : productPrice,
            "soldAmount" : soldAmount
        ])
    }
    
    func loopInProducts(providerUidPath: String) async throws {
        var tempHolder = [ProductProviderDataModel]()
        let productRef = db.collection("ProductsProvider").document(providerUidPath).collection("Products")
        let getDocuments = try await productRef.getDocuments().documents
        tempHolder = getDocuments.compactMap { queryDocumentSnapshot in
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
        }
        for holder in tempHolder {
            guard let id = holder.id else { return }
            try await fetchPostSoldInfo(providerUidPath: providerUidPath, proDocID: id)
            print(soldDataSet)
        }
    }
    
    @MainActor
    func fetchPostSoldInfo(providerUidPath: String, proDocID: String) async throws {
        var tempHolder = [ProductSoldCollectionDataModel]()
        let soldRef = db.collection("ProductsProvider").document(providerUidPath).collection("Products").document(proDocID).collection("SoldProducts")
        let document = try await soldRef.getDocuments().documents
        tempHolder = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: ProductSoldCollectionDataModel.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print(error.localizedDescription)
            }
            return nil
        })
        fetchingProcess(input: tempHolder) {
            fetchComplete = true
        }
    }
    
    func fetchingProcess(input: [ProductSoldCollectionDataModel], completion: () -> Void) {
        for input in input {
            soldDataSet.append(input)
            print("Array count: \(soldDataSet.count)")
        }
        completion()
        print("Fetch status: \(fetchComplete)")
    }
    
    func summitSettleProducIncome(providerUidPath: String, docID: String, input: ProductSoldCollectionDataModel) async throws {
        let settlementMonthlyIncomeRef = db.collection("users").document(providerUidPath).collection("MonthlySettlement").document(docID).collection("MonthlyIncome")
        _ = try await settlementMonthlyIncomeRef.addDocument(data: [
            "productName" : input.productName,
            "productPrice" : input.productPrice,
            "soldAmount" : input.soldAmount,
            "soldDate" : input.soldDate?.dateValue() ?? Date()
        ])
    }
    
    @MainActor
    func fetchSettleData(providerUidPath: String, docID: String) async throws {
        let settlementMonthlyIncomeRef = db.collection("users").document(providerUidPath).collection("MonthlySettlement").document(docID).collection("MonthlyIncome")
        let document = try await settlementMonthlyIncomeRef.getDocuments().documents
        fetchSettleData = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: ProductSoldCollectionDataModel.self)
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
