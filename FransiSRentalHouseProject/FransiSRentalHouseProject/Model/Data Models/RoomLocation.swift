//
//  RoomLocation.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/22.
//

import SwiftUI
import MapKit

struct RoomLocation: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

extension RoomLocation {
    static let empty = RoomLocation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
}
