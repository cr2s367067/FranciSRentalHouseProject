//
//  RoomStatusView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct RoomStatusView: View {
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var errorHandler: ErrorHandler
    
    var roomImageURL: String {
        firestoreToFetchUserinfo.rentingRoomInfo.roomImageCover ?? ""
    }
    
    var rentalPrice: String {
        firestoreToFetchUserinfo.rentingRoomInfo.roomPrice ?? ""
    }
    
    var roomAddress: String {
        firestoreToFetchUserinfo.rentingRoomInfo.roomAddress ?? ""
    }
    
    var roomCityAndTown: String {
        let city = firestoreToFetchUserinfo.rentingRoomInfo.roomCity ?? ""
        let town = firestoreToFetchUserinfo.rentingRoomInfo.roomTown ?? ""
        return city + town
    }
    
    var roomZipCode: String {
        firestoreToFetchUserinfo.rentingRoomInfo.roomZipCode ?? ""
    }
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeigth = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea(.all)
            VStack {
                VStack {
                    HStack {
                        VStack {
                            HStack {
                                WebImage(url: URL(string: roomImageURL))
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(roomZipCode)
                                    Text(roomCityAndTown)
                                    Text(roomAddress)
                                }
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .medium))
                                .padding(.leading, 10)
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                    Spacer()
                    VStack(alignment: .center, spacing: 10) {
                        HStack(spacing: 1) {
                            Text("Monthly Rental Price: ")
                                .foregroundColor(.white)
                            Spacer()
                            Text("$\(rentalPrice)")
                                .foregroundColor(.white)
                                .padding(.leading, 1)
                        }
                        HStack(spacing: 1) {
                            Text("Expired Date: ")
                                .foregroundColor(.white)
                            Spacer()
                            Text("1/15/2023")
                                .foregroundColor(.white)
                                .padding(.leading, 1)
                            
                        }
                        
                        HStack(spacing: 1) {
                            Text("Addition Furniture:  ")
                                .foregroundColor(.white)
                            Spacer()
                            Text("Yes")
                                .foregroundColor(.white)
                                .padding(.leading, 1)
                        }
                        
                        HStack {
                            Text("Pay Rental Bill: ")
                                .foregroundColor(.white)
                            Spacer()
                            NavigationLink {
                                PurchaseView(roomsData: localData.summaryItemHolder)
                            } label: {
                                 Text("Pay")
                                    .frame(width: 108, height: 35)
                                    .background(Color("fieldGray"))
                                    .cornerRadius(10)
                            }
                        }
                        
                        HStack(spacing: 1) {
                            Text("Renew: ")
                                .foregroundColor(.white)
                            Spacer()
                            Button {
                                
                            } label: {
                                Text("Yes")
                                    .frame(width: 108, height: 35)
                                    .background(Color("fieldGray"))
                                    .cornerRadius(10)
                            }
                            .padding(.leading, 1)
                        }
                        HStack(spacing: 1) {
                            Text("Contract: ")
                                .foregroundColor(.white)
                            Spacer()
                            NavigationLink {
                                PresentContract(contractData: firestoreToFetchRoomsData.roomContractData)
                            } label: {
                                Text("show")
                                    .frame(width: 108, height: 35)
                                    .background(Color("fieldGray"))
                                    .cornerRadius(10)
                            }
                            .padding(.leading, 1)
                        }
                    }
                }
                .padding()
                .frame(width: uiScreenWidth - 40, height: uiScreenHeigth / 2)
                .background(alignment: .top) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("sessionBackground"))
                }
                Spacer()
            }
        }
        .onAppear {
            firestoreToFetchUserinfo.userRentedRoomInfo()
        }
        .task {
            do {
                _ = try await firestoreToFetchRoomsData.fetchRentedContract(uidPath: firebaseAuth.getUID())
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RoomStatusView_Previews: PreviewProvider {
    static var previews: some View {
        RoomStatusView()
    }
}
