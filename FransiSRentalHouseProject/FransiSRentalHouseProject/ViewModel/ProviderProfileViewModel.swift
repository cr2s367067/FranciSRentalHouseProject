//
//  ProviderProfileViewModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/13.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class ProviderProfileViewModel: ObservableObject {
    @Published var editMode = false
    @Published var settlementDate = Date()

    let db = Firestore.firestore()
    let paymentMM = PaymentMethodManager()

    @Published var providerConfig: ProviderConfigDM = .empty

    //MARK: - When provider close accounting
    func createSettlement(
        gui: String,
        settlement data: MonthlySettlementDM
    ) async throws {
        let storeRef = db.collection("Stores").document(gui).collection("StoreData").document(gui).collection("MonthlySettlement")
        _ = try await storeRef.addDocument(data: [
            "isCreatedMonthlySettlementData" : data.isCreatedMonthlySettlementData,
            "month" : data.month,
            "closeAmount" : data.closeAmount,
            "closeDate" : Date(),
        ])
    }

    func updateConfig(gui: String, settlementDate: Date) async throws {
        let storeRef = db.collection("Stores").document(gui).collection("StoreData").document(gui)
        try await storeRef.updateData([
            "isSetConfig": true,
            "settlementDate": settlementDate,
        ])
    }

//    func updateCreated(uidPath: String, isCreated: Bool) async throws {
//        let providerConfigRef = db.collection("users").document(uidPath).collection("ProviderConfiguration").document(uidPath)
//        try await providerConfigRef.updateData([
//            "isCreated": isCreated,
//        ])
//    }

//    func isCreateMonthlySettleData(gui: String) async throws {
//        let storeRef = db.collection("Stores").document(gui).collection("StoreData").document(gui).collection("MonthlySettlement")
//        try await storeRef.updateData([
//            "isCreatedMonthlySettlementData": true,
//        ])
//    }

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
            "settlementDate": nextMonth,
        ])
    }
}
