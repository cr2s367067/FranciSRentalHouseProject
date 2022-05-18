//
//  FirebaseAuth.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import SwiftUI
import FirebaseAuth
import CryptoKit

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
    @Published var showForgotPasswordView = false
    
    @AppStorage("failTimes") var failTimes = 0
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func getUID() -> String {
        let uid = auth.currentUser?.uid
        return uid ?? "Could not fetch UID."
    }
}


extension FirebaseAuth {
    @MainActor
    func signUpAsync(email: String, password: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
        self.signUp = true
    }
    
    @MainActor
    func signInAsync(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
        self.signIn = true
        failTimes = 0
    }
    
    func failThreeTimes(fail: Int) {
        if fail == 2 {
            print("Forget password?")
            showForgotPasswordView = true
        }
    }
    
//    @MainActor
//    func signWithAnonymousAsync() async throws {
//        try await auth.signInAnonymously()
//        self.isSkipIt = true
//    }
    
    func signOutAsync() throws {
        try auth.signOut()
        if self.signIn == true {
            self.signIn = false
        }
        if self.signUp == true {
            self.signUp = false
        }
//        if self.isSkipIt == true {
//            self.isSkipIt = false
//        }
    }
    
    func resetPasswordAsync(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
        showForgotPasswordView = false
        failTimes = 0
    }
    
}


//MARK: Sign in with Apple
extension FirebaseAuth {
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }

        
        
}
