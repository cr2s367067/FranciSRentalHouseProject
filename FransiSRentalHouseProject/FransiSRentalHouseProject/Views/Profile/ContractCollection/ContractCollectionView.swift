//
//  ContractCollectionView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/9/22.
//

import SDWebImageSwiftUI
import SwiftUI

struct ContractCollectionView: View {
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var errorHandler: ErrorHandler

//    @State private var showDetail = false
    @State private var isFocused = false
    
    var body: some View {
        VStack {
            TitleAndDivider(title: "Contract Collection")
            Spacer()
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(firestoreToFetchRoomsData.fetchRoomInfoFormOwner) { roomInfo in
                    NavigationLink {
                        RenterContractView(roomsData: roomInfo)
                    } label: {
                        ContractReusableUnit(roomsData: roomInfo)
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .background(alignment: .center) {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea(.all)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            appViewModel.updateNavigationBarColor()
        }
        .task {
            do {
                try await firestoreToFetchRoomsData.getRoomInfo(
                    gui: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? ""
                )
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        do {
                            isFocused = true
                            try await firestoreToFetchRoomsData.getRoomInfo(
                                gui: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? ""
                            )
                            isFocused = false
                        } catch {
                            self.errorHandler.handle(error: error)
                        }
                    }
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .rotationEffect(.degrees(isFocused ? 270 : 0))
                }
            }
        }
    }
}

struct ContractReusableUnit: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreRoom: FirestoreToFetchRoomsData
    @EnvironmentObject var contractCollectionVM: ContractCollectionVM

    var roomsData: RoomDM

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    private var docID: String {
        var temp = ""
        if let docID = roomsData.id {
            temp = docID
        }
        return temp
    }

    func findFirstImage() -> String {
        return firestoreRoom.fetchRoomImages.map { $0.roomImageURL }.first?.description ?? ""
    }

    func address() -> String {
        let city = roomsData.city
        let town = roomsData.town
        let roomAddress = roomsData.address
        return city + town + roomAddress
    }

    var body: some View {
        VStack {
            HStack {
                WebImage(url: URL(string: roomsData.roomsCoverImageURL))
                    .resizable()
                    .frame(width: uiScreenWidth / 3 + 20, height: uiScreenHeight / 8 + 5)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text("Address: ")
                    Text("\(address())")
                    Spacer()
                }
                HStack {
                    Text("Renter: ")
                    Text(contractCollectionVM.checkRenter(roomsData: roomsData))
                    Spacer()
                }
            }
        }
        .padding()
        .frame(width: uiScreenWidth - 20, height: uiScreenHeight / 4 - 20)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("fieldGray"))
        }
    }
}

struct ContractCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ContractCollectionView()
    }
}
