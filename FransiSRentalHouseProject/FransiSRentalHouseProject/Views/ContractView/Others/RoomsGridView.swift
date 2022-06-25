//
//  GridView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct RoomsGridView: View {
    
    let storageForRoomsImage = StorageForRoomsImage()
    let firebaseAuth = FirebaseAuth()
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var roomsData: RoomDM
    
    func cityAndTown() -> String {
        let city = roomsData.city
        let town = roomsData.town
        return city + town
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(cityAndTown())
                        Spacer()
                    }
                    HStack {
                        Text("$\(roomsData.rentalPrice)/mo")
                            .padding(.horizontal, 3)
                            .background(alignment: .center) {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color("Shadow").opacity(0.8))
                            }
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
            .padding()
        }
        .frame(width: uiScreenWidth / 2 + 88, height: uiScreenHeight / 8 + 45)
        .background(alignment: .center) {
            WebImage(url: URL(string: roomsData.roomsCoverImageURL))
                .resizable()
                .scaledToFill()
                .frame(width: uiScreenWidth / 2 + 88, height: uiScreenHeight / 8 + 45)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.5))
        }
    }
}
