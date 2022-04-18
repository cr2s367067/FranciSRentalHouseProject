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
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        TitleAndDivider(title: "User Detail Information")
                        VStack(alignment: .leading, spacing: 10) {
                            isEditMode(isEdit: userDetailInfoViewModel.isEdit)
                        }
                        .padding()
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
                            summitButton(isEdit: userDetailInfoViewModel.isEdit)
                        }
                    }
                }
            }
        }
        .onTapGesture(perform: {
            isFocused = false
        })
        .onAppear(perform: {
            if firestoreToFetchUserinfo.presentUserId().isEmpty {
                userDetailInfoViewModel.isEdit = true
            }
            appViewModel.updateNavigationBarColor()
//            reset()
        })
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
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
                Text(title)
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
    func userInfoPresenting(source: UserDataModel) -> some View {
        userInfoUnit(title: "ID", presentString: source.id)
        userInfoUnit(title: "First Name", presentString: source.firstName)
        userInfoUnit(title: "Last Name", presentString: source.lastName)
        userInfoUnit(title: "Display Name", presentString: source.displayName)
        userInfoUnit(title: "Mobile Number", presentString: source.mobileNumber)
        userInfoUnit(title: "Date of Birth", presentString: source.dob.formatted(Date.FormatStyle().year().month().day()))
        Group {
            userInfoUnit(title: "Address", presentString: source.address)
            userInfoUnit(title: "Town", presentString: source.town)
            userInfoUnit(title: "City", presentString: source.city)
            userInfoUnit(title: "Zip Code", presentString: source.zip)
            userInfoUnit(title: "Country", presentString: source.country)
        }
    }
    
    @ViewBuilder
    func isEditMode(isEdit: Bool) -> some View {
        
        if isEdit == false {
            userInfoPresenting(source: firestoreToFetchUserinfo.fetchedUserData)
        } else {
            Group {
                Group {
                InfoUnit(title: "ID", bindingString: $appViewModel.id)
                InfoUnit(title: "First Name", bindingString: $appViewModel.firstName)
                InfoUnit(title: "Last Name", bindingString: $appViewModel.lastName)
                InfoUnit(title: "Display Name", bindingString: $appViewModel.displayName)
                        .onTapGesture {
                            appViewModel.displayName = ""
                        }
                Group {
                    Text("Gender")
                        .foregroundColor(.white)
                        .font(.system(size: 13, weight: .semibold))
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
                Group {
                InfoUnit(title: "Mobile Number", bindingString: $appViewModel.mobileNumber)
                    .keyboardType(.decimalPad)
                DatePicker("Date of Birth", selection: $appViewModel.dob, in: ...Date(), displayedComponents: .date)
                    .foregroundColor(.white)
                    .background(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                //InfoUnit(title: "Date of Birth", bindingString: $dob)
                InfoUnit(title: "Address", bindingString: $appViewModel.address)
                InfoUnit(title: "Town", bindingString: $appViewModel.town)
                InfoUnit(title: "City", bindingString: $appViewModel.city) //: Picker
                InfoUnit(title: "Zip Code", bindingString: $appViewModel.zipCode)
                InfoUnit(title: "Country", bindingString: $appViewModel.country) //: Picker
            }
            }
            .focused($isFocused)
        }
    }
    
    @ViewBuilder
    func summitButton(isEdit: Bool) -> some View {
        if isEdit == true {
            Button {
                Task {
                    if !appViewModel.id.isEmpty, !appViewModel.firstName.isEmpty, !appViewModel.lastName.isEmpty, !appViewModel.gender.isEmpty, !appViewModel.mobileNumber.isEmpty, !appViewModel.address.isEmpty, !appViewModel.town.isEmpty, !appViewModel.city.isEmpty, !appViewModel.zipCode.isEmpty, !appViewModel.country.isEmpty == true {
                        do {
                            try appViewModel.userInfoFormatterCheckerAsync(id: appViewModel.id,
                                                                           firstName: appViewModel.firstName,
                                                                           lastName: appViewModel.lastName,
                                                                           gender: appViewModel.gender,
                                                                           mobileNumber: appViewModel.mobileNumber)
                            
                            
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
}



class UserDetailInfoViewModel: ObservableObject {
    @Published var isEdit = false
}
