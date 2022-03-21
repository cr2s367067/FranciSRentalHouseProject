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
    @Published var userRentedRoomInfo: RentedRoomInfo = .empty
    @Published var userLastName = ""
    
    // MARK: remove after testing
//    func fetchUploadUserData() {
//        fetchUploadedUserData(uidPath: firebaseAuth.getUID())
//    }
    
    // MARK: remove after testing
//    func createUserInfomation(uidPath: String, id: String , firstName: String, lastName: String, mobileNumber: String, dob: Date, address: String, town: String, city: String, zip: String, country: String, gender: String, userType: String, emailAddress: String?, providerType: String = "House Owner", RLNumber: String? = "") {
//        let rentalFee = RentalFee(paymentDate: Date(), pastRentalFee: "")
//        let rentedRoomInfo = RentedRoomInfo(roomUID: "", roomAddress: "", roomTown: "", roomCity: "", roomPrice: "", roomImageCover: "", pastRentalFee: rentalFee)
//        let userInfo = UserDataModel(id: id, firstName: firstName, lastName: lastName, mobileNumber: mobileNumber, dob: dob, address: address, town: town, city: city, zip: zip, country: country, gender: gender, userType: userType, providerType: providerType, rentalManagerLicenseNumber: RLNumber, emailAddress: emailAddress, rentedRoomInfo: rentedRoomInfo)
//        do {
//            try db.collection("users").document(uidPath).setData(from: userInfo)
//        } catch {
//            print("Error writting!")
//        }
//    }
    
    // MARK: remove after testing
//    private func fetchUploadedUserData(uidPath: String) {
//        let userRef = db.collection("users").document(uidPath)
//        userRef.getDocument { (document, error) in
//            let result = Result {
//                try document?.data(as: UserDataModel.self)
//            }
//            switch result {
//            case .success(let userInfo):
//                if let _userInfo = userInfo {
//                    DispatchQueue.userInitial(delay: 1.0) {
//                        if !self.fetchedUserData.isEmpty {
//                            self.fetchedUserData.removeAll()
//                            self.fetchedUserData.append(UserDataModel(id: _userInfo.id, firstName: _userInfo.firstName,
//                                                                      lastName: _userInfo.lastName,
//                                                                      mobileNumber: _userInfo.mobileNumber,
//                                                                      dob: _userInfo.dob,
//                                                                      address: _userInfo.address,
//                                                                      town: _userInfo.town,
//                                                                      city: _userInfo.city,
//                                                                      zip: _userInfo.zip,
//                                                                      country: _userInfo.country,
//                                                                      gender: _userInfo.gender,
//                                                                      userType: _userInfo.userType,
//                                                                      providerType: _userInfo.providerType,
//                                                                      rentalManagerLicenseNumber: _userInfo.rentalManagerLicenseNumber,
//                                                                      emailAddress: _userInfo.emailAddress,
//                                                                      rentedRoomInfo: _userInfo.rentedRoomInfo))
//                        } else {
//                            self.fetchedUserData.append(UserDataModel(id: _userInfo.id,
//                                                                      firstName: _userInfo.firstName,
//                                                                      lastName: _userInfo.lastName,
//                                                                      mobileNumber: _userInfo.mobileNumber,
//                                                                      dob: _userInfo.dob,
//                                                                      address: _userInfo.address,
//                                                                      town: _userInfo.town,
//                                                                      city: _userInfo.city,
//                                                                      zip: _userInfo.zip,
//                                                                      country: _userInfo.country,
//                                                                      gender: _userInfo.gender,
//                                                                      userType: _userInfo.userType,
//                                                                      providerType: _userInfo.providerType,
//                                                                      rentalManagerLicenseNumber: _userInfo.rentalManagerLicenseNumber,
//                                                                      emailAddress: _userInfo.emailAddress,
//                                                                      rentedRoomInfo: _userInfo.rentedRoomInfo))
//                        }
//                    } completion: {
//                        self.userLastName = self.getUserLastName(lastName: self.fetchedUserData)
//                    }
//                } else {
//                    debugPrint("Document does not exist")
//                }
//            case .failure(let error):
//                debugPrint("Error: \(error)")
//            }
//        }
//    }
    
    private func getUserLastName(lastName: UserDataModel) -> String{
        var tempLastNameHolder = ""
        tempLastNameHolder = lastName.lastName 
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
        tempHolder = input.providerType ?? ""
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

//: Update user data - roomInfo
extension FirestoreToFetchUserinfo {
    // MARK: remove after testing
    func updateUserInformation(uidPath: String, roomID: String = "", roomImage: String, roomAddress: String, roomTown: String, roomCity: String, roomPrice: String, roomZipCode: String) {
        let userRef = db.collection("users").document(uidPath)
        userRef.updateData([
            "rentedRoomInfo.roomUID" : roomID,
            "rentedRoomInfo.roomAddress" : roomAddress,
            "rentedRoomInfo.roomTown" : roomTown,
            "rentedRoomInfo.roomCity" : roomCity,
            "rentedRoomInfo.roomPrice" : roomPrice,
            "rentedRoomInfo.roomZipCode" : roomZipCode,
            "rentedRoomInfo.roomImageCover" : roomImage
        ], completion: { error in
            if let _error = error {
                print("error to update: \(_error)")
            } else {
                print("Update success")
            }
        })
    }
}

extension FirestoreToFetchUserinfo {
    func appendFetchedDataInLocalRentedRoomInfo() {
        userRentedRoomInfo = dataInLocalRentedRoomInfo(input: fetchedUserData)
    }
    private func dataInLocalRentedRoomInfo(input: UserDataModel) -> RentedRoomInfo {
        let roomUID = input.rentedRoomInfo?.roomUID ?? ""
        let roomAddress = input.rentedRoomInfo?.roomAddress ?? ""
        let roomTown = input.rentedRoomInfo?.roomTown ?? ""
        let roomCity = input.rentedRoomInfo?.roomCity ?? ""
        let roomPrice = input.rentedRoomInfo?.roomPrice ?? ""
        let roomZipCode = input.rentedRoomInfo?.roomZipCode ?? ""
        let roomImageCover = input.rentedRoomInfo?.roomImageCover ?? ""
        self.userRentedRoomInfo = RentedRoomInfo(roomUID: roomUID,
                                                roomAddress: roomAddress,
                                                roomTown: roomTown,
                                                roomCity: roomCity,
                                                roomPrice: roomPrice,
                                                roomZipCode: roomZipCode,
                                                roomImageCover: roomImageCover
                                               )
        return userRentedRoomInfo
    }
    
    func getRoomUID() -> String {
        var holderRoomUID = ""
            holderRoomUID = getRoomUID(input: userRentedRoomInfo)
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
}

extension FirestoreToFetchUserinfo {
    
    func updateUserInfomationAsync(uidPath: String, id: String , firstName: String, lastName: String, mobileNumber: String, dob: Date, address: String, town: String, city: String, zip: String, country: String, gender: String, userType: String, emailAddress: String?, providerType: String = "House Owner", RLNumber: String? = "") async throws {
        let rentalFee = RentalFee(paymentDate: Date(),
                                  pastRentalFee: "")
        let rentedRoomInfo = RentedRoomInfo(roomUID: "",
                                            roomAddress: "",
                                            roomTown: "",
                                            roomCity: "",
                                            roomPrice: "",
                                            roomImageCover: "",
                                            pastRentalFee: rentalFee)
        _ = UserDataModel(id: id,
                                     firstName: firstName,
                                     lastName: lastName,
                                     mobileNumber: mobileNumber,
                                     dob: dob,
                                     address: address,
                                     town: town,
                                     city: city,
                                     zip: zip,
                                     country: country,
                                     gender: gender,
                                     userType: userType,
                                     providerType: providerType,
                                     rentalManagerLicenseNumber: RLNumber,
                                     emailAddress: emailAddress,
                                     rentedRoomInfo: rentedRoomInfo)
        let userRef = db.collection("users").document(uidPath)
        try await userRef.updateData([
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
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
    
    func createUserInfomationAsync(uidPath: String, id: String , firstName: String, lastName: String, mobileNumber: String, dob: Date, address: String, town: String, city: String, zip: String, country: String, gender: String, userType: String, emailAddress: String?, providerType: String = "House Owner", RLNumber: String? = "") async throws {
        let rentalFee = RentalFee(paymentDate: Date(),
                                  pastRentalFee: "")
        let rentedRoomInfo = RentedRoomInfo(roomUID: "",
                                            roomAddress: "",
                                            roomTown: "",
                                            roomCity: "",
                                            roomPrice: "",
                                            roomImageCover: "",
                                            pastRentalFee: rentalFee)
        _ = UserDataModel(id: id,
                                     firstName: firstName,
                                     lastName: lastName,
                                     mobileNumber: mobileNumber,
                                     dob: dob,
                                     address: address,
                                     town: town,
                                     city: city,
                                     zip: zip,
                                     country: country,
                                     gender: gender,
                                     userType: userType,
                                     providerType: providerType,
                                     rentalManagerLicenseNumber: RLNumber,
                                     emailAddress: emailAddress,
                                     rentedRoomInfo: rentedRoomInfo)
        let userRef = db.collection("users").document(uidPath)
        try await userRef.setData([
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
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
                "roomUID": "",
                "roomAddress": "",
                "roomTown": "",
                "roomCity": "",
                "roomPrice": "",
                "roomImageCover": "",
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
    
    @MainActor
    func fetchUploadUserDataAsync() async throws {
        fetchedUserData = try await fetchUploadedUserDataAsync(uidPath: firebaseAuth.getUID())
        self.userLastName = self.getUserLastName(lastName: self.fetchedUserData)
    }
    
    private func fetchUploadedUserDataAsync(uidPath: String) async throws -> UserDataModel {
        let userRef = db.collection("users").document(uidPath)
        let userData = try await userRef.getDocument(as: UserDataModel.self)
        self.fetchedUserData = userData
        return fetchedUserData
    }
    
    func updateUserInformationAsync(uidPath: String, roomID: String = "", roomImage: String, roomAddress: String, roomTown: String, roomCity: String, roomPrice: String, roomZipCode: String) async throws {
        let userRef = db.collection("users").document(uidPath)
        try await userRef.updateData([
            "rentedRoomInfo.roomUID" : roomID,
            "rentedRoomInfo.roomAddress" : roomAddress,
            "rentedRoomInfo.roomTown" : roomTown,
            "rentedRoomInfo.roomCity" : roomCity,
            "rentedRoomInfo.roomPrice" : roomPrice,
            "rentedRoomInfo.roomZipCode" : roomZipCode,
            "rentedRoomInfo.roomImageCover" : roomImage
        ])
//        userRef.updateData([
//            "rentedRoomInfo.roomUID" : roomID,
//            "rentedRoomInfo.roomAddress" : roomAddress,
//            "rentedRoomInfo.roomTown" : roomTown,
//            "rentedRoomInfo.roomCity" : roomCity,
//            "rentedRoomInfo.roomPrice" : roomPrice,
//            "rentedRoomInfo.roomZipCode" : roomZipCode,
//            "rentedRoomInfo.roomImageCover" : roomImage
//        ], completion: { error in
//            if let _error = error {
//                print("error to update: \(_error)")
//            } else {
//                print("Update success")
//            }
//        })
    }
    
}


//extension FirestoreToFetchUserinfo {
//    func testFun() async throws {
//        testUserData = try await fetchUploadedUserDataAsyncTest(uidPath: firebaseAuth.getUID())
//    }
//    private func fetchUploadedUserDataAsyncTest(uidPath: String) async throws -> UserDataModel {
//        let userRef = db.collection("users").document(uidPath)
//        let userData = try await userRef.getDocument(as: UserDataModel.self)
//        let id = userData.id
//        let firstName = userData.firstName
//        let lastName = userData.lastName
//        let mobileNumber = userData.mobileNumber
//        let dob = userData.dob
//        let address = userData.address
//        let town = userData.town
//        let city = userData.city
//        let zip = userData.zip
//        let country = userData.country
//        let gender = userData.gender
//        let userType = userData.userType
//        let providerType = userData.providerType
//        let rentalManagerLicenseNumber = userData.rentalManagerLicenseNumber
//        let emailAddress = userData.emailAddress
//        let rentedRoomInfo = userData.rentedRoomInfo
////        self.testUserData = userData
////        return testUserData
//
//        return UserDataModel(id: id,
//                             firstName: firstName,
//                             lastName: lastName,
//                             mobileNumber: mobileNumber,
//                             dob: dob,
//                             address: address,
//                             town: town,
//                             city: city,
//                             zip: zip,
//                             country: country,
//                             gender: gender,
//                             userType: userType,
//                             providerType: providerType,
//                             rentalManagerLicenseNumber: rentalManagerLicenseNumber,
//                             emailAddress: emailAddress,
//                             rentedRoomInfo: rentedRoomInfo)
//    }
//}
