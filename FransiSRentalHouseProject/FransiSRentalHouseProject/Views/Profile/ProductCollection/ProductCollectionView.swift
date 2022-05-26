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
        VStack {
            TitleAndDivider(title: "Product Collection")
            containHolder()
            Spacer()
        }
        .modifier(ViewBackgroundInitModifier())
        .task {
            do {
                try await firestoreForProducts.fetchStoreProduct(uidPath: firebaseAuth.getUID())
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
}

extension ProductCollectionView {
    @ViewBuilder
    func containHolder() -> some View {
        if firestoreForProducts.storeProductsDataSet.isEmpty {
            Spacer()
            Text("Hi, you haven't provide any product.🥺")
                .foregroundColor(.white)
                .font(.headline)
                .fontWeight(.bold)
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(firestoreForProducts.storeProductsDataSet) { product in
                    NavigationLink {
                        ProductCollectionDetialView(productData: product)
                    } label: {
                        ProductCollectionReusableUnitView(productData: product)
                    }
                }
            }
        }
    }
}

struct ProductCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCollectionView()
    }
}
