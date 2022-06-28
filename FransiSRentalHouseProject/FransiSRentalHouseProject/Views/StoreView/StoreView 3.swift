//
//  StoreView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/21.
//

import SDWebImageSwiftUI
import SwiftUI

struct StoreView: View {
    @EnvironmentObject var storageImage: StorageForProductImage
    @EnvironmentObject var firestoreToFetchUserinf: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var roomsDetailVM: RoomsDetailViewModel

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    var imageURL: String = ""
//    var productURL: String = ""
    var storeData: StoreDataModel
    var firstImage: String {
        var temp = ""
        if let image = storageImage.productImageSet.first {
            temp = image.productImage
        }
        return temp
    }

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                // MARK: Input the store data

                titleSection(storeData: storeData)
                HStack {
                    Text("Products")
                        .modifier(StoreTextModifier())
                        .font(.title)
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    // MARK: Foreach the data from providers

                    HStack(spacing: 20) {
                        ForEach(firestoreForProducts.storeProductsDataSet) { data in
                            productUnitCard(productData: data)
                        }
                    }
                }
            }
        }
        .modifier(ViewBackgroundInitModifier())
        .task {
            do {
                try await firestoreForProducts.fetchStoreProduct(uidPath: storeData.provideBy)
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if firestoreToFetchUserinf.fetchedUserData.userType == "Renter" {
                    NavigationLink {
                        MessageMainView()
                    } label: {
                        Image(systemName: "text.bubble")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded { _ in
                            roomsDetailVM.createNewChateRoom = true
                            roomsDetailVM.providerUID = storeData.provideBy
                            roomsDetailVM.providerDisplayName = storeData.providerDisplayName
                            roomsDetailVM.providerChatDodID = storeData.storeChatDocID
                        }
                    )
                }
            }
        }
    }
}

extension StoreView {
    @ViewBuilder
    func titleSection(storeData: StoreDataModel) -> some View {
        VStack {
            HStack {
                WebImage(url: URL(string: storeData.providerProfileImage))
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
//                HStack {
//                    Text("Rate: ")
//                    Text("15")
//                }
//                .modifier(StoreCreditModifier())
            }
            HStack {
                Text(storeData.providerDisplayName)
                    .modifier(StoreTextModifier())
                    .font(.headline)
                Spacer()
            }
            HStack {
                Text("Description")
                    .modifier(StoreTextModifier())
                    .font(.headline)
                Spacer()
            }
            HStack {
                Text(storeData.providerDescription)
                    .modifier(StoreTextModifier())
                    .font(.body)
                Spacer()
            }
        }
        .padding(.horizontal)
        .frame(width: uiScreenWidth - 20, height: uiScreenHeight / 5 + 60)
        .background(alignment: .center) {
            WebImage(url: URL(string: storeData.storeBackgroundImage))
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 20))
            RoundedRectangle(cornerRadius: 20)
                .fill(.black.opacity(0.4))
        }
    }

    @ViewBuilder
    func productUnitCard(productData: ProductProviderDataModel) -> some View {
        VStack(spacing: 10) {
            // MARK: Still working......set the first string for webimage url

            WebImage(url: URL(string: firstImage))
                .resizable()
                .modifier(ProductUnitImageModifier())
            HStack {
                Text(productData.productName)
                    .modifier(StoreTextModifier())
                Spacer()
//                HStack {
//                    Image(systemName: "star.fill")
//                        .foregroundColor(.yellow)
//                        .font(.system(size: 14))
//                    Text(rating)
//                        .modifier(StoreTextModifier())
//                        .font(.system(size: 13))
//                }
//                .frame(width: uiScreenWidth / 5 - 10, height: 25)
//                .background(alignment: .center) {
//                    Capsule()
//                        .fill(.black.opacity(0.3))
//                }
            }
            Spacer()
                .frame(height: 5)
            HStack {
                NavigationLink {
                    ProductDetailView(productName: productData.productName,
                                      productPrice: Int(productData.productPrice) ?? 0,
                                      productUID: productData.productUID,
                                      productAmount: productData.productAmount,
                                      productFrom: productData.productFrom,
                                      providerUID: productData.providerUID,
                                      isSoldOut: productData.isSoldOut,
                                      providerName: productData.providerName,
                                      productDescription: productData.productDescription,
                                      docID: productData.id ?? "")
                } label: {
                    HStack {
                        Text("Check Detial")
                        Image(systemName: "plus.circle")
                            .font(.system(size: 17))
                    }
                    .modifier(StoreTextModifier())
                    .frame(width: uiScreenWidth / 4 + 40, height: 25)
                    .background(alignment: .center) {
                        Capsule()
                            .fill(.black.opacity(0.3))
                    }
                }
                Spacer()
                Text(productData.productPrice)
                    .modifier(StoreTextModifier())
                    .font(.system(size: 20, weight: .bold))
            }
        }
        .padding()
        .frame(width: uiScreenWidth / 2 + 30, height: uiScreenHeight / 3 + 50)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.gray.opacity(0.65))
        }
    }
}

struct ProductUnitImageModifier: ViewModifier {
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    func body(content: Content) -> some View {
        content
            .frame(width: uiScreenWidth / 2, height: uiScreenHeight / 4)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct StoreProfileImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.system(size: 40))
            .frame(width: 80, height: 80)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.5))
            }
    }
}

struct StoreCreditModifier: ViewModifier {
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.system(size: 20))
            .frame(width: uiScreenWidth / 4, height: 40)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.5))
            }
    }
}

struct StoreTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
    }
}

struct ViewBackgroundInitModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(alignment: .center) {
                LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea([.top, .bottom])
            }
    }
}
