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
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var providerProfileViewModel: ProviderProfileViewModel
    @EnvironmentObject var paymentReceiveManager: PaymentReceiveManager
    @EnvironmentObject var pwdM: PwdManager
    
    @State private var tosSheetShow = false
    @State private var ppSheetShow = false
    
    @State private var pwdCheckLength = false
    @State private var pwdCheckSymbol = false
    @State private var pwdCheckUppercase = false
    
    @FocusState private var isFocus: Bool
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    private func reset() {
        appViewModel.emailAddress = ""
        appViewModel.userPassword = ""
        appViewModel.recheckPassword = ""
        appViewModel.isRenter = false
        appViewModel.isProvider = false
        appViewModel.isAgree = false
        UINavigationBar.appearance().backgroundColor = UIColor(Color.clear)
    }
    
    private func delayUnFocused() async {
        //MARK: 1 second = 1_000_000_000 nanoseconds
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        isFocus = false
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    //                    Spacer()
                    //                        .frame(height: 90)
                    HStack {
                        Text(firebaseAuth.signByApple ? "Please Chose User Type" : "Sign Up")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding(.leading)
                            .padding()
                        Spacer()
                    }
                    .padding(.top, -10)
                    .padding(.bottom, -15)
                    VStack {
                        VStack(spacing: 10) {
                            Group {
                                //MARK: - Username
                                VStack {
                                    HStack {
                                        TextField("", text: $appViewModel.emailAddress)
                                            .foregroundColor(.white)
                                            .placeholer(when: appViewModel.emailAddress.isEmpty) {
                                                Text("E-mail")
                                                    .foregroundColor(.white.opacity(0.8))
                                            }
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding(.leading)
                                            .keyboardType(.emailAddress)
                                            .accessibilityIdentifier("signUpUserName")
                                            .focused($isFocus)
//                                            .onChange(of: appViewModel.emailAddress.count) { newValue in
//                                                Task {
//                                                    await delayUnFocused()
//                                                }
//                                            }
                                    }
                                    .modifier(customTextField())
                                }
                                if firebaseAuth.signByApple == false {
                                    //MARK: - password
                                    VStack(alignment: .leading) {
                                        HStack {
                                            SecureField("", text: $appViewModel.userPassword)
                                                .accessibilityIdentifier("signUpPassword")
                                                .foregroundColor(.white)
                                                .placeholer(when: appViewModel.userPassword.isEmpty) {
                                                    Text("Password")
                                                        .foregroundColor(.white.opacity(0.8))
                                                }
                                                .disableAutocorrection(true)
                                                .textInputAutocapitalization(.never)
                                                .padding(.leading)
                                                .focused($isFocus)
                                                .onChange(of: appViewModel.userPassword) { newValue in
                                                    pwdCheckSymbol = pwdM.symbolCheck(password: newValue)
                                                    pwdCheckLength = pwdM.lengthCheck(password: newValue)
                                                    pwdCheckUppercase = pwdM.upperCheck(password: newValue)
//                                                    Task {
//                                                        await delayUnFocused()
//                                                    }
                                                }
                                        }
                                        .modifier(customTextField())
                                        Group {
                                            Text("> Length greater than 8 charater")
                                                .foregroundColor(pwdCheckLength ? .gray : .white)
                                            Text("> Must contain symbols (!@#$%^&*)")
                                                .foregroundColor(pwdCheckSymbol ? .gray : .white)
                                            Text("> At least one Uppercase")
                                                .foregroundColor(pwdCheckUppercase ? .gray : .white)
                                        }
                                        .font(.caption)
                                    }
                                    //MARK: - re-Password
                                    VStack {
                                        HStack {
                                            //Re-check the password
                                            SecureField("", text: $appViewModel.recheckPassword)
                                                .foregroundColor(.white)
                                                .placeholer(when: appViewModel.recheckPassword.isEmpty) {
                                                    Text("Confirm")
                                                        .foregroundColor(.white.opacity(0.8))
                                                }
                                                .disableAutocorrection(true)
                                                .textInputAutocapitalization(.never)
                                                .padding(.leading)
                                                .accessibilityIdentifier("confirmPassword")
                                                .focused($isFocus)
                                        }
                                        .modifier(customTextField())
                                    }
                                }
                            }
                            HStack {
                                Button {
                                    if appViewModel.isRenter == true {
                                        appViewModel.isRenter = false
                                    }
                                    if appViewModel.isProvider == false {
                                        appViewModel.isProvider = true
                                        appViewModel.userType = "Provider"
                                        isFocus = false
                                        
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
                                .accessibilityIdentifier("isProvider")
                                Spacer()
                                    .frame(width: uiScreenWidth / 8 + 10)
                                Button {
                                    if appViewModel.isProvider == true {
                                        appViewModel.isProvider = false
                                        
                                    }
                                    if appViewModel.isRenter == false {
                                        appViewModel.isRenter = true
                                        appViewModel.userType = "Renter"
                                        isFocus = false
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
                                .accessibilityIdentifier("isRenter")
                            }
                            .padding(.top, 10)
                        }
                        .focused($isFocus)
                        if appViewModel.isProvider == true {
                            HStack {
                                Button {
                                    if appViewModel.isRentalM == true {
                                        appViewModel.isRentalM = false
                                    }
                                    if appViewModel.isFurnitureProvider == false {
                                        appViewModel.isFurnitureProvider = true
                                        appViewModel.providerType = "Furniture Provider"
                                    }
                                } label: {
                                    HStack {
                                        Text("Product Provider")
                                            .foregroundColor(appViewModel.isFurnitureProvider ? .white : .gray)
                                        Image(systemName: appViewModel.isFurnitureProvider ? "checkmark.circle.fill" : "checkmark.circle")
                                            .foregroundColor(appViewModel.isFurnitureProvider ? .green : .gray)
                                            .padding(.leading, 10)
                                        
                                    }
                                    .frame(width: 180, height: 34)
                                    .background(Color("fieldGray").opacity(0.07))
                                    .cornerRadius(5)
                                }
                                .accessibilityIdentifier("productProvider")
                                Spacer()
                                    .frame(width: uiScreenWidth / 8 - 30)
                                Button {
                                    if appViewModel.isFurnitureProvider == true {
                                        appViewModel.isFurnitureProvider = false
                                        
                                    }
                                    if appViewModel.isRentalM == false {
                                        appViewModel.isRentalM = true
                                        appViewModel.providerType = "Rental Manager"
                                    }
                                    
                                } label: {
                                    HStack {
                                        Text("Rental Manager")
                                            .foregroundColor(appViewModel.isRentalM ? .white : .gray)
                                        Image(systemName: appViewModel.isRentalM ? "checkmark.circle.fill" : "checkmark.circle")
                                            .foregroundColor(appViewModel.isRentalM ? .green : .gray)
                                            .padding(.leading, 10)
                                    }
                                    .frame(width: 160, height: 34)
                                    .background(Color("fieldGray").opacity(0.07))
                                    .cornerRadius(5)
                                }
                                .accessibilityIdentifier("rentalManager")
                            }
                            .padding(.top, 10)
                        }
                        if appViewModel.isRentalM == true && appViewModel.isProvider == true {
//                            InfoUnit(title: "License Number", bindingString: $appViewModel.rentalManagerLicenseNumber)
                                
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(LocalizedStringKey("License Number"))
                                        .modifier(textFormateForProviderSummitView())
                                        
                                    Spacer()
                                }
                                ZStack {
                                    TextField("", text: $appViewModel.rentalManagerLicenseNumber)
                                        .foregroundStyle(Color.white)
                                        .frame(height: 30)
                                        .background(Color.clear)
                                        .cornerRadius(5)
                                        .keyboardType(.default)
                                        .focused($isFocus)
                                        .accessibilityIdentifier("licenseNumber")
                                    HStack {
                                        Spacer()
                                        ScanButton(text: $appViewModel.rentalManagerLicenseNumber)
                                            .frame(width: uiScreenWidth / 4, height: 50, alignment: .center)
                                            
                                    }
                                }
                            }
                            .padding()
                            .frame(width: uiScreenWidth - 50, height: uiScreenHeight / 5 - 80)
                            .background(alignment: .center, content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 1)
                            })
                        }
                    }
                    VStack {
                        Button {
                            Task {
                                do {
                                    try siwAFormChecker(signWA: firebaseAuth.signByApple)
                                    if firebaseAuth.signByApple == false {
                                        try pwdM.passwordChecker(password: appViewModel.recheckPassword)
                                        try await appViewModel.passwordCheckAndSignUpAsync(email: appViewModel.emailAddress,
                                                                                           password: appViewModel.userPassword,
                                                                                           confirmPassword: appViewModel.recheckPassword)
                                        try await firebaseAuth.signUpAsync(email: appViewModel.emailAddress, password: appViewModel.userPassword)
                                    }
                                    if appViewModel.isProvider {
                                        print("Create provider config")
                                        try await providerProfileViewModel.createConfig(uidPath: firebaseAuth.getUID())
                                    }
                                    try await firestoreToFetchUserinfo.createUserInfomationAsync(uidPath: firebaseAuth.getUID(),
                                                                                                 id: appViewModel.id,
                                                                                                 firstName: appViewModel.firstName,
                                                                                                 lastName: appViewModel.lastName,
                                                                                                 displayName: appViewModel.displayName,
                                                                                                 mobileNumber: appViewModel.mobileNumber,
                                                                                                 dob: appViewModel.dob,
                                                                                                 address: appViewModel.address,
                                                                                                 town: appViewModel.town,
                                                                                                 city: appViewModel.city,
                                                                                                 zip: appViewModel.zipCode,
                                                                                                 country: appViewModel.country,
                                                                                                 gender: appViewModel.gender,
                                                                                                 userType: appViewModel.userType,
                                                                                                 emailAddress: appViewModel.emailAddress,
                                                                                                 providerType: appViewModel.providerType,
                                                                                                 RLNumber: appViewModel.rentalManagerLicenseNumber, signByApple: firebaseAuth.signByApple)
                                    if firebaseAuth.signByApple {
                                        firebaseAuth.signIn = true
                                        firebaseAuth.showSignUpView = false
                                        firebaseAuth.signByApple = false
                                    }
                                } catch {
                                    self.errorHandler.handle(error: error)
                                }
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
                        .accessibilityIdentifier("signUp")
                        Spacer()
                            .frame(height: 80)
                        HStack {
                            Button {
                                appViewModel.isAgree.toggle()
                            } label: {
                                Image(systemName: appViewModel.isAgree ? "checkmark.square.fill" : "square")
                                    .foregroundColor(appViewModel.isAgree ? .green : .white)
                                    .padding(.trailing, 5)
                            }
                            .accessibilityIdentifier("tosCheckBox")
                            Group {
                                Text("I agree to the FranciS")
                                    .foregroundColor(.white)
                                    .accessibilityIdentifier("tosP1")
                                Text("Terms of Service")
                                    .foregroundColor(Color.blue)
                                    .accessibilityIdentifier("tosP2")
                                    .onTapGesture {
                                        tosSheetShow.toggle()
                                    }
                                Text("and")
                                    .foregroundColor(.white)
                                    .accessibilityIdentifier("tosP3")
                                Text("Privacy Policy")
                                    .foregroundColor(Color.blue)
                                    .onTapGesture {
                                        ppSheetShow.toggle()
                                    }
                                    .accessibilityIdentifier("tosP4")
                                Text(".")
                                    .foregroundColor(.white)
                                    .accessibilityIdentifier("tosP5")
                            }
                            .font(.system(size: 12, weight: .medium))
                            
                        }
                    }
                    .padding(.top, 25)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isFocus = false
                }
            }
        }
        .background(alignment: .center) {
            Group {
                Image("door1")
                    .resizable()
                    .blur(radius: 10)
                    .scaledToFill()
                    .frame(width: 428, height: 926)
                    .offset(x: 20)
                    .clipped()
                Rectangle()
                    .fill(.gray.opacity(0.5))
                    .blendMode(.multiply)
            }
            .edgesIgnoringSafeArea([.top, .bottom])
        }
        .sheet(isPresented: $tosSheetShow, content: {
            TermOfServiceView()
        })
        .sheet(isPresented: $ppSheetShow, content: {
            PrivatePolicyView()
        })
        .onAppear(perform: {
            reset()
        })
    }
}

extension SignUpView {
    func siwAFormChecker(signWA: Bool) throws {
        if signWA {
            guard !appViewModel.emailAddress.isEmpty else {
                throw SignUpError.emailIsEmpty
            }
            guard appViewModel.isAgree == true else {
                throw SignUpError.termofServiceIsNotAgree
            }
            guard appViewModel.isRenter == true || appViewModel.isProvider == true else {
                throw SignUpError.missingUserType
            }
            if appViewModel.isProvider {
                guard appViewModel.isRentalM == true || appViewModel.isFurnitureProvider == true else {
                    throw SignUpError.providerTypeError
                }
            }
        }
    }
}




struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
