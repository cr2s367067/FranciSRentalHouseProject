//
//  SheetView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct SheetView: View {
    @EnvironmentObject var localData: LocalData

    var roomName = "room3"
    var roomPrice = "9000"

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color("backgroundBrown"))
            VStack(alignment: .center) {
                HStack {
                    Text(roomName)
                    Spacer()
                    Text("$\(roomPrice)")
                }
                .foregroundColor(.white)
                .font(.system(size: 25, weight: .bold))
                .padding()
                HStack {
                    Button {
//                        if localData.tempCart.isEmpty {
//
//                        }
                    } label: {
                        Text("Next")
                            .foregroundColor(.white)
                            .frame(width: 250, height: 35)
                            .background(Color("buttonBlue"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
                .padding()
            }
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView()
    }
}
