//
//  ProviderRoomSummitView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import AVKit
import FirebaseFirestoreSwift
import SwiftUI

struct ProviderRoomSummitView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var storageForRoomsImage: StorageForRoomsImage
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firestoreForTextingMessage: FirestoreForTextingMessage
    @EnvironmentObject var providerRoomSummitVM: ProviderRoomSummitViewModel
    @Environment(\.colorScheme) var colorScheme

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    @State private var selectlimit = 5
    @FocusState private var isFocus: Bool
<<<<<<< HEAD
    
    @State private var getVideo = false
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    let testURL = "gs://francisrentalhouseproject.appspot.com/roomVideo/The 30-Second Video.mp4"
    
=======

    @State private var getVideo = false

    init() {
        UITextView.appearance().backgroundColor = .clear
    }

    let testURL = "gs://francisrentalhouseproject.appspot.com/roomVideo/The 30-Second Video.mp4"

>>>>>>> PodsAdding
    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                ScrollView(.vertical, showsIndicators: false) {
                    TitleAndDivider(title: "Ready to Post your Room?")
<<<<<<< HEAD
                    
                    //MARK: - Room Cover photo
=======

                    // MARK: - Room Cover photo

>>>>>>> PodsAdding
                    StepsTitle(stepsName: "Step1: Upload the room pic.")
                    Button {
                        providerRoomSummitVM.showSheet.toggle()
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
                            if providerRoomSummitVM.isSummitRoomPic == true {
                                Image(uiImage: self.providerRoomSummitVM.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: uiScreenWidth - 30, height: 304)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .accessibilityIdentifier("coverImage")
<<<<<<< HEAD
                    //MARK: - Room infos
=======

                    // MARK: - Room infos

>>>>>>> PodsAdding
                    StepsTitle(stepsName: "Step2: Please provide the necessary information")
                    VStack(spacing: 10) {
                        Group {
//                            InfoUnit(title: "Holder Name", bindingString: $appViewModel.holderName)
//                            InfoUnit(title: "Mobile Number", bindingString: $appViewModel.holderMobileNumber)
                            Group {
                                InfoUnit(
                                    title: "Zip Code",
                                    bindingString: $providerRoomSummitVM.roomZipCode
                                )
                                .accessibilityIdentifier("zipcode")
                                InfoUnit(
                                    title: "City",
                                    bindingString: $providerRoomSummitVM.roomCity
                                )
                                .accessibilityIdentifier("city")
                                InfoUnit(
                                    title: "Town",
                                    bindingString: $providerRoomSummitVM.roomTown
                                )
                                .accessibilityIdentifier("town")
                                InfoUnit(
                                    title: "Room Address",
                                    bindingString: $providerRoomSummitVM.roomAddress
                                )
                                .accessibilityIdentifier("roomAddress")
                            }
                            InfoUnit(title: "Room Area", bindingString: $providerRoomSummitVM.roomArea)
                                .accessibilityIdentifier("roomArea")
                            InfoUnit(title: "Rental Price", bindingString: $providerRoomSummitVM.roomRentalPrice)
                                .accessibilityIdentifier("rentalPrice")
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text("Room Description")
                                        .modifier(textFormateForProviderSummitView())
                                    Spacer()
                                }
                                TextEditor(text: $providerRoomSummitVM.roomDescription)
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
<<<<<<< HEAD
                        
                        //MARK: - Additional Room Images
=======

                        // MARK: - Additional Room Images

>>>>>>> PodsAdding
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text("Additional Room Images")
                                    .modifier(textFormateForProviderSummitView())
                                Spacer()
                            }
                            .padding(.bottom)
                            Button {
                                providerRoomSummitVM.showPHPicker.toggle()
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
                                    if providerRoomSummitVM.isSelectedRoomSet == true {
                                        Image(uiImage: providerRoomSummitVM.presentImage(input: providerRoomSummitVM.imageSet))
                                            .resizable()
                                            .frame(width: uiScreenWidth / 2, height: uiScreenHeight / 6, alignment: .center)
                                            .cornerRadius(10)
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    VStack(alignment: .trailing) {
                                        HStack {
                                            Spacer()
                                            Text("\(providerRoomSummitVM.imageSet.count)")
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
<<<<<<< HEAD
                        
                        //MARK: - Addtional Room Intro Video
=======

                        // MARK: - Addtional Room Intro Video

>>>>>>> PodsAdding
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text("Additional Room Intro Video")
                                    .modifier(textFormateForProviderSummitView())
                                Button {
<<<<<<< HEAD
                                    providerRoomSummitViewModel.showPHPicker.toggle()
=======
                                    providerRoomSummitVM.showPHPicker.toggle()
>>>>>>> PodsAdding
                                } label: {
                                    Image(systemName: getVideo ? "checkmark.square.fill" : "plus.square")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(getVideo ? Color.green : Color.gray)
                                }
                                .accessibilityIdentifier("addtionalPh")
                                Spacer()
                            }
                            .padding(.bottom)
<<<<<<< HEAD
                            if providerRoomSummitViewModel.isSelectedRoomSet == true && !(providerRoomSummitViewModel.roomIntroVideoURL?.pathComponents.isEmpty ?? true) {
                                if let url = providerRoomSummitViewModel.roomIntroVideoURL {
=======
                            if providerRoomSummitVM.isSelectedRoomSet == true, !(providerRoomSummitVM.roomIntroVideoURL?.pathComponents.isEmpty ?? true) {
                                if let url = providerRoomSummitVM.roomIntroVideoURL {
>>>>>>> PodsAdding
                                    VStack {
                                        VideoPlayer(player: AVPlayer(url: url))
                                    }
                                    .frame(width: uiScreenWidth - 30, height: uiScreenHeight / 3, alignment: .center)
                                    .padding()
                                }
                            }
                        }
                        .padding()
                        .frame(width: uiScreenWidth - 30, height: uiScreenHeight / 6)
<<<<<<< HEAD
                        
                        //MARK: - Require Questions
=======

                        // MARK: - Require Questions

>>>>>>> PodsAdding
                        Group {
                            HStack {
                                Text("Does someone dead in this room before?")
                                Spacer()
                            }
                            HStack {
                                Button {
                                    if providerRoomSummitVM.doesSomeDeadinRoomNo == true {
                                        providerRoomSummitVM.doesSomeDeadinRoomNo = false
                                    }
                                    if providerRoomSummitVM.doesSomeDeadinRoomYes == false {
                                        providerRoomSummitVM.doesSomeDeadinRoomYes = true
                                        providerRoomSummitVM.someoneDeadinRoom = true
                                    }
                                } label: {
                                    Image(systemName: providerRoomSummitVM.doesSomeDeadinRoomYes ? "checkmark.square.fill" : "square")
                                        .foregroundColor(providerRoomSummitVM.doesSomeDeadinRoomYes ? .green : .white)
                                        .padding(.trailing, 5)
                                    Text("Yes")
                                        .foregroundColor(Color.white)
                                }
                                Button {
                                    if providerRoomSummitVM.doesSomeDeadinRoomYes == true {
                                        providerRoomSummitVM.doesSomeDeadinRoomYes = false
                                    }
                                    if providerRoomSummitVM.doesSomeDeadinRoomNo == false {
                                        providerRoomSummitVM.doesSomeDeadinRoomNo = true
                                        providerRoomSummitVM.someoneDeadinRoom = false
                                    }
                                } label: {
                                    Image(systemName: providerRoomSummitVM.doesSomeDeadinRoomNo ? "checkmark.square.fill" : "square")
                                        .foregroundColor(providerRoomSummitVM.doesSomeDeadinRoomNo ? .green : .white)
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
                                    if providerRoomSummitVM.hasWaterLeakingNo == true {
                                        providerRoomSummitVM.hasWaterLeakingNo = false
                                    }
                                    if providerRoomSummitVM.hasWaterLeakingYes == false {
                                        providerRoomSummitVM.hasWaterLeakingYes = true
                                        providerRoomSummitVM.waterLeakingProblem = true
                                    }
                                } label: {
                                    Image(systemName: providerRoomSummitVM.hasWaterLeakingYes ? "checkmark.square.fill" : "square")
                                        .foregroundColor(providerRoomSummitVM.hasWaterLeakingYes ? .green : .white)
                                        .padding(.trailing, 5)
                                    Text("Yes")
                                        .foregroundColor(Color.white)
                                }
                                Button {
                                    if providerRoomSummitVM.hasWaterLeakingYes == true {
                                        providerRoomSummitVM.hasWaterLeakingYes = false
                                    }
                                    if providerRoomSummitVM.hasWaterLeakingNo == false {
                                        providerRoomSummitVM.hasWaterLeakingNo = true
                                        providerRoomSummitVM.waterLeakingProblem = false
                                    }
                                } label: {
                                    Image(systemName: providerRoomSummitVM.hasWaterLeakingNo ? "checkmark.square.fill" : "square")
                                        .foregroundColor(providerRoomSummitVM.hasWaterLeakingNo ? .green : .white)
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
                                providerRoomSummitVM.holderTosAgree.toggle()
                            } label: {
                                Image(systemName: providerRoomSummitVM.holderTosAgree ? "checkmark.square.fill" : "square")
                                    .foregroundColor(providerRoomSummitVM.holderTosAgree ? .green : .white)
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
                                    providerRoomSummitVM.tosSheetShow.toggle()
                                }
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button {
                            Task {
                                do {
                                    try await checker(
                                        holderName: providerRoomSummitVM.holderName,
                                        holderMobileNumber: providerRoomSummitVM.holderMobileNumber,
                                        roomAddress: providerRoomSummitVM.roomAddress,
                                        roomTown: providerRoomSummitVM.roomTown,
                                        roomCity: providerRoomSummitVM.roomCity,
                                        roomZipCode: providerRoomSummitVM.roomZipCode,
                                        roomArea: providerRoomSummitVM.roomArea,
                                        roomRentalPrice: providerRoomSummitVM.roomRentalPrice,
                                        tosAgreement: providerRoomSummitVM.holderTosAgree,
                                        isSummitRoomImage: providerRoomSummitVM.isSummitRoomPic,
                                        roomUID: firestoreToFetchRoomsData.roomID,
                                        someoneDeadInRoom: providerRoomSummitVM.someoneDeadinRoom,
                                        waterLeakingProblem: providerRoomSummitVM.waterLeakingProblem,
                                        roomImageURL: storageForRoomsImage.representedRoomImageURL
                                    )
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
                                .alert("Notice", isPresented: $providerRoomSummitVM.showSummitAlert, actions: {
                                    HStack {
                                        Button {
                                            providerRoomSummitVM.showSummitAlert = false
                                        } label: {
                                            Text("Cancel")
                                        }
                                        Button {
                                            Task {
                                                do {
                                                    providerRoomSummitVM.showProgressView = true
                                                    try await storageForRoomsImage.uploadRoomCoverImage(
                                                        uidPath: firebaseAuth.getUID(),
                                                        image: providerRoomSummitVM.image,
                                                        roomID: firestoreToFetchRoomsData.roomID,
                                                        imageUID: storageForRoomsImage.imageUUID
                                                    )
                                                    try await roomSummit(
                                                        rentalRoom: RoomDM(
                                                            isPublish: false,
                                                            roomUID: firestoreToFetchRoomsData.roomID,
                                                            providerUID: firebaseAuth.getUID(),
                                                            providerGUI: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? "",
                                                            renterUID: "",
                                                            roomsCoverImageURL: storageForRoomsImage.representedRoomImageURL,
                                                            rentalPrice: providerRoomSummitVM.roomRentalPrice,
                                                            zipCode: providerRoomSummitVM.roomZipCode,
                                                            city: providerRoomSummitVM.roomCity,
                                                            town: providerRoomSummitVM.roomTown,
                                                            address: providerRoomSummitVM.roomAddress,
                                                            roomDescription: providerRoomSummitVM.roomDescription,
                                                            someoneDeadInRoom: providerRoomSummitVM.someoneDeadinRoom,
                                                            waterLeakingProblem: providerRoomSummitVM.waterLeakingProblem
                                                        )
                                                    )
                                                    resetView()
                                                    providerRoomSummitVM.showProgressView = false
                                                    providerRoomSummitVM.showSummitAlert = false
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
                .disabled(providerRoomSummitVM.showProgressView ? true : false)
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
                if firestoreToFetchUserinfo.userIDisEmpty() {
                    UnregisterCoverView(isShowUserDetailView: $appViewModel.isShowUserDetailView)
                }
                if providerRoomSummitVM.showProgressView == true {
                    CustomProgressView()
                }
            })
            .onAppear(perform: {
                firestoreToFetchRoomsData.roomID = firestoreToFetchRoomsData.roomIdGenerator()
                storageForRoomsImage.imageUUID = storageForRoomsImage.imagUUIDGenerator()
                providerRoomSummitVM.holderMobileNumber = firestoreToFetchUserinfo.fetchedUserData.mobileNumber
                providerRoomSummitVM.holderName = firestoreToFetchUserinfo.fetchedUserData.lastName + firestoreToFetchUserinfo.fetchedUserData.firstName
            })
            .sheet(isPresented: $providerRoomSummitVM.tosSheetShow, content: {
                TermOfServiceForRentalManager()
            })
<<<<<<< HEAD
            .sheet(isPresented: $providerRoomSummitViewModel.showPHPicker) {
                providerRoomSummitViewModel.isSelectedRoomSet = true
                //MARK: Fix the presenting bug
                if !(providerRoomSummitViewModel.roomIntroVideoURL?.pathComponents.isEmpty ?? true) {
                    getVideo = true
                }
                debugPrint("getting video url: \(String(describing: providerRoomSummitViewModel.roomIntroVideoURL))")
=======
            .sheet(isPresented: $providerRoomSummitVM.showPHPicker) {
                providerRoomSummitVM.isSelectedRoomSet = true

                // MARK: Fix the presenting bug

                if !(providerRoomSummitVM.roomIntroVideoURL?.pathComponents.isEmpty ?? true) {
                    getVideo = true
                }
                debugPrint("getting video url: \(String(describing: providerRoomSummitVM.roomIntroVideoURL))")
>>>>>>> PodsAdding
            } content: {
                PHPickerRepresentable(selectLimit: $selectlimit, images: self.$providerRoomSummitVM.imageSet, video: $providerRoomSummitVM.roomIntroVideoURL)
            }
            .sheet(isPresented: $providerRoomSummitVM.showSheet) {
                providerRoomSummitVM.isSummitRoomPic = true
            } content: {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$providerRoomSummitVM.image)
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
    func makeUIView(context _: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        return view
    }

    func updateUIView(_: UIVisualEffectView, context _: Context) {}
}

extension ProviderRoomSummitView {
//    @ViewBuilder
//    func someOneDeadInThisRoom(
//        config: Bool,
//        name: String,
//        void: @autoclosure ()->Void
//    ) -> some View {
//        if config {
//            Button {
//                void()
//            } label: {
//                Image(systemName: config ? "checkmark.square.fill" : "square")
//                    .foregroundColor(config ? .green : .white)
//                    .padding(.trailing, 5)
//                Text(name)
//                    .foregroundColor(Color.white)
//            }
//        }
//    }

    private func roomSummit(
        rentalRoom config: RoomDM
    ) async throws {
        _ = try await firestoreForTextingMessage.fetchStoredUserData(uidPath: firebaseAuth.getUID())
        try await firestoreToFetchRoomsData.summitRoomInfoAsync(
            gui: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? "",
            roomDM: config,
            house: .roomCreate(zipCode: config.zipCode, city: config.city, town: config.town, address: config.address, rentalPrice: config.rentalPrice)
        )
        if !providerRoomSummitVM.imageSet.isEmpty {
            try await storageForRoomsImage.uploadImageSet(
                gui: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? "",
                images: providerRoomSummitVM.imageSet,
                roomID: config.roomUID
            )
        }
<<<<<<< HEAD
        if !(providerRoomSummitViewModel.roomIntroVideoURL?.pathComponents.isEmpty ?? true) {
            guard let videoURL = providerRoomSummitViewModel.roomIntroVideoURL else { return }
            debugPrint("uploading vieo url: \(videoURL)")
            try await storageForRoomsImage.uploadRoomVideo(
                movie: videoURL,
                uidPath: firebaseAuth.getUID(),
                roomID: roomUID,
                docID: docID
            )
        }
=======

        // MARK: Modify video ref, include room and product

//        if !(providerRoomSummitVM.roomIntroVideoURL?.pathComponents.isEmpty ?? true) {
//            guard let videoURL = providerRoomSummitVM.roomIntroVideoURL else { return }
//            debugPrint("uploading vieo url: \(videoURL)")
//            try await storageForRoomsImage.uploadRoomVideo(
//                movie: videoURL,
//                uidPath: firebaseAuth.getUID(),
//                roomID: config.roomUID,
//                docID: docID
//            )
//        }
>>>>>>> PodsAdding
    }

    private func checker(
        holderName: String,
        holderMobileNumber: String,
        roomAddress: String,
        roomTown: String,
        roomCity: String,
        roomZipCode: String,
        roomArea: String,
        roomRentalPrice: String,
        tosAgreement: Bool,
        isSummitRoomImage: Bool,
        roomUID: String,
        someoneDeadInRoom _: Bool,
        waterLeakingProblem _: Bool,
        roomImageURL _: String
    ) async throws {
        try await appViewModel.providerSummitCheckerAsync(
            holderName: holderName,
            holderMobileNumber: holderMobileNumber,
            roomAddress: roomAddress,
            roomTown: roomTown,
            roomCity: roomCity,
            roomZipCode: roomZipCode,
            roomArea: roomArea,
            roomRentalPrice: roomRentalPrice,
            tosAgreement: tosAgreement,
            isSummitRoomImage: isSummitRoomImage,
            roomUID: roomUID
        )

        providerRoomSummitVM.showSummitAlert = true
    }

    private func resetView() {
        providerRoomSummitVM.holderName = ""
        providerRoomSummitVM.holderMobileNumber = ""
        providerRoomSummitVM.roomAddress = ""
        providerRoomSummitVM.roomTown = ""
        providerRoomSummitVM.roomCity = ""
        providerRoomSummitVM.roomArea = ""
        providerRoomSummitVM.roomRentalPrice = ""
        providerRoomSummitVM.roomZipCode = ""
        firestoreToFetchRoomsData.roomID = firestoreToFetchRoomsData.roomIdGenerator()
        storageForRoomsImage.imageUUID = storageForRoomsImage.imagUUIDGenerator()
        providerRoomSummitVM.isSummitRoomPic = false
        providerRoomSummitVM.isSelectedRoomSet = false
        providerRoomSummitVM.holderTosAgree = false
        providerRoomSummitVM.doesSomeDeadinRoomYes = false
        providerRoomSummitVM.doesSomeDeadinRoomNo = false
        providerRoomSummitVM.hasWaterLeakingNo = false
        providerRoomSummitVM.hasWaterLeakingYes = false
        providerRoomSummitVM.someoneDeadinRoom = false
        providerRoomSummitVM.waterLeakingProblem = false
        providerRoomSummitVM.imageSet.removeAll()
        providerRoomSummitVM.roomDescription = ""
    }
}
