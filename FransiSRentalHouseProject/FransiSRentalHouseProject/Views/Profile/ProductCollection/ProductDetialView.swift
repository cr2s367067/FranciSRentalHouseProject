//
//  ProductDetialView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetialView: View {
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var productName: String = ""
    var productRate: String = ""
    var productPrice: String = ""
    var productFrom: String = ""
    var productDescription: String = ""
    var productUserComment: String = ""
    var productImage: String = ""
    
    //MARK: Put some visual kit to presenting data, also provider could edit product description
    var body: some View {
        VStack {
            HStack {
                WebImage(url: URL(string: productImage))
                    .resizable()
                    .frame(width: 140, height: 120, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.8), radius: 10)
                Spacer()
            }
            .padding(.horizontal)
            ReusableUnit(title: "Product Name", containName: productName)
            ReusableUnit(title: "Product Rate", containName: productRate)
            ReusableUnit(title: "Product Price", containName: productPrice)
            ReusableUnit(title: "Product From", containName: productFrom)
            ReusableUnitWithCommentDescription(title: "Product Description", commentOrDescription: productDescription)
            ReusableUnitWithCommentDescription(title: "User Comment", commentOrDescription: productUserComment)
        }
        .padding()
        .frame(width: uiScreenWidth - 30)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.2))
        }
    }
}

struct ProductDetialView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetialView()
    }
}
