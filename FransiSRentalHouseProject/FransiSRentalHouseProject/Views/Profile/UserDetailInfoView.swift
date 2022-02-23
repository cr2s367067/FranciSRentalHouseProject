//
//  UserDetailInfoView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct UserDetailInfoView: View {
    
    @EnvironmentObject var fetchFirestore: FetchFirestore
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State var id = ""
    @State var firstName = ""
    @State var lastName = ""
    @State var mobileNumber = ""
    @State var dob = Date()
    @State var address = ""
    @State var town = ""
    @State var city = ""
    @State var zip = ""
    @State var country = ""
    @State var gender = ""
    @State var isMale = false
    @State var isFemale = false
    @State var showAlert = false
    @State var inforFormatterCorrect = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("backgroundBrown"))
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        TitleAndDivider(title: "User Detail Information")
                        VStack(alignment: .leading, spacing: 10) {
                            Group {
                                InfoUnit(title: "ID", bindingString: $id)
                                InfoUnit(title: "First Name", bindingString: $firstName)
                                InfoUnit(title: "Last Name", bindingString: $lastName)
                                Text("Gender")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .semibold))
                                
                                HStack {
                                    Button {
                                        isMale.toggle()
                                        if isMale == true {
                                            gender = "Male"
                                            debugPrint(gender)
                                        }
                                        if isFemale == true {
                                            isFemale = false
                                        }
                                    } label: {
                                        HStack {
                                            Text("Male")
                                                .foregroundColor(isMale ? .white : .gray)
                                            Image(systemName: isMale ? "checkmark.circle.fill" : "checkmark.circle")
                                                .foregroundColor(isMale ? .green : .gray)
                                                .padding(.leading, 10)
                                            
                                        }
                                        .frame(width: 140, height: 20)
                                        .background(Color("fieldGray").opacity(0.07))
                                        .cornerRadius(5)
                                    }
                                    Spacer()
                                        .frame(width: 50)
                                    Button {
                                        isFemale.toggle()
                                        if isFemale == true {
                                            gender = "Female"
                                            debugPrint(gender)
                                        }
                                        if isMale == true {
                                            isMale = false
                                        }
                                    } label: {
                                        HStack {
                                            Text("Female")
                                                .foregroundColor(isFemale ? .white : .gray)
                                            Image(systemName: isFemale ? "checkmark.circle.fill" : "checkmark.circle")
                                                .foregroundColor(isFemale ? .green : .gray)
                                                .padding(.leading, 10)
                                        }
                                        .frame(width: 140, height: 20)
                                        .background(Color("fieldGray").opacity(0.07))
                                        .cornerRadius(5)
                                    }
                                }
                            }
                            Group {
                                InfoUnit(title: "Mobile Number", bindingString: $mobileNumber)
                                    .keyboardType(.decimalPad)
                                DatePicker("Date of Birth", selection: $dob, in: ...Date(), displayedComponents: .date)
                                    .background(Color("fieldGray"))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                //InfoUnit(title: "Date of Birth", bindingString: $dob)
                                InfoUnit(title: "Address", bindingString: $address)
                                InfoUnit(title: "Town", bindingString: $town) //: Picker
                                InfoUnit(title: "City", bindingString: $city) //: Picker
                                InfoUnit(title: "Zip", bindingString: $zip)
                                InfoUnit(title: "Country", bindingString: $country) //: Picker
                            }
                        }
                        .padding(.leading)
                        .frame(width: 330)
                        Spacer()
                        HStack {
                            Spacer()
                                .frame(width: 240)
                                .padding(.top)
                            Button {
                                if !id.isEmpty, !firstName.isEmpty, !lastName.isEmpty, !gender.isEmpty, !mobileNumber.isEmpty, !address.isEmpty, !town.isEmpty, !city.isEmpty, !zip.isEmpty, !country.isEmpty == true {
                                    do {
                                        try appViewModel.userInfoFormatterChecker(id: id, firstName: firstName, lastName: lastName, gender: gender, mobileNumber: mobileNumber)
                                        fetchFirestore.updateUserInformation(uidPath: fetchFirestore.getUID(), id: id, firstName: firstName, lastName: lastName, PhoneNumber: mobileNumber, dob: dob, address: address, town: town, city: city, zip: zip, country: country, gender: gender, userType: appViewModel.userType)
                                        debugPrint(UserDataModel(id: id, firstName: firstName, lastName: lastName, phoneNumber: mobileNumber, dob: dob, address: address, town: town, city: city, zip: zip, country: country, gender: gender, userType: appViewModel.userType))
                                    } catch {
                                        self.errorHandler.handle(error: error)
                                    }
                                } else {
                                    showAlert = true
                                }
                                //                                debugPrint(fetchFirestore.getUserType(input: fetchFirestore.fetchData))
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
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct UserDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailInfoView()
    }
}
