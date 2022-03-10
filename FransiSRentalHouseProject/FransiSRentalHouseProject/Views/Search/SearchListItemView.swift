//
//  SearchListItemView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchListItemView: View {
    
    var roomImage: String = ""
    var roomAddress: String
    var roomTown: String
    var roomCity: String

    var roomPrice: Int = 0
//    var ranking: Int = 0
    
    func address() -> String {
        var tempAddressHolder = ""
        tempAddressHolder = address(roomAddress: roomAddress, roomTown: roomTown, roomCity: roomCity)
        return tempAddressHolder
    }
    
    private func address(roomAddress: String, roomTown: String, roomCity: String) -> String {
        return roomCity + roomTown + roomAddress
    }
    
    var body: some View {
        ZStack {
            VStack {
                WebImage(url: URL(string: roomImage))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400, height: 338)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .clipped()
                HStack {
                    VStack(alignment: .leading) {
                        Text(address())
                            .foregroundColor(.white)
                            .font(.system(size: 25, weight: .bold))
//                        Text(roomDescribtion)
//                            .foregroundColor(.white)
//                            .font(.system(size: 15, weight: .semibold))
                        HStack {
                            ForEach(0..<5) { _ in
                                Image("Vector")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        }
                    }
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(Color("listItemPriceBackground"))
                            .frame(width: 147, height: 92)
                            .cornerRadius(20, corners: [.topRight, .bottomLeft])
                        VStack {
                            Text("$\(roomPrice)")
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
