//
//  UserDetailInfoView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct UserDetailInfoView: View {
    
    //    @EnvironmentObject var fetchFirestore: FetchFirestore
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreForTextingMessage: FirestoreForTextingMessage
    @EnvironmentObject var userDetailInfoViewModel: UserDetailInfoViewModel
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var storeProfileVM: StoreProfileViewModel
    
    
    let uiScreenWidth = UIScreen.main.bounds.width
    
    
    @State var showAlert = false
    @State var inforFormatterCorrect = false
    @State private var isSummit = false
    @State private var selection = "House Owner"
    
    @FocusState private var isFocused: Bool
    
    
    //    private func reset() {
    //        appViewModel.userDetailViewReset()
    //        isMale = false
    //        isFemale = false
    //    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    TitleAndDivider(title: "User Detail Information")
                    VStack(alignment: .center, spacing: 10) {
                        isEditMode(isEdit: userDetailInfoViewModel.isEdit, uType: SignUpType(rawValue: firestoreToFetchUserinfo.fetchedUserData.userType) ?? .isNormalCustomer)
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Group {
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(isSummit ? Color.green : Color.clear)
                            Text("Success")
                                .foregroundColor(isSummit ? Color.green : Color.clear)
                                .font(.system(size: 12, weight: .thin))
                        }
                        summitButton(isEdit: userDetailInfoViewModel.isEdit, uType: SignUpType(rawValue: firestoreToFetchUserinfo.fetchedUserData.userType) ?? .isNormalCustomer)
                    }
                }
            }
        }
        .frame(width: uiScreenWidth - 30)
        .modifier(ViewBackgroundInitModifier())
        .onAppear(perform: {
            if firestoreToFetchUserinfo.presentUserId().isEmpty {
                userDetailInfoViewModel.isEdit = true
            }
            appViewModel.updateNavigationBarColor()
            appViewModel.id = firestoreToFetchUserinfo.fetchedUserData.id
            appViewModel.firstName = firestoreToFetchUserinfo.fetchedUserData.firstName
            appViewModel.lastName = firestoreToFetchUserinfo.fetchedUserData.lastName
            appViewModel.displayName = firestoreToFetchUserinfo.fetchedUserData.displayName
            appViewModel.mobileNumber = firestoreToFetchUserinfo.fetchedUserData.mobileNumber
            appViewModel.dob = firestoreToFetchUserinfo.fetchedUserData.dob
            appViewModel.address = firestoreToFetchUserinfo.fetchedUserData.address
            appViewModel.town = firestoreToFetchUserinfo.fetchedUserData.town
            appViewModel.city = firestoreToFetchUserinfo.fetchedUserData.city
            appViewModel.zipCode = firestoreToFetchUserinfo.fetchedUserData.zip
            appViewModel.country = firestoreToFetchUserinfo.fetchedUserData.country
            appViewModel.gender = firestoreToFetchUserinfo.fetchedUserData.gender
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    userDetailInfoViewModel.isEdit.toggle()
                } label: {
                    Image(systemName: "gearshape")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20, alignment: .trailing)
                }
            }
            
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isFocused = false
                }
            }
        }
    }
}


struct UserDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailInfoView()
    }
}


extension UserDetailInfoView {
    @ViewBuilder
    func userInfoUnit(title: String, presentString: String) -> some View {
        let uiScreenWidth = UIScreen.main.bounds.width
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(LocalizedStringKey(title))
                    .modifier(textFormateForProviderSummitView())
                Spacer()
            }
            Text(presentString)
                .foregroundStyle(Color.white)
                .frame(height: 30)
                .background(Color.clear)
                .cornerRadius(5)
        }
        .padding()
        .frame(width: uiScreenWidth - 30)
        .background(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 1)
        })
    }
    
    @ViewBuilder
    func userInfoPresenting(source: UserDataModel, uType: SignUpType) -> some View {
        if uType == .isNormalCustomer {
            userInfoUnit(title: "ID", presentString: source.id)
            userInfoUnit(title: "First Name", presentString: source.firstName)
            userInfoUnit(title: "Last Name", presentString: source.lastName)
        }
        if uType == .isProvider {
            userInfoUnit(title: "GUI", presentString: source.id)
            userInfoUnit(title: "Company Name", presentString: source.firstName)
        }
        userInfoUnit(title: "Display Name", presentString: source.displayName)
        userInfoUnit(title: "Mobile Number", presentString: source.mobileNumber)
        if uType == .isNormalCustomer {
            userInfoUnit(title: "Date of Birth", presentString: source.dob.formatted(Date.FormatStyle().year().month().day()))
        }
        Group {
            userInfoUnit(title: "Country", presentString: source.country)
            userInfoUnit(title: "Zip Code", presentString: source.zip)
            userInfoUnit(title: "City", presentString: source.city)
            userInfoUnit(title: "Town", presentString: source.town)
            userInfoUnit(title: "Address", presentString: source.address)
        }
    }
    
    @ViewBuilder
    func isEditMode(isEdit: Bool, uType: SignUpType) -> some View {
        
        if isEdit == false {
            userInfoPresenting(source: firestoreToFetchUserinfo.fetchedUserData, uType: uType)
        } else {
            Group {
                Group {
                    if uType == .isNormalCustomer {
                        InfoUnit(title: "ID", bindingString: $appViewModel.id)
                        InfoUnit(title: "First Name", bindingString: $appViewModel.firstName)
                        InfoUnit(title: "Last Name", bindingString: $appViewModel.lastName)
                    }
                    if uType == .isProvider {
                        InfoUnit(title: "GUI", bindingString: $appViewModel.id)
                        InfoUnit(title: "Company Name", bindingString: $appViewModel.firstName)
                    }
                    InfoUnit(title: "Display Name", bindingString: $appViewModel.displayName)
                        .onTapGesture {
                            appViewModel.displayName = ""
                        }
                    if uType == .isNormalCustomer {
                        Group {
                            HStack {
                                Text("Gender")
                                    .foregroundColor(.white)
                                    .font(.body)
                                Spacer()
                            }
                            .frame(width: uiScreenWidth - 35)
                            HStack(alignment: .center, spacing: 30) {
                                Spacer()
                                Button {
                                    appViewModel.isMale.toggle()
                                    if appViewModel.isMale == true {
                                        appViewModel.gender = "Male"
                                        debugPrint(appViewModel.gender)
                                    }
                                    if appViewModel.isFemale == true {
                                        appViewModel.isFemale = false
                                    }
                                } label: {
                                    HStack {
                                        Text("Male")
                                            .foregroundColor(appViewModel.isMale ? .white : .white)
                                        Image(systemName: appViewModel.isMale ? "checkmark.circle.fill" : "checkmark.circle")
                                            .foregroundColor(appViewModel.isMale ? .green : .white)
                                            .padding(.leading, 10)
                                        
                                    }
                                    .frame(width: 140, height: 30)
                                    .background(Color("fieldGray").opacity(0.07))
                                    .cornerRadius(5)
                                }
                                Button {
                                    appViewModel.isFemale.toggle()
                                    if appViewModel.isFemale == true {
                                        appViewModel.gender = "Female"
                                        debugPrint(appViewModel.gender)
                                    }
                                    if appViewModel.isMale == true {
                                        appViewModel.isMale = false
                                    }
                                } label: {
                                    HStack {
                                        Text("Female")
                                            .foregroundColor(appViewModel.isFemale ? .white : .white)
                                        Image(systemName: appViewModel.isFemale ? "checkmark.circle.fill" : "checkmark.circle")
                                            .foregroundColor(appViewModel.isFemale ? .green : .white)
                                            .padding(.leading, 10)
                                    }
                                    .frame(width: 140, height: 30)
                                    .background(Color("fieldGray").opacity(0.07))
                                    .cornerRadius(5)
                                }
                                Spacer()
                            }
                        }
                    }
                }
                Group {
                    InfoUnit(title: "Mobile Number", bindingString: $appViewModel.mobileNumber)
                        .keyboardType(.decimalPad)
                    if uType == .isNormalCustomer {
                        DatePicker("Date of Birth", selection: $appViewModel.dob, in: ...Date(), displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .applyTextColor(.white)
                            .frame(width: uiScreenWidth - 35)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    InfoUnit(title: "Country", bindingString: $appViewModel.country) //: Picker
                    InfoUnit(title: "Zip Code", bindingString: $appViewModel.zipCode)
                    InfoUnit(title: "City", bindingString: $appViewModel.city) //: Picker
                    InfoUnit(title: "Town", bindingString: $appViewModel.town)
                    InfoUnit(title: "Address", bindingString: $appViewModel.address)
                }
            }
            .focused($isFocused)
        }
    }
    
    @ViewBuilder
    func summitButton(isEdit: Bool, uType: SignUpType) -> some View {
        if isEdit == true {
            Button {
                Task {
                    if uType == .isNormalCustomer {
                        try await forNormalUser()
                    }
                    if uType == .isProvider {
                        try await forProviderUser()
                    }
                }
            } label: {
                Text("Summit")
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Notice"), message: Text("Please check out all blank"), dismissButton: .default(Text("Okay")))
                    }
            }
            .foregroundColor(.white)
            .frame(width: 108, height: 35)
            .background(Color("buttonBlue"))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(.trailing)
        }
    }
    
    func forProviderUser() async throws {
        guard appViewModel.id.count == 8 else {
            throw UserInformationError.guiFormatError
        }
        guard !appViewModel.firstName.isEmpty, !appViewModel.displayName.isEmpty, !appViewModel.mobileNumber.isEmpty, !appViewModel.address.isEmpty, !appViewModel.town.isEmpty, !appViewModel.city.isEmpty, !appViewModel.zipCode.isEmpty, !appViewModel.country.isEmpty else {
            throw UserInformationError.blankError
        }
        do {
            try appViewModel.userInfoFormatterCheckerAsync(id: appViewModel.id,
                                                           firstName: appViewModel.firstName,
                                                           lastName: appViewModel.lastName,
                                                           gender: appViewModel.gender,
                                                           mobileNumber: appViewModel.mobileNumber, uType: SignUpType(rawValue: firestoreToFetchUserinfo.fetchedUserData.userType) ?? .isNormalCustomer)
            
            
            try await firestoreToFetchUserinfo.updateUserInfomationAsync(uidPath: firebaseAuth.getUID(),
                                                                         id: appViewModel.id,
                                                                         firstName: appViewModel.firstName,
                                                                         lastName: appViewModel.lastName,
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
                                                                         RLNumber: appViewModel.rentalManagerLicenseNumber,
                                                                         displayName: appViewModel.displayName)
            try await firestoreForTextingMessage.createAndStoreContactUser(uidPath: firebaseAuth.getUID())
            isSummit = true
            try await firestoreToFetchUserinfo.reloadUserData()
            if firestoreToFetchUserinfo.fetchedUserData.providerType == "Furniture Provider" {
                //MARK: (BUG) Doesn't create store after provider info update
                try await firestoreForProducts.createStore(uidPath: firebaseAuth.getUID(),
                                                           provideBy: firebaseAuth.getUID(),
                                                           providerDisplayName: firestoreToFetchUserinfo.fetchedUserData.displayName,
                                                           providerProfileImage: firestoreToFetchUserinfo.fetchedUserData.profileImageURL,
                                                           providerDescription: storeProfileVM.providerDescription, storeChatDocID: firestoreForTextingMessage.senderUIDPath.chatDocId)
                storeProfileVM.isCreated = true
            }
            appViewModel.isShowUserDetailView = false
            userDetailInfoViewModel.isEdit = false
        } catch {
            self.errorHandler.handle(error: error)
        }
        
    }
    
    func forNormalUser() async throws {
        if !appViewModel.id.isEmpty, !appViewModel.firstName.isEmpty, !appViewModel.lastName.isEmpty, !appViewModel.gender.isEmpty, !appViewModel.mobileNumber.isEmpty, !appViewModel.address.isEmpty, !appViewModel.town.isEmpty, !appViewModel.city.isEmpty, !appViewModel.zipCode.isEmpty, !appViewModel.country.isEmpty == true {
            do {
                try appViewModel.userInfoFormatterCheckerAsync(id: appViewModel.id,
                                                               firstName: appViewModel.firstName,
                                                               lastName: appViewModel.lastName,
                                                               gender: appViewModel.gender,
                                                               mobileNumber: appViewModel.mobileNumber, uType: SignUpType(rawValue: firestoreToFetchUserinfo.fetchedUserData.userType) ?? .isNormalCustomer)
                
                
                try await firestoreToFetchUserinfo.updateUserInfomationAsync(uidPath: firebaseAuth.getUID(),
                                                                             id: appViewModel.id,
                                                                             firstName: appViewModel.firstName,
                                                                             lastName: appViewModel.lastName,
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
                                                                             RLNumber: appViewModel.rentalManagerLicenseNumber,
                                                                             displayName: appViewModel.displayName)
                try await firestoreForTextingMessage.createAndStoreContactUser(uidPath: firebaseAuth.getUID())
                isSummit = true
                try await firestoreToFetchUserinfo.reloadUserData()
                appViewModel.isShowUserDetailView = false
                userDetailInfoViewModel.isEdit = false
            } catch {
                self.errorHandler.handle(error: error)
            }
        } else {
            showAlert = true
        }
    }
    
}



class UserDetailInfoViewModel: ObservableObject {
    @Published var isEdit = false
}
