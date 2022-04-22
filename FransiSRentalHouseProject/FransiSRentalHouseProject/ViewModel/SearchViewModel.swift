//
//  SearchViewModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/19.
//

import Foundation


class SearchViewModel: ObservableObject {
    
    
    
    @Published var isPressentSheetData: RoomInfoDataModel? = nil
    @Published var searchName = ""
    @Published var holderArray = [String]()
    @Published var showTags = false
    @Published var showRooms = true
    @Published var showProducts = false
    @Published var showStores = false
    @Published var showProductTags = false
    
    //MARK: For rooms
    
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
    
    func filterProductByTags(input: [ProductProviderDataModel], tags: String) -> [ProductProviderDataModel] {
        var sortedHolder = [ProductProviderDataModel]()
        sortedHolder = input.filter({ tag in
            tag.productType.contains(tags) || tag.productName.contains(tags)
        })
        return sortedHolder
    }
    
    func filterStore(input: [StoreDataModel], name: String) -> [StoreDataModel] {
        var resultArray = [StoreDataModel]()
        if name.isEmpty {
            resultArray = input
        } else {
            resultArray = input.filter({ store in
                store.providerDisplayName.contains(name)
            })
        }
        return resultArray
    }
    
    
    //MARK: For products
    let groceryTypesArray: [String] = GroceryTypes.allCases.map({$0.rawValue})
}
