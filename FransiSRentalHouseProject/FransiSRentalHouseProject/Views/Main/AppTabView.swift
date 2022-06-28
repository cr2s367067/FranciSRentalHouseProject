//
//  AppTabView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI
import WebKit

struct AppTabView: View {
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firestoreForFurniture: FirestoreForProducts
    @EnvironmentObject var providerProfileViewModel: ProviderProfileViewModel
    @EnvironmentObject var paymentReceiveManager: PaymentReceiveManager
    @EnvironmentObject var productVM: ProductDetailViewModel

    @State private var selecting = "TapHomeButton"

    @AppStorage("userHodler") var userHodler: SignUpType = .isNormalCustomer
    @AppStorage("providerHolder") var providerHolder: ProviderTypeStatus = .roomProvider

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    var body: some View {
        ZStack {
            tabViews(signUpType: SignUpType(rawValue: firestoreToFetchUserinfo.fetchedUserData.userType) ?? .isNormalCustomer, providerType: ProviderTypeStatus(rawValue: firestoreToFetchUserinfo.fetchedUserData.providerType) ?? .roomProvider)
            tabBarItem()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .task {
            do {
                try await firestoreToFetchUserinfo.fetchUploadUserDataAsync()
                try await initTask(signUpType: SignUpType(rawValue: firestoreToFetchUserinfo.fetchedUserData.userType) ?? .isNormalCustomer)
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
        .onAppear {
            UITabBar.appearance().barTintColor = UIColor(named: "background2")
            firestoreToFetchRoomsData.listeningRoomInfoForPublic()
            firestoreForFurniture.listeningProduct()
            userHodler = SignUpType(rawValue: firestoreToFetchUserinfo.fetchedUserData.userType) ?? .isNormalCustomer
            if userHodler == .isProvider {
                providerHolder = ProviderTypeStatus(rawValue: firestoreToFetchUserinfo.fetchedUserData.providerType) ?? .roomProvider
            }
        }
    }
}

extension AppTabView {
    func initTask(signUpType: SignUpType) async throws {
        if signUpType == .isNormalCustomer {
            print("Is getting custormer config data")
            try await firestoreToFetchRoomsData.getRoomInfo(uidPath: firebaseAuth.getUID())
        }
        if signUpType == .isProvider {
            print("Is getting provider config data")
            try await firestoreToFetchRoomsData.getRoomInfo(uidPath: firebaseAuth.getUID())
            _ = try await providerProfileViewModel.fetchConfigData(uidPath: firebaseAuth.getUID())
            try await paymentReceiveManager.fetchMonthlySettlement(uidPath: firebaseAuth.getUID())
        }
    }

    @ViewBuilder
    func tabBarItem() -> some View {
        VStack {
            Spacer()
            HStack(alignment: .center, spacing: 40) {
                ForEach(appViewModel.selectArray, id: \.self) { buttonName in
                    ZStack {
                        TabBarButton(tagSelect: $appViewModel.selecting, buttonImage: AppViewModel.BarItemStatus(rawValue: buttonName) ?? .homeButton)
                            .accessibilityIdentifier(buttonName)
                        if buttonName == AppViewModel.BarItemStatus.paymentButton.rawValue {
                            if appViewModel.isAddNewItem {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 15, height: 15, alignment: .center)
                                    .offset(x: 15, y: -6)
                            }
                        }
                    }
                }
            }
            .padding()
            .frame(width: uiScreenWidth - 50, height: 40)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    @ViewBuilder
    func tabViews(signUpType: SignUpType, providerType: ProviderTypeStatus) -> some View {
        TabView(selection: $appViewModel.selecting) {
            RenterMainView()
                .tag(AppViewModel.BarItemStatus.homeButton)
//                .tag("TapHomeButton")
            if signUpType == .isNormalCustomer {
                PrePurchaseView()
                    .tag(AppViewModel.BarItemStatus.paymentButton)
//                    .tag("TapPaymentButton")
            }
            if signUpType == .isProvider {
                if providerType == .roomProvider {
                    ProviderRoomSummitView()
                        .tag(AppViewModel.BarItemStatus.paymentButton)
//                        .tag("TapPaymentButton")
                }
                if providerType == .productProvider {
                    ProductsProviderSummitView()
                        .tag(AppViewModel.BarItemStatus.paymentButton)
//                        .tag("TapPaymentButton")
                }
            }
            ProfileView()
                .tag(AppViewModel.BarItemStatus.profileButton)
//                .tag("TapProfileButton")
            SearchView()
                .tag(AppViewModel.BarItemStatus.searchButton)
//                .tag("TapSearchButton")

            if signUpType == .isNormalCustomer {
                MaintainView()
                    .tag(AppViewModel.BarItemStatus.fixButton)
//                    .tag("FixButton")
            }
            if signUpType == .isProvider {
                if providerType == .roomProvider {
                    MaintainWaitingView()
                        .tag(AppViewModel.BarItemStatus.fixButton)
//                        .tag("FixButton")
                }
                if providerType == .productProvider {
                    ShippingListView()
                        .tag(AppViewModel.BarItemStatus.fixButton)
//                        .tag("FixButton")
                }
            }
        }
    }
}
