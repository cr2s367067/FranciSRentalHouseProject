//
//  FurnitureDetailView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetailView: View {
    
    
    @EnvironmentObject var productDetailViewModel: ProductDetailViewModel
    @EnvironmentObject var localData: LocalData
    
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
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    productDetailViewModel.mark.toggle()
                } label: {
                     Image(systemName: "bookmark.circle")
                        .resizable()
                        .foregroundColor(productDetailViewModel.mark ? .orange : .white)
                        .frame(width: 35, height: 35)
                        .padding(.trailing)
                }
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
                            Text("4.7")
                                .font(.system(size: 15, weight: .bold))
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
                    Text("Description")
                        .foregroundColor(.white)
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
                        self.productDetailViewModel.addToCart(productName: productName,
                                                         productUID: productUID,
                                                         productPrice: productPrice,
                                                         productAmount: productAmount,
                                                         productFrom: productFrom,
                                                         providerUID: providerUID,
                                                         productImage: productImage,
                                                         providerName: providerName,
                                                         orderAmount: String(productDetailViewModel.orderAmount))
                        localData.sumPrice = localData.sum(productSource: productDetailViewModel.productOrderCart)
                        print(localData.sumPrice)
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
    }
}

//struct FurnitureDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FurnitureDetailView()
//    }
//}

//extension ProductDetailView {
class ProductDetailViewModel: ObservableObject {
    
    @Published var productOrderCart = [UserOrederProductsDataModel]()
    @Published var mark = false
    @Published var orderAmount = 0
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    func addToCart(productName: String, productUID: String, productPrice: Int, productAmount: String, productFrom: String, providerUID: String, productImage: String, providerName: String, orderAmount: String) {
        self.productOrderCart.append(UserOrederProductsDataModel(productImage: productImage, productName: productName, productPrice: productPrice, providerUID: providerUID, productUID: productUID, orderAmount: orderAmount))
    }
    
}
//}
