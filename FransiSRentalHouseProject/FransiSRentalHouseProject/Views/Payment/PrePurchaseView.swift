//
//  PrePurchaseView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PrePurchaseView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreForFurnitureOrder: FirestoreForProducts
    @EnvironmentObject var productDetailViewModel: ProductDetailViewModel
    
    @State var roomImage = "room3"
    @State var roomPrice = "9000"
    @State var ranking = 4
    @State var totalPrice = "9000"
    @State private var isRented = false
    
    var gridFurItemLayout = [
        GridItem(.fixed(170)),
        GridItem(.fixed(170))
    ]
    
    var body: some View {
        NavigationView {
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            if !localData.tempCart.isEmpty {
                                ForEach(localData.tempCart) { data in
                                    SearchListItemView(roomImage: data.roomImage ?? "",
                                                       roomAddress: data.roomAddress,
                                                       roomTown: data.town,
                                                       roomCity: data.city,
                                                       roomPrice: Int(data.rentalPrice) ?? 0)
                                }
                                .onAppear {
                                    appViewModel.isRedacted = false
                                }
                            } else {
                                SearchListItemView(roomAddress: "placehold", roomTown: "placehold", roomCity: "placehold")
                                    .redacted(reason: appViewModel.isRedacted ? .placeholder : .init())
                            }
                            TitleAndDivider(title: "Furnitures")
                            VStack(alignment: .center) {
                                Spacer()
                                ScrollView(.vertical, showsIndicators: false) {
                                    SummaryItems(roomsData: localData.summaryItemHolder)
                                }
                            }
                            .padding()
                        }
                        HStack {
                            Spacer()
                            Group {
                                Image(systemName: "dollarsign.circle")
                                Text("\(localData.sumPrice)")
                                if firestoreToFetchUserinfo.notRented() && !localData.summaryItemHolder.roomUID.isEmpty && !localData.tempCart.isEmpty {
                                    Text("(Include Deposit fee 2 month)")
                                        .font(.system(size: 12, weight: .semibold))
                                }
                            }
                            Spacer()
                                .frame(width: 50)
                            checkCartIsNotEmptyAndShowTheView()
                        }
                        .frame(width: 400, height: 50)
                        .foregroundColor(.white)
                        .background(Color("fieldGray").opacity(0.5))
                        .cornerRadius(10)
                    }
                }
                .background {
                    LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea([.top, .bottom])
                }
            .overlay(content: {
                if firestoreToFetchUserinfo.presentUserId().isEmpty {
                    UnregisterCoverView(isShowUserDetailView: $appViewModel.isShowUserDetailView)
                }
            })
            .onAppear(perform: {
                appViewModel.updateNavigationBarColor()
            })
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PrePurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PrePurchaseView()
    }
}


struct FurnitureItemView: View {
    
    var furnitureImage: String
    var furnitureName: String
    var furniturePrice: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            VStack(spacing: 3) {
                HStack {
                    Text(furnitureName)
                        .padding(.horizontal, 3)
                        .background(alignment: .center) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.brown.opacity(0.4))
                        }
                    Spacer()
                }
                HStack {
                    Text("$\(furniturePrice)")
                        .padding(.horizontal, 3)
                        .background(alignment: .center) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.brown.opacity(0.4))
                        }
                    Spacer()
                }
            }
            .foregroundColor(.black)
        }
        .padding()
        .frame(width: 200, height: 160, alignment: .center)
        .background(alignment: .center) {
            //            WebImage(url: URL(string: ""))
            Image(furnitureImage)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

extension PrePurchaseView {
    @ViewBuilder
    private func checkCartIsNotEmptyAndShowTheView() -> some View {
        if !localData.summaryItemHolder.roomUID.isEmpty || !productDetailViewModel.productOrderCart.isEmpty {
            withAnimation(.easeInOut) {
                NavigationLink {
                    PaymentSummaryView()
                } label: {
                    Text("Check Out")
                        .foregroundColor(.white)
                        .frame(width: 108, height: 35)
                        .background(Color("buttonBlue"))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.trailing)
                }
            }
        }
    }
}
