//
//  SearchView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firestoreForFurniture: FirestoreForProducts
    
    @State private var tagSelect = "TapSearchButton"
    @State private var searchName = ""
    @State private var isPressentSheetData: RoomInfoDataModel? = nil
    
    @State private var showRooms = true
    @State private var showFurniture = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                    .edgesIgnoringSafeArea([.bottom, .top])
                VStack(spacing: 10) {
                    Spacer()
                    //: Search TextField For Temp
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding(.leading)
                        TextField("", text: $searchName)
                            .placeholer(when: searchName.isEmpty) {
                                Text("Search")
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .textInputAutocapitalization(.never)
                    }
                    .frame(width: 400, height: 50)
                    .foregroundColor(.gray)
                    .background(Color("fieldGray").opacity(0.07))
                    .cornerRadius(10)
                    .fixedSize(horizontal: true, vertical: true)
                    HStack(spacing: 5) {
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
                    .padding(.horizontal)
                    .padding(.trailing)
                    //: Scroll View
                    VStack {
                        if showRooms == true {
                            ScrollView(.vertical, showsIndicators: false) {
                                //ForEach to catch the data from firebase
                                ForEach(firestoreToFetchRoomsData.fetchRoomInfoFormPublic.filter({
                                    searchName.isEmpty ? true : $0.town.contains(searchName)
                                })) { result in
                                    Button {
                                        isPressentSheetData = result
                                    } label: {
                                        SearchListItemView(roomImage: result.roomImage ?? "",
                                                           roomAddress: result.roomAddress,
                                                           roomTown: result.town,
                                                           roomCity: result.city,
                                                           roomPrice: Int(result.rentalPrice) ?? 0)
                                    }
                                }
                                .sheet(item: $isPressentSheetData) { result in
                                    RoomDetailSheetView(roomImage: result.roomImage ?? "",
                                                        roomAddress: result.roomAddress,
                                                        roomTown: result.town,
                                                        roomCity: result.city,
                                                        roomPrice: Int(result.rentalPrice) ?? 0,
                                                        roomUID: result.roomUID ,
                                                        roomZipCode: result.zipCode,
                                                        docID: result.docID ?? "",
                                                        providedBy: result.providedBy,
                                                        providedName: result.providerDisplayName ,
                                                        result: result, chatDocID: result.providerChatDocId)
                                }
                            }
                            
                        } else if showFurniture == true {
                            ScrollView(.vertical, showsIndicators: false) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 40) {
                                        ForEach(firestoreForFurniture.productsDataSet) { product in
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
                                                                  productDescription: product.productDescription)
                                            } label: {
                                                SearchProductListItemView(productName: product.productName, productImage: product.productImage, productPrice: product.productPrice)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}



/*
 

*/
