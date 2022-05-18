//
//  SignInWithAppleButtonView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/18.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonView: View {
    
    @EnvironmentObject var firebaseAuth: FirebaseAuth

    
    let uiScreenWith = UIScreen.main.bounds.width
    
    @State private var currentNonce: String?
    
    var body: some View {
            SignInWithAppleButton(.continue) { request in
                let nonce = firebaseAuth.randomNonceString()
                currentNonce = nonce
                request.requestedScopes = [.fullName, .email]
                request.nonce = firebaseAuth.sha256(nonce)
                } onCompletion: { result in
                    switch result {
                    case .success(let authResult):
                        switch authResult.credential {
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                            guard let nonce = currentNonce else {
                                fatalError("Invaild State: login callback was received, but no login request was sent.")
                            }
                            guard let appleIdToken = appleIDCredential.identityToken else {
                                print("Fail to fetch token")
                                return
                            }
                            guard let idTokenString = String(data: appleIdToken, encoding: .utf8) else {
                                print("Unable to serialize token string from data: \(appleIdToken.debugDescription)")
                                return
                            }
                            print("token: \(idTokenString)")
                            Task {
                                do {
                                    try await firebaseAuth.signInWithToken(idTokenString: idTokenString, nonce: nonce)
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
//                        case let passwordCredential as ASPasswordCredential:
//                            let username = passwordCredential.user
//                            let password = passwordCredential.password
//                            print("username: \(username)")
//                            print("password: \(password)")
                        default:
                            break
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    
                }
                .frame(width: uiScreenWith / 2 + 5, height: 34, alignment: .center)
                .signInWithAppleButtonStyle(.whiteOutline)
                .animation(.easeInOut, value: 1)
                .accessibilityShowsLargeContentViewer()
    }
}

struct SignInWithAppleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithAppleButtonView()
    }
}
