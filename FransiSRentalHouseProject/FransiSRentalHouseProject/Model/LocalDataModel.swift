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
    @Published var summaryItemHolder: [SummaryItemHolder] = []
    
    //: Maintain Task
    @Published var maintainTaskHolder: [MaintainTaskHolder] = []
    
    //: Room Information
//    @Published var localRoomsHolder: RoomInfoDataModel = .empty
    
    
    func addItem(roomAddress: String, roomTown: String, roomCity: String, itemPrice: Int, roomUID: String, roomImage: String, roomZipCode: String, docID: String, providerUID: String) {
        summaryItemHolder.append(SummaryItemHolder(roomAddress: roomAddress,
                                                   roomTown: roomTown,
                                                   roomCity: roomCity,
                                                   itemPrice: itemPrice,
                                                   roomUID: roomUID,
                                                   roomImage: roomImage,
                                                   roomZipCode: roomZipCode,
                                                   docID: docID,
                                                   providerUID: providerUID))
    }
    
    func compute(source: [SummaryItemHolder]) -> Int {
        var newElemet = 0
        for item in source {
            newElemet += item.itemPrice
        }
        debugPrint(newElemet)
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
