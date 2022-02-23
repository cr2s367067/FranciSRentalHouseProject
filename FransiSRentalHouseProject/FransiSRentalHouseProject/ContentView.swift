//
//  ContentView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    
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
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
