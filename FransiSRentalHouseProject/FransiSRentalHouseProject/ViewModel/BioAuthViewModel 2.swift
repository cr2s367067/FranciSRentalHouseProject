//
//  BioAuthViewModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/17.
//

import Foundation
import LocalAuthentication
import SwiftUI

class BioAuthViewModel: ObservableObject {
    enum BioAuthStatus: String {
        case faceIDEnable, emailAddressForBiologin, userPasswordForBioLogin
    }

    let firebaseAuth = FirebaseAuth()

    @AppStorage(BioAuthStatus.faceIDEnable.rawValue) var faceIDEnable = false
    @AppStorage(BioAuthStatus.emailAddressForBiologin.rawValue) var userNameBioAuth = ""
    @AppStorage(BioAuthStatus.userPasswordForBioLogin.rawValue) var passwordBioAuth = ""

    @Published var isUnlocked = false

    func bioAuthentication(userNameBioAuth: String, passBioAuth: String) {
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        if canEvaluate {
            let reason = "To access your account."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                if success {
                    print("Access success")
                    Task {
                        do {
                            try await self.firebaseAuth.signInAsync(email: userNameBioAuth, password: passBioAuth)
                            DispatchQueue.main.async {
                                self.isUnlocked = true
                            }
                        } catch {
                            print("could not log in")
                        }
                    }
                } else {
                    // Some error eccure
                    print("Fail to access account")
                }
            }
        } else {
            // If device doesn't have bioAuthSencer
            print("This device doesn't provider bio authentication")
        }
    }
}
