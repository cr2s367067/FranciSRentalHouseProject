//
//  FirestoreForContactInfo.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/5/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseStorageSwift
import FirebaseAuth

class FirestoreForContactInfo: ObservableObject {
    let db = Firestore.firestore()
    
    func summitContactInfo(question description: String = "", uidPath: String) {
        let contactDM = ContactDataModel(connectDescription: description)
        let contactRef = db.collection(uidPath)
        do {
           _ = try contactRef.addDocument(from: contactDM)
        } catch {
            print("Fail to upload contact information.")
        }
    }
}
