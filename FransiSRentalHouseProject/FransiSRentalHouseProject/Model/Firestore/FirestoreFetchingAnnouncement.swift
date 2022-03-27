//
//  FirestoreFetchingAnnouncement.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/27.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class FirestoreFetchingAnnouncement: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var announcementDataSet = [AnnouncementDataModel]()
    
    @MainActor
    func fetchAnnouncement() async throws {
        let announcementRef = db.collection("Announcement")
        let document = try await announcementRef.getDocuments().documents
        self.announcementDataSet = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: AnnouncementDataModel.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print("some error: \(error)")
            }
            return nil
        })
    }
    
}
