//
//  FirestoreToFetchUserInfo.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth


class FirestoreToFetchUserinfo: ObservableObject {
    
    let firebaseAuth = FirebaseAuth()
    let db = Firestore.firestore()
    
    @Published var fetchedUserData: UserDataModel = .empty
    @Published var rentingRoomInfo: RentedRoomInfo = .empty
    @Published var userLastName = ""
    
    private func getUserLastName(lastName: UserDataModel) -> String{
        var tempLastNameHolder = ""
        tempLastNameHolder = lastName.displayName
        return tempLastNameHolder
    }
    
    func getUserType(input: UserDataModel) -> String {
        var tempHolder = ""
        tempHolder = input.userType 
        return tempHolder
    }
    
    func evaluateProviderType() -> String {
        var tempHoler = ""
        tempHoler = evaluateProviderType(input: fetchedUserData)
        return tempHoler
    }
    
    private func evaluateProviderType(input: UserDataModel) -> String {
        var tempHolder = ""
        tempHolder = input.providerType
        return tempHolder
    }
    
    func presentUserName() -> String {
        var userName = ""
        userName = presentUserName(input: fetchedUserData)
        return userName
    }
    
    private func presentUserName(input: UserDataModel) -> String {
        var tempFirstName = ""
        var tempLastName = ""
        tempFirstName = input.firstName
        tempLastName = input.lastName
        return tempFirstName + tempLastName
    }
    
    func presentUserId() -> String {
        var userId = ""
        userId = presentUserId(input: fetchedUserData)
        return userId
    }
    
    private func presentUserId(input: UserDataModel) -> String {
        var tempIdholder = ""
        tempIdholder = input.id
        return tempIdholder
    }
    
    func presentAddress() -> String {
        var tempAddressHolder = ""
        tempAddressHolder = presentAddress(input: fetchedUserData)
        return tempAddressHolder
    }
    
    private func presentAddress(input: UserDataModel) -> String {
        var tempAddressHolder = ""
        var tempTownHolder = ""
        var tempCityHolder = ""
        var tempZipCodeHolder = ""
        tempAddressHolder = input.address
        tempTownHolder = input.town
        tempCityHolder = input.city
        tempZipCodeHolder = input.zip
        return tempZipCodeHolder + tempCityHolder + tempTownHolder + tempAddressHolder
    }
    
    func presentMobileNumber() -> String {
        var tempMobileNumberHolder = ""
        tempMobileNumberHolder = presentMobileNumber(input: fetchedUserData)
        return tempMobileNumberHolder
    }
    
    private func presentMobileNumber(input: UserDataModel) -> String {
        var tempMobileNumberHolder = ""
        tempMobileNumberHolder = input.mobileNumber
        return tempMobileNumberHolder
    }
    
    func presentEmailAddress() -> String {
        var tempEmailAddress = ""
        tempEmailAddress = presentEmailAddress(input: fetchedUserData)
        return tempEmailAddress
    }
    
    private func presentEmailAddress(input: UserDataModel) -> String {
        var tempEmailAddress = ""
        tempEmailAddress = input.emailAddress ?? ""
        return tempEmailAddress
    }
    
    
}

extension FirestoreToFetchUserinfo {
    func userRentedRoomInfo() {
        rentingRoomInfo = dataInLocalRentedRoomInfo(input: fetchedUserData)
    }
    private func dataInLocalRentedRoomInfo(input: UserDataModel) -> RentedRoomInfo {
        let roomUID = input.rentedRoomInfo?.roomUID
        let roomAddress = input.rentedRoomInfo?.roomAddress
        let roomTown = input.rentedRoomInfo?.roomTown
        let roomCity = input.rentedRoomInfo?.roomCity
        let roomPrice = input.rentedRoomInfo?.roomPrice
        let roomZipCode = input.rentedRoomInfo?.roomZipCode
        let roomImageCover = input.rentedRoomInfo?.roomImageCover
        let providerUID = input.rentedRoomInfo?.providerUID
        self.rentingRoomInfo = RentedRoomInfo(roomUID: roomUID,
                                                roomAddress: roomAddress,
                                                roomTown: roomTown,
                                                roomCity: roomCity,
                                                roomPrice: roomPrice,
                                                roomZipCode: roomZipCode,
                                              roomImageCover: roomImageCover,
                                              providerUID: providerUID
                                               )
        return rentingRoomInfo
    }
    
    func getRoomUID() -> String {
        var holderRoomUID = ""
            holderRoomUID = getRoomUID(input: rentingRoomInfo)
        return holderRoomUID
    }
    func getRoomUID(input: RentedRoomInfo) -> String {
        var rentedRoomUID = ""
        rentedRoomUID = input.roomUID ?? ""
        return rentedRoomUID
    }
    
    func checkRoosStatus(roomUID: String) throws {
        guard !roomUID.isEmpty else {
            throw UserInformationError.userRentalError
        }
    }
    func checkMaintainFilled(description: String, appointmentDate: Date) throws {
        guard description.isEmpty || description != "Please describe what stuff needs to fix." else {
            throw MaintainError.maintianFillingError
        }
    }
}

extension FirestoreToFetchUserinfo {
    
    func updateDisplayName(uidPath: String, displayName: String) async throws {
        let userRef = db.collection("users").document(uidPath)
        try await userRef.updateData([
            "displayName" : displayName
        ])
    }
    
    func updateUserInfomationAsync(uidPath: String, id: String , firstName: String, lastName: String, mobileNumber: String, dob: Date, address: String, town: String, city: String, zip: String, country: String, gender: String, userType: String, emailAddress: String?, providerType: String = "House Owner", RLNumber: String? = "", displayName: String) async throws {
//        let rentalFee = RentalFee(paymentDate: Date(),
//                                  pastRentalFee: "")
//        let rentedRoomInfo = RentedRoomInfo(roomUID: "",
//                                            roomAddress: "",
//                                            roomTown: "",
//                                            roomCity: "",
//                                            roomPrice: "",
//                                            roomImageCover: "",
//                                            providerUID: "",
//                                            pastRentalFee: rentalFee)
//        _ = UserDataModel(id: id,
//                          firstName: firstName,
//                          lastName: lastName,
//                          displayName: displayName,
//                          mobileNumber: mobileNumber,
//                          dob: dob,
//                          address: address,
//                          town: town,
//                          city: city,
//                          zip: zip,
//                          country: country,
//                          gender: gender,
//                          userType: userType,
//                          providerType: providerType,
//                          rentalManagerLicenseNumber: RLNumber,
//                          emailAddress: emailAddress,
//                          rentedRoomInfo: rentedRoomInfo)
        let userRef = db.collection("users").document(uidPath)
        try await userRef.updateData([
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
            "displayName" : displayName,
            "mobileNumber": mobileNumber,
            "dob": dob,
            "address": address,
            "town": town,
            "city": city,
            "zip": zip,
            "country": country,
            "gender": gender
        ])
    }
    
    func createUserInfomationAsync(uidPath: String, id: String , firstName: String, lastName: String, displayName: String, mobileNumber: String, dob: Date, address: String, town: String, city: String, zip: String, country: String, gender: String, userType: String, emailAddress: String?, providerType: String = "House Owner", RLNumber: String? = "") async throws {
//        let rentalFee = RentalFee(paymentDate: Date(),
//                                  pastRentalFee: "")
//        let rentedRoomInfo = RentedRoomInfo(roomUID: "",
//                                            roomAddress: "",
//                                            roomTown: "",
//                                            roomCity: "",
//                                            roomPrice: "",
//                                            roomImageCover: "",
//                                            providerUID: "",
//                                            pastRentalFee: rentalFee)
//        _ = UserDataModel(id: id,
//                                     firstName: firstName,
//                                     lastName: lastName,
//                                     mobileNumber: mobileNumber,
//                                     dob: dob,
//                                     address: address,
//                                     town: town,
//                                     city: city,
//                                     zip: zip,
//                                     country: country,
//                                     gender: gender,
//                                     userType: userType,
//                                     providerType: providerType,
//                                     rentalManagerLicenseNumber: RLNumber,
//                                     emailAddress: emailAddress,
//                                     rentedRoomInfo: rentedRoomInfo)
        let userRef = db.collection("users").document(uidPath)
        try await userRef.setData([
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
            "displayName" : displayName,
            "mobileNumber": mobileNumber,
            "dob": dob,
            "address": address,
            "town": town,
            "city": city,
            "zip": zip,
            "country": country,
            "gender": gender,
            "userType": userType,
            "providerType": providerType,
            "rentalManagerLicenseNumber": RLNumber ?? "",
            "emailAddress": emailAddress ?? "",
            "rentedRoomInfo": [
                "roomUID" : "",
                "roomAddress" : "",
                "roomTown" : "",
                "roomCity" : "",
                "roomPrice" : "",
                "roomImageCover" : "",
                "providerUID" : "",
                "pastRentalFee": [
                    "paymentDate": Date(),
                    "pastRentalFee": ""
                ]
            ]
        ])
    }
    
    func reloadUserData() async throws {
        try await fetchUploadUserDataAsync()
    }
    
    
    func fetchUploadUserDataAsync() async throws {
        fetchedUserData = try await fetchUploadedUserDataAsync(uidPath: firebaseAuth.getUID())
        self.userLastName = self.getUserLastName(lastName: self.fetchedUserData)
    }
    
    @MainActor
    private func fetchUploadedUserDataAsync(uidPath: String) async throws -> UserDataModel {
        let userRef = db.collection("users").document(uidPath)
        let userData = try await userRef.getDocument(as: UserDataModel.self)
        self.fetchedUserData = userData
        return fetchedUserData
    }
    
    func updateUserInformationAsync(uidPath: String, roomID: String = "", roomImage: String, roomAddress: String, roomTown: String, roomCity: String, roomPrice: String, roomZipCode: String, providerUID: String) async throws {
        let userRef = db.collection("users").document(uidPath)
        try await userRef.updateData([
            "rentedRoomInfo.roomUID" : roomID,
            "rentedRoomInfo.roomAddress" : roomAddress,
            "rentedRoomInfo.roomTown" : roomTown,
            "rentedRoomInfo.roomCity" : roomCity,
            "rentedRoomInfo.roomPrice" : roomPrice,
            "rentedRoomInfo.roomZipCode" : roomZipCode,
            "rentedRoomInfo.roomImageCover" : roomImage,
            "rentedRoomInfo.providerUID" : providerUID
        ])
    }
    
}

extension FirestoreToFetchUserinfo {
    func reloadUserDataTest() async throws {
        try await fetchUploadUserDataAsync()
        userRentedRoomInfo()
    }
}


extension FirestoreToFetchUserinfo {
    func summitPaidInfo(uidPath: String, rentalPrice: String, date: Date) async throws {
        let paymentHistoryRef = db.collection("users").document(uidPath).collection("PaymentHistory")
        _ = try await paymentHistoryRef.addDocument(data: [
            "paidRentalPrice" : rentalPrice,
            "paymentDate" : date
        ])
        
    }
}
