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
//        ZStack {
//            WebImage(url: URL(string: imageURL))
//                .resizable()
//                .frame(width: 160, height: 100)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(cityAndTown())
                            Spacer()
                        }
                        HStack {
                            Text("$\(objectPrice)/mo")
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
            .frame(width: 300, height: 160)
            .background(alignment: .center) {
                WebImage(url: URL(string: imageURL))
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.5))
            }
//        }
    }
}
