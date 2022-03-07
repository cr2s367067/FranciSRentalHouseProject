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
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.signUp = true
            }
        }
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                self?.alertTitle = "Error"
                self?.alertButton = "Ok"
                if let x = error {
                    let err = x as NSError
                    switch err.code {
                    case AuthErrorCode.wrongPassword.rawValue:
                        self?.showAlert = true
                        self?.alertMessage = err.localizedDescription
                    case AuthErrorCode.invalidEmail.rawValue:
                        self?.showAlert = true
                        self?.alertMessage = err.localizedDescription
                    case AuthErrorCode.userNotFound.rawValue:
                        self?.showAlert = true
                        self?.alertMessage = err.localizedDescription
                    default:
                        self?.showAlert = true
                        self?.alertMessage = err.localizedDescription
                    }
                }
                return
            }
            DispatchQueue.main.async {
                self?.signIn = true
                
            }
        }
    }
    
    func signWithAnonymous() {
        auth.signInAnonymously { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            //            guard let user = result?.user else {
            //                return
            //            }
            //            let isAnonymous = user.isAnonymous
            //            let uid = user.uid
            DispatchQueue.main.async {
                self?.isSkipIt = true
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
        } catch let error as NSError {
            print(error.description)
        }
        DispatchQueue.main.async {
            self.signIn = false
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
    
    func resetPassword(email: String) {
        auth.sendPasswordReset(withEmail: email) { [self] error in
            guard error == nil else {
                self.alertTitle = "Error"
                self.alertButton = "Ok"
                if let x = error {
                    let err = x as NSError
                    switch err.code {
                    case AuthErrorCode.invalidMessagePayload.rawValue:
                        self.showAlert = true
                        self.alertMessage = err.localizedDescription
                    default:
                        self.showAlert = true
                        self.alertMessage = err.localizedDescription
                    }
                }
                return
            }
        }
    }
    
}