//
//  RoomsDetailView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/5.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SDWebImageSwiftUI
import SwiftUI

struct RoomsDetailView: View {
    @EnvironmentObject var roomsDetailViewModel: RoomsDetailViewModel
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var roomCARVM: RoomCommentAndRattingViewModel
    @EnvironmentObject var providerStoreM: ProviderStoreM
    @Environment(\.colorScheme) var colorScheme

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    var roomsData: RoomDM

    var body: some View {
        VStack {
            Spacer()
            if roomsDetailViewModel.showMap == false {
                HStack {
                    Spacer()
                    Button {
                        roomsDetailViewModel.zoomImageIn.toggle()
                    } label: {
                        Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .padding(.trailing)
                    }
                }
            }
            VStack {
                roomImagesPresenterWithPlaceHolder()
                    .frame(width: uiScreenWidth - 50, height: uiScreenHeight / 7 - 72)
                Spacer()
                    .frame(height: 15)
                VStack(alignment: .center, spacing: 10) {
                    HStack {
                        Text(providerStoreM.storesData.companyName)
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.heavy)
                        Spacer()
                        Group {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                NavigationLink {
                                    RoomCommentAndRatePresenterView(roomsData: roomsData)
                                } label: {
                                    Text("\(roomCARVM.rattingCompute(input: firestoreToFetchRoomsData.roomCARDataSet), specifier: "%.1f")")
                                        .foregroundColor(.black)
                                        .font(.body)
                                        .fontWeight(.heavy)
                                }
                            }
                            .padding()
                            .frame(width: uiScreenWidth / 4, height: 30, alignment: .center)
                            .background(alignment: .trailing) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.4), radius: 5)
                            }
                        }
                        Button {
                            roomsDetailViewModel.showMap.toggle()
                        } label: {
                            withAnimation {
                                Image(systemName: roomsDetailViewModel.showMap ? "photo.artframe" : "map")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                            }
                        }
                    }
                    ScrollView(.vertical) {
                        VStack(spacing: 5) {
                            RoomsInfoUnit(title: "Rooms Address")
                            HStack {
                                Text(address(input: roomsData))
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        VStack(spacing: 5) {
                            HStack {
                                Text("Description")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                Text(roomsData.roomDescription)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .regular))
                                Spacer()
                            }
                        }
                        HStack {
                            isRegist(uType: SignUpType(rawValue: firestoreToFetchUserinfo.fetchedUserData.userType) ?? .isNormalCustomer)
                            NavigationLink {
                                RenterContractView(roomsData: roomsData)
                            } label: {
                                Text("Check Contract")
                                    .foregroundColor(.white)
                                    .frame(width: uiScreenWidth / 4 + 50, height: 35)
                                    .background(Color("buttonBlue"))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .padding()
                            }
                        }
                        .sheet(isPresented: $roomsDetailViewModel.showUserInfoCover) {
                            VStack {
                                SheetPullBar()
                                UserDetailInfoView()
                            }
                            .padding()
                        }
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding()
                .frame(width: uiScreenWidth, height: uiScreenHeight / 3)
                .background {
                    Rectangle()
                        .fill(Color("background2"))
                        .cornerRadius(30, corners: [.topLeft, .topRight])
                }
            }
            .frame(height: uiScreenHeight / 2 - 60, alignment: .bottom)
            .background {
                Rectangle()
                    .fill(Color("background3"))
                    .cornerRadius(30, corners: [.topLeft, .topRight])
            }
        }
        .padding()
        .edgesIgnoringSafeArea(.top)
        .frame(maxWidth: .infinity)
        .background(alignment: .center) {
            VStack {
                mapSwitch(showMap: roomsDetailViewModel.showMap, address: getAddress())
                Spacer()
                Color("background2")
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            NavigationLink {
//                VideoView(urlString: firestoreToFetchRoomsData.roomVideoPath.videoURL)
//            } label: {
//                Image(systemName: "film")
//                    .foregroundColor(.white)
//                    .font(.system(size: 18))
//            }
//        }
        .overlay(content: {
            if roomsDetailViewModel.zoomImageIn {
//                ShowImageSets(roomImages: firestoreToFetchRoomsData.fetchRoomImages, zoomImageIn: $roomsDetailViewModel.zoomImageIn)
                ShowImage(
                    imageArray: imageSetConvert(
                        images: firestoreToFetchRoomsData.fetchRoomImages
                    ),
                    showImageDetail: $roomsDetailViewModel.zoomImageIn
                )
            }
        })
        .task {
            do {
                try await firestoreToFetchRoomsData.fetchRoomImages(
                    gui: roomsData.providerGUI,
                    roomUID: roomsData.roomUID
                )
//                try await firestoreToFetchRoomsData.fetchRoomVideo(uidPath: roomsData.providedBy, docID: roomsData.id ?? "")
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
        .onAppear {
            UINavigationBar.appearance().barTintColor = UIColor(Color.clear)
            UINavigationBar.appearance().backgroundColor = UIColor(Color.clear)
        }
    }
}

struct RoomsInfoUnit: View {
    var title: String
    var body: some View {
        HStack {
            Text("\(title):")
            Spacer()
        }
    }
}

class RoomsDetailViewModel: ObservableObject {
    @Published var showMap = true
    @Published var presentingImageURL = ""
    @Published var createNewChateRoom = false

    @Published var providerUID = ""
    @Published var providerDisplayName = ""
    @Published var providerChatDodID = ""

    @Published var zoomImageIn = false

    @Published var showUserInfoCover = false
    @Published var showAlert = false

//    func userInfoChecker(id: String) throws {
//        guard !id.isEmpty else {
//            showUserInfoCover = true
//            throw StarUpError.userInfoError
//        }
//    }
}

extension RoomsDetailView {
    
    private func imageSetConvert(images: [RoomImageSet]) -> [String] {
        var holder = [String]()
        
        for image in images {
            holder.append(image.roomImageURL)
        }
        
        return holder
    }
    
    @ViewBuilder
    func isRegist(uType: SignUpType) -> some View {
        if uType == .isNormalCustomer {
            if firestoreToFetchUserinfo.fetchedUserData.id.isEmpty {
                Button {
                    roomsDetailViewModel.showAlert.toggle()
                } label: {
                    Text("Contact provider.")
                        .foregroundColor(.white)
                        .frame(width: 175, height: 35)
                        .background(Color("buttonBlue"))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.trailing)
                        .alert("Notice", isPresented: $roomsDetailViewModel.showAlert) {
                            Button("Cancel") {
                                roomsDetailViewModel.showAlert = false
                            }
                            Button("Sure") {
                                roomsDetailViewModel.showUserInfoCover = true
                            }
                        } message: {
                            let message = "Hi, please fill up necessary user info first thanks."
                            Text(message)
                        }
                }
            } else {
                NavigationLink {
                    MessageMainView()
                } label: {
                    Text("Contact Provider")
                        .foregroundColor(.white)
                        .frame(width: uiScreenWidth / 3 + 25, height: 35)
                        .background(Color("buttonBlue"))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding()
                }
                .simultaneousGesture(TapGesture().onEnded { _ in
                    roomsDetailViewModel.createNewChateRoom = true
                    debugPrint(roomsDetailViewModel.createNewChateRoom)
                    roomsDetailViewModel.providerUID = roomsData.providerUID
                    debugPrint("providerBy: \(roomsDetailViewModel.providerUID)")
                    roomsDetailViewModel.providerDisplayName = providerStoreM.storesData.companyName
                    debugPrint("providerDN: \(roomsDetailViewModel.providerDisplayName)")
                    //MARK: Haven't update doc id
                    roomsDetailViewModel.providerChatDodID = providerStoreM.storesData.storeChatDocID
                    debugPrint("providerChatID: \(roomsDetailViewModel.providerChatDodID)")
                })
            }
        }
    }

    @ViewBuilder
    func mapSwitch(showMap: Bool, address: String) -> some View {
        if showMap {
            RoomLocateMapView(address: address)
                .frame(height: uiScreenHeight / 2, alignment: .top)
                .edgesIgnoringSafeArea(.top)
        } else {
            if !roomsDetailViewModel.presentingImageURL.isEmpty {
                WebImage(url: URL(string: roomsDetailViewModel.presentingImageURL))
                    .resizable()
                    .scaledToFill()
                    .frame(height: uiScreenHeight / 2 + 190, alignment: .center)
                    .clipped()
                    .edgesIgnoringSafeArea(.top)
            } else {
                WebImage(url: URL(string: roomsData.roomsCoverImageURL))
                    .resizable()
                    .scaledToFill()
                    .frame(height: uiScreenHeight / 2 + 190, alignment: .center)
                    .clipped()
                    .edgesIgnoringSafeArea(.top)
            }
        }
    }

    @ViewBuilder
    func roomImagesPresenter() -> some View {
        ScrollView(.horizontal) {
            HStack(alignment: .center) {
                ForEach(firestoreToFetchRoomsData.fetchRoomImages) { image in
                    Button {
                        roomsDetailViewModel.presentingImageURL = image.roomImageURL
                        roomsDetailViewModel.showMap = false
                        print(roomsDetailViewModel.presentingImageURL)
                    } label: {
                        WebImage(url: URL(string: image.roomImageURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60, alignment: .center)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func roomImagesPresenterWithPlaceHolder() -> some View {
        if firestoreToFetchRoomsData.fetchRoomImages.isEmpty {
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray)
                    .frame(width: 60, height: 60)
            }
            .redacted(reason: .placeholder)
        } else {
            roomImagesPresenter()
        }
    }

    func getAddress() -> String {
        return address(input: roomsData)
    }

    func address(input: RoomDM) -> String {
        let city = input.city
        let town = input.town
        let roomAddress = input.address
        return city + town + roomAddress
    }
}

struct ShowImageSets: View {
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    var roomImages: [RoomImageSet]
    @Binding var zoomImageIn: Bool
    var body: some View {
        VStack(spacing: 22) {
            HStack {
                Spacer()
                Button {
                    zoomImageIn = false
                } label: {
                    Image(systemName: "x.square")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 25))
                }
            }
            .padding(.horizontal)
            VStack {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(roomImages) { image in
                            WebImage(url: URL(string: image.roomImageURL))
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .frame(width: uiScreenWidth - 100, height: uiScreenHeight / 2)
                                .padding()
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(alignment: .center) {
            Color.black.opacity(0.85)
                .edgesIgnoringSafeArea([.top, .bottom])
        }
    }
}
