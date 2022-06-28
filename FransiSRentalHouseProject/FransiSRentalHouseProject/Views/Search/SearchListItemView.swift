//
//  SearchListItemView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchListItemView: View {
    
    var roomsData: RoomDM
    
    let uiScreenWith = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var address: String {
        let city = roomsData.city
        let town = roomsData.town
        let roomAddress = roomsData.address
        return city + town + roomAddress
    }
    
    var body: some View {
        VStack {
            WebImage(url: URL(string: roomsData.roomsCoverImageURL))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: uiScreenWith - 30, height: uiScreenHeight / 3 + 20)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .clipped()
            HStack {
                VStack(alignment: .leading) {
                    Text(address)
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.bold)
                        
                }
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(Color("listItemPriceBackground"))
                        .frame(width: uiScreenWith / 3 + 15, height: 92)
                        .cornerRadius(20, corners: [.topRight, .bottomLeft])
                    VStack {
                        Text("$\(roomsData.rentalPrice)")
                        Text("Per Month")
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 25, weight: .bold))
                }
            }
//            .padding(.top, -5)
        }
        .frame(width: uiScreenWith - 30, height: uiScreenHeight / 2 - 8)
    }
}
