//
//  UserDM.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/21.
//

import Foundation
import AuthenticationServices


//MARK: - Basic User Information
struct UserDM: Codable {
    var id: String
    var firstName: String
    var lastName: String
    var nickName: String
    var mobileNumber: String
    var zipCode: String
    var city: String
    var town: String
    var address: String
    var email: String
    var dob: Date
    var gender: String
    var profileImageURL: String
    var userType: String
    var providerType: String
    //MARK: If is founder then create `providerDM` otherwise enter gui to join exist store
    var isFounder: Bool?
    //MARK: if user type is provider and `isFounder` is false then fill out the value
    var providerGUI: String?
    var isSignByApple: Bool
    var agreeAutoPay: Bool
    
    init(id: String, firstName: String, lastName: String, nickName: String, mobileNumber: String, zipCode: String, city: String, town: String, address: String, email: String, dob: Date, gender: String, profileImageURL: String, userType: String, providerType: String, isFounder: Bool? = nil, providerGUI: String? = nil, isSignByApple: Bool, agreeAutoPay: Bool) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.nickName = nickName
        self.mobileNumber = mobileNumber
        self.zipCode = zipCode
        self.city = city
        self.town = town
        self.address = address
        self.email = email
        self.dob = dob
        self.gender = gender
        self.profileImageURL = profileImageURL
        self.userType = userType
        self.providerType = providerType
        self.isFounder = isFounder
        self.providerGUI = providerGUI
        self.isSignByApple = isSignByApple
        self.agreeAutoPay = agreeAutoPay
    }
}

extension UserDM {
    static let empty = UserDM(id: "", firstName: "", lastName: "", nickName: "", mobileNumber: "", zipCode: "", city: "", town: "", address: "", email: "", dob: Date(), gender: "", profileImageURL: "", userType: "", providerType: "", isFounder: false, providerGUI: "", isSignByApple: false, agreeAutoPay: false)
    static func signUpInit(
        userType: String,
        providerType: String,
        isFounder: Bool,
        providerGUI: String,
        isSignByApple: Bool
    ) -> UserDM {
        return UserDM(
            id: "",
            firstName: "",
            lastName: "",
            nickName: "",
            mobileNumber: "",
            zipCode: "",
            city: "",
            town: "",
            address: "",
            email: "",
            dob: Date(),
            gender: "",
            profileImageURL: "",
            userType: userType,
            providerType: providerType,
            isFounder: isFounder,
            providerGUI: providerGUI,
            isSignByApple: isSignByApple,
            agreeAutoPay: false
        )
    }
}

//MARK: - If User type is provider then create it
struct ProviderDM: Codable {
    var gui: String
    var companyName: String
    var chargeName: String
    var city: String
    var town: String
    var address: String
    var email: String
    var companyProfileImageURL: String
}

//MARK: - Product provider and Rental House Provider Store interface and setting configuration
struct ProviderStore: Codable {
    var isCreateGroup: Bool
    var isSetConfig: Bool
    var settlementDate: Date
    var isCreateStore: Bool
    var groupMemberAmount: Int
    var RentalManagerLicenseNumber: String?
    var empSet: EmpDataSet
    var storeChatDocID: String
    var storeBackgroundImage: String
    var storeDescription: String
}

struct EmpDataSet: Codable {
    var id = UUID().uuidString
    var empUID: String
}

