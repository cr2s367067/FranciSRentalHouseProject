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
    @Environment(\.colorScheme) var colorScheme

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    @FocusState private var isFocus: Bool
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
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
                                .frame(width: uiScreenWidth - 30, height: 304)
                                .cornerRadius(10)
                            Image(systemName: "plus.square")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color.gray)
                            if providerRoomSummitViewModel.isSummitRoomPic == true {
                                Image(uiImage: self.providerRoomSummitViewModel.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: uiScreenWidth - 30, height: 304)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .accessibilityIdentifier("coverImage")
                    StepsTitle(stepsName: "Step2: Please provide the necessary information")
                    VStack(spacing: 10) {
                        Group {
                            InfoUnit(title: "Holder Name", bindingString: $appViewModel.holderName)
                            InfoUnit(title: "Mobile Number", bindingString: $appViewModel.holderMobileNumber)
                            Group {
                                InfoUnit(title: "Room Address", bindingString: $appViewModel.roomAddress)
                                    .accessibilityIdentifier("roomAddress")
                                InfoUnit(title: "Town", bindingString: $appViewModel.roomTown)
                                    .accessibilityIdentifier("town")
                                InfoUnit(title: "City", bindingString: $appViewModel.roomCity)
                                    .accessibilityIdentifier("city")
                                InfoUnit(title: "Zip Code", bindingString: $appViewModel.roomZipCode)
                                    .accessibilityIdentifier("zipcode")
                            }
                            InfoUnit(title: "Room Area", bindingString: $appViewModel.roomArea)
                                .accessibilityIdentifier("roomArea")
                            InfoUnit(title: "Rental Price", bindingString: $appViewModel.roomRentalPrice)
                                .accessibilityIdentifier("rentalPrice")
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text("Room Description")
                                        .modifier(textFormateForProviderSummitView())
                                    Spacer()
                                }
                                TextEditor(text: $appViewModel.roomDescription)
                                    .foregroundStyle(Color.white)
                                    .frame(height: 300, alignment: .center)
                                    .cornerRadius(5)
                                    .background(Color.clear)
                                    .accessibilityIdentifier("roomDes")
                            }
                            .padding()
                            .frame(width: uiScreenWidth - 30)
                            .background(alignment: .center, content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 1)
                            })
                        }
                        .focused($isFocus)
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
                                            .aspectRatio(contentMode: .fit)
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
                                                        .fill(colorScheme == .dark ? .gray.opacity(0.5) : Color.black.opacity(0.4))
                                                }
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            .accessibilityIdentifier("addtionalPh")
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
                                .accessibilityIdentifier("no1")
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
                                .accessibilityIdentifier("no2")
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
                            .accessibilityIdentifier("tosAgree")
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
                                                                         providerDisplayName: appViewModel.displayName, roomDescription: appViewModel.roomDescription)
                                                    
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
                                        .accessibilityIdentifier("okay")
                                    }
                                }, message: {
                                    let message = "Room's Information is waiting to summit, if you want to adjust something, please press cancel, else press okay to continue"
                                    Text(message)
                                })
                        }
                        .accessibilityIdentifier("summit")
                    }
                    .padding([.trailing, .top])
                    .frame(width: 400)
                }
                .disabled(providerRoomSummitViewModel.showProgressView ? true : false)
            }
            .modifier(ViewBackgroundInitModifier())
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isFocus = false
                    }
                }
            }
            .navigationBarHidden(true)
            .overlay(content: {
                if firestoreToFetchUserinfo.presentUserId().isEmpty {
                    UnregisterCoverView(isShowUserDetailView: $appViewModel.isShowUserDetailView)
                }
                if providerRoomSummitViewModel.showProgressView == true {
                    CustomProgressView()
                }
            })
            .onAppear(perform: {
                firestoreToFetchRoomsData.roomID = firestoreToFetchRoomsData.roomIdGenerator()
                storageForRoomsImage.imageUUID = storageForRoomsImage.imagUUIDGenerator()
                appViewModel.holderMobileNumber = firestoreToFetchUserinfo.fetchedUserData.mobileNumber
                appViewModel.holderName = firestoreToFetchUserinfo.fetchedUserData.lastName + firestoreToFetchUserinfo.fetchedUserData.firstName
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
            Text(LocalizedStringKey(stepsName))
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
    
    private func roomSummit(holderName: String, holderMobileNumber: String, roomAddress: String, roomTown: String, roomCity: String, roomZipCode: String, roomArea: String, roomRentalPrice: String, tosAgreement: Bool, isSummitRoomImage: Bool, roomUID: String, someoneDeadInRoom: String, waterLeakingProblem: String, roomImageURL: String, providerDisplayName: String, roomDescription: String) async throws {
        
        let docID = UUID().uuidString
//        _ = try await firestoreForTextingMessage.fetchStoredUserData(uidPath: firebaseAuth.getUID())
        try await firestoreToFetchRoomsData.summitRoomInfoAsync(docID: docID, uidPath: firebaseAuth.getUID(), roomUID: roomUID, holderName: holderName, mobileNumber: holderMobileNumber, roomAddress: roomAddress, town: roomTown, city: roomCity, zipCode: roomZipCode, roomArea: roomArea, rentalPrice: roomRentalPrice, someoneDeadInRoom: someoneDeadInRoom, waterLeakingProblem: waterLeakingProblem, roomImageURL: roomImageURL, providerDisplayName: providerDisplayName, providerChatDocId: firestoreForTextingMessage.senderUIDPath.chatDocId, roomDescription: roomDescription)
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
        appViewModel.roomDescription = ""
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
