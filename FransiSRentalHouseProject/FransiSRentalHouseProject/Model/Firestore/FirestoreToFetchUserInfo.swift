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
    
    let fetchFirestore = FetchFirestore()
    
    let db = Firestore.firestore()
    
    @Published var fetchedUserData: [UserDataModel] = []
    @Published var userLastName = ""
    
    func createUserInfomation(uidPath: String, id: String , firstName: String, lastName: String, mobileNumber: String, dob: Date, address: String, town: String, city: String, zip: String, country: String, gender: String, userType: String) {
        let userInfo = UserDataModel(id: id, firstName: firstName, lastName: lastName, mobileNumber: mobileNumber, dob: dob, address: address, town: town, city: city, zip: zip, country: country, gender: gender, userType: userType)
        do {
            try db.collection("users").document(uidPath).setData(from: userInfo)
        } catch {
            print("Error writting!")
        }
    }
    
    func updateUserInformation(uidPath: String, id: String , firstName: String, lastName: String, mobileNumber: String, dob: Date, address: String, town: String, city: String, zip: String, country: String, gender: String) {
        db.collection("users").document(uidPath).updateData([
            "id" : id,
            "firstName" : firstName,
            "lastName" : lastName,
            "mobileNumber" : mobileNumber,
            "dob" : dob,
            "address" : address,
            "town" : town,
            "city" : city,
            "country" : country,
            "gender" : gender,
        ], completion: { error in
            if let _error = error {
                print("error to update: \(_error)")
            } else {
                print("Update success")
            }
        })
    }
    
    func fetchUploadedUserData(uidPath: String) {
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
                            self.fetchedUserData.append(UserDataModel(id: _userInfo.id, firstName: _userInfo.firstName, lastName: _userInfo.lastName, mobileNumber: _userInfo.mobileNumber, dob: _userInfo.dob, address: _userInfo.address, town: _userInfo.town, city: _userInfo.city, zip: _userInfo.zip, country: _userInfo.country, gender: _userInfo.gender, userType: _userInfo.userType))
                        } else {
                            self.fetchedUserData.append(UserDataModel(id: _userInfo.id, firstName: _userInfo.firstName, lastName: _userInfo.lastName, mobileNumber: _userInfo.mobileNumber, dob: _userInfo.dob, address: _userInfo.address, town: _userInfo.town, city: _userInfo.city, zip: _userInfo.zip, country: _userInfo.country, gender: _userInfo.gender, userType: _userInfo.userType))
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
    
}
