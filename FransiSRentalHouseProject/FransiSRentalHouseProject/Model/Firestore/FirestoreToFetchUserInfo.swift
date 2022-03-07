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
    
    @Published var fetchedUserData: [UserDataModel] = []
    @Published var userLastName = ""
    
    func fetchUploadUserData() {
        fetchUploadedUserData(uidPath: firebaseAuth.getUID())
    }
    
    func createUserInfomation(uidPath: String, id: String , firstName: String, lastName: String, mobileNumber: String, dob: Date, address: String, town: String, city: String, zip: String, country: String, gender: String, userType: String, emailAddress: String?, providerType: String = "House Owner", RLNumber: String? = "") {
        let userInfo = UserDataModel(id: id, firstName: firstName, lastName: lastName, mobileNumber: mobileNumber, dob: dob, address: address, town: town, city: city, zip: zip, country: country, gender: gender, userType: userType, providerType: providerType, rentalManagerLicenseNumber: RLNumber, emailAddress: emailAddress)
        do {
            try db.collection("users").document(uidPath).setData(from: userInfo)
        } catch {
            print("Error writting!")
        }
    }
    
    func updateUserInformation(uidPath: String, roomID: String = "") {
        db.collection("users").document(uidPath).updateData([
            "rentingRoomUID" : roomID
        ], completion: { error in
            if let _error = error {
                print("error to update: \(_error)")
            } else {
                print("Update success")
            }
        })
    }
    
    private func fetchUploadedUserData(uidPath: String) {
        let userRef = db.collection("users").document(uidPath)
        userRef.getDocument { (document, error) in
            let result = Result {
                try document?.data(as: UserDataModel.self)
            }
            switch result {
            case .success(let userInfo):
                if let _userInfo = userInfo {
                    DispatchQueue.userInitial(delay: 1.0) {
                        if !self.fetchedUserData.isEmpty {
                            self.fetchedUserData.removeAll()
                            self.fetchedUserData.append(UserDataModel(id: _userInfo.id, firstName: _userInfo.firstName, lastName: _userInfo.lastName, mobileNumber: _userInfo.mobileNumber, dob: _userInfo.dob, address: _userInfo.address, town: _userInfo.town, city: _userInfo.city, zip: _userInfo.zip, country: _userInfo.country, gender: _userInfo.gender, userType: _userInfo.userType, providerType: _userInfo.providerType, rentalManagerLicenseNumber: _userInfo.rentalManagerLicenseNumber, emailAddress: _userInfo.emailAddress, rentingRoomUID: _userInfo.rentingRoomUID))
                        } else {
                            self.fetchedUserData.append(UserDataModel(id: _userInfo.id, firstName: _userInfo.firstName, lastName: _userInfo.lastName, mobileNumber: _userInfo.mobileNumber, dob: _userInfo.dob, address: _userInfo.address, town: _userInfo.town, city: _userInfo.city, zip: _userInfo.zip, country: _userInfo.country, gender: _userInfo.gender, userType: _userInfo.userType, providerType: _userInfo.providerType, rentalManagerLicenseNumber: _userInfo.rentalManagerLicenseNumber, emailAddress: _userInfo.emailAddress, rentingRoomUID: _userInfo.rentingRoomUID))
                        }
                    } completion: {
                        self.userLastName = self.getUserLastName(lastName: self.fetchedUserData)
                    }
                } else {
                    debugPrint("Document does not exist")
                }
            case .failure(let error):
                debugPrint("Error: \(error)")
            }
        }
    }
    
    private func getUserLastName(lastName: [UserDataModel]) -> String{
        var tempLastNameHolder = ""
        tempLastNameHolder = lastName.map({$0.lastName}).first?.description ?? ""
        return tempLastNameHolder
    }
    
    func getUserType(input: [UserDataModel]) -> String {
        var tempHolder = ""
        tempHolder = input.map({$0.userType}).first?.description ?? ""
        return tempHolder
    }
    
    func evaluateProviderType() -> String {
        var tempHoler = ""
        tempHoler = evaluateProviderType(input: fetchedUserData)
        return tempHoler
    }
    
    private func evaluateProviderType(input: [UserDataModel]) -> String {
        var tempHolder = ""
        tempHolder = input.map({$0.providerType}).first??.description ?? ""
        return tempHolder
    }
    
    func presentUserName() -> String {
        var userName = ""
        userName = presentUserName(input: fetchedUserData)
        return userName
    }
    
    private func presentUserName(input: [UserDataModel]) -> String {
        var tempFirstName = ""
        var tempLastName = ""
        tempFirstName = input.map({$0.firstName}).first?.description ?? ""
        tempLastName = input.map({$0.lastName}).first?.description ?? ""
        return tempFirstName + tempLastName
    }
    
    func presentUserId() -> String {
        var userId = ""
        userId = presentUserId(input: fetchedUserData)
        return userId
    }
    
    private func presentUserId(input: [UserDataModel]) -> String {
        var tempIdholder = ""
        tempIdholder = input.map({$0.id}).first?.description ?? ""
        return tempIdholder
    }
    
    func presentAddress() -> String {
        var tempAddressHolder = ""
        tempAddressHolder = presentAddress(input: fetchedUserData)
        return tempAddressHolder
    }
    
    private func presentAddress(input: [UserDataModel]) -> String {
        var tempAddressHolder = ""
        var tempTownHolder = ""
        var tempCityHolder = ""
        var tempZipCodeHolder = ""
        tempAddressHolder = input.map({$0.address}).first?.description ?? ""
        tempTownHolder = input.map({$0.town}).first?.description ?? ""
        tempCityHolder = input.map({$0.city}).first?.description ?? ""
        tempZipCodeHolder = input.map({$0.zip}).first?.description ?? ""
        return tempZipCodeHolder + tempCityHolder + tempTownHolder + tempAddressHolder
    }
    
    func presentMobileNumber() -> String {
        var tempMobileNumberHolder = ""
        tempMobileNumberHolder = presentMobileNumber(input: fetchedUserData)
        return tempMobileNumberHolder
    }
    
    private func presentMobileNumber(input: [UserDataModel]) -> String {
        var tempMobileNumberHolder = ""
        tempMobileNumberHolder = input.map({$0.mobileNumber}).first?.description ?? ""
        return tempMobileNumberHolder
    }
    
    func presentEmailAddress() -> String {
        var tempEmailAddress = ""
        tempEmailAddress = presentEmailAddress(input: fetchedUserData)
        return tempEmailAddress
    }
    
    private func presentEmailAddress(input: [UserDataModel]) -> String {
        var tempEmailAddress = ""
        tempEmailAddress = input.map({$0.emailAddress}).first??.description ?? ""
        return tempEmailAddress
    }
    
    
}



//func fetchListeningData(uidPath: String) {
//    let userRef = db.collection("users").document(uidPath)
//    userRef.addSnapshotListener { querySnapshot, error in
//        guard let document = querySnapshot else {
//            print("Error fetching document: \(error!)")
//            return
//        }
//        guard let data = document.data() else {
//            print("Document data was empty")
//            return
//        }
//        guard self.fetchData.isEmpty else {
//            self.fetchData.removeAll()
//            return
//        }
//        self.fetchData = data.map { (dataSnapShot) -> UserDataModel in
//
//            let id = data["id"] as? String ?? ""
//            let firstName = data["firstName"] as? String ?? ""
//            let lastName = data["lastname"] as? String ?? ""
//            let mobileNumber = data["mobileNumber"] as? String ?? ""
//            let dob = data["dob"] as? Date ?? Date()
//            let address = data["address"] as? String ?? ""
//            let town = data["town"] as? String ?? ""
//            let city = data["city"] as? String ?? ""
//            let zip = data["zip"] as? String ?? ""
//            let country = data["country"] as? String ?? ""
//            let gender = data["gender"] as? String ?? ""
//            let userType = data["userType"] as? String ?? ""
//
//            return UserDataModel(id: id, firstName: firstName, lastName: lastName, mobileNumber: mobileNumber, dob: dob, address: address, town: town, city: city, zip: zip, country: country, gender: gender, userType: userType)
//        }
//    }
//}


//func nestConverting(input dataSet: [MaintainTaskHolder]) {
//    for parentData in dataSet {
//        for childData in parentData.maintainTasks {
//            fetchMaintainInfo.append(MaintainTasks(taskName: childData.taskName, appointmentDate: childData.appointmentDate))
//        }
//    }
//}
