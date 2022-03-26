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
    
    func fetchListeningMaintainInfo(uidPath: String, roomUID: String = "") {
        let userRef = db.collection("MaintainTask").document(roomUID)
        userRef.addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty")
                return
            }
            guard self.fetchMaintainInfo.isEmpty else {
                self.fetchMaintainInfo.removeAll()
                return
            }
            self.fetchMaintainInfo = data.map { (dataSnapShot) -> MaintainTaskHolder in
                
                let id = data["id"] as? String ?? ""
                let taskName = data["taskName"] as? String ?? ""
                let appointmentDate = data["appointmentDate"] as? Date ?? Date()
                return MaintainTaskHolder(id: id, description: taskName, appointmentDate: appointmentDate)
            }
        }
    }
}

extension FirestoreToFetchMaintainTasks {
    func uploadMaintainInfoAsync(uidPath: String, taskName: String, appointmentDate: Date, isFixed: Bool? = false, roomUID: String = "") async throws {
        _ = MaintainTaskHolder(description: taskName, appointmentDate: appointmentDate, isFixed: isFixed)
        let maintainRef = db.collection("MaintainTask").document(uidPath).collection(roomUID)
        _ = try await maintainRef.addDocument(data: [
            "description": taskName,
            "appointmentDate": appointmentDate,
            "isFixed": isFixed ?? false
        ])
    }
    
    @MainActor
    func fetchMaintainInfoAsync(uidPath: String?, roomUID: String?) async throws {
        guard let uidPath = uidPath else { return }
        guard let roomUID = roomUID else { return }
        let maintainRef = db.collection("MaintainTask").document(uidPath).collection(roomUID)
//        print(maintainRef)
        let document = try await maintainRef.getDocuments().documents
//        print(document)
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
