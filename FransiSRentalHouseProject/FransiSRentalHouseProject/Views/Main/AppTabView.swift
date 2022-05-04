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
                let userTypeWithDefault = SignUpType(rawValue: firestoreToFetchUserinfo.fetchedUserData.userType) ?? .isNormalCustomer
                try await firestoreToFetchUserinfo.fetchUploadUserDataAsync()
                try await initTask(signUpType: userTypeWithDefault)
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
        .onAppear {
            UITabBar.appearance().barTintColor = UIColor.init(named: "background2")
            firestoreToFetchRoomsData.listeningRoomInfoForPublicRestruct()
            firestoreForFurniture.listeningFurnitureInfo()
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
            try await firestoreToFetchRoomsData.getRoomInfo(uidPath: firebaseAuth.getUID())
        }
        if signUpType == .isProvider {
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
                    TabBarButton(tagSelect: $selecting, buttonImage: buttonName)
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
            .frame(width: uiScreenWidth - 50, height: 40)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    @ViewBuilder
    func tabViews(signUpType: SignUpType, providerType: ProviderTypeStatus) -> some View {
        TabView(selection: $selecting) {
            RenterMainView()
                .tag("TapHomeButton")
            if signUpType == .isNormalCustomer {
                PrePurchaseView()
                    .tag("TapPaymentButton")
            }
            if signUpType == .isProvider {
                if providerType == .roomProvider {
                    ProviderRoomSummitView()
                        .tag("TapPaymentButton")
                }
                if providerType == .productProvider {
                    ProductsProviderSummitView()
                        .tag("TapPaymentButton")
                }
            }
            ProfileView()
                .tag("TapProfileButton")
            SearchView()
                .tag("TapSearchButton")
            
            if signUpType == .isNormalCustomer {
                MaintainView()
                    .tag("FixButton")
            }
            if signUpType == .isProvider {
                if providerType == .roomProvider {
                    MaintainWaitingView()
                        .tag("FixButton")
                }
                if  providerType == .productProvider {
                    ShippingListView()
                        .tag("FixButton")
                }
            }
        }
    }
}
