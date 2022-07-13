//
//  FirestoreFetchingAnnouncement.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/27.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SwiftUI

class FirestoreFetchingAnnouncement: ObservableObject {
    let db = Firestore.firestore()

    @Published var announcementDataSet = [AnnouncementDataModel]()

    @MainActor
    func fetchAnnouncement() async throws {
        let announcementRef = db.collection("Announcement")
        let document = try await announcementRef.getDocuments().documents
        announcementDataSet = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: AnnouncementDataModel.self)
            }
            switch result {
            case let .success(data):
                return data
            case let .failure(error):
                print("some error: \(error)")
            }
            return nil
        }
    }
}
