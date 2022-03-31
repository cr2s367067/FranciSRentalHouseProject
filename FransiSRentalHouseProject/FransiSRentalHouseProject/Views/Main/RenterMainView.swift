//
//  RenterMainView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct RenterMainView: View {

    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreFetchingAnnouncement: FirestoreFetchingAnnouncement
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    
    var gridItemLayout = [
        GridItem(.fixed(170)),
        GridItem(.fixed(170))
    ]
    
    private func notRented() -> Bool {
        return firestoreToFetchUserinfo.fetchedUserData.rentedRoomInfo?.roomUID?.isEmpty ?? false
    }
    
    @State private var showRooms = true
    @State private var showFurniture = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    //: Announcement Group
                    Group {
                        TitleAndDivider(title: "Announcement")
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
                                Button {
                                    if showFurniture == true {
                                        showFurniture = false
                                    }
                                    if showRooms == false {
                                        showRooms = true
                                    }
                                } label: {
                                    Image(systemName: "house")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 28, height: 25)
                                }
                                Button {
                                    if showRooms == true {
                                        showRooms = false
                                    }
                                    if showFurniture == false {
                                        showFurniture = true
                                    }
                                } label: {
                                    Image(systemName: "bag")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 26)
                                }
                            }
                            HStack {
                                VStack {
                                    Divider()
                                        .background(Color.white)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 25)
                        //: New publish scrill view
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: gridItemLayout, spacing: 35) {
                                if showRooms == true {
                                    ForEach(firestoreToFetchRoomsData.fetchRoomInfoFormPublic) { result in
                                    Button {
                                        if localData.tempCart.isEmpty {
                                            if firestoreToFetchUserinfo.notRented() {
                                                localData.tempCart.append(result)
                                                localData.addItem(roomAddress: result.roomAddress,
                                                                  roomTown: result.town,
                                                                  roomCity: result.city,
                                                                  itemPrice: (Int(result.rentalPrice) ?? 0) * 3,
                                                                  roomUID: result.roomUID ,
                                                                  roomImage: result.roomImage ?? "",
                                                                  roomZipCode: result.zipCode,
                                                                  docID: result.docID ?? "",
                                                                  providerUID: result.providedBy)
                                            }
                                        } else {
                                            localData.tempCart.removeAll()
                                            localData.summaryItemHolder.removeAll()
                                            if localData.tempCart.isEmpty {
                                                localData.tempCart.append(result)
                                                if firestoreToFetchUserinfo.notRented() {
                                                    localData.addItem(roomAddress: result.roomAddress,
                                                                      roomTown: result.town,
                                                                      roomCity: result.city,
                                                                      itemPrice: (Int(result.rentalPrice) ?? 0) * 3 ,
                                                                      roomUID: result.roomUID ,
                                                                      roomImage: result.roomImage ?? "",
                                                                      roomZipCode: result.zipCode,
                                                                      docID: result.docID ?? "",
                                                                      providerUID: result.providedBy)
                                                }
                                            }
                                        }
                                        if appViewModel.isPresent == false {
                                            appViewModel.isPresent = true
                                        }
                                        localData.sumPrice = localData.compute(source: localData.summaryItemHolder)
                                        
                                    } label: {
                                        RoomsGridView(imageURL: result.roomImage ?? "",
                                                 roomTown: result.town,
                                                 roomCity: result.city,
                                                 objectPrice: Int(result.rentalPrice) ?? 0)
                                        .frame(height: 160)
                                        .alert(isPresented: $appViewModel.isPresent) {
                                            //MARK: Throw the "Have rented error to instead"
                                            Alert(title: Text("Congrate!"), message: Text("The room is adding in the chart, also check out the furnitures if needing. Please see Payment session."), dismissButton: .default(Text("Sure")))
                                        }
                                        
                                    }
                                }
                                } else if showFurniture == true {
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
                                    }
                                }
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
                            LazyHGrid(rows: gridItemLayout, spacing: 50) {
                                ForEach(firestoreToFetchRoomsData.fetchRoomInfoFormPublic) { result in
                                    Button {
                                        if localData.tempCart.isEmpty {
                                            if firestoreToFetchUserinfo.notRented() {
                                                localData.tempCart.append(result)
                                                localData.addItem(roomAddress: result.roomAddress,
                                                                  roomTown: result.town,
                                                                  roomCity: result.city,
                                                                  itemPrice: (Int(result.rentalPrice) ?? 0) * 3,
                                                                  roomUID: result.roomUID ,
                                                                  roomImage: result.roomImage ?? "",
                                                                  roomZipCode: result.zipCode,
                                                                  docID: result.docID ?? "",
                                                                  providerUID: result.providedBy)
                                            }
                                        } else {
                                            localData.tempCart.removeAll()
                                            localData.summaryItemHolder.removeAll()
                                            if localData.tempCart.isEmpty {
                                                if firestoreToFetchUserinfo.notRented() {
                                                    localData.tempCart.append(result)
                                                    localData.addItem(roomAddress: result.roomAddress,
                                                                      roomTown: result.town,
                                                                      roomCity: result.city,
                                                                      itemPrice: (Int(result.rentalPrice) ?? 0) * 3,
                                                                      roomUID: result.roomUID ,
                                                                      roomImage: result.roomImage ?? "",
                                                                      roomZipCode: result.zipCode,
                                                                      docID: result.docID ?? "", providerUID: result.providedBy )
                                                }
                                            }
                                        }
                                        if appViewModel.isPresent == false {
                                            appViewModel.isPresent = true
                                        }
                                        localData.sumPrice = localData.compute(source: localData.summaryItemHolder)
                                    } label: {
                                        RoomsGridView(imageURL: result.roomImage ?? "",
                                                 roomTown: result.town,
                                                 roomCity: result.city,
                                                 objectPrice: Int(result.rentalPrice) ?? 0)
                                        .frame(height: 160)
                                        .alert(isPresented: $appViewModel.isPresent) {
                                            Alert(title: Text("Congrate!"), message: Text("The room is adding in the chart, also check out the furnitures if needing. Please see Payment session."), dismissButton: .default(Text("Sure")))
                                        }
                                    }
                                }
                            }
                        }
                        .frame(height: 330)
                        .padding()
                    }
                    
                }
            }
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
                } catch {
                    print("some error")
                }
            }
        }
    }
    
    struct RenterMainView_Previews: PreviewProvider {
        static var previews: some View {
            RenterMainView()
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
