//
//  ProviderRoomSummitView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ProviderRoomSummitView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var storageForRoomsImage: StorageForRoomsImage
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firestoreForTextingMessage: FirestoreForTextingMessage
    @EnvironmentObject var providerRoomSummitViewModel: ProviderRoomSummitViewModel

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                    .edgesIgnoringSafeArea([.top, .bottom])
                VStack(spacing: 5) {
                    ScrollView(.vertical, showsIndicators: false){
                        TitleAndDivider(title: "Ready to Post your Room?")
                        StepsTitle(stepsName: "Step1: Upload the room pic.")
                        Button {
                            providerRoomSummitViewModel.showSheet.toggle()
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
                                if providerRoomSummitViewModel.isSummitRoomPic == true {
                                    Image(uiImage: self.providerRoomSummitViewModel.image)
                                        .resizable()
                                        .frame(width: 378, height: 304)
                                        .cornerRadius(10)
                                        .scaledToFit()
                                }
                            }
                        }
                        StepsTitle(stepsName: "Step2: Please provide the necessary information")
                        VStack(spacing: 10) {
                            InfoUnit(title: "Holder Name", bindingString: $appViewModel.holderName)
                            InfoUnit(title: "Mobile Number", bindingString: $appViewModel.holderMobileNumber)
                            Group {
                                InfoUnit(title: "Room Address", bindingString: $appViewModel.roomAddress)
                                InfoUnit(title: "Town", bindingString: $appViewModel.roomTown)
                                InfoUnit(title: "City", bindingString: $appViewModel.roomCity)
                                InfoUnit(title: "Zip Code", bindingString: $appViewModel.roomZipCode)
                            }
                            InfoUnit(title: "Room Area", bindingString: $appViewModel.roomArea)
                            InfoUnit(title: "Rental Price", bindingString: $appViewModel.roomRentalPrice)
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text("Additional Room Images")
                                        .modifier(textFormateForProviderSummitView())
                                    Spacer()
                                }
                                .padding(.bottom)
                                Button {
                                    providerRoomSummitViewModel.showPHPicker.toggle()
                                } label: {
                                    ZStack(alignment: .center) {
                                        Rectangle()
                                            .fill(Color("fieldGray"))
                                            .frame(width: uiScreenWidth / 2, height: uiScreenHeight / 6, alignment: .center)
                                            .cornerRadius(10)
                                        Image(systemName: "plus.square")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color.gray)
                                        if providerRoomSummitViewModel.isSelectedRoomSet == true {
                                            Image(uiImage: providerRoomSummitViewModel.presentImage(input: providerRoomSummitViewModel.imageSet))
                                                .resizable()
                                                .frame(width: uiScreenWidth / 2, height: uiScreenHeight / 6, alignment: .center)
                                                .cornerRadius(10)
                                                .scaledToFit()
                                        }
                                        VStack(alignment: .trailing) {
                                            HStack {
                                                Spacer()
                                                Text("\(providerRoomSummitViewModel.imageSet.count)")
                                                    .foregroundColor(.white)
                                                    .padding()
                                                    .frame(width: 50, height: 40, alignment: .center)
                                                    .background {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(Color.black.opacity(0.4))
                                                    }
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .padding()
                            .frame(width: uiScreenWidth - 30)
                            Group {
                                HStack {
                                    Text("Does someone dead in this room before?")
                                    Spacer()
                                }
                                HStack {
                                    Button {
                                        if appViewModel.doesSomeDeadinRoomNo == true {
                                            appViewModel.doesSomeDeadinRoomNo = false
                                        }
                                        if appViewModel.doesSomeDeadinRoomYes == false {
                                            appViewModel.doesSomeDeadinRoomYes = true
                                            appViewModel.someoneDeadinRoom = "Yes"
                                        }
                                    } label: {
                                        Image(systemName: appViewModel.doesSomeDeadinRoomYes ? "checkmark.square.fill" : "checkmark.square")
                                            .foregroundColor(appViewModel.doesSomeDeadinRoomYes ? .green : .white)
                                            .padding(.trailing, 5)
                                        Text("Yes")
                                            .foregroundColor(Color.white)
                                    }
                                    Button {
                                        if appViewModel.doesSomeDeadinRoomYes == true {
                                            appViewModel.doesSomeDeadinRoomYes = false
                                        }
                                        if appViewModel.doesSomeDeadinRoomNo == false {
                                            appViewModel.doesSomeDeadinRoomNo = true
                                            appViewModel.someoneDeadinRoom = "No"
                                        }
                                    } label: {
                                        Image(systemName: appViewModel.doesSomeDeadinRoomNo ? "checkmark.square.fill" : "checkmark.square")
                                            .foregroundColor(appViewModel.doesSomeDeadinRoomNo ? .green : .white)
                                            .padding(.trailing, 5)
                                        Text("No")
                                            .foregroundColor(Color.white)
                                    }
                                    Spacer()
                                }
                            }
                            .modifier(textFormateForProviderSummitView())
                            
                            Group {
                                HStack {
                                    Text("Does the room has water leak problem?")
                                    Spacer()
                                }
                                HStack {
                                    Button {
                                        if appViewModel.hasWaterLeakingNo == true {
                                            appViewModel.hasWaterLeakingNo = false
                                        }
                                        if appViewModel.hasWaterLeakingYes == false {
                                            appViewModel.hasWaterLeakingYes = true
                                            appViewModel.waterLeakingProblem = "Yes"
                                        }
                                    } label: {
                                        Image(systemName: appViewModel.hasWaterLeakingYes ? "checkmark.square.fill" : "checkmark.square")
                                            .foregroundColor(appViewModel.hasWaterLeakingYes ? .green : .white)
                                            .padding(.trailing, 5)
                                        Text("Yes")
                                            .foregroundColor(Color.white)
                                    }
                                    Button {
                                        if appViewModel.hasWaterLeakingYes == true {
                                            appViewModel.hasWaterLeakingYes = false
                                        }
                                        if appViewModel.hasWaterLeakingNo == false {
                                            appViewModel.hasWaterLeakingNo = true
                                            appViewModel.waterLeakingProblem = "No"
                                        }
                                    } label: {
                                        Image(systemName: appViewModel.hasWaterLeakingNo ? "checkmark.square.fill" : "checkmark.square")
                                            .foregroundColor(appViewModel.hasWaterLeakingNo ? .green : .white)
                                            .padding(.trailing, 5)
                                        Text("No")
                                            .foregroundColor(Color.white)
                                    }
                                    Spacer()
                                }
                            }
                            .modifier(textFormateForProviderSummitView())
                        }
                        .padding(.top, 5)
                        .frame(width: 350)
                        StepsTitle(stepsName: "Step3: Please check out the terms of service.")
                        VStack(alignment: .leading) {
                            Spacer()
                            HStack {
                                Button {
                                    providerRoomSummitViewModel.holderTosAgree.toggle()
                                } label: {
                                    Image(systemName: providerRoomSummitViewModel.holderTosAgree ? "checkmark.square.fill" : "checkmark.square")
                                        .foregroundColor(providerRoomSummitViewModel.holderTosAgree ? .green : .white)
                                        .padding(.trailing, 5)
                                }
                                Text("I have read and agree the")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .medium))
                                Text("terms of Service.")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 14, weight: .medium))
                                    .onTapGesture {
                                        providerRoomSummitViewModel.tosSheetShow.toggle()
                                    }
                            }
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            if firestoreToFetchUserinfo.evaluateProviderType() == "Rental Manager" {
                                Button {
                                    Task {
                                        do {
                                            try await checker(holderName: appViewModel.holderName, holderMobileNumber: appViewModel.holderMobileNumber, roomAddress: appViewModel.roomAddress, roomTown: appViewModel.roomTown, roomCity: appViewModel.roomCity, roomZipCode: appViewModel.roomZipCode, roomArea: appViewModel.roomArea, roomRentalPrice: appViewModel.roomRentalPrice, tosAgreement: providerRoomSummitViewModel.holderTosAgree, isSummitRoomImage: providerRoomSummitViewModel.isSummitRoomPic, roomUID: firestoreToFetchRoomsData.roomID, someoneDeadInRoom: appViewModel.someoneDeadinRoom, waterLeakingProblem: appViewModel.waterLeakingProblem, roomImageURL: storageForRoomsImage.representedRoomImageURL, providerDisplayName: appViewModel.displayName)
                                        } catch {
                                            self.errorHandler.handle(error: error)
                                        }
                                    }
                                } label: {
                                    Text("Summit")
                                        .foregroundColor(.white)
                                        .frame(width: 108, height: 35)
                                        .background(Color("buttonBlue"))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .alert("Notice", isPresented: $providerRoomSummitViewModel.showSummitAlert, actions: {
                                            HStack {
                                                Button {
                                                    providerRoomSummitViewModel.showSummitAlert = false
                                                } label: {
                                                    Text("Cancel")
                                                }
                                                Button {
                                                    Task {
                                                        do {
                                                            providerRoomSummitViewModel.showProgressView = true
                                                            try await storageForRoomsImage.uploadRoomCoverImage(uidPath: firebaseAuth.getUID(),
                                                                                                                image: providerRoomSummitViewModel.image,
                                                                                                                roomID: firestoreToFetchRoomsData.roomID,
                                                                                                                imageUID: storageForRoomsImage.imageUUID)
                                                            try await roomSummit(holderName: appViewModel.holderName,
                                                                                 holderMobileNumber: appViewModel.holderMobileNumber,
                                                                                 roomAddress: appViewModel.roomAddress,
                                                                                 roomTown: appViewModel.roomTown,
                                                                                 roomCity: appViewModel.roomCity,
                                                                                 roomZipCode: appViewModel.roomZipCode,
                                                                                 roomArea: appViewModel.roomArea,
                                                                                 roomRentalPrice: appViewModel.roomRentalPrice,
                                                                                 tosAgreement: providerRoomSummitViewModel.holderTosAgree,
                                                                                 isSummitRoomImage: providerRoomSummitViewModel.isSummitRoomPic,
                                                                                 roomUID: firestoreToFetchRoomsData.roomID,
                                                                                 someoneDeadInRoom: appViewModel.someoneDeadinRoom,
                                                                                 waterLeakingProblem: appViewModel.waterLeakingProblem,
                                                                                 roomImageURL: storageForRoomsImage.representedRoomImageURL,
                                                                                 providerDisplayName: appViewModel.displayName)
                                                            
                                                            resetView()
                                                            providerRoomSummitViewModel.showProgressView = false
                                                            providerRoomSummitViewModel.showSummitAlert = false
                                                        } catch {
                                                            self.errorHandler.handle(error: error)
                                                        }
                                                    }
                                                    
                                                } label: {
                                                    Text("Okay")
                                                        .foregroundColor(.white)
                                                        .frame(width: 108, height: 35)
                                                        .background(Color("buttonBlue"))
                                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                                }
                                            }
                                        }, message: {
                                            let message = "Room's Information is waiting to summit, if you want to adjust something, please press cancel, else press okay to continue"
                                            Text(message)
                                        })
                                }
                            }
                        }
                        .padding([.trailing, .top])
                        .frame(width: 400)
                    }
                }
                
            }
            .navigationBarHidden(true)
            .overlay(content: {
                if firestoreToFetchUserinfo.presentUserId().isEmpty {
                    UnregisterCoverView(isShowUserDetailView: $appViewModel.isShowUserDetailView)
                }
                if providerRoomSummitViewModel.showProgressView == true {
                    ProgressView("Uploading please wait...")
                }
            })
            .onAppear(perform: {
                firestoreToFetchRoomsData.roomID = firestoreToFetchRoomsData.roomIdGenerator()
                storageForRoomsImage.imageUUID = storageForRoomsImage.imagUUIDGenerator()
            })
            .sheet(isPresented: $providerRoomSummitViewModel.tosSheetShow, content: {
                TermOfServiceForRentalManager()
            })
            .sheet(isPresented: $providerRoomSummitViewModel.showPHPicker) {
                providerRoomSummitViewModel.isSelectedRoomSet = true
            } content: {
                PHPickerRepresentable(images: self.$providerRoomSummitViewModel.imageSet)
            }
            .sheet(isPresented: $providerRoomSummitViewModel.showSheet) {
                
                providerRoomSummitViewModel.isSummitRoomPic = true
            } content: {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$providerRoomSummitViewModel.image)
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
        .padding([.top, .leading])
    }
}

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

extension ProviderRoomSummitView {
    
    private func roomSummit(holderName: String, holderMobileNumber: String, roomAddress: String, roomTown: String, roomCity: String, roomZipCode: String, roomArea: String, roomRentalPrice: String, tosAgreement: Bool, isSummitRoomImage: Bool, roomUID: String, someoneDeadInRoom: String, waterLeakingProblem: String, roomImageURL: String, providerDisplayName: String) async throws {
        
        let docID = UUID().uuidString
        _ = try await firestoreForTextingMessage.fetchStoredUserData(uidPath: firebaseAuth.getUID())
        try await firestoreToFetchRoomsData.summitRoomInfoAsync(docID: docID, uidPath: firebaseAuth.getUID(), roomUID: roomUID, holderName: holderName, mobileNumber: holderMobileNumber, roomAddress: roomAddress, town: roomTown, city: roomCity, zipCode: roomZipCode, roomArea: roomArea, rentalPrice: roomRentalPrice, someoneDeadInRoom: someoneDeadInRoom, waterLeakingProblem: waterLeakingProblem, roomImageURL: roomImageURL, providerDisplayName: providerDisplayName, providerChatDocId: firestoreForTextingMessage.senderUIDPath.chatDocId)
        if !providerRoomSummitViewModel.imageSet.isEmpty {
            try await storageForRoomsImage.uploadImageSet(uidPath: firebaseAuth.getUID(), images: providerRoomSummitViewModel.imageSet, roomID: roomUID, docID: docID)
        }
    }
    
    private func checker(holderName: String, holderMobileNumber: String, roomAddress: String, roomTown: String, roomCity: String, roomZipCode: String, roomArea: String, roomRentalPrice: String, tosAgreement: Bool, isSummitRoomImage: Bool, roomUID: String, someoneDeadInRoom: String, waterLeakingProblem: String, roomImageURL: String, providerDisplayName: String) async throws {
        try await appViewModel.providerSummitCheckerAsync(holderName: holderName, holderMobileNumber: holderMobileNumber, roomAddress: roomAddress, roomTown: roomTown, roomCity: roomCity, roomZipCode: roomZipCode, roomArea: roomArea, roomRentalPrice: roomRentalPrice, tosAgreement: tosAgreement, isSummitRoomImage: isSummitRoomImage, roomUID: roomUID)
        
        providerRoomSummitViewModel.showSummitAlert = true
    }
    
    private func resetView() {
        appViewModel.holderName = ""
        appViewModel.holderMobileNumber = ""
        appViewModel.roomAddress = ""
        appViewModel.roomTown = ""
        appViewModel.roomCity = ""
        appViewModel.roomArea = ""
        appViewModel.roomRentalPrice = ""
        appViewModel.roomZipCode = ""
        firestoreToFetchRoomsData.roomID = firestoreToFetchRoomsData.roomIdGenerator()
        storageForRoomsImage.imageUUID = storageForRoomsImage.imagUUIDGenerator()
        providerRoomSummitViewModel.isSummitRoomPic = false
        providerRoomSummitViewModel.isSelectedRoomSet = false
        providerRoomSummitViewModel.holderTosAgree = false
        appViewModel.doesSomeDeadinRoomYes = false
        appViewModel.doesSomeDeadinRoomNo = false
        appViewModel.hasWaterLeakingNo = false
        appViewModel.hasWaterLeakingYes = false
        appViewModel.someoneDeadinRoom = ""
        appViewModel.waterLeakingProblem = ""
        providerRoomSummitViewModel.imageSet.removeAll()
    }
}

class ProviderRoomSummitViewModel: ObservableObject {
    @Published var holderTosAgree = false
    @Published var image = UIImage()
    @Published var imageSet = [UIImage]()
    @Published var showSheet = false
    @Published var showPHPicker = false
    @Published var tosSheetShow = false
    @Published var isSummitRoomPic = false
    @Published var isSelectedRoomSet = false
    @Published var showSummitAlert = false
    @Published var showProgressView = false
    
    func presentImage(input: [UIImage]) -> UIImage {
        var image = UIImage()
        if let firstImage = input.first {
            image = firstImage
        }
        return image
    }
}


/*
 
 if firestoreToFetchUserinfo.evaluateProviderType() == "House Owner"{
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
 
 if firestoreToFetchUserinfo.evaluateProviderType() == "House Owner" {
     Group {
         InfoUnit(title: "專有部分建號：", bindingString: $appViewModel.specificBuildingNumber)
         InfoUnit(title: "專有部分權利範圍：", bindingString: $appViewModel.specificBuildingRightRange)
         InfoUnit(title: "專有部分面積共計：", bindingString: $appViewModel.specificBuildingArea)
         InfoUnit(title: "主建物面積幾層幾平方公尺：", bindingString: $appViewModel.mainBuildArea)
         InfoUnit(title: "主建物用途：", bindingString: $appViewModel.mainBuildingPurpose)
         InfoUnit(title: "附屬建物用途：", bindingString: $appViewModel.subBuildingPurpose)
         InfoUnit(title: "附屬建物面積幾平方公尺：", bindingString: $appViewModel.subBuildingArea)
         InfoUnit(title: "共有部分建號：", bindingString: $appViewModel.publicBuildingNumber)
         InfoUnit(title: "共有部分權利範圍：", bindingString: $appViewModel.publicBuildingRightRange)
         InfoUnit(title: "共有部分持分面積幾平方公尺：", bindingString: $appViewModel.publicBuildingArea)
     }
     Group {
         HStack(spacing: 3) {
             Text("車位")
             Button {
                 if appViewModel.hasParkinglotNo == true {
                     appViewModel.hasParkinglotNo = false
                 }
                 if appViewModel.hasParkinglotYes == false {
                     appViewModel.hasParkinglotYes = true
                 }
             } label: {
                 HStack {
                     Image(systemName: appViewModel.hasParkinglotYes ? "checkmark.square.fill" : "checkmark.square")
                         .foregroundColor(appViewModel.hasParkinglotYes ? .green : .white)
                         .padding(.trailing, 5)
                     Text("有")
                 }
             }
             Button {
                 if appViewModel.hasParkinglotYes == true {
                     appViewModel.hasParkinglotYes = false
                 }
                 if appViewModel.hasParkinglotNo == false {
                     appViewModel.hasParkinglotNo = true
                 }
             } label: {
                 HStack {
                     Image(systemName: appViewModel.hasParkinglotNo ? "checkmark.square.fill" : "checkmark.square")
                         .foregroundColor(appViewModel.hasParkinglotNo ? .green : .white)
                         .padding(.trailing, 5)
                     Text("無")
                         .foregroundColor(Color.white)
                 }
             }
             Spacer()
         }
         InfoUnit(title: "汽車/機車車位數量", bindingString: $appViewModel.parkinglotAmount)
         Group {
             HStack(spacing: 3) {
                 Text("設定他項權利")
                     .foregroundColor(Color.white)
                 Button {
                     if appViewModel.isSettingTheRightForThirdPersonNo == true {
                         appViewModel.isSettingTheRightForThirdPersonNo = false
                     }
                     if appViewModel.isSettingTheRightForThirdPersonYes == false {
                         appViewModel.isSettingTheRightForThirdPersonYes = true
                     }
                 } label: {
                     HStack {
                         Image(systemName: appViewModel.isSettingTheRightForThirdPersonYes ? "checkmark.square.fill" : "checkmark.square")
                             .foregroundColor(appViewModel.isSettingTheRightForThirdPersonYes ? .green : .white)
                             .padding(.trailing, 5)
                         Text("有")
                             .foregroundColor(Color.white)
                     }
                 }
                 Button {
                     if appViewModel.isSettingTheRightForThirdPersonYes == true {
                         appViewModel.isSettingTheRightForThirdPersonYes = false
                     }
                     if appViewModel.isSettingTheRightForThirdPersonNo == false {
                         appViewModel.isSettingTheRightForThirdPersonNo = true
                     }
                 } label: {
                     HStack {
                         Image(systemName: appViewModel.isSettingTheRightForThirdPersonNo ? "checkmark.square.fill" : "checkmark.square")
                             .foregroundColor(appViewModel.isSettingTheRightForThirdPersonNo ? .green : .white)
                             .padding(.trailing, 5)
                         Text("無")
                             .foregroundColor(Color.white)
                     }
                 }
                 Spacer()
             }
         }
         InfoUnit(title: "權利種類:", bindingString: $appViewModel.SettingTheRightForThirdPersonForWhatKind)
         Group {
             HStack(spacing: 3) {
                 Text("查封登記")
                     .foregroundColor(Color.white)
                 Button {
                     if appViewModel.isBlockByBankNo == true {
                         appViewModel.isBlockByBankNo = false
                     }
                     if appViewModel.isBlockByBankYes == false {
                         appViewModel.isBlockByBankYes = true
                     }
                 } label: {
                     HStack {
                         Image(systemName: appViewModel.isBlockByBankYes ? "checkmark.square.fill" : "checkmark.square")
                             .foregroundColor(appViewModel.isBlockByBankYes ? .green : .white)
                             .padding(.trailing, 5)
                         Text("有")
                             .foregroundColor(Color.white)
                     }
                 }
                 Button {
                     if appViewModel.isBlockByBankYes == true {
                         appViewModel.isBlockByBankYes = false
                     }
                     if appViewModel.isBlockByBankNo == false {
                         appViewModel.isBlockByBankNo = true
                     }
                 } label: {
                     HStack {
                         Image(systemName: appViewModel.isBlockByBankNo ? "checkmark.square.fill" : "checkmark.square")
                             .foregroundColor(appViewModel.isBlockByBankNo ? .green : .white)
                             .padding(.trailing, 5)
                         Text("無")
                             .foregroundColor(Color.white)
                     }
                 }
                 Spacer()
             }
         }
     }
     .modifier(textFormateForProviderSummitView())
     Group {
         HStack(spacing: 3) {
             Text("租賃住宅管理範圍")
                 .foregroundColor(Color.white)
                 .font(.system(size: 14, weight: .semibold))
             Button {
                 if appViewModel.provideForPart == true {
                     appViewModel.provideForPart = false
                 }
                 if appViewModel.provideForAll == false {
                     appViewModel.provideForAll = true
                 }
             } label: {
                 HStack {
                     Image(systemName: appViewModel.provideForAll ? "checkmark.square.fill" : "checkmark.square")
                         .foregroundColor(appViewModel.provideForAll ? .green : .white)
                         .padding(.trailing, 5)
                     Text("全部")
                         .foregroundColor(Color.white)
                 }
             }
             Button {
                 if appViewModel.provideForAll == true {
                     appViewModel.provideForAll = false
                 }
                 if appViewModel.provideForPart == false {
                     appViewModel.provideForPart = true
                 }
             } label: {
                 HStack {
                     Image(systemName: appViewModel.provideForPart ? "checkmark.square.fill" : "checkmark.square")
                         .foregroundColor(appViewModel.provideForPart ? .green : .white)
                         .padding(.trailing, 5)
                     Text("部分")
                         .foregroundColor(Color.white)
                 }
             }
             Spacer()
         }
         InfoUnit(title: "租賃住宅第幾層", bindingString: $appViewModel.provideFloor)
         InfoUnit(title: "租賃住宅房間數", bindingString: $appViewModel.provideRooms)
         InfoUnit(title: "租賃住宅第幾室", bindingString: $appViewModel.provideRoomNumber)
         InfoUnit(title: "租賃住宅面積幾平方公尺", bindingString: $appViewModel.provideRoomArea)
     }
     .modifier(textFormateForProviderSummitView())
     
     if appViewModel.hasParkinglotYes == true && appViewModel.hasParkinglotNo == false {
         Group {
             HStack(spacing: 3) {
                 Text("車位")
                     .foregroundColor(Color.white)
                 Button {
                     if appViewModel.isBoth == true || appViewModel.isMorto == true {
                         appViewModel.isBoth = false
                         appViewModel.isMorto = false
                     }
                     if appViewModel.isVehicle == false {
                         appViewModel.isVehicle = true
                     }
                 } label: {
                     HStack {
                         Image(systemName: appViewModel.isVehicle ? "checkmark.square.fill" : "checkmark.square")
                             .foregroundColor(appViewModel.isVehicle ? .green : .white)
                             .padding(.trailing, 5)
                         Text("汽車")
                             .foregroundColor(Color.white)
                     }
                 }
                 Button {
                     if appViewModel.isVehicle == true || appViewModel.isBoth == true {
                         appViewModel.isVehicle = false
                         appViewModel.isBoth = false
                     }
                     if appViewModel.isMorto == false {
                         appViewModel.isMorto = true
                     }
                 } label: {
                     HStack {
                         Image(systemName: appViewModel.isMorto ? "checkmark.square.fill" : "checkmark.square")
                             .foregroundColor(appViewModel.isMorto ? .green : .white)
                             .padding(.trailing, 5)
                         Text("機車")
                             .foregroundColor(Color.white)
                     }
                 }
                 Button {
                     if appViewModel.isVehicle == true || appViewModel.isMorto == true {
                         appViewModel.isVehicle = false
                         appViewModel.isMorto = false
                     }
                     if appViewModel.isBoth == false {
                         appViewModel.isBoth = true
                     }
                 } label: {
                     HStack {
                         Image(systemName: appViewModel.isBoth ? "checkmark.square.fill" : "checkmark.square")
                             .foregroundColor(appViewModel.isBoth ? .green : .white)
                             .padding(.trailing, 5)
                         Text("兩者皆有")
                             .foregroundColor(Color.white)
                     }
                 }
                 Spacer()
             }
             InfoUnit(title: "地上(下)第幾層", bindingString: $appViewModel.parkingUGFloor)
             HStack(spacing: 3) {
                 Text("車位類型")
                     .foregroundColor(Color.white)
                 Button {
                     if appViewModel.parkingStyleM == true {
                         appViewModel.parkingStyleM = false
                     }
                     if appViewModel.parkingStyleN == false {
                         appViewModel.parkingStyleN = true
                     }
                 } label: {
                     HStack {
                         Image(systemName: appViewModel.parkingStyleN ? "checkmark.square.fill" : "checkmark.square")
                             .foregroundColor(appViewModel.parkingStyleN ? .green : .white)
                             .padding(.trailing, 5)
                         Text("平面式")
                             .foregroundColor(Color.white)
                     }
                 }
                 Button {
                     if appViewModel.parkingStyleN == true {
                         appViewModel.parkingStyleN = false
                     }
                     if appViewModel.parkingStyleM == false {
                         appViewModel.parkingStyleM = true
                     }
                 } label: {
                     HStack {
                         Image(systemName: appViewModel.parkingStyleM ? "checkmark.square.fill" : "checkmark.square")
                             .foregroundColor(appViewModel.parkingStyleM ? .green : .white)
                             .padding(.trailing, 5)
                         Text("機械式")
                             .foregroundColor(Color.white)
                     }
                 }
                 Spacer()
             }
             InfoUnit(title: "編號第幾號", bindingString: $appViewModel.parkingNumber)
             HStack(spacing: 3) {
                 Text("使用時間")
                     .foregroundColor(Color.white)
                 Button {
                     if appViewModel.forMorning == true || appViewModel.forNight == true {
                         appViewModel.forMorning = false
                         appViewModel.forNight = false
                     }
                     if appViewModel.forAllday == false {
                         appViewModel.forAllday = true
                     }
                 } label: {
                     HStack {
                         Image(systemName: appViewModel.forAllday ? "checkmark.square.fill" : "checkmark.square")
                             .foregroundColor(appViewModel.forAllday ? .green : .white)
                             .padding(.trailing, 5)
                         Text("全日")
                             .foregroundColor(Color.white)
                     }
                 }
                 Button {
                     if appViewModel.forAllday == true || appViewModel.forNight == true {
                         appViewModel.forAllday = false
                         appViewModel.forNight = false
                     }
                     if appViewModel.forMorning == false {
                         appViewModel.forMorning = true
                     }
                 } label: {
                     HStack {
                         Image(systemName: appViewModel.forMorning ? "checkmark.square.fill" : "checkmark.square")
                             .foregroundColor(appViewModel.forMorning ? .green : .white)
                             .padding(.trailing, 5)
                         Text("日間")
                             .foregroundColor(Color.white)
                     }
                 }
                 Button {
                     if appViewModel.forMorning == true || appViewModel.forAllday == true {
                         appViewModel.forMorning = false
                         appViewModel.forAllday = false
                     }
                     if appViewModel.forNight == false {
                         appViewModel.forNight = true
                     }
                 } label: {
                     HStack {
                         Image(systemName: appViewModel.forNight ? "checkmark.square.fill" : "checkmark.square")
                             .foregroundColor(appViewModel.forNight ? .green : .white)
                             .padding(.trailing, 5)
                         Text("夜間")
                             .foregroundColor(Color.white)
                     }
                 }
                 Spacer()
             }
         }
         .modifier(textFormateForProviderSummitView())
     }
     
     Group {
         HStack(spacing: 3) {
             Text("租賃附屬設備")
                 .foregroundColor(Color.white)
             Button {
                 if appViewModel.havingSubFacilityNo == true {
                     appViewModel.havingSubFacilityNo = false
                 }
                 if appViewModel.havingSubFacilityYes == false {
                     appViewModel.havingSubFacilityYes = true
                 }
             } label: {
                 HStack {
                     Image(systemName: appViewModel.havingSubFacilityYes ? "checkmark.square.fill" : "checkmark.square")
                         .foregroundColor(appViewModel.havingSubFacilityYes ? .green : .white)
                         .padding(.trailing, 5)
                     Text("有")
                         .foregroundColor(Color.white)
                 }
             }
             Button {
                 if appViewModel.havingSubFacilityYes == true {
                     appViewModel.havingSubFacilityYes = false
                 }
                 if appViewModel.havingSubFacilityNo == false {
                     appViewModel.havingSubFacilityNo = true
                 }
             } label: {
                 HStack {
                     Image(systemName: appViewModel.havingSubFacilityNo ? "checkmark.square.fill" : "checkmark.square")
                         .foregroundColor(appViewModel.havingSubFacilityNo ? .green : .white)
                         .padding(.trailing, 5)
                     Text("無")
                         .foregroundColor(Color.white)
                 }
             }
             Spacer()
         }
         InfoUnit(title: "委託管理期間自", bindingString: $appViewModel.providingTimeRangeStart)
         InfoUnit(title: "委託管理期間至", bindingString: $appViewModel.providingTimeRangeEnd)
     }
     .modifier(textFormateForProviderSummitView())
     Group {
         HStack(spacing: 3) {
             Text("報酬給付方式")
                 .foregroundColor(Color.white)
             Button {
                 if appViewModel.paybyTransmission == true {
                     appViewModel.paybyTransmission = false
                 }
                 if appViewModel.paybyCash == false {
                     appViewModel.paybyCash = true
                 }
             } label: {
                 HStack {
                     Image(systemName: appViewModel.paybyCash ? "checkmark.square.fill" : "checkmark.square")
                         .foregroundColor(appViewModel.paybyCash ? .green : .white)
                         .padding(.trailing, 5)
                     Text("現金繳付")
                         .foregroundColor(Color.white)
                 }
             }
             Button {
                 if appViewModel.paybyCash == true {
                     appViewModel.paybyCash = false
                 }
                 if appViewModel.paybyTransmission == false {
                     appViewModel.paybyTransmission = true
                 }
             } label: {
                 HStack {
                     Image(systemName: appViewModel.paybyTransmission ? "checkmark.square.fill" : "checkmark.square")
                         .foregroundColor(appViewModel.paybyTransmission ? .green : .white)
                         .padding(.trailing, 5)
                     Text("轉帳繳付")
                         .foregroundColor(Color.white)
                 }
             }
             Spacer()
         }
         InfoUnit(title: "金融機構", bindingString: $appViewModel.bankName)
         InfoUnit(title: "戶名", bindingString: $appViewModel.bankOwnerName)
         InfoUnit(title: "帳號", bindingString: $appViewModel.bankAccount)
     }
     .modifier(textFormateForProviderSummitView())
     Group {
         HStack {
             Text("履行本契約之通知")
                 .foregroundColor(Color.white)
             Spacer()
         }
         HStack(spacing: 3) {
             Button {
                 if appViewModel.contractSendbyTextingMessage == true || appViewModel.contractSendbyMessageSoftware == true {
                     appViewModel.contractSendbyTextingMessage = false
                     appViewModel.contractSendbyMessageSoftware = false
                 }
                 if appViewModel.contractSendbyEmail == false {
                     appViewModel.contractSendbyEmail = true
                 }
             } label: {
                 HStack {
                     Image(systemName: appViewModel.contractSendbyEmail ? "checkmark.square.fill" : "checkmark.square")
                         .foregroundColor(appViewModel.contractSendbyEmail ? .green : .white)
                         .padding(.trailing, 5)
                     Text("電子郵件信箱")
                         .foregroundColor(Color.white)
                 }
             }
             Button {
                 if appViewModel.contractSendbyEmail == true || appViewModel.contractSendbyMessageSoftware == true {
                     appViewModel.contractSendbyEmail = false
                     appViewModel.contractSendbyMessageSoftware = false
                 }
                 if appViewModel.contractSendbyTextingMessage == false {
                     appViewModel.contractSendbyTextingMessage = true
                 }
             } label: {
                 HStack {
                     Image(systemName: appViewModel.contractSendbyTextingMessage ? "checkmark.square.fill" : "checkmark.square")
                         .foregroundColor(appViewModel.contractSendbyTextingMessage ? .green : .white)
                         .padding(.trailing, 5)
                     Text("手機簡訊")
                         .foregroundColor(Color.white)
                 }
             }
             Button {
                 if appViewModel.contractSendbyTextingMessage == true || appViewModel.contractSendbyEmail == true {
                     appViewModel.contractSendbyTextingMessage = false
                     appViewModel.contractSendbyEmail = false
                 }
                 if appViewModel.contractSendbyMessageSoftware == false {
                     appViewModel.contractSendbyMessageSoftware = true
                 }
             } label: {
                 HStack {
                     Image(systemName: appViewModel.contractSendbyMessageSoftware ? "checkmark.square.fill" : "checkmark.square")
                         .foregroundColor(appViewModel.contractSendbyMessageSoftware ? .green : .white)
                         .padding(.trailing, 5)
                     Text("即時通訊軟體")
                         .foregroundColor(Color.white)
                 }
             }
             Spacer()
         }
     }
     .modifier(textFormateForProviderSummitView())
 }
*/
