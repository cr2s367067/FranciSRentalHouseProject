//
//  SettlementPaymentView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/13.
//

import SwiftUI

struct SettlementPaymentView: View {
    @EnvironmentObject var providerProfileViewModel: ProviderProfileViewModel
    @EnvironmentObject var paymentReceiveManager: PaymentReceiveManager
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            VStack {
                initView()
            }
            .padding()
            .frame(width: uiScreenWidth - 20, height: uiScreenHeight / 2 + 280)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .dark ? .gray.opacity(0.3) : .white)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(alignment: .center) {
            LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea([.top, .bottom])
        }
        .onAppear {
            appViewModel.updateNavigationBarColor()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        do {
                            try await paymentReceiveManager.createMonthlySettlement(uidPath: firebaseAuth.getUID(), settlementDate: providerProfileViewModel.providerConfig.settlementDate)
                            try await paymentReceiveManager.fetchMonthlySettlement(uidPath: firebaseAuth.getUID())
                        } catch {
                            self.errorHandler.handle(error: error)
                        }
                    }
                } label: {
                    Image(systemName: "plus.square")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
            }
        }
    }
}

struct SettlementPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        SettlementPaymentView()
    }
}


extension SettlementPaymentView {
    @ViewBuilder
    func initView() -> some View {
        if paymentReceiveManager.monthlySettlement.isEmpty {
            Text("Hi welecome, press + button to create one.🥳")
                .foregroundColor(.primary)
                .padding()
        } else {
            ScrollView(.vertical, showsIndicators: true) {
                //MARK: Store the history data in data base the
                ForEach(paymentReceiveManager.monthlySettlement) { data in
                    MonthlySettlementDetailView(settleData: data)
                }
            }
        }
    }
}
