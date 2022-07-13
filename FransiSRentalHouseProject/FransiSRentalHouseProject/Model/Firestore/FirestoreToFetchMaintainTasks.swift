//
//  FirestoreToFetchMaintainTasks.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SwiftUI

class FirestoreToFetchMaintainTasks: ObservableObject {
    let db = Firestore.firestore()

    @Published var fetchMaintainInfo = [MaintainDM]()
    @Published var showMaintainDetail = false
}

extension FirestoreToFetchMaintainTasks {
    func uploadMaintainInfoAsync(
        uidPath: String,
        roomUID: String,
        maintain task: MaintainDM
    ) async throws {
        let maintainRef = db.collection("RoomsForOwner").document(uidPath).collection("Rooms").document(roomUID).collection("MaintainTasks")
        _ = try await maintainRef.addDocument(data: [
            "maintainDescription": task.maintainDescription,
            "appointmentDate": task.appointmentDate,
            "itemImageURL": task.itemImageURL,
            "isFixed": task.isFixed,
            "publishDate": Date(),
        ])
    }

    @MainActor
    func fetchMaintainInfoAsync(
        uidPath: String,
        roomUID: String
    ) async throws {
        let maintainRef = db.collection("RoomsForOwner").document(uidPath).collection("Rooms").document(roomUID).collection("MaintainTasks").order(by: "appointmentDate", descending: false)
        let document = try await maintainRef.getDocuments().documents
        fetchMaintainInfo = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: MaintainDM.self)
            }
            switch result {
            case let .success(data):
                return data
            case let .failure(error):
                print("some error eccure: \(error)")
            }
            return nil
        }
    }
}

extension FirestoreToFetchMaintainTasks {
    func updateFixedInfo(
        uidPath: String,
        roomUID: String,
        maintainDocID: String
    ) async throws {
        let maintainRef = db.collection("RoomsForOwner").document(uidPath).collection("Rooms").document(roomUID).collection("MaintainTasks").document(maintainDocID)
        try await maintainRef.updateData([
            "isFixed": true,
        ])
    }

    func deleteFixedItem(
        uidPath: String,
        roomUID: String,
        maintainDocID: String
    ) async throws {
        let maintainRef = db.collection("RoomsForOwner").document(uidPath).collection("Rooms").document(roomUID).collection("MaintainTasks").document(maintainDocID)
        try await maintainRef.delete()
    }

    func updateMaintainTaskInfo(
        provider uidPath: String,
        rented roomUID: String,
        update task: MaintainDM
//        maintainDocID: String
    ) async throws {
        let maintainRef = db.collection("RoomsForOwner").document(uidPath).collection("Rooms").document(roomUID).collection("MaintainTasks").document(task.id ?? "")
        try await maintainRef.updateData([
            //            "description": newTaskDes,
//            "appointmentDate": newAppointDate,
//            "isFixed": false,
//            "itemImageURL" : newImageURL
            "maintainDescription": task.maintainDescription,
            "appointmentDate": task.appointmentDate,
            "itemImageURL": task.itemImageURL,
            "isFixed": task.isFixed,
            "publishDate": Date(),
        ])
    }
}
