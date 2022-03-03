//
//  ContentView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var fetchFirestore: FetchFirestore
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        Group {
            if appViewModel.signIn == true || appViewModel.signUp == true || appViewModel.isSkipIt == true {
                AppTabView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            appViewModel.signIn = appViewModel.isSignedIn
            if fetchFirestore.auth.currentUser != nil {
                fetchFirestore.fetchUploadData(uidPath: fetchFirestore.getUID())
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
