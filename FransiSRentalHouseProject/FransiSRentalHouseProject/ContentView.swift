//
//  ContentView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var bioAuthViewModel: BioAuthViewModel
    
   
    var body: some View {
        Group {
            if firebaseAuth.signIn == true || firebaseAuth.signUp == true || firebaseAuth.isSkipIt == true || bioAuthViewModel.isUnlocked == true {
                AppTabView()
            } else  {
                LoginView()
//                SignInWithAppleButtonView()
            }
        }
        .task({
            if firebaseAuth.auth.currentUser != nil {
                do {
                    try await firestoreToFetchUserinfo.fetchUploadUserDataAsync()
                } catch {
                    self.errorHandler.handle(error: error)
                }
            }
        })
        .onAppear {
            firebaseAuth.signIn = firebaseAuth.isSignedIn
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




