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

    @Published var fetchMaintainInfo = [MaintainTaskHolder]()
}

extension FirestoreToFetchMaintainTasks {
    func uploadMaintainInfoAsync(uidPath: String, taskName: String, appointmentDate: Date, docID: String, itemImageURL: String) async throws {
        let maintainRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID).collection("MaintainTasks")
        _ = try await maintainRef.addDocument(data: [
            "description": taskName,
            "appointmentDate": appointmentDate,
            "isFixed": false,
            "itemImageURL": itemImageURL,
        ])
    }

    @MainActor
    func fetchMaintainInfoAsync(uidPath: String, docID: String) async throws {
        let maintainRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID).collection("MaintainTasks").order(by: "appointmentDate", descending: false)
        let document = try await maintainRef.getDocuments().documents
        fetchMaintainInfo = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: MaintainTaskHolder.self)
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
    func updateFixedInfo(uidPath: String, docID: String, maintainDocID: String) async throws {
        let maintainRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID).collection("MaintainTasks").document(maintainDocID)
        try await maintainRef.updateData([
            "isFixed": true,
        ])
    }

    func deleteFixedItem(uidPath: String, docID: String, maintainDocID: String) async throws {
        let maintainRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID).collection("MaintainTasks").document(maintainDocID)
        try await maintainRef.delete()
    }
}
