//
//  RoomLocationDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/22.
//

import SwiftUI
import MapKit

struct RoomLocationDataModel: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

extension RoomLocationDataModel {
    static let empty = RoomLocationDataModel(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
}
