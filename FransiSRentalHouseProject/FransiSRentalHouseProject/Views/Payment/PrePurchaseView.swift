//
//  PrePurchaseView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct PrePurchaseView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    @State var roomImage = "room3"
    @State var roomPrice = "9000"
    @State var ranking = 4
    @State var totalPrice = "9000"
    
    @State private var isRedacted = true
    let dataModel: RoomsDataModel
    
    var tempFurData = ["furpic1", "furpic2", "furpic3", "furpic4", "furpic5", "furpic6", "furpic7", "furpic8"]
    
    var gridFurItemLayout = [
        GridItem(.fixed(170)),
        GridItem(.fixed(170))
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(Color("backgroundBrown"))
                    .ignoresSafeArea(.all)
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            if !localData.tempCart.isEmpty {
                                ForEach(localData.tempCart) { data in
                                    SearchListItemView(
                                        roomImage: data.roomImage,
                                        roomName: data.roomName,
                                        roomPrice: data.roomPrice,
                                        roomDescribtion: data.roomDescribtion,
                                        ranking: data.ranking
                                    )
                                }
                                .onAppear {
                                    isRedacted = false
                                }
                            } else {
                                SearchListItemView(roomImage: "room3", roomName: "room3", roomPrice: 0, roomDescribtion: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.", ranking: 3)
                                    .redacted(reason: isRedacted ? .placeholder : .init())
                            }
                            TitleAndDivider(title: "Furnitures")
                            HStack(alignment: .center) {
                                Spacer()
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHGrid(rows: gridFurItemLayout, spacing: 20) {
                                        ForEach(localData.furnitureDataSets) { item in
                                            Button {
                                                localData.addItem(itemName: item.furnitureName, itemPrice: item.furniturePrice)
                                                localData.sumPrice = localData.compute(source: localData.summaryItemHolder)
                                            } label: {
                                                GridView(objectImage: item.furnitureImage, objectName: item.furnitureName, objectPrice: item.furniturePrice)
                                                    .frame(height: 160)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        HStack {
                            Spacer()
                            Group {
                                Image(systemName: "dollarsign.circle")
                                Text("\(localData.sumPrice)")
                            }
                            Spacer()
                                .frame(width: 50)
                            NavigationLink {
                                PaymentSummaryView()
                            } label: {
                                Text("Check Out")
                            }
                            .foregroundColor(.white)
                            .frame(width: 108, height: 35)
                            .background(Color("buttonBlue"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .padding(.trailing)
                        }
                        .frame(width: 400, height: 50)
                        .foregroundColor(.white)
                        .background(Color("fieldGray").opacity(0.1))
                        .cornerRadius(10)
                    }
                }
            }
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
        PrePurchaseView(dataModel: RoomsDataModel(roomImage: "", roomName: "", roomDescribtion: "", roomPrice: 0, ranking: 0, isSelected: false))
    }
}
