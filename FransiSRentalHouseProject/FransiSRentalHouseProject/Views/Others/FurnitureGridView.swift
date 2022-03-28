//
//  FurnitureGridView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/28.
//

import SwiftUI
import SDWebImageSwiftUI

struct FurnitureGridView: View {
    
    var furnitureIamge: String
    var furnitureName: String
    var furniturePrice: Int
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(furnitureName)
                        Spacer()
                    }
                    HStack {
                        Text("$\(furniturePrice)/mo")
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
            WebImage(url: URL(string: furnitureIamge))
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10))
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.5))
        }
    }
}

struct FurnitureGridView_Previews: PreviewProvider {
    static var previews: some View {
        FurnitureGridView(furnitureIamge: "", furnitureName: "", furniturePrice: 0)
    }
}
