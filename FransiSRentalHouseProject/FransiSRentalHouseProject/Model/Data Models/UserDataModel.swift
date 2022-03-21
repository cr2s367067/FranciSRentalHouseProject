//
//  UserDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI


struct UserDataModel: Identifiable, Codable {
    var id: String
    var firstName: String
    var lastName: String
    var mobileNumber: String
    var dob: Date
    var address: String
    var town: String
    var city: String
    var zip: String
    var country: String
    var gender: String
    var userType: String
    var providerType: String?
    var rentalManagerLicenseNumber: String?
    var emailAddress: String?
    var rentedRoomInfo: RentedRoomInfo?
}

struct RentedRoomInfo: Codable {
    var roomUID: String?
    var roomAddress: String?
    var roomTown: String?
    var roomCity: String?
    var roomPrice: String?
    var roomZipCode: String?
    var roomImageCover: String?
    var pastRentalFee: RentalFee?
}

struct RentalFee: Codable {
    var paymentDate : Date?
    var pastRentalFee: String?
}

extension UserDataModel {
    static let empty = UserDataModel(id: "", firstName: "", lastName: "", mobileNumber: "", dob: Date(), address: "", town: "", city: "", zip: "", country: "", gender: "", userType: "", providerType: "", rentalManagerLicenseNumber: "", emailAddress: "", rentedRoomInfo: nil)
}

extension RentedRoomInfo {
    static let empty = RentedRoomInfo(roomUID: "", roomAddress: "", roomTown: "", roomCity: "", roomPrice: "", roomZipCode: "", roomImageCover: "", pastRentalFee: nil)
}
