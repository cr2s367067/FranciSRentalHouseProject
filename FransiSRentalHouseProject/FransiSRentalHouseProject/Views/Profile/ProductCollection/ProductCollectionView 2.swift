//
//  ProductCollectionView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import SwiftUI

struct ProductCollectionView: View {
    
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var errorHandler: ErrorHandler
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill( LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack {
                TitleAndDivider(title: "Product Collection")
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(firestoreForProducts.storeProductsDataSet) { product in
                        NavigationLink {
                            ProductCollectionDetialView(productData: product)
                        } label: {
                            ProductCollectionReusableUnitView(productData: product)
                        }
                    }
                }
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                try await firestoreForProducts.fetchStoreProduct(uidPath: firebaseAuth.getUID())
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
}

struct ProductCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCollectionView()
    }
}
