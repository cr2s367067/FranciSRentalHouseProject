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
    
    //: User Data
//    @Published var userDataHolder: [UserDataModel] = []
    //: Maintain Task
    @Published var maintainTaskHolder: [MaintainTaskHolder] = []
    
    //: Room Information
    @Published var localRoomsHolder: RoomInfoDataModel = .empty
    
    
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
    
    
//    func addFetchedData(id: String, firstName: String, lastName: String, mobileNumber: String, dob: Date, address: String, town: String, city: String, zip: String, country: String, gender: String, userType: String, providerType: String = "") {
//        userDataHolder.append(UserDataModel(id: id, firstName: firstName, lastName: lastName, mobileNumber: mobileNumber, dob: dob, address: address, town: town, city: city, zip: zip, country: country, gender: gender, userType: userType, providerType: providerType))
//    }
    
    func compute(source: [SummaryItemHolder]) -> Int {
        var newElemet = 0
        for item in source {
            newElemet += item.itemPrice
        }
        debugPrint(newElemet)
        sumPrice = newElemet
        return sumPrice
    }
    
}














//    @Published var roomDataSets = [
//        RoomsDataModel(
//            roomImage: "room3",
//            roomName: "room3",
//            roomDescribtion: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.",
//            roomPrice: 9000,
//            ranking: 3,
//            isSelected: false
//        ),
//        RoomsDataModel(
//            roomImage: "room4",
//            roomName: "room4",
//            roomDescribtion: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.",
//            roomPrice: 8000,
//            ranking: 5,
//            isSelected: false
//
//        ),
//        RoomsDataModel(
//            roomImage: "room5",
//            roomName: "room5",
//            roomDescribtion: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.",
//            roomPrice: 7000,
//            ranking: 2,
//            isSelected: false
//        ),
//        RoomsDataModel(
//            roomImage: "room6",
//            roomName: "room6",
//            roomDescribtion: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.",
//            roomPrice: 9000,
//            ranking: 3,
//            isSelected: false
//        ),
//        RoomsDataModel(
//            roomImage: "room7",
//            roomName: "room7",
//            roomDescribtion: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.",
//            roomPrice: 8000,
//            ranking: 4,
//            isSelected: false
//        ),
//        RoomsDataModel(
//            roomImage: "room8",
//            roomName: "room8",
//            roomDescribtion: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.",
//            roomPrice: 8000,
//            ranking: 2,
//            isSelected: false
//        )
//    ]


//    @Published var furnitureDataSets = [
//        FurnitureDataModel(
//            furnitureImage: "furpic1",
//            furnitureName: "furpic1",
//            furniturePrice: 100
//        ),
//        FurnitureDataModel(
//            furnitureImage: "furpic2",
//            furnitureName: "furpic2",
//            furniturePrice: 200
//        ),
//        FurnitureDataModel(
//            furnitureImage: "furpic3",
//            furnitureName: "furpic3",
//            furniturePrice: 300
//        ),
//        FurnitureDataModel(
//            furnitureImage: "furpic4",
//            furnitureName: "furpic4",
//            furniturePrice: 400
//        ),
//        FurnitureDataModel(
//            furnitureImage: "furpic5",
//            furnitureName: "furpic5",
//            furniturePrice: 500
//        ),
//        FurnitureDataModel(
//            furnitureImage: "furpic6",
//            furnitureName: "furpic6",
//            furniturePrice: 600
//        ),
//        FurnitureDataModel(
//            furnitureImage: "furpic7",
//            furnitureName: "furpic7",
//            furniturePrice: 700
//        ),
//        FurnitureDataModel(
//            furnitureImage: "furpic8",
//            furnitureName: "furpic8",
//            furniturePrice: 800
//        )
//    ]


//func addRoomDataToArray(roomUID: String = "", holderName: String, mobileNumber: String, roomAddress: String, town: String, city: String, zipCode: String, roomArea: String, rentalPrice: String, roomImageURL: String) {
//    guard
//        let _roomImageURL = URL(string: roomImageURL)
//    else {
//        return
//    }
//    let roomImageCovers = RoomImageCovers(roomImagURL: _roomImageURL)
//    localRoomsHolder = RoomInfoDataModel(roomUID: roomUID, holderName: holderName, mobileNumber: mobileNumber, roomAddress: roomAddress, town: town, city: city, zipCode: zipCode, roomArea: roomArea, rentalPrice: Int(rentalPrice) ?? 0, roomImage: roomImageCovers)
//}


//    func addTask(taskname: String, appointmentDate: Date) {
//        maintainTaskHolder.append(MaintainTaskHolder(taskName: taskname, appointmentDate: appointmentDate))
//    }
