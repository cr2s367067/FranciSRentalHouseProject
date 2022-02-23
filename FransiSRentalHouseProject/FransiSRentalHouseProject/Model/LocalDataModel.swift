//
//  LocalDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import Foundation
import SwiftUI

class LocalData: ObservableObject {
    
    
    @Published var tempCart: [RoomsDataModel] = []
    
    @Published var sumPrice = 0
    
    @Published var summaryItemHolder: [SummaryItemHolder] = []
    
    @Published var maintainTaskHolder: [MaintainTaskHolder] = []
    
    @Published var userDataHolder: [UserDataModel] = []
    
    
    @Published var roomDataSets = [
        RoomsDataModel(
            roomImage: "room3",
            roomName: "room3",
            roomDescribtion: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.",
            roomPrice: 9000,
            ranking: 3,
            isSelected: false
        ),
        RoomsDataModel(
            roomImage: "room4",
            roomName: "room4",
            roomDescribtion: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.",
            roomPrice: 8000,
            ranking: 5,
            isSelected: false
            
        ),
        RoomsDataModel(
            roomImage: "room5",
            roomName: "room5",
            roomDescribtion: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.",
            roomPrice: 7000,
            ranking: 2,
            isSelected: false
        ),
        RoomsDataModel(
            roomImage: "room6",
            roomName: "room6",
            roomDescribtion: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.",
            roomPrice: 9000,
            ranking: 3,
            isSelected: false
        ),
        RoomsDataModel(
            roomImage: "room7",
            roomName: "room7",
            roomDescribtion: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.",
            roomPrice: 8000,
            ranking: 4,
            isSelected: false
        ),
        RoomsDataModel(
            roomImage: "room8",
            roomName: "room8",
            roomDescribtion: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.",
            roomPrice: 8000,
            ranking: 2,
            isSelected: false
        )
    ]
    @Published var furnitureDataSets = [
        FurnitureDataModel(
            furnitureImage: "furpic1",
            furnitureName: "furpic1",
            furniturePrice: 100
        ),
        FurnitureDataModel(
            furnitureImage: "furpic2",
            furnitureName: "furpic2",
            furniturePrice: 200
        ),
        FurnitureDataModel(
            furnitureImage: "furpic3",
            furnitureName: "furpic3",
            furniturePrice: 300
        ),
        FurnitureDataModel(
            furnitureImage: "furpic4",
            furnitureName: "furpic4",
            furniturePrice: 400
        ),
        FurnitureDataModel(
            furnitureImage: "furpic5",
            furnitureName: "furpic5",
            furniturePrice: 500
        ),
        FurnitureDataModel(
            furnitureImage: "furpic6",
            furnitureName: "furpic6",
            furniturePrice: 600
        ),
        FurnitureDataModel(
            furnitureImage: "furpic7",
            furnitureName: "furpic7",
            furniturePrice: 700
        ),
        FurnitureDataModel(
            furnitureImage: "furpic8",
            furnitureName: "furpic8",
            furniturePrice: 800
        )
    ]
    
   
    
    func addItem(itemName: String, itemPrice: Int) {
        summaryItemHolder.append(SummaryItemHolder(itemName: itemName, itemPrice: itemPrice))
    }
    
    func addTask(taskname: String, appointmentDate: Date) {
        maintainTaskHolder.append(MaintainTaskHolder(taskName: taskname, appointmentDate: appointmentDate))
    }
    
    func addFetchedData(id: String, firstName: String, lastName: String, mobileNumber: String, dob: Date, address: String, town: String, city: String, zip: String, country: String, gender: String, userType: String) {
        userDataHolder.append(UserDataModel(id: id, firstName: firstName, lastName: lastName, phoneNumber: mobileNumber, dob: dob, address: address, town: town, city: city, zip: zip, country: country, gender: gender, userType: userType))
    }
    
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

struct MaintainTaskHolder: Identifiable, Codable {
    var id = UUID()
    var taskName: String
    var appointmentDate: Date
    
    enum Codingkeys: String, CodingKey {
        case id
        case taskName
        case appointmentDate
    }
}

struct SummaryItemHolder: Identifiable {
    var id = UUID()
    var itemName: String
    var itemPrice: Int
}

struct RoomsDataModel: Identifiable, Codable {
    var id = UUID()
    var roomImage: String
    var roomName: String
    var roomDescribtion: String
    var roomPrice: Int
    var ranking: Int
    var isSelected: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case roomImage
        case roomName
        case roomDescribtion
        case roomPrice
        case ranking
        case isSelected
    }
    
}

struct FurnitureDataModel: Identifiable, Codable {
    var id = UUID()
    var furnitureImage: String
    var furnitureName: String
    var furniturePrice: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case furnitureImage
        case furnitureName
        case furniturePrice
    }
}

struct UserDataModel: Codable {
    var id: String
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var dob: Date
    var address: String
    var town: String
    var city: String
    var zip: String
    var country: String
    var gender: String
    var userType: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case phoneNumber
        case dob
        case address
        case town
        case city
        case zip
        case country
        case gender
        case userType
    }
}
