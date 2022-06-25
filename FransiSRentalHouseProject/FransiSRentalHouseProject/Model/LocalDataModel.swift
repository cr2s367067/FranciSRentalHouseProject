//
//  LocalDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

class LocalData: ObservableObject {

    
    //: Payment Holder
    @Published var sumPrice = 0
    @Published var tempCart: RoomDM = .empty
    @Published var summaryItemHolder: HouseContract = .empty
    
    //: Maintain Task
    @Published var maintainTaskHolder: [MaintainTaskHolder] = []
    
    //: Room Information
//    @Published var localRoomsHolder: RoomInfoDataModel = .empty
    
    
    func addItem(roomsInfo: HouseContract) {
        self.summaryItemHolder = roomsInfo
    }
    
    func compute(source: HouseContract) -> Int {
        var newElement = 0
        let convertInt = Int(source.roomRentalPrice) ?? 0
        newElement = convertInt * 3
        return newElement
    }
    
    func computeProductsPrice(source: [ProductDM]) -> Int {
        var newElemet = 0
        for item in source {
            let selectedAmount = item.productAmount
            let multiResult = item.productPrice * selectedAmount
            newElemet += multiResult
        }
        debugPrint(newElemet)
        return newElemet
    }
    
    func sum(productSource: [ProductDM]) -> Int {
        var newValue = 0
        newValue = sum(value1: compute(source: summaryItemHolder), value2: computeProductsPrice(source: productSource))
        return newValue
    }
    
    private func sum(value1: Int, value2: Int?) -> Int {
        let _value2 = value2 ?? 0
        return value1 + _value2
    }
    
}
