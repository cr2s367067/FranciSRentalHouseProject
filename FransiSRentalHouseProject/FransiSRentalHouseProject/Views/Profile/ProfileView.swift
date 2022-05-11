//
//  ProfileView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var storageForUserProfile: StorageForUserProfile
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreToFetchMaintainTasks: FirestoreToFetchMaintainTasks
    
    @State private var show = false

    
    var body: some View {
        NavigationView {
            SideMenuBar(sidebarWidth: 180, showSidebar: $show) {
                MenuView()
            } content: {
                identUserType(uType: SignUpType(rawValue: firestoreToFetchUserinfo.fetchedUserData.userType) ?? .isNormalCustomer)
            }
            .gesture(
                DragGesture(minimumDistance: 10).onEnded({ drag in
                    if drag.startLocation.x < drag.predictedEndLocation.x {
                        show = true
                    } else if drag.startLocation.x > drag.predictedEndLocation.x {
                        show = false
                    }
                })
            )
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}


extension ProfileView {
    
    @ViewBuilder
    func identUserType(uType: SignUpType) -> some View {
        if uType == .isNormalCustomer {
            RenterProfileView(show: $show)
        }
        if uType == .isProvider {
            ProviderProfileView(show: $show)
        }
    }
    
}
