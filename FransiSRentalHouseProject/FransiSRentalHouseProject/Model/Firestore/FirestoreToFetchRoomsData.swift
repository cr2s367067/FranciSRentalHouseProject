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
import FirebaseAuth


class FirestoreToFetchRoomsData: ObservableObject {
    
    let fetchFirestore = FetchFirestore()
    
    let db = Firestore.firestore()
    
    @Published var fetchRoomInfo: [RoomInfoDataModel] = []
    
    //    func summitRoomInfo(uidPath: String, holderName: String, mobileNumber: String, roomAddress: String, town: String, city: String, zipCode: String, emailAddress: String, roomArea: String, rentalPrice: String)
        func summitRoomInfo() {
            let roomRef = db.collection("Rooms")
            do {
                let newDocReference = try roomRef.addDocument(from: self.fetchRoomInfo)
                print("Success to updata with new reference: \(newDocReference)")
            } catch {
                print("Fail to upload")
            }
        }
    
    func listeningRoomInfo(uidPath: String) {
        let userRef = db.collection("MaintainTask").document().collection(uidPath).document(uidPath)
        userRef.addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty")
                return
            }
//            guard self.fetchMaintainInfo.isEmpty else {
//                self.fetchMaintainInfo.removeAll()
//                return
//            }
//            self.fetchRoomInfo = data.map { (dataSnapShot) -> RoomInfoDataModel in
//
//                let id = data["id"] as? String ?? ""
//                let holderName = data["holderName"] as? String ?? ""
//                let mobileNumber = data["mobileNumber"] as? String ?? ""
//                let roomAddress = data["roomAddress"] as? String ?? ""
//                let town = data["town"] as? String ?? ""
//                let city = data["city"] as? String ?? ""
//                let zipCode = data["zipCode"] as? String ?? ""
//                let emailAddress = data["emailAddress"] as? String ?? ""
//                let roomArea = data["roomArea"] as? String ?? ""
//                let rentalPrice = data["rentalPrice"] as? Int ?? 0
//                return RoomInfoDataModel(id: id,
//                                         holderName: holderName,
//                                         mobileNumber: mobileNumber,
//                                         roomAddress: roomAddress,
//                                         town: town,
//                                         city: city,
//                                         zipCode: zipCode,
//                                         emailAddress: emailAddress,
//                                         roomArea: roomArea,
//                                         rentalPrice: rentalPrice)
//            }
        }
    }
}
