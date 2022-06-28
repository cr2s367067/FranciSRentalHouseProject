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
    // MARK: - Rooms Rented Holder

    @Published var roomRenting: RoomDM = .empty
    @Published var rentingContractHolder: HouseContract = .empty

    //: Payment Holder
    @Published var sumPrice = 0
    @Published var tempCart: RoomDM = .empty

    //: Maintain Task
    @Published var maintainTaskHolder: [MaintainTaskHolder] = []

    //: Room Information
//    @Published var localRoomsHolder: RoomInfoDataModel = .empty

    func addItem(roomsInfo: HouseContract) {
        rentingContractHolder = roomsInfo
    }

    func compute(source: HouseContract) -> Int {
        var newElement = 0
        let convertInt = Int(source.roomRentalPrice) ?? 0
        newElement = convertInt * 3
        return newElement
    }

    func computeProductsPrice(source: [ProductCartDM]) -> Int {
        var newElemet = 0
        for item in source {
            let selectedAmount = item.orderAmount
            let priceConvertInt = Int(item.product.productPrice) ?? 0
            let multiResult = priceConvertInt * selectedAmount
            newElemet += multiResult
        }
        debugPrint(newElemet)
        return newElemet
    }

    func sum(productSource: [ProductCartDM]) -> Int {
        var newValue = 0
        newValue = sum(value1: compute(source: rentingContractHolder), value2: computeProductsPrice(source: productSource))
        return newValue
    }

    private func sum(value1: Int, value2: Int?) -> Int {
        let _value2 = value2 ?? 0
        return value1 + _value2
    }
}
