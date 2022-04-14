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
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
 
    var body: some View {
        ZStack {
            tabViews()
            tabBarItem()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .task({
            do {
                try await firestoreToFetchUserinfo.fetchUploadUserDataAsync()
                if firestoreToFetchUserinfo.fetchedUserData.userType == "Provider" {
                    _ = try await providerProfileViewModel.fetchConfigData(uidPath: firebaseAuth.getUID())
                    try await paymentReceiveManager.fetchMonthlySettlement(uidPath: firebaseAuth.getUID())
                }
            } catch {
                self.errorHandler.handle(error: error)
            }
        })
        .onAppear {
            UITabBar.appearance().barTintColor = UIColor.init(named: "background2")
            firestoreToFetchRoomsData.listeningRoomInfoOwnerSideRestruct(uidPath: firebaseAuth.getUID())
            firestoreToFetchRoomsData.listeningRoomInfoForPublicRestruct()
            firestoreForFurniture.listeningFurnitureInfo()
        }
    }
}


//struct AppTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppTabView()
//    }
//}

extension AppTabView {
    
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
            //                .background(alignment: .center) {
            //                    RoundedRectangle(cornerRadius: 30)
            //                        .fill(Color("Shadow"))
            //                }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    @ViewBuilder
    func tabViews() -> some View {
        TabView(selection: $selecting) {
                RenterMainView()
//                .tabItem({
//                    Image("TapHomeButton")
//                })
                .tag("TapHomeButton")
                if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Renter" || appViewModel.userType == "Renter" {
                    PrePurchaseView()
//                        .tabItem({
//                            Image("TapPaymentButton")
//
//                        })
                        .tag("TapPaymentButton")

                } else if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Provider" || appViewModel.userType == "Provider" {
                    if firestoreToFetchUserinfo.fetchedUserData.providerType == "Rental Manager" {
                        ProviderRoomSummitView()
//                            .tabItem({
//                                Image("TapPaymentButton")
//                            })
                            .tag("TapPaymentButton")
                    } else if firestoreToFetchUserinfo.fetchedUserData.providerType == "Furniture Provider" {
                        ProductsProviderSummitView()
//                            .tabItem({
//                                Image("TapPaymentButton")
//                            })
                            .tag("TapPaymentButton")
                    }
                }
                ProfileView()
//                .tabItem({
//                    Image("TapProfileButton")
//                })
                    .tag("TapProfileButton")
                SearchView()
//                .tabItem({
//                    Image("TapSearchButton")
//                })
                    .tag("TapSearchButton")
                if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Provider" || appViewModel.userType == "Provider" {
                    MaintainWaitingView()
//                        .tabItem({
//                            Image("FixButton")
//                        })
                        .tag("FixButton")
                } else if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Renter" || appViewModel.userType == "Renter" {
                    MaintainView()
//                        .tabItem({
//                            Image("FixButton")
//                        })
                        .tag("FixButton")
                }
            
        }
    }
}


/*
 
 ZStack {
             tabViews()
             //: Tab Views
 //            TabView(selection: $appViewModel.tagSelect) {
 //                    RenterMainView()
 //                        .tag("TapHomeButton")
 //                    if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Renter" || appViewModel.userType == "Renter" {
 //                        PrePurchaseView()
 //                            .tag("TapPaymentButton")
 //
 //                    } else if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Provider" || appViewModel.userType == "Provider" {
 //                        if firestoreToFetchUserinfo.fetchedUserData.providerType == "Rental Manager" {
 //                            ProviderRoomSummitView()
 //                                .tag("TapPaymentButton")
 //                        } else if firestoreToFetchUserinfo.fetchedUserData.providerType == "Furniture Provider" {
 //                            ProductsProviderSummitView()
 //                                .tag("TapPaymentButton")
 //                        }
 //                    }
 //                    ProfileView()
 //                        .tag("TapProfileButton")
 //                    SearchView()
 //                        .tag("TapSearchButton")
 //                    if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Provider" || appViewModel.userType == "Provider" {
 //                        MaintainWaitingView()
 //                            .tag("FixButton")
 //                    } else if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Renter" || appViewModel.userType == "Renter" {
 //                        MaintainView()
 //                            .tag("FixButton")
 //                    }
 //
 //            }
             //: Tab bar
 //            VStack {
 //                Spacer()
 //                HStack(alignment: .center, spacing: 40) {
 //                    ForEach(appViewModel.selectArray, id: \.self) { buttonName in
 //                        TabBarButton(tagSelect: $appViewModel.tagSelect, buttonImage: buttonName)
 //                    }
 //                }
 ////                .padding(.horizontal)
 ////                .padding(.vertical)
 //                .frame(width: uiScreenWidth - 50, height: 40)
 ////                .background(alignment: .center) {
 ////                    RoundedRectangle(cornerRadius: 30)
 ////                        .fill(Color("Shadow"))
 ////                }
 //            }
 //            .padding(.horizontal)
 //            .ignoresSafeArea(.keyboard, edges: .bottom)
 //        }
*/
