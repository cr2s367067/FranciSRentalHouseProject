//
//  FirebaseAuth.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import SwiftUI
import FirebaseAuth
import CryptoKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseAuth: ObservableObject {
    
    let auth: Auth
    let db = Firestore.firestore()
    
    init() {
        self.auth = Auth.auth()
    }
    
//    @Published var isCreated = false
    @Published var signByApple = false
    @Published var showSignUpView = false
    @Published var signIn = false
    @Published var signUp = false
    @Published var isSkipIt = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var alertTitle = ""
    @Published var alertButton = ""
    @Published var showForgotPasswordView = false
    
    @AppStorage("failTimes") var failTimes = 0
    
    @Published var userCollectionSet = [UserDataModel]()
    
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
    
    
    @MainActor
    func signInWithToken(idTokenString: String, nonce: String) async throws {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        //notes: Figure out, how to identity user is new or not
        try await auth.signIn(with: credential)
        let gettingUid = auth.currentUser?.uid ?? "no data"
        print("user uidPath: \(gettingUid)")
        let userCollection = db.collection("users")
        let document = try await userCollection.getDocuments().documents
        userCollectionSet = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: UserDataModel.self)
            }
            switch result {
            case .success(let data):
                print(data)
                return data
            case .failure(let error):
                print(error.localizedDescription)
            }
            return nil
        })
        for uidPath in userCollectionSet {
            print("current: \(String(describing: uidPath.uid))")
            print("observed uidPaht: \(gettingUid)")
            if gettingUid == uidPath.uid {
                print("exist user")
                self.signIn = true
                showSignUpView = false
                signByApple = false
                break
            } else {
                print("new user")
                showSignUpView = true
                signByApple = true
            }
        }
//        if auth.currentUser == nil {
//
//        } else {
////            guard !getUID().isEmpty else {
////                return
////            }
//
//        }
    }
    
    func signOutAsync() throws {
        try auth.signOut()
        if self.signIn == true {
            self.signIn = false
        }
        if self.signUp == true {
            self.signUp = false
        }
    }
    
    func resetPasswordAsync(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
        showForgotPasswordView = false
        failTimes = 0
    }
    
}


//MARK: - Sign in with Apple
extension FirebaseAuth {
    
     func randomNonceString(length: Int = 32) -> String {
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
     func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }

        
        
}
