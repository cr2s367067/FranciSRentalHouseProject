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
    var rentingRoomUID: String?
    var pastRentalFee: RentalFee?
}

struct RentalFee: Codable {
    var pastRentalFee: Int?
}

extension UserDataModel {
    static let empty = UserDataModel(id: "", firstName: "", lastName: "", mobileNumber: "", dob: Date(), address: "", town: "", city: "", zip: "", country: "", gender: "", userType: "", providerType: "", rentalManagerLicenseNumber: "", emailAddress: "", rentingRoomUID: "", pastRentalFee: nil)
}