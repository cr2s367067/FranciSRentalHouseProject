//
//  CryptoManagement.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/4.
//

// import Foundation
// import CryptoKit
// import SwiftUI
//
// class CryptoManagement: ObservableObject {
//
//    func encryptMessage(message: String, uidPath: String) throws {
//        let data = Data(message.utf8)
//        let digest = SHA256.hash(data: data)
//        let hash = digest.compactMap({String(format: "%02x", $0)}).joined()
//
//        let key = SymmetricKey(data: uidPath.data(using: .utf8) ?? Data())
//        print("\(key)")
//        guard let sealedBox = try? ChaChaPoly.seal(hash, using: key) else {
//            throw EncryptError.encryptError
//        }
//
//
//    }
//
// }
