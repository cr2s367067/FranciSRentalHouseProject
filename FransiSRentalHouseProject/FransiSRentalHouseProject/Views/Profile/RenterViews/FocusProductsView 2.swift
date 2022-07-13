//
//  FocusProductsView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/31.
//

import SDWebImageSwiftUI
import SwiftUI

struct FocusProductsView: View {
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var firebaseAuth: FirebaseAuth

    private func updateMarkProduct() {
        firestoreForProducts.productsDataSet.forEach { product in
            firestoreForProducts.markedProducts.forEach { mark in
                if product.productUID == mark.productUID {
                    Task {
                        do {
                            try await firestoreForProducts.updateBookMarkInfo(uidPath: firebaseAuth.getUID(),
                                                                              productUID: product.productUID,
                                                                              providerUID: product.providerUID,
                                                                              productName: product.productName,
                                                                              productPrice: product.productPrice,
                                                                              productImage: product.productImage,
                                                                              productFrom: product.productFrom,
                                                                              isSoldOut: product.isSoldOut,
                                                                              productAmount: product.productAmount,
                                                                              productDescription: product.productDescription,
                                                                              providerName: product.providerName,
                                                                              docID: mark.id ?? "")
                        } catch {
                            self.errorHandler.handle(error: error)
                        }
                    }
                }
            }
        }
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .edgesIgnoringSafeArea([.top, .bottom])

            VStack {
                ifEmptyArray()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                updateMarkProduct()
            }
        }
    }
}

// struct FocusProductsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FocusProductsView()
//    }
// }

extension FocusProductsView {
    @ViewBuilder
    func ifEmptyArray() -> some View {
        if firestoreForProducts.markedProducts.isEmpty {
            Text("Hey, you haven't add any product.🥺")
                .foregroundColor(.white)
                .font(.system(size: 20))
                .padding()
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(firestoreForProducts.markedProducts) { products in
                    NavigationLink {
                        ProductDetailView(productName: products.productName,
                                          productPrice: Int(products.productPrice) ?? 0,
                                          productImage: products.productImage,
                                          productUID: products.productUID,
                                          productAmount: products.productAmount,
                                          productFrom: products.productFrom,
                                          providerUID: products.providerUID,
                                          isSoldOut: products.isSoldOut,
                                          providerName: products.providerName,
                                          productDescription: products.productDescription,
                                          docID: products.id ?? "")
                    } label: {
                        FocusProductsUnitView(productAmount: products.productAmount,
                                              productName: products.productName,
                                              productImage: products.productImage,
                                              productPrice: products.productPrice,
                                              productFrom: products.productFrom,
                                              productDescription: products.productDescription,
                                              isSoldOut: products.isSoldOut)
                    }
                }
            }
        }
    }
}

struct FocusProductsUnitView: View {
    @Environment(\.colorScheme) var colorScheme

    var productAmount: String
    var productName: String
    var productImage: String
    var productPrice: String
    var productFrom: String
    var productDescription: String
    var isSoldOut: Bool

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .center) {
                ZStack {
//                    Image("furpic2")
                    WebImage(url: URL(string: productImage))
                        .resizable()
                        .frame(width: 140, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.5), radius: 10)
                    if isSoldOut == true {
                        Text("Is Sold Out")
                            .foregroundColor(.red.opacity(0.7))
                            .font(.system(size: 20, weight: .bold))
                    }
                }
                Spacer()
                VStack {
                    HStack {
                        Text("Amount: ")
                        Text(productAmount)
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .regular))
                }
            }
            .padding(.horizontal)
            ReusableUnit(title: "Product Name", containName: productName)
            ReusableUnit(title: "Product Price", containName: productPrice)
            ReusableUnit(title: "Product From", containName: productFrom)
//            ReusableUnitWithCommentDescription(title: "Product Description", commentOrDescription: productDescription)
        }
        .padding()
        .frame(width: uiScreenWidth - 30, height: uiScreenHeight / 4)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? .gray.opacity(0.3) : .black.opacity(0.5))
                .shadow(color: .black.opacity(0.3), radius: 10)
        }
    }
}
