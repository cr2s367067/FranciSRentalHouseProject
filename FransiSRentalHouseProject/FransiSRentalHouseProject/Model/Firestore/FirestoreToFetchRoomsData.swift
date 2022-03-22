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
    
    @EnvironmentObject var localData: LocalData
    
    //    let localData = LocalData()
    let firebaseAuth = FirebaseAuth()
    
    let db = Firestore.firestore()
    
    @Published var fetchRoomInfoFormOwner = [RoomInfoDataModel]()
    @Published var fetchRoomInfoFormPublic = [RoomInfoDataModel]()
    
    @Published var testingHolder = [RoomInfoDataModel]()
    
    @Published var roomID = ""
    
    func listenRoomsData() {
        listeningRoomInfo(uidPath: firebaseAuth.getUID())
    }
    
    func roomIdGenerator() -> String {
        let roomId = UUID().uuidString
        roomID = roomId
        return roomID
    }

    
    func listeningRoomInfoForPublic() {
        let roomPublicRef = db.collection("RoomsForPublic")
        roomPublicRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot?.documents else {
                print("Error fetch document: \(error!)")
                return
            }
            
            self.fetchRoomInfoFormPublic = document.map { queryDocumentSnapshot -> RoomInfoDataModel in
                let data = queryDocumentSnapshot.data()
                let docID = queryDocumentSnapshot.documentID
                let holderName = data["holderName"] as? String ?? ""
                let mobileNumber = data["mobileNumber"] as? String ?? ""
                let roomAddress = data["roomAddress"] as? String ?? ""
                let town = data["town"] as? String ?? ""
                let city = data["city"] as? String ?? ""
                let zipCode = data["zipCode"] as? String ?? ""
                let roomArea = data["roomArea"] as? String ?? ""
                let rentalPrice = data["rentalPrice"] as? String ?? ""
                let someoneDeadInRoom = data["someoneDeadInRoom"] as? String ?? ""
                let waterLeakingProblem = data["waterLeakingProblem"] as? String ?? ""
                let roomUID = data["roomUID"] as? String ?? ""
                let roomImage = data["roomImage"] as? String ?? ""
                let providedBy = data["providedBy"] as? String ?? ""
                return RoomInfoDataModel(docID: docID, roomUID: roomUID, holderName: holderName, mobileNumber: mobileNumber, roomAddress: roomAddress, town: town, city: city, zipCode: zipCode, roomArea: roomArea, rentalPrice: rentalPrice, someoneDeadInRoom: someoneDeadInRoom, waterLeakingProblem: waterLeakingProblem, roomImage: roomImage, providedBy: providedBy)
                
            }
        }
    }
    
    func listeningRoomInfo(uidPath: String) {
        let roomOwnerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath)
        roomOwnerRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot?.documents else {
                print("Error fetch document: \(error!)")
                return
            }
            self.fetchRoomInfoFormOwner = document.map { queryDocumentSnapshot -> RoomInfoDataModel in
                let data = queryDocumentSnapshot.data()
                let docID = queryDocumentSnapshot.documentID
                let holderName = data["holderName"] as? String ?? ""
                let mobileNumber = data["mobileNumber"] as? String ?? ""
                let roomAddress = data["roomAddress"] as? String ?? ""
                let town = data["town"] as? String ?? ""
                let city = data["city"] as? String ?? ""
                let zipCode = data["zipCode"] as? String ?? ""
                let roomArea = data["roomArea"] as? String ?? ""
                let rentalPrice = data["rentalPrice"] as? String ?? ""
                let someoneDeadInRoom = data["someoneDeadInRoom"] as? String ?? ""
                let waterLeakingProblem = data["waterLeakingProblem"] as? String ?? ""
                let roomUID = data["roomUID"] as? String ?? ""
                let roomImage = data["roomImage"] as? String ?? ""
                let isRented = data["isRented"] as? Bool ?? false
                let rentedBy = data["rentedBy"] as? String ?? ""
                let providedBy = data["providedBy"] as? String ?? ""
                return RoomInfoDataModel(docID: docID, roomUID: roomUID, holderName: holderName, mobileNumber: mobileNumber, roomAddress: roomAddress, town: town, city: city, zipCode: zipCode, roomArea: roomArea, rentalPrice: rentalPrice, someoneDeadInRoom: someoneDeadInRoom, waterLeakingProblem: waterLeakingProblem, roomImage: roomImage,isRented: isRented,rentedBy: rentedBy, providedBy: providedBy)
                
            }
        }
    }
    
}

extension FirestoreToFetchRoomsData {
    func summitRoomInfoAsync(docID: String, uidPath: String, roomUID: String = "", holderName: String, mobileNumber: String, roomAddress: String, town: String, city: String, zipCode: String, roomArea: String, rentalPrice: String, someoneDeadInRoom: String, waterLeakingProblem: String, roomImageURL: String, isRented: Bool = false, rentedBy: String = "") async throws {
        let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID)
        let roomPublicRef = db.collection("RoomsForPublic").document(docID)
        _ = try await roomOwerRef.setData([
            "roomUID" : roomUID,
            "holderName" : holderName,
            "mobileNumber" : mobileNumber,
            "roomAddress" : roomAddress,
            "town" : town,
            "city" : city,
            "zipCode" : zipCode,
            "roomArea" : roomArea,
            "rentalPrice" : rentalPrice,
            "someoneDeadInRoom" : someoneDeadInRoom,
            "waterLeakingProblem" : waterLeakingProblem,
            "roomImage" : roomImageURL,
            "isRented" : isRented,
            "rentedBy" : rentedBy,
            "providedBy": uidPath
        ])
        _ = try await roomPublicRef.setData([
            "roomUID" : roomUID,
            "holderName" : holderName,
            "mobileNumber" : mobileNumber,
            "roomAddress" : roomAddress,
            "town" : town,
            "city" : city,
            "zipCode" : zipCode,
            "roomArea" : roomArea,
            "rentalPrice" : rentalPrice,
            "someoneDeadInRoom" : someoneDeadInRoom,
            "waterLeakingProblem" : waterLeakingProblem,
            "roomImage" : roomImageURL,
            "providedBy": uidPath
        ])
    }
}

extension FirestoreToFetchRoomsData {
    func deleteRentedRoom(docID: String) async throws {
        let roomPublicRef = db.collection("RoomsForPublic")
        try await roomPublicRef.document(docID).delete()
    }
    
    func updateRentedRoom(uidPath: String, docID: String, renterID: String) async throws {
        let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID)
        try await roomOwerRef.updateData([
            "isRented" : true,
            "rentedBy" : renterID
        ])
    }
}
