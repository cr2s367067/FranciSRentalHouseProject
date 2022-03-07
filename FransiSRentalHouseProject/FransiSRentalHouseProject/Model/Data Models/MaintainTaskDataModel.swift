//
//  MaintainTaskDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct MaintainTaskHolder: Identifiable, Codable {
    @DocumentID var id: String?
    var taskName: String
    var appointmentDate: Date
    var isFixed: Bool?
    
//    enum Codingkeys: String, CodingKey {
//        case id
//        case taskName
//        case appointmentDate
//    }
}

extension MaintainTaskHolder {
   static let empty = MaintainTaskHolder(taskName: "", appointmentDate: Date(), isFixed: false)
}
