//
//  RoomsLocationViewModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/22.
//

import MapKit
import SwiftUI


class RoomsLocationDataModel: ObservableObject {
    
    @Published var roomLocation = [RoomLocation]()
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.0, longitude: 121.0), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    private func convertedAddress(address: String) async throws -> CLLocationCoordinate2D {
        let geoCoder = CLGeocoder()
        let converted = try await geoCoder.geocodeAddressString(address)
        let lat = converted.first?.location?.coordinate.latitude ?? 0.0
        let lon = converted.first?.location?.coordinate.longitude ?? 0.0
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    private func showMapRegion(address: String) async throws -> MKCoordinateRegion {
        let center = try await convertedAddress(address: address)
        return MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.00875, longitudeDelta: 0.00875))
    }
    
    @MainActor
    func makeConvertAndAppend(address: String) async throws {
        let convertedCor = try await convertedAddress(address: address)
        self.mapRegion = try await showMapRegion(address: address)
        roomLocation.append(RoomLocation(coordinate: convertedCor))
    }
    
}
