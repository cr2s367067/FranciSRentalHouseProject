//
//  GridView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct GridView: View {
    
    let storageForRoomsImage = StorageForRoomsImage()
    let firebaseAuth = FirebaseAuth()
    
    
    var imageURL: String
    var roomTown: String
    var roomCity: String
    var objectPrice: Int
    
    func cityAndTown() -> String {
        var tempHolder = ""
        tempHolder = cityAndTown(roomCity: roomCity, roomTown: roomTown)
        return tempHolder
    }
    
    private func cityAndTown(roomCity: String, roomTown: String) -> String {
        return roomCity + roomTown
    }
    
    var body: some View {
        ZStack {
            WebImage(url: URL(string: imageURL))
                .resizable()
                .frame(width: 160, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack {
                Spacer()
                    .frame(height: 140)
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(cityAndTown())
                            Spacer()
                        }
                        HStack {
                            Text("$\(objectPrice)")
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .regular))
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 5)
                    Image(systemName: "plus.circle")
                        .resizable()
                        .foregroundColor(Color.white)
                        .frame(width: 20, height: 20)
                        .padding(.leading, 10)
                }
            }
        }
    }
}
