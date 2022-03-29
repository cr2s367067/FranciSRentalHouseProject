//
//  SearchProductListItemView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchProductListItemView: View {
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var productName: String = "productName"
    var productImage: String = ""
    var productPrice: String = "100"
    
    
    var body: some View {
        VStack {
            HStack {
                Text(productName)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .regular))
                    .background(alignment: .center) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.black.opacity(0.4))
                    }
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                Text("$ \(productPrice)")
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .regular))
                    .background(alignment: .center) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.black.opacity(0.4))
                    }
            }
        
        }
        .padding()
        .frame(width: uiScreenWidth / 3 + 40, height: uiScreenHeight / 6 + 40, alignment: .center)
        .background(alignment: .center) {
            WebImage(url: URL(string: productImage))
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 20))
//                .shadow(color: .black.opacity(0.4), radius: 10)
                
        }
    }
}

struct SearchProductListItemView_Previews: PreviewProvider {
    static var previews: some View {
        SearchProductListItemView()
    }
}
