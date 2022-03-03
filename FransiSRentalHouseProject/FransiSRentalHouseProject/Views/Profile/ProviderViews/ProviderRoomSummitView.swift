//
//  ProviderRoomSummitView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ProviderRoomSummitView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    //    @EnvironmentObject var firebaseStorageDM: FirebaseStorage
    //    @EnvironmentObject var fetchFirestore: FetchFirestore
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firebaseStorageInGeneral: FirebaseStorageInGeneral
    @EnvironmentObject var storageForRoomsImage: StorageForRoomsImage
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    
    //    let firebaseMg = FirebaseManager()
    
    @State var holderName = ""
    @State var holderMobileNumber = ""
    @State var holderEmailAddress = ""
    @State var roomAddress = ""
    @State var town = ""
    @State var city = ""
    @State var zipCode = ""
    @State var roomArea = ""
    @State var rentalPrice = ""
    @State private var holderTosAgree = false
    @State var image = UIImage()
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(Color("backgroundBrown"))
                    .edgesIgnoringSafeArea([.top, .bottom])
                VStack(spacing: 5) {
                    ScrollView(.vertical, showsIndicators: false){
                        TitleAndDivider(title: "Ready to Post your Room?")
                        StepsTitle(stepsName: "Step1: Upload the room pic.")
                        Button {
                            showSheet.toggle()
                        } label: {
                            ZStack(alignment: .center) {
                                Rectangle()
                                    .fill(Color("fieldGray"))
                                    .frame(width: 378, height: 304)
                                    .cornerRadius(10)
                                Image(systemName: "plus.square")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.gray)
                            }
                        }
                        StepsTitle(stepsName: "Step2: Please provide the necessary information")
                        VStack(spacing: 10) {
                            InfoUnit(title: "Holder Name", bindingString: $holderName)
                            InfoUnit(title: "Mobile Number", bindingString: $holderMobileNumber)
                            Group {
                                InfoUnit(title: "Room Address", bindingString: $roomAddress)
                                InfoUnit(title: "Town", bindingString: $town)
                                InfoUnit(title: "City", bindingString: $city)
                                InfoUnit(title: "Zip Code", bindingString: $zipCode)
                            }
                            InfoUnit(title: "Email Address", bindingString: $holderEmailAddress)
                            InfoUnit(title: "Room Area", bindingString: $roomArea)
                            InfoUnit(title: "Rental Price", bindingString: $rentalPrice)
                            
                        }
                        .padding(.top, 5)
                        .frame(width: 350)
                        StepsTitle(stepsName: "Step3: Please check out the terms of service.")
                        VStack(alignment: .leading) {
                            Spacer()
                            HStack {
                                Button {
                                    holderTosAgree.toggle()
                                } label: {
                                    Image(systemName: holderTosAgree ? "checkmark.square.fill" : "checkmark.square")
                                        .foregroundColor(holderTosAgree ? .green : .white)
                                        .padding(.trailing, 5)
                                }
                                Text("I have read and agree the terms of Service.")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .medium))
                            }
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            NavigationLink {
                                ProviderSummittedRoomContractView()
                            } label: {
                                Text("Next")
                                    .foregroundColor(.white)
                                    .frame(width: 108, height: 35)
                                    .background(Color("buttonBlue"))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                        }
                        .padding(.trailing)
                        .frame(width: 400)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear(perform: {
                firebaseStorageInGeneral.imageUIDHolder = firebaseStorageInGeneral.imgUIDGenerator()
            })
            .sheet(isPresented: $showSheet) {
                if !image.isSymbolImage {
                    storageForRoomsImage.uploadRoomImage(uidPath: firebaseAuth.getUID(), image: image)
                    
                }
            } content: {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
        }
    }
}

struct StepsTitle: View {
    var stepsName = ""
    var body: some View {
        HStack {
            Text(stepsName)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.leading)
    }
}

struct ProviderRoomSummitView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderRoomSummitView()
    }
}


//Button {
//    localData.addRoomDataToArray(holderName: holderName, mobileNumber: holderMobileNumber, roomAddress: roomAddress, town: town, city: city, zipCode: zipCode, emailAddress: holderEmailAddress, roomArea: roomArea, rentalPrice: rentalPrice)
//    print("\(localData.localRoomsHolder)")
//} label: {
//    Text("Next")
//        .foregroundColor(.white)
//        .frame(width: 108, height: 35)
//        .background(Color("buttonBlue"))
//        .clipShape(RoundedRectangle(cornerRadius: 5))
//}
