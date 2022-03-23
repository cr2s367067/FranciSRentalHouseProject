//
//  FirebaseAuth.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import SwiftUI
import FirebaseAuth

class FirebaseAuth: ObservableObject {
    
    let auth: Auth
    
    init() {
        self.auth = Auth.auth()
    }
    
    @Published var signIn = false
    @Published var signUp = false
    @Published var isSkipIt = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var alertTitle = ""
    @Published var alertButton = ""
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func getUID() -> String {
        let uid = auth.currentUser?.uid
        return uid ?? "Could not fetch UID."
    }
}


extension FirebaseAuth {
    func signUpAsync(email: String, password: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
        DispatchQueue.main.async {
            self.signUp = true
        }
    }
    
    func signInAsync(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
        DispatchQueue.main.async {
            self.signIn = true
        }
    }
    
    func signWithAnonymousAsync() async throws {
        try await auth.signInAnonymously()
        DispatchQueue.main.async {
            self.isSkipIt = true
        }
    }
    
    func signOutAsync() throws {
        try auth.signOut()
        DispatchQueue.main.async {
            if self.isSkipIt == true {
                self.isSkipIt = false
            }
            if self.signIn == true {
                self.signIn = false
            }
            if self.signUp == true {
                self.signUp = false
            }
        }
    }
    
    func resetPasswordAsync(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
    
}
