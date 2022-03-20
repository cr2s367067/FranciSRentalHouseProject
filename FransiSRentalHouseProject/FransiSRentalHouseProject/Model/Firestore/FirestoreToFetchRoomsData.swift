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
    
    
    // MARK: remove after testing
//    func summitRoomInfo(uidPath: String, roomUID: String = "", holderName: String, mobileNumber: String, roomAddress: String, town: String, city: String, zipCode: String, roomArea: String, rentalPrice: String, someoneDeadInRoom: String, waterLeakingProblem: String, roomImageURL: String) {
//        let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath)
//        let roomPublicRef = db.collection("RoomsForPublic")
//
//        roomOwerRef.addDocument(data: [
//            "roomUID" : roomUID,
//            "holderName" : holderName,
//            "mobileNumber" : mobileNumber,
//            "roomAddress" : roomAddress,
//            "town" : town,
//            "city" : city,
//            "zipCode" : zipCode,
//            "roomArea" : roomArea,
//            "rentalPrice" : rentalPrice,
//            "someoneDeadInRoom" : someoneDeadInRoom,
//            "waterLeakingProblem" : waterLeakingProblem,
//            "roomImage" : roomImageURL
//        ], completion: { error in
//            if let _error = error {
//                print("Fail to summit room information: \(_error)")
//            }
//        })
//
//        roomPublicRef.addDocument(data: [
//            "roomUID" : roomUID,
//            "holderName" : holderName,
//            "mobileNumber" : mobileNumber,
//            "roomAddress" : roomAddress,
//            "town" : town,
//            "city" : city,
//            "zipCode" : zipCode,
//            "roomArea" : roomArea,
//            "rentalPrice" : rentalPrice,
//            "someoneDeadInRoom" : someoneDeadInRoom,
//            "waterLeakingProblem" : waterLeakingProblem,
//            "roomImage" : roomImageURL
//        ]) { error in
//            if let _error = error {
//                print("Fail to summit romm in public: \(_error)")
//            }
//        }
//    }
    

    
    func listeningRoomInfoForPublic() {
        let roomPublicRef = db.collection("RoomsForPublic")
        roomPublicRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot?.documents else {
                print("Error fetch document: \(error!)")
                return
            }
            
            self.fetchRoomInfoFormPublic = document.map { queryDocumentSnapshot -> RoomInfoDataModel in
                let data = queryDocumentSnapshot.data()
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
                return RoomInfoDataModel(roomUID: roomUID, holderName: holderName, mobileNumber: mobileNumber, roomAddress: roomAddress, town: town, city: city, zipCode: zipCode, roomArea: roomArea, rentalPrice: rentalPrice, someoneDeadInRoom: someoneDeadInRoom, waterLeakingProblem: waterLeakingProblem, roomImage: roomImage)
                
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
                return RoomInfoDataModel(roomUID: roomUID, holderName: holderName, mobileNumber: mobileNumber, roomAddress: roomAddress, town: town, city: city, zipCode: zipCode, roomArea: roomArea, rentalPrice: rentalPrice, someoneDeadInRoom: someoneDeadInRoom, waterLeakingProblem: waterLeakingProblem, roomImage: roomImage)
                
            }
        }
    }
    
}

extension FirestoreToFetchRoomsData {
    func summitRoomInfoAsync(uidPath: String, roomUID: String = "", holderName: String, mobileNumber: String, roomAddress: String, town: String, city: String, zipCode: String, roomArea: String, rentalPrice: String, someoneDeadInRoom: String, waterLeakingProblem: String, roomImageURL: String) async throws {
        let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath)
        let roomPublicRef = db.collection("RoomsForPublic")
        
        roomOwerRef.addDocument(data: [
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
            "roomImage" : roomImageURL
        ], completion: { error in
            if let _error = error {
                print("Fail to summit room information: \(_error)")
            }
        })
        
        roomPublicRef.addDocument(data: [
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
            "roomImage" : roomImageURL
        ]) { error in
            if let _error = error {
                print("Fail to summit romm in public: \(_error)")
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


//func summitRoomInfo(inputRoomData: RoomInfoDataModel, uidPath: String) {
//    let roomRef = db.collection("Rooms").document(uidPath).collection(uidPath)
//
//    roomRef.addDocument(data: [
//        "roomUID" : inputRoomData.roomUID ?? "",
//        "holderName" : inputRoomData.holderName,
//        "mobileNumber" : inputRoomData.mobileNumber,
//        "roomAddress" : inputRoomData.roomAddress,
//        "town" : inputRoomData.town,
//        "city" : inputRoomData.city,
//        "zipCode" : inputRoomData.zipCode,
////            "emailAddress" : inputRoomData.emailAddress,
//        "roomArea" : inputRoomData.roomArea,
//        "rentalPrice" : inputRoomData.rentalPrice,
//        "roomImage" : inputRoomData.roomImage!
//    ], completion: { error in
//        if let _error = error {
//            print("Fail to summit room information: \(_error)")
//        }
//    })
//}


//    private func listeningRoomInfo(uidPath: String) {
//        let roomRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath)
//        roomRef.addSnapshotListener { [weak self] (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("No document found")
//                return
//            }
//
//            self?.fetchRoomInfoFormOwner = documents.map { queryDocumentSnapshot -> RoomInfoDataModel in
//                let data = queryDocumentSnapshot.data()
//                let holderName = data["holderName"] as? String ?? ""
//                let mobileNumber = data["mobileNumber"] as? String ?? ""
//                let roomAddress = data["roomAddress"] as? String ?? ""
//                let town = data["town"] as? String ?? ""
//                let city = data["city"] as? String ?? ""
//                let zipCode = data["zipCode"] as? String ?? ""
//                //                let emailAddress = data["emailAddress"] as? String ?? ""
//                let roomArea = data["roomArea"] as? String ?? ""
//                let rentalPrice = data["rentalPrice"] as? Int ?? 0
//                let someoneDeadInRoom = data["someoneDeadInRoom"] as? String ?? ""
//                let waterLeakingProblem = data["waterLeakingProblem"] as? String ?? ""
//                let roomUID = data["roomUID"] as? String ?? ""
//                let roomImage = data["roomImage"] as? String ?? ""
//                return RoomInfoDataModel(id: .init(), roomUID: roomUID, holderName: holderName,
//                                         mobileNumber: mobileNumber,
//                                         roomAddress: roomAddress,
//                                         town: town,
//                                         city: city,
//                                         zipCode: zipCode,
//                                         roomArea: roomArea,
//                                         rentalPrice: rentalPrice,
//                                         someoneDeadInRoom: someoneDeadInRoom,
//                                         waterLeakingProblem: waterLeakingProblem,
//                                         roomImage: roomImage)
//            }
//        }
//    }
