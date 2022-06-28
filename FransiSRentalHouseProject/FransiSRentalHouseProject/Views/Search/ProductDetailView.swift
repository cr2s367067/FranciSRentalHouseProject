//
//  FurnitureDetailView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct ProductDetailView: View {
    
    @EnvironmentObject var storageForProductImage: StorageForProductImage
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var productDetailViewModel: ProductDetailViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var purchaseViewModel: PurchaseViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var providerStoreM: ProviderStoreM
    @Environment(\.colorScheme) var colorScheme
    
    var productDM: ProductDM
    
    var pickerAmount: Int {
        let productAmountConvertInt = Int(productDM.productAmount) ?? 0
        return productAmountConvertInt
    }
    
    var realTimeComputeProductPrice: Int {
        let productPriceConvertInt = Int(productDM.productPrice) ?? 0
        return productPriceConvertInt * productDetailViewModel.orderAmount
    }
    
    var body: some View {
        VStack {
            LazyHStack {
                PageView()
            }
            .edgesIgnoringSafeArea(.top)
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Text(productDM.productName)
                        .foregroundColor(.white)
                        .font(.system(size: 35, weight: .bold))
                    
                    Button {
                        productDetailViewModel.mark.toggle()
                        Task {
                            if productDetailViewModel.mark == true {
                                await markProduct()
                            } else {
                                await unmarkProduct(productUID: productDM.productUID)
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
                    checkMarked(productUID: productDM.productUID)
                }
                HStack {
                    NavigationLink {
                        StoreView(storeData: providerStoreM.storesData)
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
                                Text("\(productDetailViewModel.productOrder.orderAmount)")
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
                            Text(productDM.productDescription)
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
                        productDetailViewModel.productOrder.product = productDM
                        self.productDetailViewModel.addToCart(cart: productDetailViewModel.productOrder)
                        
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
                    .accessibilityIdentifier("appCart")
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .frame(width: productDetailViewModel.uiScreenWidth, height: productDetailViewModel.uiScreenHeight / 2 + 40)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(alignment: .center) {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(
                        colors: [Color("background1"), Color("background2")]),
                    startPoint: .top, endPoint: .bottom
                ))
                .edgesIgnoringSafeArea(.bottom)
        }
        .toolbar {
            NavigationLink {
                VideoView(urlString: storageForProductImage.productVideo.videoURL)
            } label: {
                Image(systemName: "film")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
            }
        }
        .task {
            do {
                try await firestoreForProducts.fetchProductCommentAndRatting(productUID: productDM.productUID)
//                try await firestoreForProducts.updatePublicAmountData(docID: docID, providerUidPath: providerUID, productID: productUID)
                _ = try await providerStoreM.fetchStore(provider: productDM.providerUID)
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
}

extension ProductDetailView {
    private func markProduct() async {
        do {
            try await firestoreForProducts.bookMark(
                user: firebaseAuth.getUID(),
                marked: CustomerMarkedProduct(
                    isMark: true,
                    providerUID: productDM.providerUID,
                    productUID: productDM.productUID
                )
            )
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
    
    @Published var productOrder: ProductCartDM = .empty
    @Published var productOrderCart = [ProductCartDM]()
    @Published var mark = false
    @Published var orderAmount = 1
    
    @Published var updatingProductData: ProductDM = .empty
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    func addToCart(cart: ProductCartDM) {
        self.productOrderCart.append(cart)
    }
    
    func computeRattingAvg(commentAndRatting: [ProductCommentRatting]) -> Double {
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
                    WebImage(url: URL(string: image.productImageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: uiScreenWidth, height: uiScreenHeight / 2, alignment: .center)
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



//struct TestVideoView: View {
//    var body: some View {
//        VStack {
//            VideoPlayer(player: AVPlayer(url: <#T##URL#>))
//        }
//    }
//}
