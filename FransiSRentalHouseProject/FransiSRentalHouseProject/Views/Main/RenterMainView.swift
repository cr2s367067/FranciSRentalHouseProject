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
//    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreFetchingAnnouncement: FirestoreFetchingAnnouncement
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var renterProfileViewModel: RenterProfileViewModel
    @EnvironmentObject var paymentMg: PaymentMethodManager
    @EnvironmentObject var fireMessage: FirestoreForTextingMessage
    @EnvironmentObject var renterMainVM: RenterMainVM

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    @State private var dragCompleted = false

    var gridItemLayout = [
        GridItem(.fixed(170)),
        GridItem(.fixed(170)),
    ]

    @State private var showRooms = true
//    @State private var showFurniture = false

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    // MARK: - Announcement Group

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

                    // MARK: - New rooms Group

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

                        // MARK: - New publish scrill view

                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: gridItemLayout, spacing: 35) {
                                elementSwitch(showRooms: showRooms)
                            }
                            .frame(height: 330)
                            .padding()
                        }
                    }

                    // MARK: - Everybody's facorite

                    Group {
                        TitleAndDivider(title: "What's Everybody Favorite")

                        // MARK: - New publish scrill view

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
                    .onEnded { gesture in
                        if gesture.startLocation.x > gesture.predictedEndLocation.x {
                            dragCompleted = true
                        }
                    }
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
                    if firestoreToFetchUserinfo.fetchedUserData.isRented {                    
                        try await firestoreForProducts.fetchMarkedProducts(uidPath: firebaseAuth.getUID())
                    }
                    guard !firestoreToFetchUserinfo.userIDisEmpty() else { return }
                    _ = try await fireMessage.fetchStoredUserData(uidPath: firebaseAuth.getUID())
                    try await firebaseAuth.checkAndUpdateToken(
                        oldToken: fireMessage.senderUIDPath.userToken,
                        uidPath: firebaseAuth.getUID()
                    )
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
                RoomsGridView(roomsData: result)
//                .frame(height: uiScreenHeight / 8)
                    .alert(isPresented: $renterMainVM.isPresent) {
                        // MARK: Throw the "Have rented error to instead"

                        Alert(title: Text("Congrate!"), message: Text("The room is adding in the chart, also check out the furnitures if needing. Please see Payment session."), dismissButton: .default(Text("Sure")))
                    }
            }
            .simultaneousGesture(TapGesture().onEnded { _ in
                Task {
                    do {
                        guard let id = result.id else { return }
                        try await firestoreToFetchRoomsData.getCommentDataSet(roomUID: id)
                    } catch {
                        self.errorHandler.handle(error: error)
                    }
                }
            })
        }
    }

    @ViewBuilder
    func showProductElement() -> some View {
        ForEach(firestoreForProducts.publicProductDataSet) { product in
            NavigationLink {
//                ProductDetailView(
//                    productName: product.productName,
//                    productPrice: Int(product.productPrice) ?? 0,
//                    productImage: product.productImage,
//                    productUID: product.productUID,
//                    productAmount: product.productAmount,
//                    productFrom: product.productFrom,
//                    providerUID: product.providerUID,
//                    isSoldOut: product.isSoldOut,
//                    providerName: product.providerName,
//                    productDescription: product.productDescription, docID: product.id ?? ""
//                )
            } label: {
                FurnitureGridView(productDM: product)
            }
            .accessibilityIdentifier("testProduct")
            .simultaneousGesture(
                TapGesture().onEnded { _ in
                    Task {
                        do {
                            try await storageForProductImage.getProductImages(providerUidPath: product.providerUID, productUID: product.productUID)
                        } catch {
                            self.errorHandler.handle(error: error)
                        }
                    }
                }
            )
        }
    }
}
