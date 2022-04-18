//
//  SearchView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct SearchView: View {

    enum Cities: String, CaseIterable {
        case taipei = "Taipei"
        case newTaipei = "新北市"
        case taoyuan = "Taoyuan"
        case taichung = "Taichung"
        case tainan = "Tainan"
        case kaohsiung = "Kaohsiung"
    }
    
    enum Counties: String, CaseIterable {
        case hsinchu = "Hsinchu County"
        case miaoli = "Miaoli County"
        case chanhua = "Chanhua County"
        case nantou = "Nantou County"
        case yunlin = "Yunlin County"
        case chiayi = "Chiayi County"
        case pingtung = "Pingtung County"
        case yilan = "Yilan County"
        case hualien = "Hualien County"
        case taitung = "Taitung County"
        case penghu = "Penghu County"
        case kinmen = "Kinmen County"
        case matsu = "Matsu County"
        case keelungCity = "Keelung City"
        case hsinchuCity = "Hsinchu City"
        case chiayiCity = "Chiayi City"
    }
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    
    @State private var tagSelect = "TapSearchButton"
    @State private var searchName = ""
    @State private var isPressentSheetData: RoomInfoDataModel? = nil
    
    @State private var showTags = false
    @State private var showRooms = true
    @State private var showProducts = false
    
    @FocusState private var isFocused: Bool
    
    let cityAarray: [String] = Cities.allCases.map({$0.rawValue})
    let countyArray: [String] = Counties.allCases.map({$0.rawValue})
    
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
                        TextField("", text: $searchName)
                            .foregroundColor(.white)
                            .focused($isFocused)
                            .placeholer(when: searchName.isEmpty) {
                                Text("Search")
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .textInputAutocapitalization(.never)
                        Button {
                            showTags.toggle()
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
                            if showProducts == true {
                                showProducts = false
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
                            if showProducts == false {
                                showProducts = true
                            }
                        } label: {
                            Image(systemName: "bag")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 26)
                        }
                    }
                    if showTags {
                        HStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(cityAarray, id: \.self) { city in
                                        sortingTagUnit(name: city)
                                            .onTapGesture {
                                                searchName = tagCollecte(firstTag: city)
                                            }
                                    }
                                }
                            }
                        }
                    }
                    //: Scroll View
                    VStack {
                        identityRoomsProducts(showRooms: showRooms, showProducts: showProducts)
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

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}

extension SearchView {
    
    func address(input: RoomInfoDataModel) -> String {
        let zipCode = input.zipCode
        let city = input.city
        let town = input.town
        let address = input.roomAddress
        return zipCode + city + town + address
    }
    
    func customSearchFilter(input: [RoomInfoDataModel], searchText: String) -> [RoomInfoDataModel] {
        var tempHolder = [RoomInfoDataModel]()
        if searchText.isEmpty {
            tempHolder = input
        } else {
            tempHolder = input.filter({ search in
                let city = search.city
                let town = search.town
                let address = search.roomAddress
                let fullAddress = city + town + address
                return fullAddress.contains(searchText)
            })
        }
        return tempHolder
    }
    
    @ViewBuilder
    private func roomsUnit() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            //ForEach to catch the data from firebase
            ForEach(customSearchFilter(input: firestoreToFetchRoomsData.fetchRoomInfoFormPublic, searchText: searchName)) { result in
                NavigationLink {
                    RoomsDetailView(roomsData: result)
                } label: {
                    SearchListItemView(roomImage: result.roomImage ?? "",
                                       roomAddress: result.roomAddress,
                                       roomTown: result.town,
                                       roomCity: result.city,
                                       roomPrice: Int(result.rentalPrice) ?? 0)
                }
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
        return CGFloat(Double(name.count) * 2.3)
    }
    
    private func tagCollecte(firstTag: String?, secTag: String? = nil) -> String {
        return (firstTag ?? "") + (secTag ?? "")
    }
}

struct SortUnitView: View {
    var body: some View {
        HStack {
            Text("#台北市")
                .foregroundColor(.white)
        }
        .frame(width: 80, height: 30)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 5)
                .fill(.gray.opacity(0.7))
        }
    }
}

struct SortUnitView_Previews: PreviewProvider {
    static var previews: some View {
        SortUnitView()
    }
}

/*
 countys:
 hsinchu
 miaoli
 chanhua
 nantou
 yunlin
 chiayi
 pingtung
 yilan
 hualien
 taitung
 penghu
 kinmen
 matsu
 
 city:
 keelung
 hsinchu
 chiayi
*/
