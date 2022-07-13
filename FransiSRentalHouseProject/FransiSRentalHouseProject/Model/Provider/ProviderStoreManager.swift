//
//  ProviderStoreManager.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/25.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class ProviderStoreM: ObservableObject {
    let db = Firestore.firestore()

    //MARK: - Show Sign up store view
    @Published var showSignUpStore = false
    
    // MARK: - Provider store data

    @Published var storesData: ProviderStore = .empty

    // MARK: - Products in store

    @Published var storeProductsDataSet = [ProductDM]()

    // MARK: - Provider create their store

    func createStore(
        gui: String,
        provider store: ProviderStore
    ) async throws {
        let storeRef = db.collection("Stores").document(gui).collection("StoreData").document(gui)
        _ = try await storeRef.setData([
            "isSetConfig" : store.isSetConfig,
            "settlementDate" : store.settlementDate,
            "isCreateStore" : store.isCreateStore,
            "groupMemberAmount" : store.groupMemberAmount,
            "storeChatDocID" : store.storeChatDocID,
            "storeBackgroundImage" : store.storeBackgroundImage,
            "storeDescription" : store.storeDescription,
            "companyProfileImage" : store.companyProfileImage,
            "companyName" : store.companyName,
            "companyAddress" : store.companyAddress,
            "companyGUI" : store.companyGUI,
            "telNumber" : store.telNumber,
            "companyEmail" : store.companyEmail,
            "chargeName" : store.chargeName,
            "chargeID" : store.chargeID
        ])
        try await fetchStore(provider: gui)
    }

    // MARK: - Update store background image

    func updateProfilePic(
        gui: String,
        profileImage: String
    ) async throws {
        let storeRef = db.collection("Stores").document(gui)
        _ = try await storeRef.updateData([
            "storeBackgroundImage": profileImage,
        ])
    }

    // MARK: - Update store description

    func updateStoreInfo(
        gui: String,
        provider store: ProviderStore
    ) async throws {
        let storeRef = db.collection("Stores").document(gui).collection("StoreData").document(gui)
        _ = try await storeRef.updateData([
            "isSetConfig" : store.isSetConfig,
            "settlementDate" : store.settlementDate,
            "isCreateStore" : store.isCreateStore,
            "groupMemberAmount" : store.groupMemberAmount,
            "storeChatDocID" : store.storeChatDocID,
            "storeBackgroundImage" : store.storeBackgroundImage,
            "storeDescription" : store.storeDescription,
            "companyProfileImage" : store.companyProfileImage,
            "companyName" : store.companyName,
            "companyAddress" : store.companyAddress,
            "companyGUI" : store.companyGUI,
            "telNumber" : store.telNumber,
            "companyEmail" : store.companyEmail,
            "chargeName" : store.chargeName,
            "chargeID" : store.chargeID
        ])
    }

//    @MainActor
//    func fetchStoreInLocal(uidPath: String) async throws -> StoreDataModel {
//        let storeRef = db.collection("Stores").document(uidPath)
//        storeLocalData = try await storeRef.getDocument(as: ProviderStore.self)
//        return storeLocalData
//    }
//

    // MARK: - Fetch created store

    @MainActor
    func fetchStore(provider gui: String) async throws {
        let storeRef = db.collection("Stores").document(gui).collection("StoreData").document(gui)
        storesData = try await storeRef.getDocument(as: ProviderStore.self)
    }

    // MARK: - Fetch store's products

    @MainActor
    func fetchStoreProduct(provder gui: String) async throws {
        let productRef = db.collection("ProductsProvider").document(gui).collection("Products")
        let document = try await productRef.getDocuments().documents
        storeProductsDataSet = document.compactMap { queryDocumentSnapshot in
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
