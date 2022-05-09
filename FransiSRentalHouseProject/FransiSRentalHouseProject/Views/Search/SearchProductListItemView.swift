//
//  SearchProductListItemView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchProductListItemView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var productName: String = "productName"
    var productImage: String = ""
    var productPrice: String = "100"
    var productDes: String = "test description"
    
    var body: some View {
        HStack {
            VStack {
                WebImage(url: URL(string: productImage))
                    .resizable()
                    .scaledToFill()
                    .frame(width: uiScreenWidth / 4 + 40, height: uiScreenHeight / 7 + 20, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                //                .shadow(color: .black.opacity(0.4), radius: 10)
            }
            VStack {
                HStack {
                    Text(productName)
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                }
                HStack {
                    Text(productDes)
                        .foregroundColor(.white)
                        .font(.body)
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Text("$ \(productPrice)")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                }
                
            }
            .padding()
        }
        .padding()
        .frame(width: uiScreenWidth - 20, height: uiScreenHeight / 6 + 40, alignment: .center)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? .gray.opacity(0.5) : .black.opacity(0.5))
        }
    }
}

struct SearchProductListItemView_Previews: PreviewProvider {
    static var previews: some View {
        SearchProductListItemView()
    }
}
