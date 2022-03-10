//
//  ContractCollectionView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/9/22.
//

import SwiftUI

struct ContractCollectionView: View {
    
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData

    @State private var showDetail = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("backgroundBrown"))
                .ignoresSafeArea(.all)
            VStack {
                TitleAndDivider(title: "Contract Collection")
                Spacer()
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(firestoreToFetchRoomsData.fetchRoomInfoFormOwner) { roomInfo in
                        ContractReusableUnit(showDetail: $showDetail, roomAddress: roomInfo.roomAddress, roomTown: roomInfo.town, roomCity: roomInfo.city, roomZipCode: roomInfo.zipCode)
                    }
                }
            }
        }
    }
}

struct ContractReusableUnit: View {
    
    @Binding var showDetail: Bool
    
    var roomAddress: String = ""
    var roomTown: String = ""
    var roomCity: String = ""
    var roomZipCode: String = ""
    var renter: String = ""
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    func address() -> String {
        var tempAddressHolder = ""
        tempAddressHolder = address(roomAddress: roomAddress, roomTown: roomTown, roomCity: roomCity, roomZipCode: roomZipCode)
        return tempAddressHolder
    }
    
   private func address(roomAddress: String, roomTown: String, roomCity: String, roomZipCode: String) -> String {
        return roomZipCode + roomCity + roomTown + roomAddress
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("fieldGray"))
                .frame(width: uiScreenWidth - 30, height: uiScreenHeight - 785)
            VStack {
                HStack {
                    Image(systemName: "photo")
                        .font(.system(size: 50))
                        .frame(width: 100, height: 70)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.brown)
                        )
                    Spacer()
                        .frame(width: uiScreenWidth - 200)
                }
                VStack(spacing: 3) {
                    HStack {
                        Text("Address: ")
                        Text("\(address())")
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.top, 3)
                    HStack {
                        Text("Renter: ")
                        Text(renter)
                        Spacer()
                    }
                    .padding(.leading)
                }
                HStack {
                    Spacer()
                        .frame(width: uiScreenWidth - 50)
                    Button {
                        withAnimation {
                            showDetail.toggle()
                        }
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .foregroundColor(Color("buttonBlue"))
                            .frame(width: 25, height: 25, alignment: .trailing)
                            .rotationEffect(showDetail ? .degrees(45) : .degrees(0))
                    }
                }
                .padding(.trailing)
                Spacer()
                    .frame(height: 30)
            }
            .frame(width: uiScreenWidth - 20, height: uiScreenHeight - 670)
        }
    }
}

struct ContractCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ContractCollectionView()
    }
}
