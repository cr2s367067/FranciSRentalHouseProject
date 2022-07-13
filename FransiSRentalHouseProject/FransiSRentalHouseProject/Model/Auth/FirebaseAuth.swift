//
//  FirebaseAuth.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import CryptoKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseMessaging
import SwiftUI

class FirebaseAuth: ObservableObject {
    let auth: Auth
    let db = Firestore.firestore()

    init() {
        auth = Auth.auth()
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
    func signUpAsync(email: String, password: String, isFounder: Bool) async throws {
        try await auth.createUser(withEmail: email, password: password)
        if isFounder == false {
            signUp = true
        }
    }

    @MainActor
    func signInAsync(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
        signIn = true
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
        // notes: Figure out, how to identity user is new or not
        try await auth.signIn(with: credential)
        let gettingUid = auth.currentUser?.uid ?? "no data"
        print("user uidPath: \(gettingUid)")
        let userCollection = db.collection("users")
        let document = try await userCollection.getDocuments().documents
        userCollectionSet = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: UserDataModel.self)
            }
            switch result {
            case let .success(data):
                print(data)
                return data
            case let .failure(error):
                print(error.localizedDescription)
            }
            return nil
        }
        for uidPath in userCollectionSet {
            print("current: \(String(describing: uidPath.uid))")
            print("observed uidPaht: \(gettingUid)")
            if gettingUid == uidPath.uid {
                print("exist user")
                signIn = true
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
        if signIn == true {
            signIn = false
        }
        if signUp == true {
            signUp = false
        }
    }

    func resetPasswordAsync(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
        showForgotPasswordView = false
        failTimes = 0
    }
}

// MARK: - Sign in with Apple

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

// MARK: - Check Notification Token

extension FirebaseAuth {
    func checkAndUpdateToken(oldToken: String, uidPath: String) async throws {
        let getToken = try await Messaging.messaging().token()
        if oldToken == getToken {
            debugPrint("same token")
        } else {
            debugPrint("Dif. token and update to firestore")
            let fireMes = FirestoreForTextingMessage()
            try await fireMes.updateToken(newToken: getToken, uidPath: uidPath)
            _ = try await fireMes.fetchStoredUserData(uidPath: uidPath)
        }
    }
}
