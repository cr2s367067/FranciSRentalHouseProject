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
    @Published var tempCart = [RoomInfoDataModel]()
    @Published var summaryItemHolder: RoomInfoDataModel = .empty
    
    //: Maintain Task
    @Published var maintainTaskHolder: [MaintainTaskHolder] = []
    
    //: Room Information
//    @Published var localRoomsHolder: RoomInfoDataModel = .empty
    
    
    func addItem(roomsInfo: RoomInfoDataModel) {
        self.summaryItemHolder = roomsInfo
    }
    
    func compute(source: RoomInfoDataModel) -> Int {
        let newElemet = Int(source.rentalPrice) ?? 0
        return newElemet
    }
    
    func computeProductsPrice(source: [UserOrderProductsDataModel]) -> Int {
        var newElemet = 0
        for item in source {
            newElemet += item.productPrice
        }
        debugPrint(newElemet)
        return newElemet
    }
    
    func sum(productSource: [UserOrderProductsDataModel]) -> Int {
        var newValue = 0
        newValue = sum(value1: compute(source: summaryItemHolder), value2: computeProductsPrice(source: productSource))
        return newValue
    }
    
    private func sum(value1: Int, value2: Int?) -> Int {
        let _value2 = value2 ?? 0
        return value1 + _value2
    }
    
}
