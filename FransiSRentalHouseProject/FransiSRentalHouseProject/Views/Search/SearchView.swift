//
//  SearchView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    
    @EnvironmentObject var storageForProductImage: StorageForProductImage
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var searchVM: SearchViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firebaseAuth: FirebaseAuth

    @Environment(\.colorScheme) var colorScheme

    @FocusState private var isFocused: Bool

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
//                Spacer()
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
                        .fill(colorScheme == .dark ? .gray.opacity(0.4) : Color("fieldGray").opacity(0.07))
                }
                HStack(spacing: 5) {
                    Spacer()
                    Toggle("", isOn: $searchVM.showRooms)
                        .toggleStyle(CustomToggleStyle())
                }
                showTagView(isRooms: searchVM.showRooms)
                //: Scroll View
                ScrollView(.vertical, showsIndicators: false) {
                    identityRoomsProducts(showRooms: searchVM.showRooms, showProducts: searchVM.showProducts)
                }
            }
            .modifier(ViewBackgroundInitModifier())
            .onTapGesture(perform: {
                isFocused = false
            })
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

extension SearchView {
    
    @ViewBuilder
    func storeAccessUnit(storeData: StoreDataModel) -> some View {
        VStack {
            HStack {
                WebImage(url: URL(string: storeData.providerProfileImage))
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
            HStack {
                Text(storeData.providerDisplayName)
                    .modifier(StoreTextModifier())
                    .font(.headline)
                Spacer()
            }
            HStack {
                Text("Description")
                    .modifier(StoreTextModifier())
                    .font(.headline)
                Spacer()
            }
            HStack {
                Text(storeData.providerDescription)
                    .modifier(StoreTextModifier())
                    .font(.body)
                Spacer()
            }
        }
        .padding(.horizontal)
        .frame(width: uiScreenWidth - 20, height: uiScreenHeight / 5 + 60)
        .background(alignment: .center) {
            WebImage(url: URL(string: storeData.storeBackgroundImage))
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 20))
            RoundedRectangle(cornerRadius: 20)
                .fill(.black.opacity(0.4))
            
        }
    }
    
    @ViewBuilder
    func showTagView(isRooms: Bool) -> some View {
        if searchVM.showTags {
            if isRooms {
                roomTags()
            } else {
                productTags()
            }
        }
    }
    
    @ViewBuilder
    func roomTags() -> some View {
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
    
    @ViewBuilder
    func productTags() -> some View {
        VStack {
            HStack {
                Text("Types")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(searchVM.groceryTypesArray, id: \.self) { products in
                        sortingTagUnit(name: products)
                            .onTapGesture {
//                                searchVM.showStores = false
                                searchVM.showProducts = true
                                searchVM.searchName = tagCollecte(firstTag: products)
                            }
                    }
                }
            }
        }
    }
    
    
    
    @ViewBuilder
    private func roomsUnit() -> some View {
//        ScrollView(.vertical, showsIndicators: false) {
            //ForEach to catch the data from firebase
            ForEach(searchVM.customSearchFilter(input: firestoreToFetchRoomsData.fetchRoomInfoFormPublic, searchText: searchVM.searchName)) { result in
                NavigationLink {
                    RoomsDetailView(roomsData: result)
                } label: {
                    SearchListItemView(roomsData: result)
                }
                .simultaneousGesture(
                    TapGesture().onEnded({ _ in
                        searchVM.searchName = ""
                        searchVM.showTags = false
                        searchVM.holderArray = []
                        Task {
                            do {
                                guard let id = result.id else { return }
                                try await firestoreToFetchRoomsData.getCommentDataSet(roomUID: id)
                            } catch {
                                self.errorHandler.handle(error: error)
                            }
                        }

                    })
                )
            }
//        }
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
//        ScrollView(.vertical, showsIndicators: false) {
            ForEach(searchVM.filterProductByTags(input: firestoreForProducts.productsDataSet, tags: searchVM.searchName, searchText: searchVM.searchName)) { product in
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
                    SearchProductListItemView(productName: product.productName, productImage: product.productImage, productPrice: product.productPrice, productDes: product.productDescription)
                }
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
//        }
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
        if showRooms {
            roomUnitWithPlaceHolder()
        } else {
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

