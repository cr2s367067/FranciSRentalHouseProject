//
//  MaintainTaskDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI

struct MaintainTaskHolder: Identifiable, Codable {
    var id = UUID().uuidString
    var taskName: String
    var appointmentDate: Date
    
    enum Codingkeys: String, CodingKey {
        case id
        case taskName
        case appointmentDate
    }
}
