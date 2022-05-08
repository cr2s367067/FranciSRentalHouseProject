//
//  ProductCollectionReusableUnitView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductCollectionReusableUnitView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    
    var productData: ProductProviderDataModel
    
    var body: some View {
        VStack {
            HStack {
                WebImage(url: URL(string: productData.productImage))
                    .resizable()
                    .frame(width: 140, height: 120, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.8), radius: 10)
                Spacer()
            }
            .padding(.horizontal)
            ReusableUnit(title: "Product Name", containName: productData.productName)
            ReusableUnit(title: "Product Price", containName: productData.productPrice)
            HStack {
                Spacer()
                Image(systemName: "chevron.right.circle")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
            }
        }
        .padding()
        .frame(width: uiScreenWidth - 30)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? .gray.opacity(0.3) : .black.opacity(0.5))
        }
    }
}

//struct ProductCollectionReusableUnitView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductCollectionReusableUnitView()
//    }
//}


struct ReusableUnit: View {
    var title: String
    var containName: String
    var body: some View {
        HStack {
            Text(LocalizedStringKey(title))
            Text(containName)
            Spacer()
        }
        .foregroundColor(.white)
    }
}


struct ReusableUnitWithCommentDescription: View {
    var title: String
    var commentOrDescription: String
    var body: some View {
        VStack {
            HStack {
                Text(LocalizedStringKey(title))
                Spacer()
            }
            HStack {
                Text(commentOrDescription)
                Spacer()
            }
        }
        .foregroundColor(.white)
    }
}
