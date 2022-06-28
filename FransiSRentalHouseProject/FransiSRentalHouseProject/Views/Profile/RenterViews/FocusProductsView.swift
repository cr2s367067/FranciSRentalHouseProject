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

    var productUIDSet: [String] {
        return firestoreForProducts.markedProducts.map { $0.productUID }
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
            .task {
                do {
                    try await firestoreForProducts.fetchMarkedProducts(uidPath: firebaseAuth.getUID())
                    guard !firestoreForProducts.markedProducts.isEmpty else { return }
                    try await firestoreForProducts.getMarkedProductFromPublish(marked: productUIDSet)
                } catch {}
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
                ForEach(firestoreForProducts.getMarkedProductDetail) { products in
                    NavigationLink {
                        ProductDetailView(productDM: products)
                    } label: {
                        FocusProductsUnitView(markedProduct: products)
                    }
                }
            }
        }
    }
}

struct FocusProductsUnitView: View {
    @Environment(\.colorScheme) var colorScheme

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    var markedProduct: ProductDM

    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .center) {
                ZStack {
//                    Image("furpic2")
                    WebImage(url: URL(string: markedProduct.coverImage))
                        .resizable()
                        .frame(width: 140, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.5), radius: 10)
                    if markedProduct.isSoldOut {
                        Text("Is Sold Out")
                            .foregroundColor(.red.opacity(0.7))
                            .font(.system(size: 20, weight: .bold))
                    }
                }
                Spacer()
                VStack {
                    HStack {
                        Text("Amount: ")
                        Text("\(markedProduct.productAmount)")
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .regular))
                }
            }
            .padding(.horizontal)
            ReusableUnit(title: "Product Name", containName: markedProduct.productName)
            ReusableUnit(title: "Product Price", containName: "\(markedProduct.productPrice)")
            ReusableUnit(title: "Product From", containName: markedProduct.productFrom)
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
