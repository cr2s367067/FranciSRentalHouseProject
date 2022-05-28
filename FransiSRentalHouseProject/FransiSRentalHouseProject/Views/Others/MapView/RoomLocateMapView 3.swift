//
//  RoomLocateMapView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/22.
//

import SwiftUI
import MapKit

struct RoomLocateMapView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var roomsLocationDataModel: RoomsLocationDataModel
    
    let address: String
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $roomsLocationDataModel.mapRegion, annotationItems: roomsLocationDataModel.roomLocation) { locate in
                MapMarker(coordinate: locate.coordinate)
            }
        }
        .task {
            do {
                try await roomsLocationDataModel.makeConvertAndAppend(address: address)
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
}

struct RoomLocateMapView_Previews: PreviewProvider {
    static var previews: some View {
        RoomLocateMapView(address: "")
    }
}

struct SheetPullBar: View {
    var body: some View {
        HStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.gray.opacity(0.8))
                .frame(width: 30, height: 4, alignment: .center)
        }
//        .padding(.horizontal)
    }
}

/*
 get async {
     let geoCoder = CLGeocoder()
     var coor = CLLocationCoordinate2D()
     do {
         let converted = try await geoCoder.geocodeAddressString(address)
         let lat = converted.map({$0.location?.coordinate.latitude}).startIndex
         let lon = converted.map({$0.location?.coordinate.longitude}).startIndex
         coor = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
         return coor
     } catch {
         print("Can't covert address to coordinate")
     }
     return coor
 }
*/



