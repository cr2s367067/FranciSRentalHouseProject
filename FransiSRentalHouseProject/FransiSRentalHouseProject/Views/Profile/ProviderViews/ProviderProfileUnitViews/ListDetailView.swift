//
//  ListDetailView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/14.
//

import SwiftUI

struct ListDetailView: View {
    
    @EnvironmentObject var paymentReceiveManager: PaymentReceiveManager
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var paymentMM: PaymentMethodManager
    @EnvironmentObject var providerProfileViewModel: ProviderProfileViewModel
    
    
    var settleData: ReceivePaymentDateModel
    
    var body: some View {
        VStack {
            Form {
                Section {
                    List(paymentReceiveManager.fetchResult) { data in
                        listUnit(data: data)
                    }
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
                        Text("\(paymentReceiveManager.settlementResultAmount)")
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    Spacer()
                    Button {
                        Task {
                            do {
                                try await getResult()
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
                                guard paymentReceiveManager.settlementResultAmount != 0 else {
                                    throw SettlementError.settlementResultError
                                }
                                if settleData.isSettle == false {
                                    try await closeAccount(docID: settleData.id ?? "")
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
                try await step2(docID: settleData.id ?? "")
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
}

//struct ListDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListDetailView()
//    }
//}

extension ListDetailView {
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
    
    
    
    func step2(docID: String) async throws {
        Task {
            do {
                try await paymentReceiveManager.fetchMonthlyIncome(uidPath: firebaseAuth.getUID(), docID: docID)
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
    
    func getResult() async throws {
        Task {
            if !paymentReceiveManager.fetchResult.isEmpty{
                paymentReceiveManager.settlementResultAmount = await appendAndLoopInMonthlyData(input: paymentReceiveManager.fetchResult)
                debugPrint(paymentReceiveManager.settlementResultAmount)
            }
        }
    }
    
    private func appendAndLoopInMonthlyData(input: [PaymentHistoryDataModel]) async -> Int {
        paymentReceiveManager.computeMonthlySettlement(input: input)
    }
    
    
    func closeAccount(docID: String) async throws {
        Task(priority: .low, operation: {
            try await paymentReceiveManager.updateMonthlySettlement(uidPath: firebaseAuth.getUID(), docID: docID, settlementAmount: paymentReceiveManager.settlementResultAmount, settlementDate: Date())
            try await paymentReceiveManager.createMonthlySettlement(uidPath: firebaseAuth.getUID(), settlementDate: paymentMM.computePaymentMonth(from: Date()))
            try await providerProfileViewModel.updateConfig(uidPath: firebaseAuth.getUID(), settlementDate: paymentMM.computePaymentMonth(from: Date()))
            try await paymentReceiveManager.fetchMonthlySettlement(uidPath: firebaseAuth.getUID())
        })
    }
    
}
