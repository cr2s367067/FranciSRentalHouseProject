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
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var storeProfileVM: StoreProfileViewModel
    @EnvironmentObject var userInfoVM: UserInfoVM
    
    
    
    let uiScreenWidth = UIScreen.main.bounds.width
    
    
    @State var showAlert = false
    @State var inforFormatterCorrect = false
    @State private var isSummit = false
    @State private var selection = "House Owner"
    
    @FocusState private var isFocused: Bool
    
    
    //    private func reset() {
    //        userInfoVM.userDetailViewReset()
    //        isMale = false
    //        isFemale = false
    //    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    TitleAndDivider(title: "User Detail Information")
                    VStack(alignment: .center, spacing: 10) {
                        isEditMode(isEdit: userInfoVM.isEdit, uType: SignUpType(rawValue: firestoreToFetchUserinfo.fetchedUserData.userType) ?? .isNormalCustomer)
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
                        summitButton(isEdit: userInfoVM.isEdit, uType: SignUpType(rawValue: firestoreToFetchUserinfo.fetchedUserData.userType) ?? .isNormalCustomer)
                    }
                }
            }
        }
        .frame(width: uiScreenWidth - 30)
        .modifier(ViewBackgroundInitModifier())
        .onAppear(perform: {
            if firestoreToFetchUserinfo.userIDisEmpty() {
                userInfoVM.isEdit = true
            }
            appViewModel.updateNavigationBarColor()
//            userInfoVM.id = firestoreToFetchUserinfo.fetchedUserData.id
//            userInfoVM.firstName = firestoreToFetchUserinfo.fetchedUserData.firstName
//            userInfoVM.lastName = firestoreToFetchUserinfo.fetchedUserData.lastName
//            userInfoVM.nickName = firestoreToFetchUserinfo.fetchedUserData.nickName
//            userInfoVM.mobileNumber = firestoreToFetchUserinfo.fetchedUserData.mobileNumber
//            userInfoVM.dob = firestoreToFetchUserinfo.fetchedUserData.dob
//            userInfoVM.address = firestoreToFetchUserinfo.fetchedUserData.address
//            userInfoVM.town = firestoreToFetchUserinfo.fetchedUserData.town
//            userInfoVM.city = firestoreToFetchUserinfo.fetchedUserData.city
//            userInfoVM.zipCode = firestoreToFetchUserinfo.fetchedUserData.zipCode
////            userInfoVM.country = firestoreToFetchUserinfo.fetchedUserData.country
//            userInfoVM.gender = firestoreToFetchUserinfo.fetchedUserData.gender
            userInfoVM.userInfo = firestoreToFetchUserinfo.fetchedUserData
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    userInfoVM.isEdit.toggle()
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
    func userInfoPresenting(source: UserDM, uType: SignUpType) -> some View {
//        if uType == .isNormalCustomer {
            userInfoUnit(title: "ID", presentString: source.id)
            userInfoUnit(title: "First Name", presentString: source.firstName)
            userInfoUnit(title: "Last Name", presentString: source.lastName)
//        }
//        if uType == .isProvider {
//            userInfoUnit(title: "GUI", presentString: source.id)
//            userInfoUnit(title: "Company Name", presentString: source.firstName)
//        }
        userInfoUnit(title: "Nick Name", presentString: source.nickName)
        userInfoUnit(title: "Mobile Number", presentString: source.mobileNumber)
//        if uType == .isNormalCustomer {
            userInfoUnit(title: "Date of Birth", presentString: source.dob.formatted(Date.FormatStyle().year().month().day()))
//        }
        Group {
//            userInfoUnit(title: "Country", presentString: source.country)
            userInfoUnit(title: "Zip Code", presentString: source.zipCode)
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
                    InfoUnit(title: "ID", bindingString: $userInfoVM.userInfo.id)
                    InfoUnit(title: "First Name", bindingString: $userInfoVM.userInfo.firstName)
                    InfoUnit(title: "Last Name", bindingString: $userInfoVM.userInfo.lastName)
                    InfoUnit(title: "Nick Name", bindingString: $userInfoVM.userInfo.nickName)
                        .onTapGesture {
                            userInfoVM.userInfo.nickName = ""
                        }
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
                                userInfoVM.isMale.toggle()
                                if userInfoVM.isMale == true {
                                    userInfoVM.userInfo.gender = "Male"
                                    debugPrint(userInfoVM.userInfo.gender)
                                }
                                if userInfoVM.isFemale == true {
                                    userInfoVM.isFemale = false
                                }
                            } label: {
                                HStack {
                                    Text("Male")
                                        .foregroundColor(userInfoVM.isMale ? .white : .white)
                                    Image(systemName: userInfoVM.isMale ? "checkmark.circle.fill" : "checkmark.circle")
                                        .foregroundColor(userInfoVM.isMale ? .green : .white)
                                        .padding(.leading, 10)

                                }
                                .frame(width: 140, height: 30)
                                .background(Color("fieldGray").opacity(0.07))
                                .cornerRadius(5)
                            }
                            Button {
                                userInfoVM.isFemale.toggle()
                                if userInfoVM.isFemale == true {
                                    userInfoVM.userInfo.gender = "Female"
                                    debugPrint(userInfoVM.userInfo.gender)
                                }
                                if userInfoVM.isMale == true {
                                    userInfoVM.isMale = false
                                }
                            } label: {
                                HStack {
                                    Text("Female")
                                        .foregroundColor(userInfoVM.isFemale ? .white : .white)
                                    Image(systemName: userInfoVM.isFemale ? "checkmark.circle.fill" : "checkmark.circle")
                                        .foregroundColor(userInfoVM.isFemale ? .green : .white)
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
                Group {
                    InfoUnit(title: "Mobile Number", bindingString: $userInfoVM.userInfo.mobileNumber)
                        .keyboardType(.decimalPad)
//                    if uType == .isNormalCustomer {
                        DatePicker("Date of Birth", selection: $userInfoVM.userInfo.dob, in: ...Date(), displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .applyTextColor(.white)
                            .frame(width: uiScreenWidth - 35)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
//                    }
//                    InfoUnit(title: "Country", bindingString: $userInfoVM.userInfo.country)
                    InfoUnit(title: "Zip Code", bindingString: $userInfoVM.userInfo.zipCode)
                    InfoUnit(title: "City", bindingString: $userInfoVM.userInfo.city) //: Picker
                    InfoUnit(title: "Town", bindingString: $userInfoVM.userInfo.town)  //: Picker
                    InfoUnit(title: "Address", bindingString: $userInfoVM.userInfo.address)
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
//                    if uType == .isNormalCustomer {
                        try await forNormalUser()
//                    }
//                    if uType == .isProvider {
//                        try await forProviderUser()
//                    }
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
    
//    func forProviderUser() async throws {
//        guard userInfoVM.userInfo.id.count == 8 else {
//            throw UserInformationError.guiFormatError
//        }
//        guard
//            !userInfoVM.userInfo.firstName.isEmpty,
//            !userInfoVM.userInfo.nickName.isEmpty,
//            !userInfoVM.userInfo.mobileNumber.isEmpty,
//            !userInfoVM.userInfo.address.isEmpty,
//            !userInfoVM.userInfo.town.isEmpty,
//            !userInfoVM.userInfo.city.isEmpty,
//            !userInfoVM.userInfo.zipCode.isEmpty
//        else {
//            throw UserInformationError.blankError
//        }
//        do {
//            try userInfoVM.userInfoFormatterCheckerAsync(id: userInfoVM.userInfo.id,
//                                                           firstName: userInfoVM.userInfo.firstName,
//                                                           lastName: userInfoVM.userInfo.lastName,
//                                                           gender: userInfoVM.userInfo.gender,
//                                                           mobileNumber: userInfoVM.userInfo.mobileNumber, uType: SignUpType(rawValue: firestoreToFetchUserinfo.fetchedUserData.userType) ?? .isNormalCustomer)
//
//
//            try await firestoreToFetchUserinfo.updateUserInfomationAsync(uidPath: firebaseAuth.getUID(), userDM: userInfoVM.userInfo)
//
//
//            try await firestoreForTextingMessage.createAndStoreContactUser(uidPath: firebaseAuth.getUID())
//            isSummit = true
//            try await firestoreToFetchUserinfo.reloadUserData()
//
            //"Notice">>  Haven't update
//            if firestoreToFetchUserinfo.fetchedUserData.providerType == "Furniture Provider" {
//                //MARK: (BUG) Doesn't create store after provider info update
//                try await firestoreForProducts.createStore(uidPath: firebaseAuth.getUID(),
//                                                           provideBy: firebaseAuth.getUID(),
//                                                           providerDisplayName: firestoreToFetchUserinfo.fetchedUserData.displayName,
//                                                           providerProfileImage: firestoreToFetchUserinfo.fetchedUserData.profileImageURL,
//                                                           providerDescription: storeProfileVM.providerDescription, storeChatDocID: firestoreForTextingMessage.senderUIDPath.chatDocId)
//                storeProfileVM.isCreated = true
//            }
//            userInfoVM.isShowUserDetailView = false
//            userInfoVM.isEdit = false
//        } catch {
//            self.errorHandler.handle(error: error)
//        }
//
//    }
    
    func forNormalUser() async throws {
        if !userInfoVM.userInfo.id.isEmpty,
            !userInfoVM.userInfo.firstName.isEmpty,
            !userInfoVM.userInfo.lastName.isEmpty,
            !userInfoVM.userInfo.gender.isEmpty,
            !userInfoVM.userInfo.mobileNumber.isEmpty,
            !userInfoVM.userInfo.address.isEmpty,
            !userInfoVM.userInfo.town.isEmpty,
            !userInfoVM.userInfo.city.isEmpty,
            !userInfoVM.userInfo.zipCode.isEmpty {
            do {
                try userInfoVM.userInfoFormatterCheckerAsync(id: userInfoVM.userInfo.id,
                                                               firstName: userInfoVM.userInfo.firstName,
                                                               lastName: userInfoVM.userInfo.lastName,
                                                               gender: userInfoVM.userInfo.gender,
                                                               mobileNumber: userInfoVM.userInfo.mobileNumber, uType: SignUpType(rawValue: firestoreToFetchUserinfo.fetchedUserData.userType) ?? .isNormalCustomer)
                
                
                try await firestoreToFetchUserinfo.updateUserInfomationAsync(uidPath: firebaseAuth.getUID(), userDM: userInfoVM.userInfo)
                
                try await firestoreForTextingMessage.createAndStoreContactUser(uidPath: firebaseAuth.getUID())
                isSummit = true
                try await firestoreToFetchUserinfo.reloadUserData()
                userInfoVM.isShowUserDetailView = false
                userInfoVM.isEdit = false
            } catch {
                self.errorHandler.handle(error: error)
            }
        } else {
            showAlert = true
        }
    }
    
}
