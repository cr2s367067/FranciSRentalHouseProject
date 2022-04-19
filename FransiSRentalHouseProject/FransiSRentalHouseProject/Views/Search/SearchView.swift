//
//  SearchView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct SearchView: View {
    
    func evaluateArray(par: Cities) -> [String] {
        switch par {
        case .taipei:
            return taipeiDistrictArray
        case .newTaipei:
            return newTaipeiDistrictArray
        case .taoyuan:
            return taoyuanDistrictArray
        case .taichung:
            return taichungDistrictArray
        case .tainan:
            return tainanDistrictArray
        case .kaohsiung:
            return kaohsiungDistrictArray
        case .hsinchu:
            return hsinchuDistrictArray
        case .miaoli:
            return miaoliDistrictArray
        case .chanhua:
            return changhuaDistrictArray
        case .nantou:
            return nantouDistrictArray
        case .yunlin:
            return yunlinDistrictArray
        case .chiayi:
            return chiayiDistrictArray
        case .pingtung:
            return pingtungDistrictArray
        case .yilan:
            return yilanDistrictArray
        case .hualien:
            return hualienDistrictArray
        case .taitung:
            return taitungDistrictArray
        case .penghu:
            return penghuDistrictArray
        case .kinmen:
            return kinmenDistrictArray
        case .matsu:
            return matsuDistrictArray
        case .keelungCity:
            return keelungDistrictArray
        case .hsinchuCity:
            return hsinchuCityArray
        case .chiayiCity:
            return chiayiCityArray
        }
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
    
    @State private var holderArray = [String]()
    
    let cityAarray: [String] = Cities.allCases.map({$0.rawValue})
    let taipeiDistrictArray: [String] = TaipeiDistrict.allCases.map({$0.rawValue})
    let newTaipeiDistrictArray: [String] = NewTaipeiDistrict.allCases.map({$0.rawValue})
    let taoyuanDistrictArray: [String] = TaoyuanDistrict.allCases.map({$0.rawValue})
    let taichungDistrictArray: [String] = TaichungDistrict.allCases.map({$0.rawValue})
    let tainanDistrictArray: [String] = TainanDistrict.allCases.map({$0.rawValue})
    let kaohsiungDistrictArray: [String] = KaohsiungDistrict.allCases.map({$0.rawValue})
    let yilanDistrictArray: [String] = YilanDistrict.allCases.map({$0.rawValue})
    let nantouDistrictArray: [String] = NantouDistrict.allCases.map({$0.rawValue})
    let hsinchuDistrictArray: [String] = HsinchuDistrict.allCases.map({$0.rawValue})
    let miaoliDistrictArray: [String] = MiaoliDistrict.allCases.map({$0.rawValue})
    let changhuaDistrictArray: [String] = ChanghuaDistrict.allCases.map({$0.rawValue})
    let yunlinDistrictArray: [String] = YunlinDistrict.allCases.map({$0.rawValue})
    let chiayiDistrictArray: [String] = ChiayiDistrict.allCases.map({$0.rawValue})
    let pingtungDistrictArray: [String] = PingtungDistrict.allCases.map({$0.rawValue})
    let taitungDistrictArray: [String] = TaitungDistrict.allCases.map({$0.rawValue})
    let hualienDistrictArray: [String] = HualienDistrict.allCases.map({$0.rawValue})
    let penghuDistrictArray: [String] = PenghuDistrict.allCases.map({$0.rawValue})
    let keelungDistrictArray: [String] = KeelungDistrict.allCases.map({$0.rawValue})
    let hsinchuCityArray: [String] = HsinchuCity.allCases.map({$0.rawValue})
    let chiayiCityArray: [String] = ChiayiCity.allCases.map({$0.rawValue})
    let matsuDistrictArray: [String] = MatsuDistrict.allCases.map({$0.rawValue})
    let kinmenDistrictArray: [String] = KinmenDistrict.allCases.map({$0.rawValue})
    
    
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                    .edgesIgnoringSafeArea([.bottom, .top])
                VStack(spacing: 10) {
                    Button {
                        holderArray = evaluateArray(par: .taipei)
                        print(holderArray)
                    } label: {
                        Text("test")
                    }
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
                    showTagView()
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
    
    @ViewBuilder
    func showTagView() -> some View {
        if showTags {
            VStack {
                HStack {
                    Text("City&County")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(cityAarray, id: \.self) { city in
                            sortingTagUnit(name: city)
                                .onTapGesture {
                                    searchName = tagCollecte(firstTag: city)
                                    let defaultValue = Cities.taipei
                                    holderArray = evaluateArray(par: Cities(rawValue: city) ?? defaultValue)
                                }
                        }
                    }
                }
                if !holderArray.isEmpty {
                    HStack {
                        Text("District")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(holderArray, id: \.self) { city in
                            sortingTagUnit(name: city)
                                .onTapGesture {
                                    searchName = tagCollecte(firstTag: city)
                                }
                        }
                    }
                }
                }
            }
        }
    }
    
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
                .simultaneousGesture(
                    TapGesture().onEnded({ _ in
                        searchName = ""
                        showTags = false
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
