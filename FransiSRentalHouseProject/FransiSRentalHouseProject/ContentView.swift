//
//  ContentView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        Group {
            if firebaseAuth.signIn == true || firebaseAuth.signUp == true || firebaseAuth.isSkipIt == true {
                AppTabView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            firebaseAuth.signIn = firebaseAuth.isSignedIn
            if firebaseAuth.auth.currentUser != nil {
//                firestoreToFetchUserinfo.fetchUploadedUserData(uidPath: firebaseAuth.getUID())
                firestoreToFetchUserinfo.fetchUploadUserData()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
