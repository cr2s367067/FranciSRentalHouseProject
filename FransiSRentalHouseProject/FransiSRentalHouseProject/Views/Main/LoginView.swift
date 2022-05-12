//
//  LoginView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI


struct LoginView: View {
    
    enum LoginStatus: String {
        case saveUserName
    }
    
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var bioAuthViewModel: BioAuthViewModel
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    
    
    @State private var emailAddress = ""
    @State private var userPassword = ""
    
    @FocusState private var isFocus: Bool

    
    
    var body: some View {
        NavigationView {
            ZStack {
                Group {
                    //: Background Image
                    Image("door1")
                        .resizable()
                        .blur(radius: 10)
                        .scaledToFill()
                        .frame(width: 428, height: 926)
                        .offset(x: 20)
                        .clipped()
                    Rectangle()
                        .fill(.black.opacity(0.5))
                        .blendMode(.multiply)
                }
                .ignoresSafeArea(.all)
                VStack {
                    Spacer()
                        .frame(height: 190)
                    HStack {
                        Text("Start to find your\nright place.")
                            .font(.custom("Work Sans", size: 34))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .tracking(-0.68)
                            .padding(.leading)
                            .padding()
                        Spacer()
                    }
                    HStack {
                        Text("Sign In")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding(.leading)
                            .padding()
                        Spacer()
//                        Button {
//                            Task {
//                                do {
//                                    try await firebaseAuth.signWithAnonymousAsync()
//                                } catch {
//                                    self.errorHandler.handle(error: error)
//                                }
//                            }
//                        } label: {
//                            Text(">>> Skip")
//                                .foregroundColor(.white)
//                                .padding(.trailing, 25)
//
//                        }
                    }
                    .padding(.top, -10)
                    .padding(.bottom, -15)
                    
                    //: User Name Text Field
                    VStack {
                        HStack {
                            Image(systemName: "person.fill")
                                .padding(.leading)
                            TextField("", text: $emailAddress)
                                .foregroundColor(.white)
                                .placeholer(when: emailAddress.isEmpty) {
                                    Text("E-mail")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .focused($isFocus)
                        }
                        .modifier(customTextField())
                        
                        
                        //: Password Text Field
                        HStack {
                            Image(systemName: "lock.fill")
                                .padding(.leading)
                            SecureField("", text: $userPassword)
                                .foregroundColor(.white)
                                .placeholer(when: userPassword.isEmpty) {
                                    Text("Password")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .focused($isFocus)
                        }
                        .modifier(customTextField())
                    }
                    
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
                    }
                    .padding()
                    VStack {
                        forceResetPassord(fail: firebaseAuth.failTimes)
                        HStack {
                            Text("You don't have account?")
                                .foregroundColor(.white)
                            NavigationLink {
                                SignUpView()
                            } label: {
                                Text("Let us create one")
                                    .foregroundColor(.blue)
                            }
                        }
                        .font(.system(size: 15, weight: .regular))
                        .shadow(radius: 5)
                        .padding(.top, 80)
                        
                    }
                    Spacer()
                }
                .padding()
                .onTapGesture {
                    isFocus = false
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                if bioAuthViewModel.faceIDEnable == true {
                    if firebaseAuth.signIn == false {
                        bioAuthViewModel.bioAuthentication(userNameBioAuth: bioAuthViewModel.userNameBioAuth, passBioAuth: bioAuthViewModel.passwordBioAuth)
                    }
                }
            }
        }
    }
}




struct LogginView_Previews: PreviewProvider {
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
                        try await firebaseAuth.signInAsync(email: emailAddress, password: userPassword)
                    } catch {
                        self.errorHandler.handle(error: error) {
                            firebaseAuth.failTimes += 1
                            print(firebaseAuth.failTimes)
                        }
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white)
                    .tracking(-0.5)
                    .multilineTextAlignment(.center)
                    .frame(width: 223, height: 34)
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
                    .frame(width: 223, height: 34)
                    .background(Color("buttonBlue"))
                    .cornerRadius(5)
            }
        }
    }
    
}
