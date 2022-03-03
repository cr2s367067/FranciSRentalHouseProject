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
    var rentalManagerEmailAddress: String?
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName
//        case lastName
//        case mobileNumber
//        case dob
//        case address
//        case town
//        case city
//        case zip
//        case country
//        case gender
//        case userType
//    }
}
