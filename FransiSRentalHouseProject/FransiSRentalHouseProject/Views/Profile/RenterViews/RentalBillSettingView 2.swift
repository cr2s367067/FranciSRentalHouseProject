//
//  RentalBillSettingView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/11.
//

import SDWebImageSwiftUI
import SwiftUI

struct RentalBillSettingView: View {
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var renterProfileViewModel: RenterProfileViewModel
    @EnvironmentObject var paymentMethodManager: PaymentMethodManager
    @Environment(\.colorScheme) var colorScheme

    @State private var showOverview = true
    @State private var showPaymentMethod = false

    var rentalPrice: String {
        firestoreToFetchUserinfo.rentingRoomInfo.roomPrice ?? ""
    }

    var upComingPaymentDate: Date {
        paymentMethodManager.computePaymentMonth(from: Date())
    }

    var address: String {
        let zipCode = firestoreToFetchUserinfo.rentingRoomInfo.roomZipCode ?? ""
        let city = firestoreToFetchUserinfo.rentingRoomInfo.roomCity ?? ""
        let town = firestoreToFetchUserinfo.rentingRoomInfo.roomTown ?? ""
        let roomAddress = firestoreToFetchUserinfo.rentingRoomInfo.roomAddress ?? ""
        return zipCode + city + town + roomAddress
    }

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    var body: some View {
        VStack {
            switchBar()
            VStack {
                switchView(showOverView: showOverview, showPaymentMethod: showPaymentMethod)
            }
            .padding()
            .frame(width: uiScreenWidth - 20, alignment: .center)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .dark ? Color.gray.opacity(0.5) : Color.white)
            }
            Spacer()
        }
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
        })
//        .onDisappear(perform: {
//            UITableView.appearance().backgroundColor = .systemBackground
//        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(alignment: .center) {
            LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea([.top, .bottom])
        }
        .task {
            do {
//                _ = try await firestoreToFetchUserinfo.getSummittedContract(uidPath: firebaseAuth.getUID())
                let currentDate = Date()
                if currentDate == firestoreToFetchUserinfo.rentedContract.rentalEndDate {
                    try await renterProfileViewModel.eraseExpiredRoomInfo(from: currentDate, to: firestoreToFetchUserinfo.rentedContract.rentalEndDate, docID: firestoreToFetchUserinfo.rentedContract.docID)
                }
                try await firestoreToFetchRoomsData.getPostComment(roomUID: firestoreToFetchUserinfo.rentedContract.docID, uidPath: firebaseAuth.getUID())
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension RentalBillSettingView {
    @ViewBuilder
    func renewButton() -> some View {
        if Date() == firestoreToFetchUserinfo.rentedContract.rentalEndDate {
            NavigationLink {
                SearchView()
            } label: {
                Text("Un-Rented")
                    .frame(width: 108, height: 35)
                    .background(Color("fieldGray"))
                    .cornerRadius(10)
            }
        } else {
            Button {
                renterProfileViewModel.noticeAlert.toggle()
                renterProfileViewModel.isRenewable(from: Date(), to: firestoreToFetchUserinfo.rentedContract.rentalEndDate)
            } label: {
                Text(renterProfileViewModel.readyToRenew ? "Yes" : "No")
                    .frame(width: 108, height: 35)
                    .background(Color("fieldGray"))
                    .cornerRadius(10)
            }
            .alert("Notice", isPresented: $renterProfileViewModel.noticeAlert, actions: {
                Button {
                    renterProfileViewModel.noticeAlert = false
                } label: {
                    Text("Okay")
                }
            }, message: {
                Text(renterProfileViewModel.noticeMessage)
            })
        }
    }

    @ViewBuilder
    func addressUnit() -> some View {
        Section {
            Text(address)
                .foregroundColor(.primary)
                .font(.system(size: 15, weight: .regular))
        } header: {
            Text("Address")
                .foregroundColor(.primary)
        }
    }

    @ViewBuilder
    func rentalPriceUnit() -> some View {
        Section {
            Text(address)
                .foregroundColor(.primary)
                .font(.system(size: 15, weight: .regular))
        } header: {
            Text("Address")
                .foregroundColor(.primary)
        }
    }

    @ViewBuilder
    func renewUnit() -> some View {
        Section {
            HStack {
                Text("Renew")
                Spacer()
                renewButton()
            }
        } header: {
            Text("Renew Status")
                .foregroundColor(.primary)
        }
    }

    @ViewBuilder
    func contractUnit() -> some View {
        Section {
            NavigationLink {
                PresentContract(contractData: firestoreToFetchUserinfo.rentedContract)
            } label: {
                Text("Show Contract")
                    .foregroundColor(.primary)
            }
        } header: {
            Text("Contract Status")
                .foregroundColor(.primary)
        }
    }

    @ViewBuilder
    func CommentAndRate() -> some View {
        Section {
            NavigationLink {
                RoomCommentAndRattingView(contractInfo: firestoreToFetchUserinfo.rentedContract, firestoreUserInfo: firestoreToFetchUserinfo)
            } label: {
                Text("Give Comment")
                    .foregroundColor(.primary)
            }
        } header: {
            Text("Comment And Ratting")
                .foregroundColor(.primary)
        }
    }

    @ViewBuilder
    func paymentUnit() -> some View {
        Section {
            VStack(spacing: 10) {
                HStack {
                    Text(upComingPaymentDate, format: Date.FormatStyle().year().month().day())
                        .font(.system(size: 15))
                        .foregroundColor(.primary)
                    Spacer()
                    Text("$\(rentalPrice)")
                        .foregroundColor(.primary)
                }
                NavigationLink {
                    PurchaseView(roomsData: localData.summaryItemHolder)
                } label: {
                    Text("Unpaid")
                        .foregroundColor(.blue)
                        .font(.system(size: 15))
                }
            }
            .padding()
        } header: {
            Text("Payment")
                .foregroundColor(.primary)
        }
    }

    @ViewBuilder
    func roomsInfoFormView() -> some View {
        Form {
            addressUnit()
            paymentUnit()
            renewUnit()
            contractUnit()
            CommentAndRate()
        }
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.gray.opacity(0.2))
        }
    }

    @ViewBuilder
    func autoPaymentUnit() -> some View {
        Section {
            NavigationLink {} label: {
                Text("Auto Payment Setting")
                    .foregroundColor(.primary)
                    .font(.system(size: 15))
            }
        } header: {
            Text("Auto Payment Setting")
                .foregroundColor(.primary)
        }
    }

    @ViewBuilder
    func paymentMethodView() -> some View {
        Form {
            Section {
                NavigationLink {
                    AutoPaymentSettingView()
                } label: {
                    Text("Automatic Payment Setting")
                        .foregroundColor(.primary)
                }
            } header: {
                Text("AutoPay Setting")
                    .foregroundColor(.primary)
            }
            Section {
                Button {} label: {
                    HStack {
                        Image(systemName: "creditcard")
                            .font(.system(size: 25))
                            .foregroundColor(.primary)
                        Text("test")
                            .foregroundColor(.primary)
                            .font(.system(size: 18))
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .font(.system(size: 15))
                            .foregroundColor(.primary)
                    }
                }
            } header: {
                Text("Card Setting")
                    .foregroundColor(.primary)
            }

            Section {
                HStack {
                    Text("$9000")
                    Spacer()
                    Text("paymnet Date")
                }
                .foregroundColor(.primary)
                .font(.system(size: 18))
            } header: {
                Text("Payment History")
                    .foregroundColor(.primary)
            }
        }
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.gray.opacity(0.2))
        }
    }

    @ViewBuilder
    func switchBar() -> some View {
        HStack(alignment: .center, spacing: 30) {
            Button {
                if showOverview == false {
                    showOverview = true
                }
                if showPaymentMethod == true {
                    showPaymentMethod = false
                }
            } label: {
                VStack {
                    Image(systemName: "text.redaction")
                        .font(.system(size: 30))
                    Text("Overview")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(.white.opacity(showOverview ? 1 : 0.5))
            }
            Button {
                if showPaymentMethod == false {
                    showPaymentMethod = true
                }
                if showOverview == true {
                    showOverview = false
                }
            } label: {
                VStack {
                    Image(systemName: "creditcard")
                        .font(.system(size: 30))
                    Text("Payment Method")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(.white.opacity(showPaymentMethod ? 1 : 0.5))
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
    }

    @ViewBuilder
    func switchView(showOverView: Bool, showPaymentMethod: Bool) -> some View {
        if showOverView == true {
            roomsInfoFormView()
        }
        if showPaymentMethod == true {
            paymentMethodView()
        }
    }
}

struct CustomSectionUnit: View {
    var rentalPrice: String
    var paidDate: Date
    var body: some View {
        HStack {
            Text("$\(rentalPrice)")
            Spacer()
            Text(paidDate, format: Date.FormatStyle().year().month().day())
        }
        .foregroundColor(.primary)
        .font(.system(size: 18))
    }
}
