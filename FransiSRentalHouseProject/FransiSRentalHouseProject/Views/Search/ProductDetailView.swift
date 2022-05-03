//
//  FurnitureDetailView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetailView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var productDetailViewModel: ProductDetailViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var purchaseViewModel: PurchaseViewModel
    
    
//    var productData: ProductProviderDataModel
    var productName: String
    var productPrice: Int
    var productImage: String
    var productUID: String
    var productAmount: String
    var productFrom: String
    var providerUID: String
    var isSoldOut: Bool
    var providerName: String
    var productDescription: String
    var docID: String
    
    var pickerAmount: Int {
        let convertInt = Int(productAmount) ?? 0
        return convertInt
    }

    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    productDetailViewModel.mark.toggle()
                    Task {
                        if productDetailViewModel.mark == true {
                            await markProduct()
                        } else {
                            await unmarkProduct(productUID: productUID)
                        }
                    }
                } label: {
                     Image(systemName: "bookmark.circle")
                        .resizable()
                        .foregroundColor(productDetailViewModel.mark ? .orange : .gray)
                        .frame(width: 35, height: 35)
                        .padding(.trailing)
                }
            }
            .onAppear {
                checkMarked(productUID: productUID)
            }
            Spacer()
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Text(productName)
                        .foregroundColor(.white)
                        .font(.system(size: 35, weight: .bold))
                    Spacer()
                    Group {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            NavigationLink {
                                CommentAndRattingView()
                            } label: {
                                Text("\(productDetailViewModel.computeRattingAvg(commentAndRatting: firestoreForProducts.productCommentAndRatting), specifier: "%.1f")")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15, weight: .bold))
                            }
                        }
                        .padding()
                        .frame(width: 90, height: 30, alignment: .center)
                        .background(alignment: .trailing) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.4), radius: 5)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                HStack {
                    Section {
                        Menu {
                            Picker("", selection: $productDetailViewModel.orderAmount) {
                                ForEach(0..<pickerAmount + 1, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                        } label: {
                            HStack {
                                Text("\(productDetailViewModel.orderAmount)")
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            }
                            .frame(width: 70, height: 40)
                            .background(alignment: .center) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray.opacity(0.6))
                            }
                        }
                    } header: {
                        HStack {
                            Text("Order Amount")
                                .foregroundColor(.white)
                                .font(.headline)
                            Spacer()
                        }
                    }
                }
                .foregroundColor(.white)
                .font(.system(size: 20))
                .padding(.horizontal)
                HStack {
                    Text("Description")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    Spacer()
                }
                .padding(.horizontal)
                VStack(alignment: .leading) {
                    ScrollView(.vertical, showsIndicators: true) {
                        HStack {
                            Text(productDescription)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
                Spacer()
                HStack {
                    Text("$ \(productPrice)")
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .bold))
                    Spacer()

                    Button {
                        if productDetailViewModel.orderAmount == 0 {
                            productDetailViewModel.orderAmount = 1
                            self.productDetailViewModel.addToCart(productName: productName,
                                                                  productUID: productUID,
                                                                  productPrice: productPrice,
                                                                  productAmount: productAmount,
                                                                  productFrom: productFrom,
                                                                  providerUID: providerUID,
                                                                  productImage: productImage,
                                                                  providerName: providerName,
                                                                  orderAmount: String(productDetailViewModel.orderAmount))
                        } else {
                            self.productDetailViewModel.addToCart(productName: productName,
                                                                  productUID: productUID,
                                                                  productPrice: productPrice,
                                                                  productAmount: productAmount,
                                                                  productFrom: productFrom,
                                                                  providerUID: providerUID,
                                                                  productImage: productImage,
                                                                  providerName: providerName,
                                                                  orderAmount: String(productDetailViewModel.orderAmount))
                        }
                        purchaseViewModel.productTotalAmount = String(pickerAmount)
                        print(productDetailViewModel.productOrderCart)
                        localData.sumPrice = localData.sum(productSource: productDetailViewModel.productOrderCart)
                        productDetailViewModel.orderAmount = 0
                    } label: {
                        Text("Add Cart")
                            .foregroundColor(.white)
                            .frame(width: 108, height: 35)
                            .background(Color("buttonBlue"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .frame(width: productDetailViewModel.uiScreenWidth, height: productDetailViewModel.uiScreenHeight / 2 + 40)
            .background(alignment: .center) {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(50, corners: [.topLeft, .topRight])
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(alignment: .center) {
            VStack {
                WebImage(url: URL(string: productImage))
                    .resizable()
                    .frame(width: productDetailViewModel.uiScreenWidth, height: productDetailViewModel.uiScreenHeight / 3 + 60, alignment: .top)
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
        }
        .task {
            do {
                try await firestoreForProducts.fetchProductCommentAndRating(providerUidPath: providerUID, productID: productUID)
                try await firestoreForProducts.updatePublicAmountData(docID: docID, providerUidPath: providerUID, productID: productUID)
            } catch {
//                self.errorHandler.handle(error: error)
                print(error.localizedDescription)
            }
        }
    }
}

extension ProductDetailView {
    private func markProduct() async {
        do {
            try await firestoreForProducts.bookMark(uidPath: firebaseAuth.getUID(),
                                                    productUID: productUID,
                                                    providerUID: providerUID,
                                                    productName: productName,
                                                    productPrice: String(productPrice),
                                                    productImage: productImage,
                                                    productFrom: productFrom,
                                                    isSoldOut: isSoldOut,
                                                    productAmount: productAmount,
                                                    productDescription: productDescription,
                                                    providerName: providerName)
            try await firestoreForProducts.fetchMarkedProducts(uidPath: firebaseAuth.getUID())
        } catch {
            self.errorHandler.handle(error: error)
        }
    }
    
    private func unmarkProduct(productUID: String) async {
        firestoreForProducts.markedProducts.forEach { mark in
            if mark.productUID == productUID {
                Task {
                    do {
                        try await firestoreForProducts.unSignBookMarked(uidPath: firebaseAuth.getUID(), id: mark.id ?? "")
                        try await firestoreForProducts.fetchMarkedProducts(uidPath: firebaseAuth.getUID())
                    } catch {
                        self.errorHandler.handle(error: error)
                    }
                }
            }
        }
    }
    
    private func checkMarked(productUID: String) {
        firestoreForProducts.markedProducts.forEach { mark in
            if mark.productUID == productUID {
                return productDetailViewModel.mark = true
            } else {
                return productDetailViewModel.mark = false
            }
        }
    }
}
class ProductDetailViewModel: ObservableObject {
    
    @Published var productOrderCart = [UserOrderProductsDataModel]()
    @Published var mark = false
    @Published var orderAmount = 0
    
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    func addToCart(productName: String, productUID: String, productPrice: Int, productAmount: String, productFrom: String, providerUID: String, productImage: String, providerName: String, orderAmount: String) {
        self.productOrderCart.append(UserOrderProductsDataModel(productImage: productImage, productName: productName, productPrice: productPrice, providerUID: providerUID, productUID: productUID, orderAmount: orderAmount, comment: "", isUploadComment: false, ratting: 0))
    }
    
    func computeRattingAvg(commentAndRatting: [ProductCommentRattingDataModel]) -> Double {
        var numerator = 0
        let denominator = commentAndRatting.count
        var result: Double = 0
        for rat in commentAndRatting {
            print("ratting: \(rat.ratting)")
            numerator += rat.ratting
        }
        if denominator > 0 {
            result = Double(numerator / denominator)
        } else {
            result = Double(numerator / 1)
        }
        return result
    }
    
}



