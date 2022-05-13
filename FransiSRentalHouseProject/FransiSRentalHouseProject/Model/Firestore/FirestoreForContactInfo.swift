//
//  FirestoreForContactInfo.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/5/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
//import FirebaseStorageSwift
import FirebaseAuth

class FirestoreForContactInfo: ObservableObject {
    let db = Firestore.firestore()
    
    
    // MARK: remove after testing
//    func summitContactInfo(question description: String = "", uidPath: String) {
//        let contactDM = ContactDataModel(contactDescription: description)
//        let contactRef = db.collection(uidPath)
//        do {
//           _ = try contactRef.addDocument(from: contactDM)
//        } catch {
//            print("Fail to upload contact information.")
//        }
//    }
    
    func summitContactInfoAsync(question description: String, uidPath: String) async throws {
        let contactRef = db.collection("ContactUs").document(uidPath).collection(uidPath)
        _ = try await contactRef.addDocument(data: [
            "contactDescription" : description,
            "sentDate" : Date()
        ])
    }
}

