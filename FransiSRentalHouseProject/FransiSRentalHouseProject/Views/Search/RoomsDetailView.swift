//
//  RoomsDetailView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/5.
//

import SwiftUI
import SDWebImageSwiftUI

struct RoomsDetailView: View {
    
    @EnvironmentObject var roomsDetailViewModel: RoomsDetailViewModel
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var roomCARVM: RoomCommentAndRattingViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var roomsData: RoomInfoDataModel
    
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
                    .frame(width: uiScreenWidth - 50)
                Spacer()
                    .frame(height: 15)
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Room Name") //If it has
                            .font(.system(size: 30))
                        Spacer()
                        Group {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                NavigationLink {
                                    RoomCommentAndRatePresenterView()
                                } label: {
                                    Text("\(roomCARVM.rattingCompute(input: firestoreToFetchRoomsData.roomCARDataSet), specifier: "%.1f")")
                                        .foregroundColor(.black)
                                        .font(.system(size: 15, weight: .bold))
                                }
                            }
                            .padding()
                            .frame(width: 90, height: 30, alignment: .center)
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
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .trailing)
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
                            if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Renter" {
                                NavigationLink {
                                    MessageMainView()
                                } label: {
                                    Text("Contact provider.")
                                        .foregroundColor(.white)
                                        .frame(width: 175, height: 35)
                                        .background(Color("buttonBlue"))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .padding(.trailing)
                                }
                                .simultaneousGesture(TapGesture().onEnded({ _ in
                                    roomsDetailViewModel.createNewChateRoom = true
                                    debugPrint(roomsDetailViewModel.createNewChateRoom)
                                    roomsDetailViewModel.providerUID = roomsData.providedBy
                                    debugPrint("providerBy: \(roomsDetailViewModel.providerUID)")
                                    roomsDetailViewModel.providerDisplayName = roomsData.providerDisplayName
                                    debugPrint("providerDN: \(roomsDetailViewModel.providerDisplayName)")
                                    roomsDetailViewModel.providerChatDodID = roomsData.providerChatDocId
                                    debugPrint("providerChatID: \(roomsDetailViewModel.providerChatDodID)")
                                }))
                            }
                            NavigationLink {
                                RenterContractView(roomsData: roomsData)
                            } label: {
                                 Text("Check Contract")
                                    .foregroundColor(.white)
                                    .frame(width: 140, height: 35)
                                    .background(Color("buttonBlue"))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .padding(.horizontal)
                            }
                            
                        }
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical)
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
        .overlay(content: {
            if roomsDetailViewModel.zoomImageIn {
                ShowImageSets(roomImages: firestoreToFetchRoomsData.fetchRoomImages, zoomImageIn: $roomsDetailViewModel.zoomImageIn)
            }
        })
        .task {
            do {
                try await firestoreToFetchRoomsData.fetchRoomImages(uidPath: roomsData.providedBy, docID: roomsData.id ?? "")
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
}


extension RoomsDetailView {
    @ViewBuilder
    func mapSwitch(showMap: Bool, address: String) -> some View {
        if showMap == true {
            RoomLocateMapView(address: address)
                .frame(height: uiScreenHeight / 2, alignment: .top)
                .edgesIgnoringSafeArea(.top)
        } else {
            if !roomsDetailViewModel.presentingImageURL.isEmpty {
                WebImage(url: URL(string: roomsDetailViewModel.presentingImageURL))
                    .resizable()
                    .frame(height: uiScreenHeight / 2 + 190, alignment: .top)
                    .edgesIgnoringSafeArea(.top)
            } else {
                WebImage(url: URL(string: roomsData.roomImage ?? ""))
                    .resizable()
                    .frame(height: uiScreenHeight / 2 + 190, alignment: .top)
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
                        roomsDetailViewModel.presentingImageURL = image.imageURL
                        roomsDetailViewModel.showMap = false
                        print(roomsDetailViewModel.presentingImageURL)
                    } label: {
                        WebImage(url: URL(string: image.imageURL))
                            .resizable()
                            .cornerRadius(10)
                            .frame(width: 60, height: 60, alignment: .center)
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
    
    func address(input: RoomInfoDataModel) -> String {
        let zipCode = input.zipCode
        let city = input.city
        let town = input.town
        let roomAddress = input.roomAddress
        return zipCode + city + town + roomAddress
    }
}


struct ShowImageSets: View {
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    var roomImages: [RoomImageDataModel]
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
                            WebImage(url: URL(string: image.imageURL))
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
