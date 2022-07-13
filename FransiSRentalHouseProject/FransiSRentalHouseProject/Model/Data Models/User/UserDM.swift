//
//  UserDM.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/21.
//

import AuthenticationServices
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

// MARK: - Basic User Information

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

    // MARK: If is founder then create `providerDM` otherwise enter gui to join exist store

    var isFounder: Bool?
    var isEmployee: Bool?

    // MARK: if user type is provider and `isFounder` is false then fill out the value

    var providerGUI: String?
    var isSignByApple: Bool
    var agreeAutoPay: Bool
    var isRented: Bool

    init(id: String, firstName: String, lastName: String, nickName: String, mobileNumber: String, zipCode: String, city: String, town: String, address: String, email: String, dob: Date, gender: String, profileImageURL: String, userType: String, providerType: String, isFounder: Bool? = nil, isEmployee: Bool? = nil, providerGUI: String? = nil, isSignByApple: Bool, agreeAutoPay: Bool, isRented: Bool) {
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
        self.isEmployee = isEmployee
        self.providerGUI = providerGUI
        self.isSignByApple = isSignByApple
        self.agreeAutoPay = agreeAutoPay
        self.isRented = isRented
    }
}

extension UserDM {
    static let empty = UserDM(id: "", firstName: "", lastName: "", nickName: "", mobileNumber: "", zipCode: "", city: "", town: "", address: "", email: "", dob: Date(), gender: "", profileImageURL: "", userType: "", providerType: "", isFounder: false, isEmployee: false, providerGUI: "", isSignByApple: false, agreeAutoPay: false, isRented: false)
    static func signUpInit(
        userType: String,
        providerType: String,
        isFounder: Bool?,
        isEmployee: Bool?,
        providerGUI: String?,
        isSignByApple: Bool,
        email: String
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
            email: email,
            dob: Date(),
            gender: "",
            profileImageURL: "",
            userType: userType,
            providerType: providerType,
            isFounder: isFounder ?? false,
            isEmployee: isEmployee ?? false,
            providerGUI: providerGUI ?? ""   ,
            isSignByApple: isSignByApple,
            agreeAutoPay: false,
            isRented: false
        )
    }
}

// MARK: - If User type is provider then create it

struct ProviderDM: Codable {
    var gui: String
    var empType: String
    var empUID: String
}

extension ProviderDM {
    static let empty = ProviderDM(
        gui: "",
        empType: "",
        empUID: ""
    )
    
//    static func createProvider(
//        gui: String,
//        empType: String
//    ) -> ProviderDM {
//        return ProviderDM(
//            gui: data.gui,
//            empType: data.empType,
//            empUID: data.empUID
//        )
//    }
    
    static func updateProvider(
        provider data: ProviderDM
    ) -> ProviderDM {
        return ProviderDM(
            gui: data.gui,
            empType: data.empType,
            empUID: data.empUID
        )
    }
    
}

// MARK: - Product provider and Rental House Provider Store interface and setting configuration

struct ProviderStore: Identifiable, Codable {
    // MARK: id is uidPath

    @DocumentID var id: String?
//    var isCreateGroup: Bool
    var isSetConfig: Bool
    var settlementDate: Date
    var isCreateStore: Bool
    var groupMemberAmount: Int
    var rentalManagerLicenseNumber: String?
    var storeChatDocID: String
    var storeBackgroundImage: String
    var storeDescription: String
    //MARK: - Company Info
    var companyProfileImage: String
    var companyName: String
    var companyAddress: String
    var companyGUI: String
    var telNumber: String
    var companyEmail: String
    //MARK: - Charge Info
    var chargeName: String
    var chargeID: String
    
}

extension ProviderStore {
    static let empty = ProviderStore(
        isSetConfig: false,
        settlementDate: Date(),
        isCreateStore: false,
        groupMemberAmount: 0,
        storeChatDocID: "",
        storeBackgroundImage: "",
        storeDescription: "",
        companyProfileImage: "",
        companyName: "",
        companyAddress: "",
        companyGUI: "",
        telNumber: "",
        companyEmail: "",
        chargeName: "",
        chargeID: ""
    )
    
    static let createStore = ProviderStore(
        isSetConfig: false,
        settlementDate: Date(),
        isCreateStore: true,
        groupMemberAmount: 0,
        storeChatDocID: "",
        storeBackgroundImage: "",
        storeDescription: "",
        companyProfileImage: "",
        companyName: "",
        companyAddress: "",
        companyGUI: "",
        telNumber: "",
        companyEmail: "",
        chargeName: "",
        chargeID: ""
    )

    static func updateStore(
        created data: ProviderStore,
        companyAddress: String
    ) -> ProviderStore {
        return ProviderStore(
            isSetConfig: data.isSetConfig,
            settlementDate: data.settlementDate,
            isCreateStore: data.isCreateStore,
            groupMemberAmount: data.groupMemberAmount,
            storeChatDocID: data.storeChatDocID,
            storeBackgroundImage: data.storeBackgroundImage,
            storeDescription: data.storeDescription,
            companyProfileImage: data.companyProfileImage,
            companyName: data.companyName,
            companyAddress: companyAddress,
            companyGUI: data.companyGUI,
            telNumber: data.telNumber,
            companyEmail: data.companyEmail,
            chargeName: data.chargeName,
            chargeID: data.chargeID
        )
    }
    
}

struct EmpDataSet: Identifiable, Codable {
    @DocumentID var id: String?
    var empUID: String
}


//MARK: - Mothly income data model

struct MonthlySettlementDM: Identifiable, Codable {
    @DocumentID var id: String?
    var isCreatedMonthlySettlementData: Bool
    var month: Date
    var closeAmount: Int
    @ServerTimestamp var closeDate: Timestamp?
}

extension MonthlySettlementDM {
    static let empty = MonthlySettlementDM(isCreatedMonthlySettlementData: false, month: Date(), closeAmount: 0)
}
