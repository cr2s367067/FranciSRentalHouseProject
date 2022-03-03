//
//  FirestoreToFetchRoomsData.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


class FirestoreToFetchRoomsData: ObservableObject {
    
    
    let localData = LocalData()
    let firebaseAuth = FirebaseAuth()
    
    let db = Firestore.firestore()
    
    @Published var fetchRoomInfo = [RoomInfoDataModel]()
    
    func listenRoomsData() {
        listeningRoomInfo(uidPath: firebaseAuth.getUID())
    }
    
    
    func summitRoomInfo(inputRoomData: RoomInfoDataModel, uidPath: String) {
        let roomRef = db.collection("Rooms").document(uidPath).collection(uidPath)
        
        roomRef.addDocument(data: [
            "holderName" : inputRoomData.holderName,
            "mobileNumber" : inputRoomData.mobileNumber,
            "roomAddress" : inputRoomData.roomAddress,
            "town" : inputRoomData.town,
            "city" : inputRoomData.city,
            "zipCode" : inputRoomData.zipCode,
            "emailAddress" : inputRoomData.emailAddress,
            "roomArea" : inputRoomData.roomArea,
            "rentalPrice" : inputRoomData.rentalPrice,
            "roomImage" : inputRoomData.roomImage ?? ""
        ], completion: { error in
            if let _error = error {
                print("Fail to summit room information: \(_error)")
            }
        })
    }
    
    private func listeningRoomInfo(uidPath: String) {
        let roomRef = db.collection("Rooms").document(uidPath).collection(uidPath)
        roomRef.addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No document found")
                return
            }
            
            self?.fetchRoomInfo = documents.map { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let holderName = data["holderName"] as? String ?? ""
                let mobileNumber = data["mobileNumber"] as? String ?? ""
                let roomAddress = data["roomAddress"] as? String ?? ""
                let town = data["town"] as? String ?? ""
                let city = data["city"] as? String ?? ""
                let zipCode = data["zipCode"] as? String ?? ""
                let emailAddress = data["emailAddress"] as? String ?? ""
                let roomArea = data["roomArea"] as? String ?? ""
                let rentalPrice = data["rentalPrice"] as? Int ?? 0
                return RoomInfoDataModel(holderName: holderName,
                                         mobileNumber: mobileNumber,
                                         roomAddress: roomAddress,
                                         town: town,
                                         city: city,
                                         zipCode: zipCode,
                                         emailAddress: emailAddress,
                                         roomArea: roomArea,
                                         rentalPrice: rentalPrice)
            }
        }
    }
    
}






//        userRef.addSnapshotListener { querySnapshot, error in
//            guard let document = querySnapshot else {
//                print("Error fetching document: \(error!)")
//                return
//            }
//            guard let data = document.data() else {
//                print("Document data was empty")
//                return
//            }
//
//            self.fetchRoomInfo = data.map { (dataSnapShot) -> RoomInfoDataModel in
//
//                let holderName = data["holderName"] as? String ?? ""
//                let mobileNumber = data["mobileNumber"] as? String ?? ""
//                let roomAddress = data["roomAddress"] as? String ?? ""
//                let town = data["town"] as? String ?? ""
//                let city = data["city"] as? String ?? ""
//                let zipCode = data["zipCode"] as? String ?? ""
//                let emailAddress = data["emailAddress"] as? String ?? ""
//                let roomArea = data["roomArea"] as? String ?? ""
//                let rentalPrice = data["rentalPrice"] as? Int ?? 0
//                return RoomInfoDataModel(holderName: holderName,
//                                         mobileNumber: mobileNumber,
//                                         roomAddress: roomAddress,
//                                         town: town,
//                                         city: city,
//                                         zipCode: zipCode,
//                                         emailAddress: emailAddress,
//                                         roomArea: roomArea,
//                                         rentalPrice: rentalPrice)
//            }
//        }
