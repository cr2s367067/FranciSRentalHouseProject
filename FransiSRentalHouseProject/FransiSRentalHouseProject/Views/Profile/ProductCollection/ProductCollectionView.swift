//
//  ProductCollectionView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import SwiftUI

struct ProductCollectionView: View {
    
    @EnvironmentObject var firestoreForFurniture: FirestoreForProducts
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill( LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack {
                TitleAndDivider(title: "Product Collection")
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(firestoreForFurniture.productsDataSet) { product in
                        NavigationLink {
                            ProductDetialView(productName: product.productName, productRate: "", productPrice: product.productPrice, productFrom: product.productFrom, productDescription: product.productDescription, productUserComment: "", productImage: product.productImage)
                        } label: {
                            ProductCollectionReusableUnitView(productName: product.productName, productRate: "", productPrice: product.productPrice, productFrom: product.productFrom, productImage: product.productImage)
                        }
                    }
                }
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProductCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCollectionView()
    }
}
