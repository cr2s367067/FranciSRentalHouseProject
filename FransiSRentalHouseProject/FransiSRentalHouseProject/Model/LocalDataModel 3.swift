//
//  LocalDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import FirebaseFirestoreSwift
import Foundation
import SwiftUI

class LocalData: ObservableObject {
    //: Payment Holder
    @Published var sumPrice = 0
    @Published var tempCart: RoomInfoDataModel = .empty
    @Published var summaryItemHolder: RoomInfoDataModel = .empty

    //: Maintain Task
    @Published var maintainTaskHolder: [MaintainTaskHolder] = []

    //: Room Information
//    @Published var localRoomsHolder: RoomInfoDataModel = .empty

    func addItem(roomsInfo: RoomInfoDataModel) {
        summaryItemHolder = roomsInfo
    }

    func compute(source: RoomInfoDataModel) -> Int {
        var newElement = 0
        let convertInt = Int(source.rentalPrice) ?? 0
        newElement = convertInt * 3
        return newElement
    }

    func computeProductsPrice(source: [UserOrderProductsDataModel]) -> Int {
        var newElemet = 0
        for item in source {
            let selectedAmount = Int(item.orderAmount) ?? 0
            let multiResult = item.productPrice * selectedAmount
            newElemet += multiResult
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
