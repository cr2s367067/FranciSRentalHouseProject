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
    
//    let persistenceDM = PersistenceController()
    
//    @State var id = ""
//    @State var firstName = ""
//    @State var lastName = ""
//    @State var mobileNumber = ""
//    @State var dob = Date()
//    @State var address = ""
//    @State var town = ""
//    @State var city = ""
//    @State var zip = ""
//    @State var country = ""
//    @State var gender = ""
    @State var isMale = false
    @State var isFemale = false
    @State var showAlert = false
    @State var inforFormatterCorrect = false
    @State private var isSummit = false
    @State private var selection = "House Owner"
    
    private func reset() {
        appViewModel.userDetailViewReset()
        isMale = false
        isFemale = false
    }
    
//    private var providerType = ["House Owner", "Rental Manager"]
    
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
//                            if appViewModel.isProvider == true {
//                                Picker("Hi, would you tell us who you are?", selection: $selection) {
//                                    ForEach(providerType, id: \.self) {
//                                        Text($0)
//                                    }
//                                }
//                                .pickerStyle(.segmented)
//                            }
                            Group {
                                InfoUnit(title: "ID", bindingString: $appViewModel.id)
                                InfoUnit(title: "First Name", bindingString: $appViewModel.firstName)
                                InfoUnit(title: "Last Name", bindingString: $appViewModel.lastName)
                                InfoUnit(title: "Display Name", bindingString: $appViewModel.displayName)
//                                if selection == "Rental Manager" {
//                                    InfoUnit(title: "Rental Manager License Number", bindingString: $appViewModel.rentalManagerLicenseNumber)
//                                    VStack(alignment: .leading, spacing: 2) {
//                                        Text("Email Address")
//                                            .foregroundColor(.white)
//                                            .font(.system(size: 14, weight: .semibold))
//                                        Text(appViewModel.emailAddress)
//                                            .frame(width: 200, height: 30)
//                                            .background(Color("fieldGray"))
//                                            .cornerRadius(5)
//                                    }
//                                }
                                Group {
                                    Text("Gender")
                                        .foregroundColor(.white)
                                        .font(.system(size: 13, weight: .semibold))
                                    HStack(alignment: .center, spacing: 30) {
                                        Spacer()
                                        Button {
                                            isMale.toggle()
                                            if isMale == true {
                                                appViewModel.gender = "Male"
                                                debugPrint(appViewModel.gender)
                                            }
                                            if isFemale == true {
                                                isFemale = false
                                            }
                                        } label: {
                                            HStack {
                                                Text("Male")
                                                    .foregroundColor(isMale ? .white : .white)
                                                Image(systemName: isMale ? "checkmark.circle.fill" : "checkmark.circle")
                                                    .foregroundColor(isMale ? .green : .white)
                                                    .padding(.leading, 10)
                                                
                                            }
                                            .frame(width: 140, height: 30)
                                            .background(Color("fieldGray").opacity(0.07))
                                            .cornerRadius(5)
                                        }
                                        Button {
                                            isFemale.toggle()
                                            if isFemale == true {
                                                appViewModel.gender = "Female"
                                                debugPrint(appViewModel.gender)
                                            }
                                            if isMale == true {
                                                isMale = false
                                            }
                                        } label: {
                                            HStack {
                                                Text("Female")
                                                    .foregroundColor(isFemale ? .white : .white)
                                                Image(systemName: isFemale ? "checkmark.circle.fill" : "checkmark.circle")
                                                    .foregroundColor(isFemale ? .green : .white)
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
                                InfoUnit(title: "Zip", bindingString: $appViewModel.zipCode)
                                InfoUnit(title: "Country", bindingString: $appViewModel.country) //: Picker
                            }
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
            }
        }
        .onAppear(perform: {
            appViewModel.updateNavigationBarColor()
            reset()
        })
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct UserDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailInfoView()
    }
}
