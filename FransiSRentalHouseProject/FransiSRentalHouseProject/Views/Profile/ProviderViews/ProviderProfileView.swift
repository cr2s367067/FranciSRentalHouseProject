//
//  ProviderProfileView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ProviderProfileView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var paymentReceiveManager: PaymentReceiveManager
    @EnvironmentObject var providerProfileViewModel: ProviderProfileViewModel
    
    @Binding var show: Bool

    init(show: Binding<Bool>) {
        self._show = show
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            self.show.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.leading)
                .padding(.top)
                TitleAndDivider(title: "My Profile")
                HStack(spacing: 20) {
                    Spacer()
                    Image(systemName: "chart.bar.xaxis")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
                    Image(systemName: "chart.xyaxis.line")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
                }
                .padding(.trailing)
                ProviderBarChartView()
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            providerProfileViewModel.editMode.toggle()
                        } label: {
                            Image(systemName: "gearshape.circle")
                                .foregroundColor(.white)
                                .font(.system(size: 30, weight: .semibold))
                        }
                    }
                    SettlementUnitView(date: $providerProfileViewModel.settlementDate, editMode: $providerProfileViewModel.editMode)
                    editModeSummitButton(editMode: providerProfileViewModel.editMode)
                }
                .padding()
                Spacer()
            }
        }
        .background(alignment: .center, content: {
            Group {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
            }
            .edgesIgnoringSafeArea([.top, .bottom])
        })
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .task {
            do {
                try await paymentReceiveManager.fetchMonthlySettlement(uidPath: firebaseAuth.getUID())
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
}

struct OwnerProfileDetailUnit: View {
    var body: some View {
        HStack {
            Text("Rental Price")
            Spacer()
            Text("$9,000")
        }
        .foregroundColor(.white)
        .frame(width: 350)
        .padding()
    }
}

extension ProviderProfileView {
    @ViewBuilder
    func editModeSummitButton(editMode: Bool) -> some View {
        if editMode == true {
            Button {
                Task {
                    do {
                        try await providerProfileViewModel.updateConfig(uidPath: firebaseAuth.getUID(), settlementDate: providerProfileViewModel.settlementDate)
                        _ = try await providerProfileViewModel.fetchConfigData(uidPath: firebaseAuth.getUID())
                        providerProfileViewModel.editMode = false
                    } catch {
                        self.errorHandler.handle(error: error)
                    }
                }
            } label: {
                Text("Update")
                    .foregroundColor(.white)
                    .frame(width: 108, height: 35)
                    .background(Color("buttonBlue"))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }
}


