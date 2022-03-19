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
    
    @Published var fetchMaintainInfo: [MaintainTaskHolder] = []
    
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
    
    // MARK: remove after testing
    func uploadMaintainInfo(uidPath: String, taskName: String, appointmentDate: Date, isFixed: Bool? = false, roomUID: String = "") {
        let maintainInfo = MaintainTaskHolder(description: taskName, appointmentDate: appointmentDate, isFixed: isFixed)
        let maintainRef = db.collection("MaintainTask").document(uidPath).collection(roomUID)
        do {
           _ = try maintainRef.addDocument(from: maintainInfo.self)
        } catch {
            print("Fail to upload task")
        }
    }
    
    // MARK: remove after testing
    func fetchMaintainInfo(uidPath: String) {
        let userRef = db.collection("MaintainTask").document(uidPath)
        userRef.getDocument { (document, error) in
            let result = Result {
                try document?.data(as: MaintainTaskHolder.self)
            }
            switch result {
            case .success(let success):
                if let _userMaintainInfo = success {
                    self.fetchMaintainInfo.append(MaintainTaskHolder(description: _userMaintainInfo.description, appointmentDate: _userMaintainInfo.appointmentDate))
                }
            case .failure(let error):
                print("Error to fetch maintain information: \(error)")
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
    
    func fetchMaintainInfoAsync(uidPath: String) async throws {
        let userRef = db.collection("MaintainTask").document(uidPath)
        let maintainData = try await userRef.getDocument()
        guard let data = maintainData.data() else { return }
        let description = data["description"] as? String ?? ""
        let appointmentDate = data["appointmentDate"] as? Date ?? Date()
        let isFixed = data["isFixed"] as? Bool ?? false
        let maintainDataSet = MaintainTaskHolder(description: description, appointmentDate: appointmentDate, isFixed: isFixed)
        self.fetchMaintainInfo.append(maintainDataSet)
    }
    
}
