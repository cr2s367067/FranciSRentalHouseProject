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
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("fieldGray"))
                .frame(width: 150, height: 160)
            VStack {
                WebImage(url: URL(string: imageURL))
                    .resizable()
                    .frame(width: 105, height: 85)
                    .cornerRadius(5)
                    .padding(.horizontal)
                HStack {
                    VStack {
                        Text(cityAndTown())
                        Text("$\(objectPrice)")
                    }
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .regular))
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 5)
                    Image(systemName: "plus.circle")
                        .resizable()
                        .foregroundColor(Color.black)
                        .frame(width: 20, height: 20)
                        .padding(.leading, 10)
                }
            }
        }
    }
}
