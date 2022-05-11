//
//  FurnitureDetailView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetailView: View {
    
    @EnvironmentObject var storageForProductImage: StorageForProductImage
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var productDetailViewModel: ProductDetailViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var purchaseViewModel: PurchaseViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.colorScheme) var colorScheme
    
    
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
    
    var realTimeComputeProductPrice: Int {
        return productPrice * productDetailViewModel.orderAmount
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    PageView()
                }
            }
            .edgesIgnoringSafeArea(.top)
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Text(productName)
                        .foregroundColor(.white)
                        .font(.system(size: 35, weight: .bold))
                    
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
                            .foregroundColor(productDetailViewModel.mark ? .orange : .white)
                            .frame(width: 35, height: 35)
                            .padding(.horizontal)
                    }

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
                .onAppear {
                    checkMarked(productUID: productUID)
                }
                HStack {
                    NavigationLink {
                        StoreView(storeData: firestoreForProducts.storesDataSet)
                    } label: {
                        Text("Visit store")
                        Image(systemName: "arrow.forward.circle")
                    }
                    .foregroundColor(colorScheme == .dark ? .blue : Color("sessionBackground"))
                    .font(.headline)
                    .padding(.horizontal)
                    Spacer()
                }
                HStack {
                    Section {
                        Menu {
                            Picker("", selection: $productDetailViewModel.orderAmount) {
                                ForEach(1..<pickerAmount + 1, id: \.self) {
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
                    Text("$ \(realTimeComputeProductPrice)")
                        .foregroundColor(.white)
                        .font(.system(size: 45, weight: .bold))
                    Spacer()

                    Button {
                        self.productDetailViewModel.addToCart(productName: productName,
                                                              productUID: productUID,
                                                              productPrice: productPrice,
                                                              productAmount: productAmount,
                                                              productFrom: productFrom,
                                                              providerUID: providerUID,
                                                              productImage: productImage,
                                                              providerName: providerName,
                                                              orderAmount: String(productDetailViewModel.orderAmount))

                        purchaseViewModel.productTotalAmount = String(pickerAmount)
                        print(productDetailViewModel.productOrderCart)
                        localData.sumPrice = localData.sum(productSource: productDetailViewModel.productOrderCart)
                        productDetailViewModel.orderAmount = 1
                        appViewModel.isAddNewItem = true
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
            .frame(width: productDetailViewModel.uiScreenWidth, height: productDetailViewModel.uiScreenHeight / 2 + 50)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(alignment: .center) {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
//                    .cornerRadius(50, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom)
        }
        .task {
            do {
                try await firestoreForProducts.fetchProductCommentAndRating(providerUidPath: providerUID, productID: productUID)
                try await firestoreForProducts.updatePublicAmountData(docID: docID, providerUidPath: providerUID, productID: productUID)
                _ = try await firestoreForProducts.fetchStore(providerUidPath: providerUID)
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
    @Published var orderAmount = 1
    
    
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



struct PageView: View {
    
    @EnvironmentObject var storageForProductImage: StorageForProductImage
    
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    @State var selected = ""
    
    var body: some View {
        if storageForProductImage.productImageSet.count >= 1 {
            TabView {
                ForEach(storageForProductImage.productImageSet) { image in
                    WebImage(url: URL(string: image.productDetialImage))
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .id(image.id)
                }
            }
            .frame(width: uiScreenWidth, height: uiScreenHeight / 3 + 40)
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}
