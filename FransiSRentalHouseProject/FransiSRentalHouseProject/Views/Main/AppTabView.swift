//
//  AppTabView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI
import WebKit

struct AppTabView: View {
    
//    @EnvironmentObject var fetchFirestore: FetchFirestore
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firebaseAuth: FirebaseAuth
//    let persistenceDM = PersistenceController()
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("backgroundBrown"))
                .ignoresSafeArea(.all)
            
            //: Tab Views
            VStack {
                TabView(selection: $appViewModel.tagSelect) {
                    RenterMainView()
                        .tag("TapHomeButton")
                    if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Renter" || appViewModel.userType == "Renter" {
                        PrePurchaseView(
//                            dataModel: RoomsDataModel(roomImage: "", roomName: "", roomDescribtion: "", roomPrice: 0, ranking: 0, isSelected: false)
                        )
                            .tag("TapPaymentButton")
                        RenterProfileView()
                            .tag("TapProfileButton")
                    } else if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Provider" || appViewModel.userType == "Provider" {
                        ProviderRoomSummitView()
                            .tag("TapPaymentButton")
                        ProviderProfileView()
                            .tag("TapProfileButton")
                    }
                    SearchView()
                        .tag("TapSearchButton")
                    MaintainView()
                        .tag("FixButton")
                }
                
                //: Tab bar
                ZStack {
                    RoundedRectangle(cornerRadius: 27)
                        .fill(Color("fieldGray"))
                        .frame(width: 389, height: 70)
                    HStack {
                        ForEach(appViewModel.selectArray, id: \.self) { buttonName in
                            TabBarButton(tagSelect: $appViewModel.tagSelect, buttonImage: buttonName)
                            Spacer()
                        }
                    }
                    .padding(.leading, 40)
                }
                .padding(.bottom, 35)
            }
        }
        .edgesIgnoringSafeArea([.top, .bottom])
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
//            firestoreToFetchUserinfo.fetchUploadedUserData(uidPath: firebaseAuth.getUID())
            firestoreToFetchUserinfo.fetchUploadUserData()
        }
    }
}


struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}



//(persistenceDM.getUserUID() == fetchFirestore.getUID() && persistenceDM.getUserUID() == "Renter") ||