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
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var roomsData: RoomInfoDataModel
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                roomImagesPresenterWithPlaceHolder()
                    .frame(width: uiScreenWidth - 50)
                Spacer()
                    .frame(height: 15)
                VStack(alignment: .leading) {
                    HStack {
                        Text("Room Name") //If it has
                            .font(.system(size: 30))
                        Spacer()
                        Button {
                            roomsDetailViewModel.showMap.toggle()
                        } label: {
                            withAnimation {
                                Image(systemName: roomsDetailViewModel.showMap ? "map" : "photo.artframe")
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .trailing)
                            }
                        }
                    }
                    RoomsInfoUnit(title: "Rooms Address")
                    Spacer()
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
                    .fill(Color.brown)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
            }
        }
        .edgesIgnoringSafeArea(.top)
        .frame(maxWidth: .infinity)
        .background(alignment: .center) {
            VStack {
                mapSwitch(showMap: roomsDetailViewModel.showMap, address: getAddress())
//                Image("room")
//                    .resizable()
//                    .frame(height: uiScreenHeight / 2 + 190, alignment: .top)
//                    .edgesIgnoringSafeArea(.top)
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                try await firestoreToFetchRoomsData.fetchRoomImages(docID: roomsData.id ?? "")
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

//struct RoomsDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomsDetailView()
//    }
//}

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
                        print(roomsDetailViewModel.presentingImageURL)
                    } label: {
                        WebImage(url: URL(string: image.imageURL))
                            .resizable()
                            .cornerRadius(20)
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
                RoundedRectangle(cornerRadius: 20)
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
