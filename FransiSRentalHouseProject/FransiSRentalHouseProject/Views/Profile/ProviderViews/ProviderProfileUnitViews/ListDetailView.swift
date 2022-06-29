//
//  ListDetailView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/14.
//

import SwiftUI

struct ListDetailView: View {
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var paymentReceiveManager: PaymentReceiveManager
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var paymentMM: PaymentMethodManager
    @EnvironmentObject var providerProfileViewModel: ProviderProfileViewModel
    @EnvironmentObject var soldProductCollectionManager: SoldProductCollectionManager

    @State private var productSettlementResult = 0

    var settleData: ReceivePaymentDateModel

    var body: some View {
        VStack {
            Form {
                Section {
                    identityProviderType(providerType: ProviderTypeStatus(rawValue: firestoreToFetchUserinfo.fetchedUserData.providerType) ?? .roomProvider)
                } header: {
                    Text(settleData.settlementDate, format: Date.FormatStyle().year().month())
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                }
            }
            ScrollView(.vertical, showsIndicators: true) {
                HStack {
                    Group {
                        Text("Settlement Amount: ")
                        identityProTypeSettlementAmount(providerType: ProviderTypeStatus(rawValue: firestoreToFetchUserinfo.fetchedUserData.providerType) ?? .roomProvider)
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    Spacer()
                    Button {
                        Task {
                            do {
                                try await ideProTypeForComputeAmount(type: ProviderTypeStatus(rawValue: firestoreToFetchUserinfo.fetchedUserData.providerType) ?? .roomProvider)
                            } catch {
                                self.errorHandler.handle(error: error)
                            }
                        }
                    } label: {
                        Text("Compute Amount")
                            .foregroundColor(.white)
                            .frame(width: 150, height: 35)
                            .background(Color("buttonBlue"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding()
                HStack {
                    Spacer()
                    isSettlement(isSettle: settleData.isSettle)
                    Button {
                        Task {
                            do {
                                guard settleData.isSettle == false else {
                                    throw SettlementError.closeAccountError
                                }
                                guard paymentReceiveManager.settlementResultAmount != 0 || productSettlementResult != 0 else {
                                    throw SettlementError.settlementResultError
                                }
                                if settleData.isSettle == false {
                                    guard let id = settleData.id else { return }
                                    try await closeAccount(docID: id, providerType: ProviderTypeStatus(rawValue: firestoreToFetchUserinfo.fetchedUserData.providerType) ?? .roomProvider)
//                                    try await providerProfileViewModel.isCreateMonthlySettleData(
//                                        uidPath: firebaseAuth.getUID()
//                                    )
                                }
                            } catch {
                                self.errorHandler.handle(error: error)
                            }
                        }
                    } label: {
                        Text("Close Account")
                            .foregroundColor(.white)
                            .frame(width: 125, height: 35)
                            .background(Color("buttonBlue"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding()
            }
//            Spacer()
        }
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
            let pTypeWithDefault = ProviderTypeStatus(rawValue: firestoreToFetchUserinfo.fetchedUserData.providerType) ?? .roomProvider
            evaluateAppear(type: pTypeWithDefault)

        })
        .onDisappear(perform: {
            UITableView.appearance().backgroundColor = .systemBackground
        })
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(alignment: .center) {
            LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea([.top, .bottom])
        }
        .task {
            do {
                guard let id = settleData.id else { return }
                let pTypeWithDefault = ProviderTypeStatus(rawValue: firestoreToFetchUserinfo.fetchedUserData.providerType) ?? .roomProvider
                try await step2(docID: id, providerType: pTypeWithDefault)

            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
}

// struct ListDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListDetailView()
//    }
// }

extension ListDetailView {
    func evaluateAppear(type: ProviderTypeStatus) {
        if type == .roomProvider {
            paymentReceiveManager.settlementResultAmount = settleData.settlementAmount
        }
        if type == .productProvider {
            productSettlementResult = settleData.settlementAmount
        }
    }

    func computeSettleAmount(input: [ProductSoldCollectionDataModel]) -> Int {
        var subtotal = 0
        for input in input {
            let sAmount = input.soldAmount
            let sPrice = input.productPrice
            let multipleItem = sPrice * sAmount
            subtotal += multipleItem
        }
        print(subtotal)
        return subtotal
    }

    func ideProTypeForComputeAmount(type: ProviderTypeStatus) async throws {
        if type == .roomProvider {
            try await getResult()
        }
        if type == .productProvider {
            productSettlementResult = computeSettleAmount(input: soldProductCollectionManager.soldDataSet)
        }
    }

    @ViewBuilder
    func identityProTypeSettlementAmount(providerType: ProviderTypeStatus) -> some View {
        if providerType == .roomProvider {
            Text("\(paymentReceiveManager.settlementResultAmount)")
        }

        if providerType == .productProvider {
            Text("\(productSettlementResult)")
        }
    }

    @ViewBuilder
    func identityProviderType(providerType: ProviderTypeStatus) -> some View {
        if providerType == .roomProvider {
            List(paymentReceiveManager.fetchResult) { data in
                listUnit(data: data)
            }
        }

        if providerType == .productProvider {
            List(soldProductCollectionManager.fetchSettleData) { data in
                productInfoListUnit(data: data)
            }
        }
    }

    @ViewBuilder
    func productInfoListUnit(data: ProductSoldCollectionDataModel) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Text(data.productName)
            Text("$\(data.productPrice)")
            Spacer()
            Text("Sold Amount: \(data.soldAmount)")
        }
        .padding()
    }

    @ViewBuilder
    func listUnit(data: PaymentHistoryDataModel) -> some View {
        HStack {
            Text(data.pastPaymentFee)
            Text(data.paymentDate, format: Date.FormatStyle().year().month().day())
        }
        .padding()
    }

    @ViewBuilder
    func isSettlement(isSettle: Bool) -> some View {
        Image(systemName: isSettle ? "checkmark.circle.fill" : "checkmark.circle")
            .foregroundColor(.white)
            .font(.system(size: 20))
    }

    func step2(docID: String, providerType: ProviderTypeStatus) async throws {
        Task {
            do {
                if providerType == .roomProvider {
                    try await paymentReceiveManager.fetchMonthlyIncome(uidPath: firebaseAuth.getUID(), docID: docID)
                }

                if providerType == .productProvider {
                    try await soldProductCollectionManager.fetchSettleData(providerUidPath: firebaseAuth.getUID(), docID: docID)
                }
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }

    func getResult() async throws {
        Task {
            if !paymentReceiveManager.fetchResult.isEmpty {
                paymentReceiveManager.settlementResultAmount = await appendAndLoopInMonthlyData(input: paymentReceiveManager.fetchResult)
                debugPrint(paymentReceiveManager.settlementResultAmount)
            }
        }
    }

    private func appendAndLoopInMonthlyData(input: [PaymentHistoryDataModel]) async -> Int {
        paymentReceiveManager.computeMonthlySettlement(input: input)
    }

    func closeAccount(docID: String, providerType: ProviderTypeStatus) async throws {
        Task(priority: .low, operation: {
            var holdAmount = 0
            if providerType == .roomProvider {
                holdAmount = paymentReceiveManager.settlementResultAmount
            }
            if providerType == .productProvider {
                holdAmount = productSettlementResult
            }
            try await paymentReceiveManager.updateMonthlySettlement(uidPath: firebaseAuth.getUID(), docID: docID, settlementAmount: holdAmount, settlementDate: Date())
            try await paymentReceiveManager.createMonthlySettlement(uidPath: firebaseAuth.getUID(), settlementDate: paymentMM.computePaymentMonth(from: Date()))
            try await providerProfileViewModel.updateConfig(
                gui: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? "",
                settlementDate: paymentMM.computePaymentMonth(from: Date())
            )
            try await paymentReceiveManager.fetchMonthlySettlement(uidPath: firebaseAuth.getUID())
        })
    }
}
