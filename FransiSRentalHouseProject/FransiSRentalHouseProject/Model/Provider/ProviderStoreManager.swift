//
//  ProviderStoreManager.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


class PrivderStoreM: ObservableObject {
    
    let db = Firestore.firestore()
    
    //MARK: - Provider store data
    @Published var storesData: ProviderStore = .empty
    
    //MARK: - Products in store
    @Published var storeProductsDataSet = [ProductDM]()
    
    //MARK: - Provider create their store
    func createStore(
        uidPath: String,
        provider store: ProviderStore
    ) async throws {
        let storeRef = db.collection("Stores").document(uidPath)
        _ = try await storeRef.setData([
            "isCreateGroup" : store.isCreateGroup,
            "isSetConfig" : store.isSetConfig,
            "settlementDate" : store.settlementDate,
            "isCreateStore" : store.isCreateStore,
            "groupMemberAmount" : store.groupMemberAmount,
            "RentalManagerLicenseNumber" : store.rentalManagerLicenseNumber ?? "",
            "storeChatDocID" : store.storeChatDocID,
            "storeBackgroundImage" : store.storeBackgroundImage,
            "storeDescription" : store.storeDescription
        ])
    }
    
    //MARK: - Update store background image
    func updateProfilePic(uidPath: String, profileImage: String) async throws {
        let storeRef = db.collection("Stores").document(uidPath)
        _ = try await storeRef.updateData([
            "storeBackgroundImage" : profileImage
        ])
    }
    
    //MARK: - Update store description
    func updateStoreInfo(uidPath: String, providerDescription: String) async throws {
        let storeRef = db.collection("Stores").document(uidPath)
        _ = try await storeRef.updateData([
            "storeDescription" : providerDescription
        ])
    }
    
    
    
//    @MainActor
//    func fetchStoreInLocal(uidPath: String) async throws -> StoreDataModel {
//        let storeRef = db.collection("Stores").document(uidPath)
//        storeLocalData = try await storeRef.getDocument(as: ProviderStore.self)
//        return storeLocalData
//    }
//
    
    //MARK: - Fetch created store
    @MainActor
    func fetchStore(provider uidPath: String) async throws {
        let storeRef = db.collection("Stores").document(uidPath)
        storesData = try await storeRef.getDocument(as: ProviderStore.self)
    }
    
    //MARK: - Fetch store's products
    @MainActor
    func fetchStoreProduct(provder uidPath: String) async throws {
        let productRef = db.collection("ProductsProvider").document(uidPath).collection("Products")
        let document = try await productRef.getDocuments().documents
        storeProductsDataSet = document.compactMap({ queryDocumentSnapshot in
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
    
    
}
