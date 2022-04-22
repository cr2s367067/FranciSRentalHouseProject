//
//  ProviderProfileViewModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/13.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProviderProfileViewModel: ObservableObject {
    @Published var editMode = false
    @Published var settlementDate = Date()
    
    let db = Firestore.firestore()
    let paymentMM = PaymentMethodManager()
    
    @Published var providerConfig: ProviderConfigDM = .empty
    
    func createConfig(uidPath: String) async throws {
        let providerConfigRef = db.collection("users").document(uidPath).collection("ProviderConfiguration").document(uidPath)
        try await providerConfigRef.setData([
            "isSetConfig" : false,
            "settlementDate" : Date(),
            "isCreated" : false
        ])
    }
    
    func updateConfig(uidPath: String, settlementDate: Date) async throws {
        let providerConfigRef = db.collection("users").document(uidPath).collection("ProviderConfiguration").document(uidPath)
        try await providerConfigRef.updateData([
            "isSetConfig" : true,
            "settlementDate" : settlementDate
        ])
    }
    
    func updateCreated(uidPath: String, isCreated: Bool) async throws {
        let providerConfigRef = db.collection("users").document(uidPath).collection("ProviderConfiguration").document(uidPath)
        try await providerConfigRef.updateData([
            "isCreated" : isCreated
        ])
    }
    
    @MainActor
    func fetchConfigData(uidPath: String) async throws -> ProviderConfigDM {
        let providerConfigRef = db.collection("users").document(uidPath).collection("ProviderConfiguration").document(uidPath)
        let document = try await providerConfigRef.getDocument(as: ProviderConfigDM.self)
        providerConfig = document
        return providerConfig
    }
    
    func computeNextSettleMonthAndUpdate(currentSettleDate: Date, uidPath: String) async throws {
        let nextMonth = paymentMM.computePaymentMonth(from: currentSettleDate)
        let providerConfigRef = db.collection("users").document(uidPath).collection("ProviderConfiguration").document(uidPath)
        try await providerConfigRef.updateData([
            "settlementDate" : nextMonth
        ])
    }
}
