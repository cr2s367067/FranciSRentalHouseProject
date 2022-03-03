//
//  RoomsDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift


struct roomImageCovers: Codable {
    var roomImagURL: URL
}

struct RoomInfoDataModel: Identifiable, Codable {
    @DocumentID var id: String?
    var holderName: String
    var mobileNumber: String
    var roomAddress: String
    var town: String
    var city: String
    var zipCode: String
    var emailAddress: String
    var roomArea: String
    var rentalPrice: Int
    var roomImage: roomImageCovers?
    
    //: At below these fields are for house owner
    //:~ Paragrah1
    var buildNumber: String?
    var buildArea: String?
    var buildingPurpose: String?
    var roomAtFloor: String?
    var floorArea: String?
    var subBuildingPurpose: String?
    var subBuildingArea: String?
    
    var provideForAll: Bool?
    var provideForPart: Bool?
    var provideFloor: String?
    var provideRooms: String?
    var provideRoomNumber: String?
    
    var isVehicle: Bool?
    var isMorto: Bool?
    var parkingUGFloor: String?
    var parkingStyleN: Bool?
    var parkingStyleM: Bool?
    var parkingNumber: String?
    
    var forAllday: Bool?
    var forMorning: Bool?
    var forNight: Bool?
    
    var havingSubFacility: Bool?
    
    //:~ paragraph 2
    var providingTimeRangeStart: String?
    var providingTimeRangeEnd: String?
}

extension RoomInfoDataModel {
    static let empty = RoomInfoDataModel(holderName: "", mobileNumber: "", roomAddress: "", town: "", city: "", zipCode: "", emailAddress: "", roomArea: "", rentalPrice: 0, roomImage: nil, buildNumber: "", buildArea: "", buildingPurpose: "", roomAtFloor: "", floorArea: "", subBuildingPurpose: "", subBuildingArea: "", provideForAll: false, provideForPart: false, provideFloor: "", provideRooms: "", provideRoomNumber: "", isVehicle: false, isMorto: false, parkingUGFloor: "", parkingStyleN: false, parkingStyleM: false, parkingNumber: "", forAllday: false, forMorning: false, forNight: false, havingSubFacility: false, providingTimeRangeStart: "", providingTimeRangeEnd: "")
}


/*
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
*/
