//
//  SearchListItemView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct SearchListItemView: View {
    
    var roomImage: String = "room3"
    var roomName: String = ""
    var roomPrice: Int = 9000
    var roomDescribtion: String = ""
    var ranking: Int = 5
    
    
    
    var body: some View {
        ZStack {
            VStack {
                Image(roomImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400, height: 338)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .clipped()
                HStack {
                    VStack(alignment: .leading) {
                        Text(roomName)
                            .foregroundColor(.white)
                            .font(.system(size: 25, weight: .bold))
                        Text(roomDescribtion)
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .semibold))
                        HStack {
                            ForEach(0..<ranking) { _ in
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
