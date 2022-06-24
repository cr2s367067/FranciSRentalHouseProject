//
//  LoginView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/18.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
//    SignInWithAppleButtonView
    enum LoginStatus: String {
        case saveUserName
    }
    
    @EnvironmentObject var loginVM: LoginVM
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var bioAuthViewModel: BioAuthViewModel
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    
    let uiScreenWith = UIScreen.main.bounds.width
    
//    @State private var emailAddress = ""
//    @State private var userPassword = ""tes
    
    @FocusState private var isFocus: Bool
    
    
//    @State private var currentNonce: String?
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Group {
                    HStack {
                        Text("Door, What's Next")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .tracking(-0.68)
                            .padding()
                        Spacer()
                    }
                    HStack {
                        Text("Sign In")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
                }
                
                Group {
                    HStack {
                        Image(systemName: "person.fill")
                            .padding(.leading)
                        TextField("", text: $loginVM.emailAddress)
                            .foregroundColor(.white)
                            .placeholer(when: loginVM.emailAddress.isEmpty) {
                                Text("E-mail")
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .focused($isFocus)
                            .accessibilityIdentifier("userName")
                    }
                    .modifier(customTextField())
                    HStack {
                        Image(systemName: "lock.fill")
                            .padding(.leading)
                        SecureField("", text: $loginVM.userPassword)
                            .foregroundColor(.white)
                            .placeholer(when: loginVM.userPassword.isEmpty) {
                                Text("Password")
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .focused($isFocus)
                            .accessibilityIdentifier("password")
                    }
                    .modifier(customTextField())
                    HStack(spacing: 5) {
                        Spacer()
                        NavigationLink(isActive: $firebaseAuth.showForgotPasswordView) {
                            ForgetPasswordView()
                        } label: {
                            Text("Forgot Password?")
                                .foregroundColor(.white)
                                .alert(isPresented: $firebaseAuth.showAlert) {
                                    Alert(title: Text(firebaseAuth.alertTitle), message: Text(firebaseAuth.alertMessage), dismissButton: .default(Text(firebaseAuth.alertButton)))
                                }
                        }
                        .accessibilityIdentifier("forgotPassword")
                    }
                }
                Spacer()
                forceResetPassord(fail: firebaseAuth.failTimes)
                    .accessibilityIdentifier("signIn")
                SignInWithAppleButton(.continue) { request in
                    let nonce = firebaseAuth.randomNonceString()
                    loginVM.currentNonce = nonce
                    request.requestedScopes = [.fullName, .email]
                    request.nonce = firebaseAuth.sha256(nonce)
                } onCompletion: { result in
                    switch result {
                    case .success(let authResult):
                        switch authResult.credential {
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                            guard let nonce = loginVM.currentNonce else {
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
                Spacer()
                HStack {
                    Text("You don't have account?")
                        .foregroundColor(.white)
                    NavigationLink(isActive: $firebaseAuth.showSignUpView) {
                        SignUpView()
                    } label: {
                        Text("Let us create one")
                            .foregroundColor(.blue)
                    }
                    .accessibilityIdentifier("signUp")
                }
                .font(.system(size: 15, weight: .regular))
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(alignment: .center) {
                Group {
                    Image("door1")
                        .resizable()
                        .blur(radius: 10)
                        .scaledToFill()
                        .frame(width: 428, height: 926)
                        .offset(x: 20)
                        .clipped()
                        .accessibilityIdentifier("door1")
                    Rectangle()
                        .fill(.black.opacity(0.5))
                        .blendMode(.multiply)
                }
                .edgesIgnoringSafeArea([.top, .bottom])
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isFocus = false
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension LoginView {
    @ViewBuilder
    func forceResetPassord(fail: Int) -> some View {
        if fail < 3 {
            Button {
                Task {
                    do {
                        try await firebaseAuth.signInAsync(email: loginVM.emailAddress, password: loginVM.userPassword)
                    } catch {
                        self.errorHandler.handle(error: error) {
                            if error.localizedDescription == "The password is invalid or the user does not have a password." {
                                firebaseAuth.failTimes += 1
                                print(firebaseAuth.failTimes)
                            }
                        }
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white)
                    .tracking(-0.5)
                    .multilineTextAlignment(.center)
                    .frame(width: uiScreenWith / 2 + 5, height: 34)
                    .background(Color("buttonBlue"))
                    .cornerRadius(5)
                    
            }
        } else if fail >= 3 {
            NavigationLink {
                ForgetPasswordView()
            } label: {
                Text("Sign In")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white)
                    .tracking(-0.5)
                    .multilineTextAlignment(.center)
                    .frame(width: uiScreenWith / 2 + 5, height: 34)
                    .background(Color("buttonBlue"))
                    .cornerRadius(5)
            }
        }
    }
}
