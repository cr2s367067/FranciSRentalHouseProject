//
//  ContractCollectionVM.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


@MainActor
class ContractCollectionVM: ObservableObject {
    let db = Firestore.firestore()
    
    func checkRenter(roomsData: RoomDM) -> String {
        var result = ""
        if roomsData.renterUID.isEmpty {
            result = "Haven't Rented"
        } else {
            Task {
                do {
                    result = try await getRenterName(user: roomsData.renterUID)
                } catch {
                    print("fail to get user's name")
                }
            }
        }
        return result
    }
    
    private func getRenterName(user uidPath: String) async throws -> String {
        let userRef = db.collection("User").document(uidPath)
        let doc = try await userRef.getDocument(as: UserDM.self)
        let firstName = doc.firstName
        let lastName = doc.lastName
        return lastName + firstName
    }
}
