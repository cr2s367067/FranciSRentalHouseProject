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
    
    @State var roomImage = "room3"
    @State var roomPrice = "9000"
    @State var ranking = 4
    @State var totalPrice = "9000"
    
    @State private var isRented = false
//    @State private var isRedacted = true
//    let dataModel: RoomsDataModel
    
//    var tempFurData = ["furpic1", "furpic2", "furpic3", "furpic4", "furpic5", "furpic6", "furpic7", "furpic8"]
    
    var gridFurItemLayout = [
        GridItem(.fixed(170)),
        GridItem(.fixed(170))
    ]
    
    private func checkout() -> Bool {
        var tempBool = false
        guard !localData.furnitureOrderChart.isEmpty else {
            tempBool = true
            return tempBool
        }
        
        guard !localData.summaryItemHolder.isEmpty && !localData.tempCart.isEmpty else {
            tempBool = true
            return tempBool
        }
        return tempBool
    }
    
    private func itemSelectChecker() throws {
        guard !localData.summaryItemHolder.isEmpty || !localData.furnitureOrderChart.isEmpty else {
            throw UserInformationError.chartError
        }
        if localData.furnitureOrderChart.isEmpty {
            guard !localData.tempCart.isEmpty && !localData.summaryItemHolder.isEmpty else {
                throw UserInformationError.roomSelectedError
            }
        }
//        guard  !localData.furnitureOrderChart.isEmpty else {
//            throw UserInformationError.roomSelectedError
//        }
    }
    
    @ViewBuilder
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
                            HStack(alignment: .center) {
                                Spacer()
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHGrid(rows: gridFurItemLayout, spacing: 20) {
                                        ForEach(localData.furnitureDataSets) { item in
                                            Button {
                                                localData.addFurniture(furnitureImage: item.furnitureImage, furnitureName: item.furnitureName, furniturePrice: item.furniturePrice)
//                                                localData.sumPrice = localData.compute(source: localData.summaryItemHolder)
                                                localData.sumPrice = localData.sum()
                                            } label: {
                                                FurnitureItemView(furnitureImage: item.furnitureImage, furnitureName: item.furnitureName, furniturePrice: String(item.furniturePrice))
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
                                if firestoreToFetchUserinfo.notRented() && !localData.summaryItemHolder.isEmpty && !localData.tempCart.isEmpty {
                                    Text("(Include Deposit fee 2 month)")
                                        .font(.system(size: 12, weight: .semibold))
                                }
                            }
                            Spacer()
                                .frame(width: 50)
                            
                            if !localData.summaryItemHolder.isEmpty || !localData.furnitureOrderChart.isEmpty {
//                                Button {
//                                    do {
//                                        try itemSelectChecker()
//                                        print("at checker stage")
//                                    } catch {
//                                        self.errorHandler.handle(error: error)
//                                    }
//                                } label: {
//                                    Text("Check Out")
//                                        .foregroundColor(.white)
//                                        .frame(width: 108, height: 35)
//                                        .background(Color("buttonBlue"))
//                                        .clipShape(RoundedRectangle(cornerRadius: 5))
//                                        .padding(.trailing)
//                                }

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
