//
//  RenterMainView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct RenterMainView: View {

    @EnvironmentObject var storageForProductImage: StorageForProductImage
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreFetchingAnnouncement: FirestoreFetchingAnnouncement
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var renterProfileViewModel: RenterProfileViewModel
    @EnvironmentObject var paymentMg: PaymentMethodManager
    @EnvironmentObject var fireMessage: FirestoreForTextingMessage
    
    
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    
    @State private var dragCompleted = false
    
    var gridItemLayout = [
        GridItem(.fixed(170)),
        GridItem(.fixed(170))
    ]
    
    private func notRented() -> Bool {
        return firestoreToFetchUserinfo.fetchedUserData.rentedRoomInfo?.roomUID?.isEmpty ?? false
    }
    
    @State private var showRooms = true
//    @State private var showFurniture = false
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    //: Announcement Group
//                    Button("Crash") {
//                        fatalError("Crash was triggered")
//                    }
//                    Button("test") {
//                        paymentMg.testapi()
//                        Task {
//                            do {
//                                let currentDate = Date().getFormatterDate(format: "yyyy-mm-dd HH:mm:ss")
//
//                                try await paymentMg.callServerToken(envPath: .testEnv,
//                                                         httpMethod: .post,
//                                                         httpContent: .contentType,
//                                                         rememberCard: .no,
//                                                         paymentUIT: .paymentChosingList,
//                                                         orderInfo: OrderInfoDM(MerchantTradeDate: currentDate,
//                                                                                MerchantTradeNo: "3002607",
//                                                                                TotalAmount: 500,
//                                                                                ReturnURL: "",
//                                                                                TradeDesc: "test",
//                                                                                ItemName: "test"),
//                                                         cardInfo: CardInfoDM(Redeem: "0",
//                                                                              OrderResultURL: "https://www.ecpay.com.tw",
//                                                                              CreditInstallment: "3"),
//                                                         consumerInfo: ConsumerInfoDM(Email: "testuser@test.com",
//                                                                                      Phone: "886987878787",
//                                                                                      Name: "test",
//                                                                                      CountryCode: "158",
//                                                                                      Address: "testAddress"))
//                            } catch {
//                                print("error occur: \(error.localizedDescription)")
//                            }
//                        }
//                    }
//                    NavigationLink("test web") {
//                        WebView(text: $paymentMg.getResultHolder)
//                    }
//                    Button("test") {
//                        Task {
//                            do {
//                                try await firebaseAuth.checkAndUpdateToken(oldToken: fireMessage.senderUIDPath.userToken, uidPath: firebaseAuth.getUID())
//                            } catch {
//                                print("error")
//                            }
//                        }
//                    }
                    Group {
                        VStack(alignment: .leading, spacing: 1) {
                            HStack {
                                Text("Announcement")
                                    .font(.system(size: 24, weight: .heavy))
                                    .foregroundColor(Color.white)
                                    .accessibilityIdentifier("announcement")
                                Spacer()
                                NavigationLink(isActive: $dragCompleted) {
                                    MessageMainView()
                                } label: {
                                    Image(systemName: "message")
                                        .foregroundColor(.white)
                                        .font(.system(size: 30))
                                }
                            }
                            HStack {
                                VStack {
                                    Divider()
                                        .background(Color.white)
                                }
                            }
                        }
                        .frame(width: uiScreenWidth - 25)
                        VStack(alignment: .leading) {
                            ForEach(firestoreFetchingAnnouncement.announcementDataSet) { anno in
                                AnnouncementView(announcement: anno.announcement ?? "")
                            }
                        }
                    }
                    //: New rooms Group
                    Group {
                        VStack(alignment: .leading, spacing: 1) {
                            HStack {
                                Text("What's new")
                                    .font(.system(size: 24, weight: .heavy))
                                    .foregroundColor(Color.white)
                                Spacer()
                                Toggle("", isOn: $showRooms)
                                    .toggleStyle(CustomToggleStyle())
                                    .accessibilityIdentifier("presentSwitch")
                            }
                            HStack {
                                VStack {
                                    Divider()
                                        .background(Color.white)
                                }
                            }
                        }
                        .frame(width: uiScreenWidth - 25)
                        //: New publish scrill view
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: gridItemLayout, spacing: 35) {
                                elementSwitch(showRooms: showRooms)
                            }
                            .frame(height: 330)
                            .padding()
                        }
                    }
                    
                    //: Everybody's facorite
                    Group {
                        TitleAndDivider(title: "What's Everybody Favorite")
                        //: New publish scrill view
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: gridItemLayout, spacing: 35) {
//                                elementSwitch(showRooms: showRooms)
                            }
                            .frame(height: 330)
                            .padding()
                        }
                    }
                    
                }
            }
            .gesture(
                DragGesture(minimumDistance: 10)
                    .onEnded({ gesture in
                        if gesture.startLocation.x > gesture.predictedEndLocation.x {
                            dragCompleted = true
                        }
                    })
            )
            .background {
                LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea([.top, .bottom])
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .task {
                do {
                    try await firestoreFetchingAnnouncement.fetchAnnouncement()
                    try await firestoreForProducts.fetchMarkedProducts(uidPath: firebaseAuth.getUID())
                    guard !firestoreToFetchUserinfo.fetchedUserData.id.isEmpty else { return }
                    _ = try await fireMessage.fetchStoredUserData(uidPath: firebaseAuth.getUID())
                    try await firebaseAuth.checkAndUpdateToken(oldToken: fireMessage.senderUIDPath.userToken, uidPath: firebaseAuth.getUID())
                } catch {
                    print("some error")
                }
            }
        }
    }
}


struct AnnouncementView: View {
    var announcement: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 5, height: 5)
                Text(announcement)
                    .foregroundColor(Color.white)
                    .font(.system(size: 18, weight: .regular))
                    .padding(.bottom, 5)
                Spacer()
            }
            .padding(.leading)
        }
    }
}

extension RenterMainView {
    
    private func checkUserInfo() throws {
        guard !firestoreToFetchUserinfo.fetchedUserData.id.isEmpty else {
            throw UserInformationError.registeError
        }
    }
    
    @ViewBuilder
    func elementSwitch(showRooms: Bool) -> some View {
        if showRooms {
            showRoomsElement()
        } else {
            showProductElement()
            
        }
    }
    
    @ViewBuilder
    func showRoomsElement() -> some View {
        ForEach(firestoreToFetchRoomsData.fetchRoomInfoFormPublic) { result in
            NavigationLink {
                RoomsDetailView(roomsData: result)
            } label: {
                RoomsGridView(imageURL: result.roomImage ?? "",
                              roomTown: result.town,
                              roomCity: result.city,
                              objectPrice: Int(result.rentalPrice) ?? 0)
//                .frame(height: uiScreenHeight / 8)
                .alert(isPresented: $appViewModel.isPresent) {
                    //MARK: Throw the "Have rented error to instead"
                    Alert(title: Text("Congrate!"), message: Text("The room is adding in the chart, also check out the furnitures if needing. Please see Payment session."), dismissButton: .default(Text("Sure")))
                }
            }
            .simultaneousGesture(TapGesture().onEnded({ _ in
                Task {
                    do {
                        guard let id = result.id else { return }
                        try await firestoreToFetchRoomsData.getCommentDataSet(roomUID: id)
                    } catch {
                        self.errorHandler.handle(error: error)
                    }
                }
            }))
        }
    }
    
    @ViewBuilder
    func showProductElement() -> some View {
        ForEach(firestoreForProducts.productsDataSet) { product in
            NavigationLink {
                ProductDetailView(productName: product.productName,
                                  productPrice: Int(product.productPrice) ?? 0,
                                  productImage: product.productImage,
                                  productUID: product.productUID,
                                  productAmount: product.productAmount,
                                  productFrom: product.productFrom,
                                  providerUID: product.providerUID,
                                  isSoldOut: product.isSoldOut,
                                  providerName: product.providerName,
                                  productDescription: product.productDescription, docID: product.id ?? "")
            } label: {
                FurnitureGridView(productIamge: product.productImage, productName: product.productName, productPrice: Int(product.productPrice) ?? 0)
            }
            .accessibilityIdentifier("testProduct")
            .simultaneousGesture(
                TapGesture().onEnded({ _ in
                    Task {
                        do {
                            try await storageForProductImage.getProductImages(providerUidPath: product.providerUID, productUID: product.productUID)
                        } catch {
                            self.errorHandler.handle(error: error)
                        }
                    }
                })
            )
        }
    }
    
    
}
