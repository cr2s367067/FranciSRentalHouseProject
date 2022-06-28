//
//  PaymentReceiveManager.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/13.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class PaymentReceiveManager: ObservableObject {
    let db = Firestore.firestore()

    @Published var dataCollection = [PaymentHistoryDataModel]()
    @Published var monthlySettlement = [ReceivePaymentDateModel]()
    @Published var fetchResult = [PaymentHistoryDataModel]()

    @Published var settlementResultAmount: Int = 0
    var receivePayment = [Int]()

    // MARK: Determin month

    func computeMonthlySettlement(input: [PaymentHistoryDataModel]) -> Int {
        var result = 0
        input.forEach { data in
            let convertInt = Int(data.pastPaymentFee) ?? 0
            result += convertInt
        }
        return result
    }

    // MARK: Fetch monthly payment receive and sum up

//    func sumUpPayment(input: [Int]) async -> Int {
//        var result = 0
//        input.forEach { pay in
//            result += pay
//        }
//        return result
//    }

    // MARK: upload sum up data monthly

    func createMonthlySettlement(uidPath: String, settlementDate: Date) async throws {
        let settlementRef = db.collection("users").document(uidPath).collection("MonthlySettlement")
        _ = try await settlementRef.addDocument(data: [
            "isSettle": false,
            "isFetchHistoryData": false,
            "settlementDate": settlementDate,
            "settlementAmount": 0,
        ])
    }

    func markFetchData(uidPath: String, docID: String) async throws {
        let settlementRef = db.collection("users").document(uidPath).collection("MonthlySettlement").document(docID)
        try await settlementRef.updateData([
            "isFetchHistoryData": true,
        ])
    }

    func updateMonthlySettlement(uidPath: String, docID: String, settlementAmount: Int, settlementDate _: Date) async throws {
        let settlementRef = db.collection("users").document(uidPath).collection("MonthlySettlement").document(docID)
        try await settlementRef.updateData([
            "isSettle": true,
            "settlementAmount": settlementAmount,
        ])
    }

    @MainActor
    func fetchMonthlyIncome(uidPath: String, docID: String) async throws {
        let settlementMonthlyIncomeRef = db.collection("users").document(uidPath).collection("MonthlySettlement").document(docID).collection("MonthlyIncome")
        Task(priority: .medium) {
            let document = try await settlementMonthlyIncomeRef.getDocuments().documents
            fetchResult = document.compactMap { queryDocumentSnapshot in
                let result = Result {
                    try queryDocumentSnapshot.data(as: PaymentHistoryDataModel.self)
                }
                switch result {
                case let .success(data):
                    return data
                case let .failure(error):
                    print("error eccure: \(error.localizedDescription)")
                }
                return nil
            }
        }
    }

    func summitMonthlyIncome(
        uidPath: String,
        docID: String,
        pastPaymentFee: Int,
        paymentDate: Date
    ) async throws {
        let settlementMonthlyIncomeRef = db.collection("users").document(uidPath).collection("MonthlySettlement").document(docID).collection("MonthlyIncome")
        _ = try await settlementMonthlyIncomeRef.addDocument(data: [
            "pastPaymentFee": pastPaymentFee,
            "paymentDate": paymentDate,
        ])
    }

    // MARK: Fetch monthly sum up data from cloud then set the monthly settlement in bar chart.

    @MainActor
    func fetchMonthlySettlement(uidPath: String) async throws {
        let settlementRef = db.collection("users").document(uidPath).collection("MonthlySettlement").order(by: "settlementDate", descending: false)
        let document = try await settlementRef.getDocuments().documents
        monthlySettlement = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: ReceivePaymentDateModel.self)
            }
            switch result {
            case let .success(data):
                return data
            case let .failure(error):
                print("some error eccure: \(error.localizedDescription)")
            }
            return nil
        }
    }

    func checkIsSettlementDate(currentDate: Date, setDate: ReceivePaymentDateModel) throws -> Bool {
        var evaluate = false
        let cal = Calendar.current
        let converCurDat = cal.dateComponents([.year, .month, .day], from: currentDate)
        let converSetDat = cal.dateComponents([.year, .month, .day], from: setDate.settlementDate)
        if converCurDat.year == converSetDat.year, converCurDat.month == converSetDat.month, converCurDat.day == converSetDat.day {
            evaluate = true
        } else {
            throw SettlementError.settlementDateError
        }
        return evaluate
    }
}
