////
////  RoomStatusView.swift
////  FransiSRentalHouseProject
////
////  Created by JerryHuang on 2/23/22.
////
//
// import SwiftUI
// import SDWebImageSwiftUI
//
// struct RoomStatusView: View {
//    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
//    @EnvironmentObject var localData: LocalData
//    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
//    @EnvironmentObject var firebaseAuth: FirebaseAuth
//    @EnvironmentObject var errorHandler: ErrorHandler
//    @EnvironmentObject var renterProfileViewModel: RenterProfileViewModel
//
//    var roomImageURL: String {
//        firestoreToFetchUserinfo.rentingRoomInfo.roomImageCover ?? ""
//    }
//
//    var rentalPrice: String {
//        firestoreToFetchUserinfo.rentingRoomInfo.roomPrice ?? ""
//    }
//
//    var roomAddress: String {
//        firestoreToFetchUserinfo.rentingRoomInfo.roomAddress ?? ""
//    }
//
//    var roomCityAndTown: String {
//        let city = firestoreToFetchUserinfo.rentingRoomInfo.roomCity ?? ""
//        let town = firestoreToFetchUserinfo.rentingRoomInfo.roomTown ?? ""
//        return city + town
//    }
//
//    var roomZipCode: String {
//        firestoreToFetchUserinfo.rentingRoomInfo.roomZipCode ?? ""
//    }
//
//    let uiScreenWidth = UIScreen.main.bounds.width
//    let uiScreenHeigth = UIScreen.main.bounds.height
//
//    var body: some View {
//        ZStack {
//            Rectangle()
//                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
//                .ignoresSafeArea(.all)
//            VStack {
//                VStack {
//                    HStack {
//                        VStack {
//                            HStack {
//                                WebImage(url: URL(string: roomImageURL))
//                                    .resizable()
//                                    .frame(width: 100, height: 100)
//                                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                                VStack(alignment: .leading, spacing: 3) {
//                                    Text(roomZipCode)
//                                    Text(roomCityAndTown)
//                                    Text(roomAddress)
//                                }
//                                .foregroundColor(.black)
//                                .font(.system(size: 18, weight: .medium))
//                                .padding(.leading, 10)
//                            }
//                            Spacer()
//                        }
//                        Spacer()
//                    }
//                    VStack(alignment: .center, spacing: 10) {
//                        HStack(spacing: 1) {
//                            Text("Monthly Rental Price: ")
//                                .foregroundColor(.white)
//                            Spacer()
//                            Text("$\(rentalPrice)")
//                                .foregroundColor(.white)
//                                .padding(.leading, 1)
//                        }
//                        HStack(spacing: 1) {
//                            Text("Expired Date: ")
//                                .foregroundColor(.white)
//                            Spacer()
//                            Text(firestoreToFetchUserinfo.rentedContract.rentalEndDate, format: Date.FormatStyle().year().month().day())
//                                .foregroundColor(.white)
//                                .padding(.leading, 1)
//
//                        }
//
//                        HStack {
//                            Text("Pay Rental Bill: ")
//                                .foregroundColor(.white)
//                            Spacer()
//                            NavigationLink {
////                                PurchaseView(roomsData: localData.summaryItemHolder)
//                                RentalBillSettingView()
//                            } label: {
//                                 Text("Setting")
//                                    .frame(width: 108, height: 35)
//                                    .background(Color("fieldGray"))
//                                    .cornerRadius(10)
//                            }
//                        }
//
//                        HStack(spacing: 1) {
//                            Text("Renew: ")
//                                .foregroundColor(.white)
//                            Spacer()
//                            renewButton()
//                            .padding(.leading, 1)
//                        }
//                        HStack(spacing: 1) {
//                            Text("Contract: ")
//                                .foregroundColor(.white)
//                            Spacer()
//                            NavigationLink {
//                                PresentContract(contractData: firestoreToFetchUserinfo.rentedContract)
//                            } label: {
//                                Text("show")
//                                    .frame(width: 108, height: 35)
//                                    .background(Color("fieldGray"))
//                                    .cornerRadius(10)
//                            }
//                            .padding(.leading, 1)
//                        }
//                    }
//                }
//                .padding()
//                .frame(width: uiScreenWidth - 40, height: uiScreenHeigth / 3 + 50)
//                .background(alignment: .top) {
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color("sessionBackground"))
//                }
//                Spacer()
//            }
//        }
//        .onAppear {
//            firestoreToFetchUserinfo.userRentedRoomInfo()
//        }
//        .task {
//            do {
//                _ = try await firestoreToFetchUserinfo.getSummittedContract(uidPath: firebaseAuth.getUID())
//                let currentDate = Date()
//                if currentDate == firestoreToFetchUserinfo.rentedContract.rentalEndDate {
//                    try await renterProfileViewModel.eraseExpiredRoomInfo(from: currentDate, to: firestoreToFetchUserinfo.rentedContract.rentalEndDate, docID: firestoreToFetchUserinfo.rentedContract.docID)
//                }
//            } catch {
//                self.errorHandler.handle(error: error)
//            }
//
//        }
//        .navigationTitle("")
//        .navigationBarTitleDisplayMode(.inline)
//    }
// }
//
// struct RoomStatusView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomStatusView()
//    }
// }
//
// extension RoomStatusView {
//    @ViewBuilder
//    func renewButton() -> some View {
//        if Date() == firestoreToFetchUserinfo.rentedContract.rentalEndDate {
//            NavigationLink {
//                SearchView()
//            } label: {
//                Text("Un-Rented")
//                    .frame(width: 108, height: 35)
//                    .background(Color("fieldGray"))
//                    .cornerRadius(10)
//            }
//        } else {
//            Button {
//                renterProfileViewModel.noticeAlert.toggle()
//                renterProfileViewModel.isRenewable(from: Date(), to: firestoreToFetchUserinfo.rentedContract.rentalEndDate)
//            } label: {
//                Text(renterProfileViewModel.readyToRenew ? "Yes" : "No")
//                    .frame(width: 108, height: 35)
//                    .background(Color("fieldGray"))
//                    .cornerRadius(10)
//            }
//            .alert("Notice", isPresented: $renterProfileViewModel.noticeAlert, actions: {
//                Button {
//                    renterProfileViewModel.noticeAlert = false
//                } label: {
//                    Text("Okay")
//                }
//            }, message: {
//                Text(renterProfileViewModel.noticeMessage)
//            })
//        }
//    }
//
//    @ViewBuilder
//    func rentalBillSetting() -> some View {
//
//    }
// }
