//
//  GridView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct GridView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    var objectImage: String = "room3"
    var objectName: String = ""
    var objectLocation: String = "Taipei"
    var objectPrice: Int = 9000
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("fieldGray"))
                .frame(width: 120, height: 160)
            VStack {
                Image(objectImage)
                    .resizable()
                    .frame(width: 75, height: 85)
                    .cornerRadius(5)
                    .padding(.leading, 30)
                
                HStack {
                    VStack {
                        Text(objectName)
                        Text("$\(objectPrice)")
                    }
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .regular))
                    .multilineTextAlignment(.center)
                    .padding(.leading, 5)
                    Image(systemName: "plus.circle")
                        .resizable()
                        .foregroundColor(Color.black)
                        .frame(width: 20, height: 20)
                        .padding(.leading, 25)
                }
            }
        }
    }
}
