//
//  HouseRentalForExternal.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

//MARK: - House Rental Provider basic information
struct RoomsConfigWithStore: Identifiable, Codable {
    @DocumentID var id: String?
    var providerUID: String
    var roomUID: [String]
    var providerChatDocID: String
    var companyName: String
    var companyProfileImageURL: String
}

extension RoomsConfigWithStore {
    static let empty = RoomsConfigWithStore(providerUID: "", roomUID: [], providerChatDocID: "", companyName: "", companyProfileImageURL: "")
}

//MARK: - Display rooms basic info in puclic place
//struct RoomDMExternal: Identifiable, Codable {
//    @DocumentID var id: String?
//    var isPublish: Bool
//    var roomUID: String
//    var renterUID: String
//    var roomsCoverImageURL: String
//    var roomDescription: String
//    var someoneDeadInRoom: Bool
//    var waterLeakingProblem: Bool
//}

//MARK: - Room's image set
struct RoomImageSetExternal: Codable {
    var id = UUID().uuidString
    var roomImageSet: String
}



//MARK: - When user rented room
struct RentedRoom: Codable {
    var rentedRoomUID: String
    var rentedProvderUID: String
    var depositFee: Int
    @ServerTimestamp var paymentDate: Timestamp?
    
    init(rentedRoomUID: String, rentedProvderUID: String, depositFee: Int, paymentDate: Timestamp? = nil) {
        self.rentedRoomUID = rentedRoomUID
        self.rentedProvderUID = rentedProvderUID
        self.depositFee = depositFee
        self.paymentDate = paymentDate
    }
}

extension RentedRoom {
    static let empty = RentedRoom(rentedRoomUID: "", rentedProvderUID: "", depositFee: 0)
}

//MARK: - When user pay rental fee
struct RentedRoomPaymentHistory: Identifiable, Codable {
    @DocumentID var id: String?
    var rentalFee: Int
    @ServerTimestamp var paymentDate: Timestamp?
    var note: String?
}

