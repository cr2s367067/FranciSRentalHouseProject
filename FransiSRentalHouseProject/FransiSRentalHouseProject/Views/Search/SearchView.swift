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
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var searchVM: SearchViewModel

    @FocusState private var isFocused: Bool

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
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
                        TextField("", text: $searchVM.searchName)
                            .foregroundColor(.white)
                            .focused($isFocused)
                            .placeholer(when: searchVM.searchName.isEmpty) {
                                Text("Search")
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .textInputAutocapitalization(.never)
                        Button {
                            searchVM.showTags.toggle()
                        } label: {
                            Image(systemName: "tag")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .frame(height: 50)
                    .foregroundColor(.gray)
                    .background(alignment: .center) {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color("fieldGray").opacity(0.07))
                    }
                    HStack(spacing: 5) {
                        Spacer()
                        Button {
                            if searchVM.showProducts == true {
                                searchVM.showProducts = false
                            }
                            if searchVM.showRooms == false {
                                searchVM.showRooms = true
                            }
                        } label: {
                            Image(systemName: "house")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 28, height: 25)
                        }
                        Button {
                            if searchVM.showRooms == true {
                                searchVM.showRooms = false
                            }
                            if searchVM.showProducts == false {
                                searchVM.showProducts = true
                            }
                        } label: {
                            Image(systemName: "bag")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 26)
                        }
                    }
                    showTagView()
                    //: Scroll View
                    VStack {
                        identityRoomsProducts(showRooms: searchVM.showRooms, showProducts: searchVM.showProducts)
                    }
//                    .padding()
                }
                .padding()
                .frame(width: uiScreenWidth - 5)
                
            }
            .onTapGesture(perform: {
                isFocused = false
            })
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

extension SearchView {
    
    @ViewBuilder
    func showTagView() -> some View {
        if searchVM.showTags {
            VStack {
                HStack {
                    Text("City&County")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(searchVM.cityAarray, id: \.self) { city in
                            sortingTagUnit(name: city)
                                .onTapGesture {
                                    searchVM.searchName = tagCollecte(firstTag: city)
                                    let defaultValue = Cities.taipei
                                    searchVM.holderArray = searchVM.evaluateArray(par: Cities(rawValue: city) ?? defaultValue)
                                }
                        }
                    }
                }
                if !searchVM.holderArray.isEmpty {
                    HStack {
                        Text("District")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(searchVM.holderArray, id: \.self) { city in
                                sortingTagUnit(name: city)
                                    .onTapGesture {
                                        searchVM.searchName = tagCollecte(firstTag: city)
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    @ViewBuilder
    private func roomsUnit() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            //ForEach to catch the data from firebase
            ForEach(searchVM.customSearchFilter(input: firestoreToFetchRoomsData.fetchRoomInfoFormPublic, searchText: searchVM.searchName)) { result in
                NavigationLink {
                    RoomsDetailView(roomsData: result)
                } label: {
                    SearchListItemView(roomImage: result.roomImage ?? "",
                                       roomAddress: result.roomAddress,
                                       roomTown: result.town,
                                       roomCity: result.city,
                                       roomPrice: Int(result.rentalPrice) ?? 0)
                }
                .simultaneousGesture(
                    TapGesture().onEnded({ _ in
                        searchVM.searchName = ""
                        searchVM.showTags = false
                        searchVM.holderArray = []
                    })
                )
            }
        }
    }
    
    
    @ViewBuilder
    func roomUnitWithPlaceHolder() -> some View {
        if firestoreToFetchRoomsData.fetchRoomInfoFormPublic.isEmpty {
            roomsUnit()
                .disabled(true)
                .redacted(reason: .placeholder)
        } else {
            roomsUnit()
        }
    }
    
    @ViewBuilder
    private func productsUnit() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 40) {
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
                            SearchProductListItemView(productName: product.productName, productImage: product.productImage, productPrice: product.productPrice)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func productsUnitWithPlaceHolder() -> some View {
        if firestoreForProducts.productsDataSet.isEmpty {
            productsUnit()
                .disabled(true)
                .redacted(reason: .placeholder)
        } else {
            productsUnit()
        }
    }
    
    @ViewBuilder
    func identityRoomsProducts(showRooms: Bool, showProducts: Bool) -> some View {
        if showRooms == true {
            roomUnitWithPlaceHolder()
        }
        if showProducts == true {
            productsUnitWithPlaceHolder()
        }
    }
    
    @ViewBuilder
    func sortingTagUnit(name: String) -> some View {
        HStack {
            Text("#\(name)")
                .foregroundColor(.white)
        }
        .frame(width: 80 + charCount(name: name), height: 30)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 5)
                .fill(.gray.opacity(0.7))
        }
    }
    
    private func charCount(name: String) -> CGFloat {
        return CGFloat(Double(name.count) * 5)
    }
    
    private func tagCollecte(firstTag: String? = nil, secTag: String? = nil) -> String {
        return (firstTag ?? "") + (secTag ?? "")
    }
}

