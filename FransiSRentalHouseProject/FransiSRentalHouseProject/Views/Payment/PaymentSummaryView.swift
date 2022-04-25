//
//  PaymentSummaryView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct PaymentSummaryView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var productDetailViewModel: ProductDetailViewModel
    @EnvironmentObject var paymentSummaryVM: PaymentSummaryViewModel
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    
    @State private var testCheck = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea(.all)
            VStack {
                TitleAndDivider(title: "Summary")
                ListItems(roomsData: localData.summaryItemHolder)
                AppDivider()
                HStack {
                    Text("Total Price")
                    Spacer()
                        .frame(width: 200)
                    Text("\(localData.sumPrice)")
                }
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .regular))
                .padding()
                if !productDetailViewModel.productOrderCart.isEmpty {
                    VStack(spacing: 10) {
                        HStack {
                            Text("Shipping Method")
                                .foregroundColor(.white)
                                .font(.headline)
                            Spacer()
                        }
                        HStack {
                            buttonWithText(buttonName: "Ship to Store", action: {
                                if paymentSummaryVM.homeDelivery == true {
                                    paymentSummaryVM.homeDelivery = false
                                    localData.sumPrice -= 50
                                }
                                
                                if  paymentSummaryVM.rushDelivery == true {
                                    paymentSummaryVM.rushDelivery = false
                                    localData.sumPrice -= 40
                                }
                                
                                if paymentSummaryVM.shipToStore == false {
                                    paymentSummaryVM.shipToStore = true
                                    localData.sumPrice += 60
                                    firestoreForProducts.shippingMethod = .convenienceStore
                                }
                                
                                print(firestoreForProducts.shippingMethod)
                            }, isCheck: paymentSummaryVM.shipToStore)
                            buttonWithText(buttonName: "Home Delivery", action: {
                                if paymentSummaryVM.shipToStore == true {
                                    paymentSummaryVM.shipToStore = false
                                    localData.sumPrice -= 60
                                }
                                
                                if paymentSummaryVM.rushDelivery == true {
                                    paymentSummaryVM.rushDelivery = false
                                    localData.sumPrice -= 40
                                }
                                
                                if paymentSummaryVM.homeDelivery == false {
                                    paymentSummaryVM.homeDelivery = true
                                    localData.sumPrice += 50
                                    firestoreForProducts.shippingMethod = .homeDelivery
                                }
                                print(firestoreForProducts.shippingMethod)
                            }, isCheck: paymentSummaryVM.homeDelivery)
                            buttonWithText(buttonName: "Rush Delivery", action: {
                                if paymentSummaryVM.shipToStore == true {
                                    paymentSummaryVM.shipToStore = false
                                    localData.sumPrice -= 60
                                }
                                
                                if paymentSummaryVM.homeDelivery == true {
                                    paymentSummaryVM.homeDelivery = false
                                    localData.sumPrice -= 50
                                }
                                
                                if paymentSummaryVM.rushDelivery == false {
                                    paymentSummaryVM.rushDelivery = true
                                    localData.sumPrice += 40
                                    firestoreForProducts.shippingMethod = .personalDelivery
                                }
                                print(firestoreForProducts.shippingMethod)
                            }, isCheck: paymentSummaryVM.rushDelivery)
                        }
                        
                    }
                    .padding(.horizontal)
                    AddressFillOut(address: $paymentSummaryVM.shippingAddress)
                }
                
                VStack(alignment: .center, spacing: 30) {
                    //: Term Agreemnet
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Button {
                                appViewModel.paymentSummaryTosAgree.toggle()
                            } label: {
                                Image(systemName: appViewModel.paymentSummaryTosAgree ? "checkmark.square.fill" : "checkmark.square")
                                    .foregroundColor(appViewModel.paymentSummaryTosAgree ? .green : .white)
                                    .padding(.trailing, 5)
                            }
                            Text("I have read and agree the terms of Service.")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .medium))
                        }
//                        HStack {
//                            Button {
//                                appViewModel.paymentSummaryAutoPayAgree.toggle()
//                            } label: {
//                                Image(systemName: appViewModel.paymentSummaryAutoPayAgree ? "checkmark.square.fill" : "checkmark.square")
//                                    .foregroundColor(appViewModel.paymentSummaryAutoPayAgree ? .green : .white)
//                                    .padding(.trailing, 5)
//                            }
//                            Text("The rent payment will automatically pay\n monthly until the expired day.")
//                                .foregroundColor(.white)
//                                .font(.system(size: 14, weight: .medium))
//                        }
                    }
                    if appViewModel.paymentSummaryTosAgree == true {
                        NavigationLink {
                            PurchaseView(roomsData: localData.summaryItemHolder)
                        } label: {
                            Text("Confirm")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .heavy))
                                .frame(width: 343, height: 50)
                                .background(Color("buttonBlue"))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                    } else {
                        Button {
                            paymentSummaryVM.showErrorAlert.toggle()
                        } label: {
                            Text("Confirm")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .heavy))
                                .frame(width: 343, height: 50)
                                .background(Color.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .alert(isPresented: $paymentSummaryVM.showErrorAlert) {
                                    Alert(title: Text("Notice"), message: Text("Please check the terms of service and payment checkbox."), dismissButton: .default(Text("Sure")))
                                }
                        }
                    }
                }
            }
        }
    }
}



struct PaymentSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentSummaryView()
    }
}



struct SummaryItems: View {
    
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var productDetailViewModel: ProductDetailViewModel
    
    var roomsData: RoomInfoDataModel
    
    var checkOutItem = "No Data"
    var checkOutPrice = "0"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            ScrollView(.vertical, showsIndicators: false) {
                if !localData.summaryItemHolder.roomUID.isEmpty {                
                    HStack {
                        Button {
                            localData.summaryItemHolder = .empty
                            localData.sumPrice = localData.sum(productSource: productDetailViewModel.productOrderCart)
                            localData.tempCart = .empty
                            appViewModel.isRedacted = true
                        } label: {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width: 22, height: 22)
                        }
                        Text(roomsData.roomAddress)
                        Spacer()
                        Text("$\(roomsData.rentalPrice)")
                    }
                }
                ForEach(productDetailViewModel.productOrderCart) { product in
                    HStack {
                        Button {
                            productDetailViewModel.productOrderCart.removeAll(where: {$0.id == product.id})
                            localData.sumPrice = localData.sum(productSource: productDetailViewModel.productOrderCart)
                            appViewModel.isRedacted = true
                        } label: {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width: 22, height: 22)
                        }
                        Text(product.productName)
                        Spacer()
                        Text("Unit: \(product.orderAmount)")
                        Text("$\(product.productPrice)")
                    }
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
        }
        .foregroundColor(.white)
        .font(.system(size: 16, weight: .regular))
    }
}

struct ListItems: View {
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var productDetailViewModel: ProductDetailViewModel
    
    var roomsData: RoomInfoDataModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            ScrollView(.vertical, showsIndicators: false) {
                if !localData.summaryItemHolder.roomUID.isEmpty {
                    HStack {
                        Text(roomsData.roomAddress)
                        Spacer()
                        Text("$\(roomsData.rentalPrice)")
                    }
                }
                ForEach(productDetailViewModel.productOrderCart) { product in
                    HStack {
                        Text(product.productName)
                        Spacer()
                        Text("$\(product.productPrice)")
                    }
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
        }
        .foregroundColor(.white)
        .font(.system(size: 16, weight: .regular))
        .padding(.horizontal)
    }
}


struct AddressFillOut: View {
    
    @Binding var address: String
    
    var body: some View {
        VStack {
            InfoUnit(title: "Shipping Address", bindingString: $address)
//            Text("Notice: Please provider shipping address, if you needed, otherwise will user address you provider in user information by default.")
//                .foregroundColor(.yellow)
//                .font(.system(size: 14, weight: .heavy))
        }
        .padding()
    }
}


class PaymentSummaryViewModel: ObservableObject {
    @Published var shippingAddress = ""
    @Published var showErrorAlert = false
    
    @Published var shipToStore = false
    @Published var rushDelivery = false
    @Published var homeDelivery = false
}


extension PaymentSummaryView {
    @ViewBuilder
    func buttonWithText(buttonName: String, action: @escaping () -> Void, isCheck: Bool) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: "checkmark.square")
                    .foregroundColor(isCheck ? .green : .white)
                    .font(.system(size: 15))
                Text(buttonName)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            }
        }
    }
}
