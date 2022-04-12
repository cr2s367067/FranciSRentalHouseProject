//
//  FirestoreToFetchMaintainTasks.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth


class FirestoreToFetchMaintainTasks: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var fetchMaintainInfo = [MaintainTaskHolder]()
    
    
}

extension FirestoreToFetchMaintainTasks {
    func uploadMaintainInfoAsync(uidPath: String, taskName: String, appointmentDate: Date, roomUID: String = "", itemImageURL: String) async throws {
        let maintainRef = db.collection("MaintainTask").document(uidPath).collection(roomUID)
        _ = try await maintainRef.addDocument(data: [
            "description": taskName,
            "appointmentDate": appointmentDate,
            "isFixed": false,
            "itemImageURL" : itemImageURL
        ])
    }
    
    @MainActor
    func fetchMaintainInfoAsync(uidPath: String?, roomUID: String?) async throws {
        guard let uidPath = uidPath else { return }
        guard let roomUID = roomUID else { return }
        let maintainRef = db.collection("MaintainTask").document(uidPath).collection(roomUID).order(by: "appointmentDate", descending: false)
        let document = try await maintainRef.getDocuments().documents
        self.fetchMaintainInfo = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: MaintainTaskHolder.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print("some error eccure: \(error)")
            }
            return nil
        }
    }
}


extension FirestoreToFetchMaintainTasks {
    func updateFixedInfo(uidPath: String, roomUID: String, maintainDocID: String) async throws {
        let maintainRef = db.collection("MaintainTask").document(uidPath).collection(roomUID).document(maintainDocID)
        try await maintainRef.updateData([
            "isFixed" : true
        ])
    }
}
