//
//  UserOrderedListView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/30.
//

import SwiftUI

struct UserOrderedListView: View {
    
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack {
                productsListUnitWithPlaceholder()
            }
            .padding(.horizontal)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                try await firestoreForProducts.fetchOrderedData(uidPath: firebaseAuth.getUID())
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
}

struct UserOrderedListView_Previews: PreviewProvider {
    static var previews: some View {
        UserOrderedListView()
    }
}

extension UserOrderedListView {
    @ViewBuilder
    func productsListUnit() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(firestoreForProducts.fetchOrderedDataSet) { products in
                UserOrderedListUnitView(productName: products.productName,
                                        productPrice: String(products.productPrice),
                                        productImage: products.productImage,
                                        docID: products.id ?? "")
            }
        }
    }
    
    @ViewBuilder
    func productsListUnitWithPlaceholder() -> some View {
        if firestoreForProducts.fetchOrderedDataSet.isEmpty {
            VStack(alignment: .center) {
                Text("You haven't bought anything yet. 😉")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .medium))
                    .padding()
            }
        } else {
            productsListUnit()
        }
    }
}
