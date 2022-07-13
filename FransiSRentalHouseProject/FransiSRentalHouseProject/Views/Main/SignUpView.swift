//
//  SignUpView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct SignUpView: View {
    
    enum EmpType: String {
        case founder = "Founder"
        case emp = "Employee"
    }
    
//    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var providerProfileViewModel: ProviderProfileViewModel
    @EnvironmentObject var paymentReceiveManager: PaymentReceiveManager
    @EnvironmentObject var pwdM: PwdManager
    @EnvironmentObject var signUpVM: SignUpVM
    @EnvironmentObject var providerStoreM: ProviderStoreM

    @State private var tosSheetShow = false
    @State private var ppSheetShow = false

    @State private var pwdCheckLength = false
    @State private var pwdCheckSymbol = false
    @State private var pwdCheckUppercase = false

    @State private var empType = ""
    
    @FocusState private var isFocus: Bool

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    private func reset() {
        signUpVM.emailAddress = ""
        signUpVM.userPassword = ""
        signUpVM.recheckPassword = ""
        signUpVM.isRenter = false
        signUpVM.isProvider = false
        signUpVM.isAgree = false
        UINavigationBar.appearance().backgroundColor = UIColor(Color.clear)
    }

    private func delayUnFocused() async {
        // MARK: 1 second = 1_000_000_000 nanoseconds

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
                                // MARK: - Username

                                VStack {
                                    HStack {
                                        TextField("", text: $signUpVM.emailAddress)
                                            .foregroundColor(.white)
                                            .placeholer(when: signUpVM.emailAddress.isEmpty) {
                                                Text("E-mail")
                                                    .foregroundColor(.white.opacity(0.8))
                                            }
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding(.leading)
                                            .keyboardType(.emailAddress)
                                            .accessibilityIdentifier("signUpUserName")
                                            .focused($isFocus)
                                    }
                                    .modifier(customTextField())
                                }
                                if firebaseAuth.signByApple == false {
                                    // MARK: - password

                                    VStack(alignment: .leading) {
                                        HStack {
                                            SecureField("", text: $signUpVM.userPassword)
                                                .foregroundColor(.white)
                                                .placeholer(when: signUpVM.userPassword.isEmpty) {
                                                    Text("Password")
                                                        .foregroundColor(.white.opacity(0.8))
                                                }
                                                .disableAutocorrection(true)
                                                .textInputAutocapitalization(.never)
                                                .padding(.leading)
                                                .accessibilityIdentifier("password")
                                                .focused($isFocus)
                                                .onChange(of: signUpVM.userPassword) { newValue in
                                                    pwdCheckSymbol = pwdM.symbolCheck(password: newValue)
                                                    pwdCheckLength = pwdM.lengthCheck(password: newValue)
                                                    pwdCheckUppercase = pwdM.upperCheck(password: newValue)
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

                                    // MARK: - re-Password

                                    VStack {
                                        HStack {
                                            // Re-check the password
                                            SecureField("", text: $signUpVM.recheckPassword)
                                                .foregroundColor(.white)
                                                .placeholer(when: signUpVM.recheckPassword.isEmpty) {
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
                                    if signUpVM.isRenter == true {
                                        signUpVM.isRenter = false
                                    }
                                    if signUpVM.isProvider == false {
                                        signUpVM.isProvider = true
                                        signUpVM.userType = "Provider"
                                        isFocus = false

                                        // debugPrint(UserDataModel(id: "", firstName: "", lastName: "", phoneNumber: "", dob: Date(), address: "", town: "", city: "", zip: "", country: "", gender: "", userType: appViewModel.userType))
                                    }
                                } label: {
                                    HStack {
                                        Text("I'm Provider")
                                            .foregroundColor(signUpVM.isProvider ? .white : .gray)
                                        Image(systemName: signUpVM.isProvider ? "checkmark.circle.fill" : "checkmark.circle")
                                            .foregroundColor(signUpVM.isProvider ? .green : .gray)
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
                                    if signUpVM.isProvider == true {
                                        signUpVM.isProvider = false
                                    }
                                    if signUpVM.isRenter == false {
                                        signUpVM.isRenter = true
                                        signUpVM.userType = "Renter"
                                        signUpVM.isEmployee = false
                                        signUpVM.isFounder = false
                                        signUpVM.isProductProvider = false
                                        signUpVM.isRentalM = false
                                        isFocus = false
                                    }
                                    //                            appViewModel.isRenter.toggle()
                                } label: {
                                    HStack {
                                        Text("I'm Renter")
                                            .foregroundColor(signUpVM.isRenter ? .white : .gray)
                                        Image(systemName: signUpVM.isRenter ? "checkmark.circle.fill" : "checkmark.circle")
                                            .foregroundColor(signUpVM.isRenter ? .green : .gray)
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
                        if signUpVM.isProvider == true {
                            HStack {
                                Button {
                                    if signUpVM.isRentalM == true {
                                        signUpVM.isRentalM = false
                                    }
                                    if signUpVM.isProductProvider == false {
                                        signUpVM.isProductProvider = true
                                        signUpVM.providerType = "Furniture Provider"
                                    }
                                } label: {
                                    HStack {
                                        Text("Product Provider")
                                            .foregroundColor(signUpVM.isProductProvider ? .white : .gray)
                                        Image(systemName: signUpVM.isProductProvider ? "checkmark.circle.fill" : "checkmark.circle")
                                            .foregroundColor(signUpVM.isProductProvider ? .green : .gray)
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
                                    if signUpVM.isProductProvider == true {
                                        signUpVM.isProductProvider = false
                                    }
                                    if signUpVM.isRentalM == false {
                                        signUpVM.isRentalM = true
                                        signUpVM.providerType = "Rental Manager"
                                    }

                                } label: {
                                    HStack {
                                        Text("Rental Manager")
                                            .foregroundColor(signUpVM.isRentalM ? .white : .gray)
                                        Image(systemName: signUpVM.isRentalM ? "checkmark.circle.fill" : "checkmark.circle")
                                            .foregroundColor(signUpVM.isRentalM ? .green : .gray)
                                            .padding(.leading, 10)
                                    }
                                    .frame(width: 160, height: 34)
                                    .background(Color("fieldGray").opacity(0.07))
                                    .cornerRadius(5)
                                }
                                .accessibilityIdentifier("rentalManager")
                            }
                            .padding(.top, 10)
                            
                            HStack {
                                Button {
                                    if signUpVM.isEmployee {
                                        signUpVM.isEmployee = false
                                    }
                                    if signUpVM.isFounder == false {
                                        signUpVM.isFounder = true
                                        empType = EmpType.founder.rawValue
                                    }
                                } label: {
                                    HStack {
                                        Text("Founder")
                                            .foregroundColor(signUpVM.isFounder ? .white : .gray)
                                        Image(systemName: signUpVM.isFounder ? "checkmark.circle.fill" : "checkmark.circle")
                                            .foregroundColor(signUpVM.isFounder ? .green : .gray)
                                            .padding(.leading, 10)
                                    }
                                    .frame(width: 160, height: 34)
                                    .background(Color("fieldGray").opacity(0.07))
                                    .cornerRadius(5)
                                    
                                }
                                
                                Button {
                                    if signUpVM.isFounder {
                                        signUpVM.isFounder = false
                                    }
                                    if signUpVM.isEmployee == false {
                                        signUpVM.isEmployee = true
                                        empType = EmpType.emp.rawValue
                                    }
                                } label: {
                                    HStack {
                                        Text("Employee")
                                            .foregroundColor(signUpVM.isEmployee ? .white : .gray)
                                        Image(systemName: signUpVM.isEmployee ? "checkmark.circle.fill" : "checkmark.circle")
                                            .foregroundColor(signUpVM.isEmployee ? .green : .gray)
                                            .padding(.leading, 10)
                                    }
                                    .frame(width: 160, height: 34)
                                    .background(Color("fieldGray").opacity(0.07))
                                    .cornerRadius(5)
                                }
                            }
                            .padding(.top, 10)
                        }
                        
                        if signUpVM.isProvider && signUpVM.isFounder || signUpVM.isEmployee {
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(LocalizedStringKey("GUI"))
                                        .modifier(textFormateForProviderSummitView())

                                    Spacer()
                                }
                                ZStack {
                                    TextField("", text: $signUpVM.gui)
                                        .foregroundStyle(Color.white)
                                        .frame(height: 30)
                                        .background(Color.clear)
                                        .cornerRadius(5)
                                        .keyboardType(.default)
                                        .focused($isFocus)
                                        .accessibilityIdentifier("gui")
                                }
                            }
                            .padding()
                            .frame(width: uiScreenWidth - 50, height: uiScreenHeight / 6 - 80)
                            .background(alignment: .center, content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 1)
                            })
                        }
                        
                        if signUpVM.isRentalM == true && signUpVM.isProvider == true {
//                            InfoUnit(title: "License Number", bindingString: $appViewModel.rentalManagerLicenseNumber)

                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(LocalizedStringKey("License Number"))
                                        .modifier(textFormateForProviderSummitView())

                                    Spacer()
                                }
                                ZStack {
                                    TextField("", text: $signUpVM.rentalManagerLicenseNumber)
                                        .foregroundStyle(Color.white)
                                        .frame(height: 30)
                                        .background(Color.clear)
                                        .cornerRadius(5)
                                        .keyboardType(.default)
                                        .focused($isFocus)
                                        .accessibilityIdentifier("licenseNumber")
                                    HStack {
                                        Spacer()
                                        ScanButton(text: $signUpVM.rentalManagerLicenseNumber)
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
                        empSignUpIdentity(
                            isFounder: signUpVM.isFounder,
                            isEmployee: signUpVM.isEmployee,
                            isRenter: signUpVM.isRenter
                        )
                        Spacer()
                            .frame(height: 40)
                        HStack {
                            Button {
                                signUpVM.isAgree.toggle()
                            } label: {
                                Image(systemName: signUpVM.isAgree ? "checkmark.square.fill" : "square")
                                    .foregroundColor(signUpVM.isAgree ? .green : .white)
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
    
    @ViewBuilder
    func empSignUpIdentity(
        isFounder: Bool,
        isEmployee: Bool,
        isRenter: Bool
    ) -> some View {
        if isFounder {
            NavigationLink(isActive: $providerStoreM.showSignUpStore)  {
                ProviderStoreSetUpView(
                    storeData: providerStoreM.storesData,
                    providerConfig: firestoreToFetchUserinfo.providerInfo
                )
            } label: {
                Text("Sign Up")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white)
                    .tracking(-0.5)
                    .multilineTextAlignment(.center)
                    .frame(width: 223, height: 34)
                    .background(Color("buttonBlue"))
                    .cornerRadius(5)
                    .onTapGesture {
                        Task {
                            try await signUpProcess(
                                isFounder: signUpVM.isFounder,
                                isEmployee: isEmployee,
                                isRenter: isRenter
                            )
                        }
                    }
            }
            .accessibilityIdentifier("signUp")
        }
        
        if isEmployee || isRenter {
            Button {
                Task {
                  try await signUpProcess(
                    isFounder: signUpVM.isFounder,
                    isEmployee: isEmployee,
                    isRenter: isRenter
                  )
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
        }
    }
    
    func signUpProcess(isFounder: Bool, isEmployee: Bool, isRenter: Bool) async throws {
//        Task {
            do {
                debugPrint("founder status: \(isFounder), employee status: \(isEmployee), Renter status: \(isRenter)")
                //MARK: - Check out sign up form
                try siwAFormChecker(signWA: firebaseAuth.signByApple)
                if firebaseAuth.signByApple == false {
                    //MARK: - If user isn't sign by apple the check password format
                    try pwdM.passwordChecker(
                        password: signUpVM.recheckPassword
                    )
                    
                    try await signUpVM.passwordCheckAndSignUpAsync(
                        email: signUpVM.emailAddress,
                        password: signUpVM.userPassword,
                        confirmPassword: signUpVM.recheckPassword
                    )
                    //MARK: - Then, sign up
                    try await firebaseAuth.signUpAsync(
                        email: signUpVM.emailAddress,
                        password: signUpVM.userPassword,
                        isFounder: isFounder
                    )
                }
                
                //MARK: - create user data and fetch
                try await firestoreToFetchUserinfo.createUserInfomationAsync(
                    uidPath: firebaseAuth.getUID(),
                    userDM: .signUpInit(
                        userType: signUpVM.userType,
                        providerType: signUpVM.providerType,
                        isFounder: signUpVM.isFounder,
                        isEmployee: signUpVM.isEmployee,
                        providerGUI: signUpVM.gui,
                        isSignByApple: firebaseAuth.signByApple,
                        email: signUpVM.emailAddress
                    )
                )
                
                if signUpVM.isProvider {
                    //MARK: - create provider data and fetch init data
                    try await firestoreToFetchUserinfo.createProviderData(
                        user: firebaseAuth.getUID(),
                        provider: ProviderDM(
                            gui: signUpVM.gui,
                            empType: empType,
                            empUID: firebaseAuth.getUID()
                        )
                    )
                    if isFounder {
                        //MARK: - Create store data and fetch
                        try await providerStoreM.createStore(
                            gui: signUpVM.gui,
                            provider: .createStore
                        )
                        providerStoreM.showSignUpStore = true
                    }
                }
               
                if firebaseAuth.signByApple {
                    firebaseAuth.signIn = true
                    firebaseAuth.showSignUpView = false
                    firebaseAuth.signByApple = false
                }
                
            } catch {
                self.errorHandler.handle(error: error)
            }
//        }
    }
    
    func siwAFormChecker(signWA: Bool) throws {
        if signWA {
            guard !signUpVM.emailAddress.isEmpty else {
                throw SignUpError.emailIsEmpty
            }
            guard signUpVM.isAgree == true else {
                throw SignUpError.termofServiceIsNotAgree
            }
            guard signUpVM.isRenter == true || signUpVM.isProvider == true else {
                throw SignUpError.missingUserType
            }
            if signUpVM.isProvider {
                guard signUpVM.isRentalM == true || signUpVM.isProductProvider == true else {
                    throw SignUpError.providerTypeError
                }
                guard signUpVM.isFounder == true || signUpVM.isEmployee == true else {
                    throw SignUpError.employeeError
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
