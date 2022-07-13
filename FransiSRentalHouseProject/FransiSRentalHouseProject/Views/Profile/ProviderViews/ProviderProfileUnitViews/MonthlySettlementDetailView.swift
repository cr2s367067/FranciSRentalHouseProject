//
//  MonthlySettlementDetailView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/14.
//

import SwiftUI

struct MonthlySettlementDetailView: View {
    @EnvironmentObject var soldProductCollectionManager: SoldProductCollectionManager
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var providerProfileViewModel: ProviderProfileViewModel
    @EnvironmentObject var paymentReceiveManager: PaymentReceiveManager
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var paymentMM: PaymentMethodManager

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    @State private var providerStatus: ProviderTypeStatus = .roomProvider

    var settleData: ReceivePaymentDateModel

    var body: some View {
        VStack {
            Group {
                HStack {
                    Text("Post Amount: ")
                    Text("\(settleData.settlementAmount)")
                    Spacer()
                }
                .foregroundColor(.primary)
                HStack {
                    Text("Post Date: ")
                    Text(settleData.settlementDate, format: Date.FormatStyle().year().month().day())
                    Spacer()
                }
                .foregroundColor(.primary)
            }
            .foregroundColor(.white)
            Spacer()
            HStack {
                Spacer()
                Button {
                    Task {
                        do {
                            _ = try paymentReceiveManager.checkIsSettlementDate(currentDate: Date(), setDate: settleData)
                            guard settleData.isFetchHistoryData == false else {
                                throw SettlementError.historyFetchingError
                            }
                            try await identityProviderFunc(type: ProviderTypeStatus(rawValue: firestoreToFetchUserinfo.fetchedUserData.providerType) ?? .roomProvider)
                            try await paymentReceiveManager.markFetchData(uidPath: firebaseAuth.getUID(), docID: settleData.id ?? "")
                            try await paymentReceiveManager.fetchMonthlySettlement(uidPath: firebaseAuth.getUID())
                        } catch {
                            self.errorHandler.handle(error: error)
                        }
                    }
                } label: {
                    Text("Load Date")
                        .foregroundColor(.white)
                        .frame(width: 120, height: 35)
                        .background(Color("buttonBlue"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                if settleData.isFetchHistoryData == true {
                    NavigationLink {
                        ListDetailView(settleData: settleData)
                    } label: {
                        Text("View Detail")
                            .foregroundColor(.white)
                            .frame(width: 125, height: 35)
                            .background(Color("buttonBlue"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(width: uiScreenWidth - 40, height: uiScreenHeight / 7, alignment: .center)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.brown)
        }
    }
}

extension MonthlySettlementDetailView {
    func identityProviderFunc(type: ProviderTypeStatus) async throws {
        if type == .roomProvider {
            print("provider Typd: \(type.rawValue)")
            try await settlementMonthlyPayment(currentDate: providerProfileViewModel.settlementDate, docID: settleData.id ?? "")
        }
        if type == .productProvider {
            print("provider Typd: \(type.rawValue)")
            guard soldProductCollectionManager.fetchComplete == false else { return }
            guard let id = settleData.id else { return }
            try await soldProductCollectionManager.loopInProducts(
                gui: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? ""
            )
            try await loopSoldProduct(
                currentDate: Date(),
                docID: id,
                fetchedArray: soldProductCollectionManager.soldDataSet
            )
        }
    }

    // MARK: Loop in product array and summit to store data

    func loopSoldProduct(
        currentDate: Date,
        docID: String,
        fetchedArray: [SoldProductDataModel]
    ) async throws {
        let cal = Calendar.current
        let convertDate = cal.dateComponents([.year, .month], from: currentDate)
        for soldProduct in fetchedArray {
            let convertRecDate = cal.dateComponents([.year, .month], from: soldProduct.soldDate?.dateValue() ?? Date())
            if convertDate.year == convertRecDate.year, convertDate.month == convertRecDate.month {
                debugPrint("upload data...")
                try await soldProductCollectionManager.summitSettleProducIncome(
                    gui: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? "",
                    product: soldProduct
                )
            }
        }

        _ = firestoreToFetchRoomsData.receivePaymentDataSet.map { pay in
            let cal = Calendar.current
            let convertDate = cal.dateComponents([.year, .month], from: currentDate)
            let convertReceivePaymentDate = cal.dateComponents([.year, .month], from: pay.paymentDate?.dateValue() ?? Date())
            if convertReceivePaymentDate.year == convertDate.year, convertReceivePaymentDate.month == convertDate.month {
                debugPrint("first step: \(pay)")
                Task(priority: .high) {
                    debugPrint("upload data...")
                    try await paymentReceiveManager.summitMonthlyIncome(
                        uidPath: firebaseAuth.getUID(),
                        docID: docID,
                        pastPaymentFee: pay.rentalFee,
                        paymentDate: pay.paymentDate?.dateValue() ?? Date()
                    )
                }
            }
        }
    }

    // Collect data from each rooms payment income and set in one data set
    func settlementMonthlyPayment(currentDate: Date, docID: String) async throws {
        firestoreToFetchRoomsData.fetchRoomInfoFormOwner.forEach { data in
            Task(priority: .high) {
                do {
                    let userUID = data.renterUID
                    if !userUID.isEmpty {
                        print("user uid: \(userUID)")
                        try await firestoreToFetchRoomsData.loopTofetchPaymentData(renter: data.renterUID)
                        try await loopDate(currentDate: currentDate, docID: docID)
                    }
                } catch {
                    self.errorHandler.handle(error: error)
                }
            }
        }
    }

    func loopDate(
        currentDate: Date,
        docID: String
    ) async throws {
        _ = firestoreToFetchRoomsData.receivePaymentDataSet.map { pay in
            let cal = Calendar.current
            let convertDate = cal.dateComponents([.year, .month], from: currentDate)
            let convertReceivePaymentDate = cal.dateComponents([.year, .month], from: pay.paymentDate?.dateValue() ?? Date())
            if convertReceivePaymentDate.year == convertDate.year, convertReceivePaymentDate.month == convertDate.month {
                debugPrint("first step: \(pay)")
                Task(priority: .high) {
                    debugPrint("upload data...")
                    try await paymentReceiveManager.summitMonthlyIncome(
                        uidPath: firebaseAuth.getUID(),
                        docID: docID,
                        pastPaymentFee: pay.rentalFee,
                        paymentDate: pay.paymentDate?.dateValue() ?? Date()
                    )
                }
            }
        }
    }
}
