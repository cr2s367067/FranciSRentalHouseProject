//
//  SearchListItemView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SDWebImageSwiftUI
import SwiftUI

struct SearchListItemView: View {
    var roomsData: RoomInfoDataModel

    var address: String {
        let roomAddress = roomsData.roomAddress
        let town = roomsData.town
        let city = roomsData.city
        return city + town + roomAddress
    }

    var body: some View {
        ZStack {
            VStack {
                WebImage(url: URL(string: roomsData.roomImage ?? ""))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400, height: 338)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .clipped()
                HStack {
                    VStack(alignment: .leading) {
                        Text(address)
                            .foregroundColor(.white)
                            .font(.system(size: 25, weight: .bold))
                    }
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(Color("listItemPriceBackground"))
                            .frame(width: 147, height: 92)
                            .cornerRadius(20, corners: [.topRight, .bottomLeft])
                        VStack {
                            Text("$\(roomsData.rentalPrice)")
                            Text("Per Month")
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .bold))
                    }
                }
                .padding(.top, -5)
            }
            .padding(.top, -5)
        }
        .padding()
    }
}
