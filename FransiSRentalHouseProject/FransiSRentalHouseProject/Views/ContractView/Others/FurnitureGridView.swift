//
//  FurnitureGridView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/28.
//

import SDWebImageSwiftUI
import SwiftUI

struct FurnitureGridView: View {
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    var productDM: ProductDM

    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(productDM.productName)
                        Spacer()
                    }
                    HStack {
                        Text("$\(productDM.productPrice)")
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
            WebImage(url: URL(string: productDM.coverImage))
                .resizable()
                .scaledToFill()
                .frame(width: uiScreenWidth / 2 + 88, height: uiScreenHeight / 8 + 45)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.5))
        }
    }
}

// struct FurnitureGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        FurnitureGridView(productIamge: "", productName: "", productPrice: 0)
//    }
// }
