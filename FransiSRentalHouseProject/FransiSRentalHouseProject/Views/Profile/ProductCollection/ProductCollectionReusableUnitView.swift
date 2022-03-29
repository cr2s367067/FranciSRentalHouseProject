//
//  ProductCollectionReusableUnitView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductCollectionReusableUnitView: View {
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var productName: String = ""
    var productRate: String = ""
    var productPrice: String = ""
    var productFrom: String = ""
//    var productDescription: String = ""
//    var productUserComment: String = ""
    var productImage: String = ""
    
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
//            ReusableUnitWithCommentDescription(title: "Product Description", commentOrDescription: productDescription)
//            ReusableUnitWithCommentDescription(title: "User Comment", commentOrDescription: productUserComment)
        }
        .padding()
        .frame(width: uiScreenWidth - 30)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.2))
        }
    }
}

struct ProductCollectionReusableUnitView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCollectionReusableUnitView()
    }
}


struct ReusableUnit: View {
    var title: String
    var containName: String
    var body: some View {
        HStack {
            Text("\(title): ")
            Text(containName)
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.horizontal)
    }
}


struct ReusableUnitWithCommentDescription: View {
    var title: String
    var commentOrDescription: String
    var body: some View {
        VStack {
            HStack {
                Text("\(title): ")
                Spacer()
            }
            HStack {
                Text(commentOrDescription)
                Spacer()
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal)
    }
}
