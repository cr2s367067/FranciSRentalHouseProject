////
////  RoomDetailSheetView.swift
////  FransiSRentalHouseProject
////
////  Created by JerryHuang on 3/13/22.
////
//
//import SwiftUI
//
//struct RoomDetailSheetView: View {
//    
//    @EnvironmentObject var firestoreForTextingMessage: FirestoreForTextingMessage
//    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
//    @EnvironmentObject var appViewModel: AppViewModel
//    @EnvironmentObject var localData: LocalData
//    
//    var roomImage: String
//    var roomAddress: String
//    var roomTown: String
//    var roomCity: String
//    var roomPrice: Int
//    var roomUID: String
//    var roomZipCode: String
//    var docID: String
//    var providedBy: String
//    var providedName: String
//    var result: RoomInfoDataModel
//    var chatDocID: String
//    
//    
//    private func fullAddress() -> String {
//        return roomZipCode + roomCity + roomTown + roomAddress
//    }
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Rectangle()
//                    .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
//                    .edgesIgnoringSafeArea([.bottom, .top])
//                VStack(alignment: .center) {
//                    SheetPullBar()
//                        .padding(.top, 5)
//                        .padding(.bottom, 2)
//                    RoomLocateMapView(address: fullAddress())
//                    ScrollView(.vertical, showsIndicators: false) {
//                        VStack(alignment: .leading) {
//                            HStack {
//                                Text("Description")
//                                    .foregroundColor(.white)
//                                    .font(.headline)
//                                Spacer()
//                            }
//                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Arcu eleifend ante consectetur nullam diam porttitor urna. Ipsum ultrices sit diam massa nisl turpis elementum. Pharetra vehicula maecenas mauris nullam libero. Egestas cras ipsum, nunc, eget orci, tincidunt pellentesque fusce. Risus curabitur ipsum, fames arcu semper sagittis. Malesuada volutpat et massa urna, tortor. ")
//                                .foregroundColor(.white)
//                                .font(.system(size: 15, weight: .regular))
//                        }
//                        .padding()
//                        Spacer()
//                        HStack {
//                            if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Renter" {
//                                NavigationLink {
////                                    MessageView(providerName: providedName, providerUID: providedBy, chatDocID: chatDocID)
//                                } label: {
//                                    Text("Contact provider.")
//                                        .foregroundColor(.white)
//                                        .frame(width: 175, height: 35)
//                                        .background(Color("buttonBlue"))
//                                        .clipShape(RoundedRectangle(cornerRadius: 5))
//                                        .padding(.trailing)
//                                }
//                            }
////                            Button {
////                                if localData.tempCart.isEmpty {
////                                    localData.tempCart.append(result)
////                                    localData.addItem(roomAddress: roomAddress,
////                                                      roomTown: roomTown,
////                                                      roomCity: roomCity,
////                                                      itemPrice: Int(roomPrice) ,
////                                                      roomUID: roomUID ,
////                                                      roomImage: roomImage ,
////                                                      roomZipCode: roomZipCode,
////                                                      docID: docID, providerUID: providedBy)
////                                } else {
////                                    localData.tempCart.removeAll()
////                                    localData.summaryItemHolder.removeAll()
////                                    if localData.tempCart.isEmpty {
////                                        localData.tempCart.append(result)
////                                        localData.addItem(roomAddress: roomAddress,
////                                                          roomTown: roomTown,
////                                                          roomCity: roomCity,
////                                                          itemPrice: Int(roomPrice) ,
////                                                          roomUID: roomUID ,
////                                                          roomImage: roomImage ,
////                                                          roomZipCode: roomZipCode,
////                                                          docID: docID, providerUID: providedBy)
////                                    }
////                                }
////                                if appViewModel.isPresent == false {
////                                    appViewModel.isPresent = true
////                                }
////                                localData.sumPrice = localData.compute(source: localData.summaryItemHolder)
////                            } label: {
////                                Text("I want this!")
////                                    .foregroundColor(.white)
////                                    .frame(width: 120, height: 35)
////                                    .background(Color("buttonBlue"))
////                                    .clipShape(RoundedRectangle(cornerRadius: 5))
////                                    .padding(.trailing)
////                                    .alert(isPresented: $appViewModel.isPresent) {
////                                        Alert(title: Text("Congrate!"), message: Text("The room is adding in the chart, also check out the furnitures if needing. Please see Payment session."), dismissButton: .default(Text("Sure")))
////                                    }
////                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("")
//            .navigationBarHidden(true)
//        }
//    }
//}
//
//
///*
// ForEach(firestoreToFetchRoomsData.fetchRoomInfoFormPublic) { result in
//     Button {
//         if localData.tempCart.isEmpty {
//             localData.tempCart.append(result)
//             localData.addItem(roomAddress: result.roomAddress,
//                               roomTown: result.town,
//                               roomCity: result.city,
//                               itemPrice: Int(result.rentalPrice) ?? 0,
//                               roomUID: result.roomUID ?? "",
//                               roomImage: result.roomImage ?? "", roomZipCode: result.zipCode )
//         } else {
//             localData.tempCart.removeAll()
//             localData.summaryItemHolder.removeAll()
//             if localData.tempCart.isEmpty {
//                 localData.tempCart.append(result)
//                 localData.addItem(roomAddress: result.roomAddress,
//                                   roomTown: result.town,
//                                   roomCity: result.city,
//                                   itemPrice: Int(result.rentalPrice) ?? 0,
//                                   roomUID: result.roomUID ?? "",
//                                   roomImage: result.roomImage ?? "", roomZipCode: result.zipCode )
//             }
//         }
//         if appViewModel.isPresent == false {
//             appViewModel.isPresent = true
//         }
//         localData.sumPrice = localData.compute(source: localData.summaryItemHolder)
//     } label: {
//         SearchListItemView(roomImage: result.roomImage ?? "",
//                            roomAddress: result.roomAddress,
//                            roomTown: result.town,
//                            roomCity: result.city,
//                            roomPrice: Int(result.rentalPrice) ?? 0)
//             .alert(isPresented: $appViewModel.isPresent) {
//                 Alert(title: Text("Congrate!"), message: Text("The room is adding in the chart, also check out the furnitures if needing. Please see Payment session."), dismissButton: .default(Text("Sure")))
//             }
//     }
// }
//*/
