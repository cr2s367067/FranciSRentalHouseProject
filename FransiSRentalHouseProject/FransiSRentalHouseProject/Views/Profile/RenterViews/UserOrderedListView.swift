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
//                Button {
//                    Task {
//                        do {
//                            try await firestoreForProducts.fetchOrderedData(uidPath: firebaseAuth.getUID())
//                            print(firestoreForProducts.fetchOrderedDataSet.count)
//                        } catch {
//                            self.errorHandler.handle(error: error)
//                        }
//                    }
//                } label: {
//                     Text("get")
//                }
                ForEach(firestoreForProducts.fetchOrderedDataSet) { products in
                    UserOrderedListUnitView(productName: products.productName,
                                            productPrice: String(products.productPrice),
                                            productImage: products.productImage,
                                            docID: products.id ?? "")
                }
            }
        }
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
