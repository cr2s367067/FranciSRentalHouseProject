//
//  SignUpView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var fetchFirestore: FetchFirestore
    
    let persistenceDM = PersistenceController()
    
    @State var emailAddress = ""
    @State var userPassword = ""
    @State var recheckPassword = ""
    
    
    
    var body: some View {
        ZStack {
            Group {
                Image("room")
                    .resizable()
                    .blur(radius: 10)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 428, height: 926)
                    .offset(x: -40)
                    .clipped()
                Rectangle()
                    .fill(.gray)
                    .blendMode(.multiply)
            }
            .edgesIgnoringSafeArea([.top, .bottom])
            VStack {
                Spacer()
                    .frame(height: 100)
                HStack {
                    Text("Sign In")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding(.leading)
                        .padding()
                    Spacer()
                }
                .padding(.top, -10)
                .padding(.bottom, -15)
                VStack {
                    VStack(alignment: .leading) {
                        HStack {
                            TextField("", text: $emailAddress)
                                .placeholer(when: emailAddress.isEmpty) {
                                    Text("E-mail")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .padding(.leading)
                        }
                        .modifier(customTextField())
                        Text("")
                            .foregroundColor(.red)
                            .font(.system(size: 12, weight: .heavy))
                            .padding(2)
                    }
                    VStack {
                        HStack {
                            SecureField("", text: $userPassword)
                                .placeholer(when: userPassword.isEmpty) {
                                    Text("Password")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .padding(.leading)
                        }
                        .modifier(customTextField())
                        Text("")
                            .foregroundColor(.red)
                            .font(.system(size: 12, weight: .heavy))
                            .padding(2)
                    }
                    VStack {
                        HStack {
                            //Re-check the password
                            SecureField("", text: $recheckPassword)
                                .placeholer(when: recheckPassword.isEmpty) {
                                    Text("Confirm")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .padding(.leading)
                        }
                        .modifier(customTextField())
                        Text("")
                            .foregroundColor(.red)
                            .font(.system(size: 12, weight: .heavy))
                            .padding(2)
                    }
                    HStack {
                        Button {
                            if appViewModel.isRenter == true {
                                appViewModel.isRenter = false
                            }
                            if appViewModel.isProvider == false {
                                appViewModel.isProvider = true
                                appViewModel.userType = "Provider"
                                
                                //debugPrint(UserDataModel(id: "", firstName: "", lastName: "", phoneNumber: "", dob: Date(), address: "", town: "", city: "", zip: "", country: "", gender: "", userType: appViewModel.userType))
                            }
                        } label: {
                            HStack {
                                Text("I'm Provider")
                                    .foregroundColor(appViewModel.isProvider ? .white : .gray)
                                Image(systemName: appViewModel.isProvider ? "checkmark.circle.fill" : "checkmark.circle")
                                    .foregroundColor(appViewModel.isProvider ? .green : .gray)
                                    .padding(.leading, 10)
                                
                            }
                            .frame(width: 140, height: 34)
                            .background(Color("fieldGray").opacity(0.07))
                            .cornerRadius(5)
                        }
                        Spacer()
                            .frame(width: 85)
                        Button {
                            if appViewModel.isProvider == true {
                                appViewModel.isProvider = false
                                
                            }
                            if appViewModel.isRenter == false {
                                appViewModel.isRenter = true
                                appViewModel.userType = "Renter"
                                debugPrint(UserDataModel(id: "", firstName: "", lastName: "", mobileNumber: "", dob: Date(), address: "", town: "", city: "", zip: "", country: "", gender: "", userType: appViewModel.userType))
                            }
//                            appViewModel.isRenter.toggle()
                        } label: {
                            HStack {
                                Text("I'm Renter")
                                    .foregroundColor(appViewModel.isRenter ? .white : .gray)
                                Image(systemName: appViewModel.isRenter ? "checkmark.circle.fill" : "checkmark.circle")
                                    .foregroundColor(appViewModel.isRenter ? .green : .gray)
                                    .padding(.leading, 10)
                            }
                            .frame(width: 140, height: 34)
                            .background(Color("fieldGray").opacity(0.07))
                            .cornerRadius(5)
                        }
                    }
                    .padding(.top, 10)
                }
                VStack {
                    Button {
                        do {
                            try appViewModel.passwordCheckAndSignUp(email: emailAddress, password: userPassword, confirmPassword: recheckPassword)
                            
                            print(appViewModel.tempUserType)
                            persistenceDM.saveUserType(userType: appViewModel.userType)
                        } catch {
                            self.errorHandler.handle(error: error)
                        }
                    } label: {
                        Text("Sign Up")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white)
                            .tracking(-0.5)
                            .multilineTextAlignment(.center)
                            .frame(width: 223, height: 34)
                            .background(Color("buttonBlue"))
                            .cornerRadius(5)
                        
                    }
                    Spacer()
                        .frame(height: 180)
                    HStack {
                        Button {
                            appViewModel.isAgree.toggle()
                        } label: {
                            Image(systemName: appViewModel.isAgree ? "checkmark.square.fill" : "checkmark.square")
                                .foregroundColor(appViewModel.isAgree ? .green : .white)
                                .padding(.trailing, 5)
                        }
                        Text("I agree to the FranciS Terms of Service and \nPrivacy Police")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium))
                    }
                    
                }
                .padding(.top, 25)
                Spacer()
            }
        }
    }
}






struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
