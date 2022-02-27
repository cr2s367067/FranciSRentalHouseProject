//
//  FetchFirestore.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class FetchFirestore: ObservableObject {
    
    let localData = LocalData()
    
    let auth = Auth.auth()
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    
    //    @Published var fireBaseUID = ""
    
    @Published var fetchData: [UserDataModel] = []
    @Published var userLastName = ""
    
    init() {
        //        fireBaseUID = getUID()
        //        fetchData(uidPath: getUID())
        //        self.fetchData.removeAll()
    }
    
    func getUID() -> String {
        let uid = auth.currentUser?.uid
        return uid ?? "Could not fetch UID."
    }
    
    func uploadUserInformation(uidPath: String, id: String , firstName: String, lastName: String, mobileNumber: String, dob: Date, address: String, town: String, city: String, zip: String, country: String, gender: String, userType: String) {
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
    
    func fetchUploadData(uidPath: String) {
        let userRef = db.collection("users").document(uidPath)
        userRef.getDocument { (document, error) in
            let result = Result {
                try document?.data(as: UserDataModel.self)
            }
            switch result {
            case .success(let userInfo):
                if let _userInfo = userInfo {
                    DispatchQueue.userInitial(delay: 1.0) {
                        if !self.fetchData.isEmpty {
                            self.fetchData.removeAll()
                            self.fetchData.append(UserDataModel(id: _userInfo.id, firstName: _userInfo.firstName, lastName: _userInfo.lastName, mobileNumber: _userInfo.mobileNumber, dob: _userInfo.dob, address: _userInfo.address, town: _userInfo.town, city: _userInfo.city, zip: _userInfo.zip, country: _userInfo.country, gender: _userInfo.gender, userType: _userInfo.userType))
                        } else {
                            self.fetchData.append(UserDataModel(id: _userInfo.id, firstName: _userInfo.firstName, lastName: _userInfo.lastName, mobileNumber: _userInfo.mobileNumber, dob: _userInfo.dob, address: _userInfo.address, town: _userInfo.town, city: _userInfo.city, zip: _userInfo.zip, country: _userInfo.country, gender: _userInfo.gender, userType: _userInfo.userType))
                        }
                    } completion: {
                        self.userLastName = self.getUserLastName(lastName: self.fetchData)
                    }
                } else {
                    debugPrint("Document does not exist")
                }
            case .failure(let error):
                debugPrint("Error: \(error)")
            }
        }
    }
    
    func fetchListeningData(uidPath: String) {
        let userRef = db.collection("users").document(uidPath)
        userRef.addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty")
                return
            }
            guard self.fetchData.isEmpty else {
                self.fetchData.removeAll()
                return
            }
            self.fetchData = data.map { (dataSnapShot) -> UserDataModel in
                
                let id = data["id"] as? String ?? ""
                let firstName = data["firstName"] as? String ?? ""
                let lastName = data["lastname"] as? String ?? ""
                let mobileNumber = data["mobileNumber"] as? String ?? ""
                let dob = data["dob"] as? Date ?? Date()
                let address = data["address"] as? String ?? ""
                let town = data["town"] as? String ?? ""
                let city = data["city"] as? String ?? ""
                let zip = data["zip"] as? String ?? ""
                let country = data["country"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let userType = data["userType"] as? String ?? ""
                
                return UserDataModel(id: id, firstName: firstName, lastName: lastName, mobileNumber: mobileNumber, dob: dob, address: address, town: town, city: city, zip: zip, country: country, gender: gender, userType: userType)
            }
        }
    }
    
    func getUserType(input: [UserDataModel]) -> String {
        var tempHolder = ""
        tempHolder = input.map({$0.userType}).first?.description ?? ""
        return tempHolder
    }
    
    
    private func getUserLastName(lastName: [UserDataModel]) -> String{
        var tempLastNameHolder = ""
        tempLastNameHolder = lastName.map({$0.lastName}).first?.description ?? ""
        return tempLastNameHolder
    }
    
}


