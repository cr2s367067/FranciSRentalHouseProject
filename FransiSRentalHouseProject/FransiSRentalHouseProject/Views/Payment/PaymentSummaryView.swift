//
//  PaymentSummaryView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct PaymentSummaryView: View {
    enum ShippingMethodName: String {
        case shipToStore = "Ship to Store"
        case homeDelivery = "Home Delivery"
        case rushDelivery = "Rush Delivery"
    }

    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var productDetailViewModel: ProductDetailViewModel
    @EnvironmentObject var paymentSummaryVM: PaymentSummaryViewModel
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    @State private var testCheck = false
    @State private var shippingMethodName: ShippingMethodName = .shipToStore
    @FocusState private var isFocus: Bool

    var body: some View {
        VStack {
            TitleAndDivider(title: "Summary")
            ListItems(roomsData: localData.roomRenting)
            AppDivider()
            HStack {
                Text("Total Price")
                Spacer()
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
                        buttonWithText(buttonName: .shipToStore, action: {
                            if paymentSummaryVM.homeDelivery == true {
                                paymentSummaryVM.homeDelivery = false
                                localData.sumPrice -= 50
                            }

                            if paymentSummaryVM.rushDelivery == true {
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
                            .accessibilityIdentifier(ShippingMethodName.shipToStore.rawValue)

                        buttonWithText(buttonName: .homeDelivery, action: {
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
                            .accessibilityIdentifier(ShippingMethodName.homeDelivery.rawValue)

                        buttonWithText(buttonName: .rushDelivery, action: {
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
                            .accessibilityIdentifier(ShippingMethodName.rushDelivery.rawValue)
                    }
                }
                .frame(width: uiScreenWidth - 30)
                AddressFillOut(address: $paymentSummaryVM.shippingAddress)
                    .focused($isFocus)
            }

            VStack(alignment: .center, spacing: 30) {
                //: Term Agreemnet
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Button {
                            appViewModel.paymentSummaryTosAgree.toggle()
                        } label: {
                            Image(systemName: appViewModel.paymentSummaryTosAgree ? "checkmark.square.fill" : "square")
                                .foregroundColor(appViewModel.paymentSummaryTosAgree ? .green : .white)
                                .padding(.trailing, 5)
                        }
                        .accessibilityIdentifier("tosAgree")
                        Text("I have read and agree the terms of Service.")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium))
                    }
                    //                        HStack {
                    //                            Button {
                    //                                appViewModel.paymentSummaryAutoPayAgree.toggle()
                    //                            } label: {
                    //                                Image(systemName: appViewModel.paymentSummaryAutoPayAgree ? "checkmark.square.fill" : "square")
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
                        PurchaseView(roomsData: localData.roomRenting)
                    } label: {
                        Text("Confirm")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .heavy))
                            .frame(width: uiScreenWidth - 80, height: 50)
                            .background(Color("buttonBlue"))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    .accessibilityIdentifier("confrim")
                } else {
                    Button {
                        paymentSummaryVM.showErrorAlert.toggle()
                    } label: {
                        Text("Confirm")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .heavy))
                            .frame(width: uiScreenWidth - 80, height: 50)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .alert(isPresented: $paymentSummaryVM.showErrorAlert) {
                                Alert(title: Text("Notice"), message: Text("Please check the terms of service and payment checkbox."), dismissButton: .default(Text("Sure")))
                            }
                    }
                }
            }
        }
        .modifier(ViewBackgroundInitModifier())
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isFocus = false
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

    var roomsData: RoomDM

    var checkOutItem = "No Data"
    var checkOutPrice = "0"

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            ScrollView(.vertical, showsIndicators: false) {
                if !localData.roomRenting.roomUID.isEmpty {
                    HStack {
                        Button {
                            localData.rentingContractHolder = .empty
                            localData.sumPrice = localData.sum(productSource: productDetailViewModel.productOrderCart)
                            localData.roomRenting = .empty
                            appViewModel.isRedacted = true
                        } label: {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width: 22, height: 22)
                        }
                        Text(roomsData.address)
                        Spacer()
                        Text("$\(roomsData.rentalPrice)")
                    }
                }
                ForEach(productDetailViewModel.productOrderCart) { product in
                    HStack {
                        Button {
                            productDetailViewModel.productOrderCart.removeAll(where: { $0.id == product.id })
                            localData.sumPrice = localData.sum(productSource: productDetailViewModel.productOrderCart)
                            appViewModel.isRedacted = true
                        } label: {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width: 22, height: 22)
                        }
                        Text(product.product.productName)
                        Spacer()
                        Text("Unit: \(product.product.productAmount)")
                        Text("$\((Int(product.product.productPrice) ?? 0) * (Int(product.product.productAmount) ?? 0))")
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

    var roomsData: RoomDM

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            ScrollView(.vertical, showsIndicators: false) {
                if !localData.roomRenting.roomUID.isEmpty {
                    HStack {
                        Text(roomsData.address)
                        Spacer()
                        Text("$\(roomsData.rentalPrice)")
                    }
                }
                ForEach(productDetailViewModel.productOrderCart) { product in
                    HStack {
                        Text(product.product.productName)
                        Spacer()
                        Text("$\(product.product.productPrice)")
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
    func buttonWithText(buttonName: ShippingMethodName, action: @escaping () -> Void, isCheck: Bool) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: isCheck ? "checkmark.square.fill" : "square")
                    .foregroundColor(isCheck ? .green : .white)
                    .font(.body)
                Text(LocalizedStringKey(buttonName.rawValue))
                    .foregroundColor(.white)
                    .font(.body)
            }
        }
    }
}
