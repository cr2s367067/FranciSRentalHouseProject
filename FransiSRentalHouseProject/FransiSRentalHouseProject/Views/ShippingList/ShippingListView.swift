//
//  ShippingListView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ShippingListView: View {
    
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @Environment(\.colorScheme) var colorScheme
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    @State private var selectedOrderData: PurchasedUserDataModel?
    
    var body: some View {
        VStack {
            TitleAndDivider(title: "Shipping List")
                .accessibilityIdentifier("shippingList")
            containPlaceholder()
        }
        .overlay(content: {
            if firestoreToFetchUserinfo.presentUserId().isEmpty {
                UnregisterCoverView(isShowUserDetailView: $appViewModel.isShowUserDetailView)
            }
        })
        .modifier(ViewBackgroundInitModifier())
        .navigationBarHidden(true)
        .task {
            do {
                try await firestoreForProducts.fetchOrdedDataProviderSide(uidPath: firebaseAuth.getUID())
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
}

struct ShippingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShippingListView()
    }
}

extension ShippingListView {
    
    @ViewBuilder
    func containPlaceholder() -> some View {
        if firestoreForProducts.purchasedUserDataSet.isEmpty {
            Spacer()
            Text("Hi, we haven't receive any order. 👾")
                .foregroundColor(.white)
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(firestoreForProducts.purchasedUserDataSet) { pUserData in
                    listUnit(pUserData: pUserData) {
                        selectedOrderData = pUserData
                    }
                }
                .sheet(item: $selectedOrderData) { data in
                    orderContain(orderData: data)
                }
            }
        }
    }
    
    func stateAdjust(shippingState: FirestoreForProducts.ShippingStatus) -> String {
        switch shippingState {
        case .orderBuilt:
            firestoreForProducts.shippingStatus = .orderConfrim
            return "Order Confirm"
        case .orderConfrim:
            firestoreForProducts.shippingStatus = .shipped
            return "Pending"
        case .shipped:
            firestoreForProducts.shippingStatus = .deliveried
            return "Shipping"
        case .deliveried:
            return "Package Arrived"
        case .cancel:
            return "Cancel Order"
        }
    }
    
    @ViewBuilder
    func listUnit(pUserData: PurchasedUserDataModel, action: (() -> Void)? = nil) -> some View {
        VStack(spacing: 10) {
            orderUserInfoUnit(pUserData: pUserData)
            HStack {
                Button {
                    Task {
                        do {
                            _ = stateAdjust(shippingState: FirestoreForProducts.ShippingStatus(rawValue: firestoreForProducts.shippingStatus.rawValue) ?? .orderBuilt)
                            print(firestoreForProducts.shippingStatus.rawValue)
                            guard let id = pUserData.id else { return }
                            try await firestoreForProducts.updateShippingStatus(update: firestoreForProducts.shippingStatus.rawValue, uidPath: firebaseAuth.getUID(), orderID: id, userUidPath: pUserData.userUidPath)
                            try await firestoreForProducts.fetchOrdedDataProviderSide(uidPath: firebaseAuth.getUID())
                        } catch {
                            self.errorHandler.handle(error: error)
                        }
                    }
                } label: {
                    Text("Update State")
                        .foregroundColor(.white)
                        .frame(width: 120, height: 35)
                        .background(Color("buttonBlue"))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .accessibilityIdentifier("updateState")
                Spacer()
                
                Button {
                    action?()
                } label: {
                    Text("Show List")
                        .modifier(ButtonModifier())
                }
                .accessibilityIdentifier("showList")
            }
            
            
            Spacer()
        }
        .padding()
        .frame(width: uiScreenWidth - 20, height: uiScreenHeight / 3 + 80)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                .fill(colorScheme == .dark ? .gray.opacity(0.3) : .black.opacity(0.5))
        }
        
    }
    
    @ViewBuilder
    func orderContain(orderData: PurchasedUserDataModel) -> some View {
        VStack {
            SheetPullBar()
            List {
                ForEach(firestoreForProducts.cartListDataSet) { item in
                    productUnit(cartItemData: item)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .modifier(ViewBackgroundInitModifier())
        .task {
            do {
                guard let id = orderData.id else { return }
                try await firestoreForProducts.fetchOrdedDataInCartList(uidPath: firebaseAuth.getUID(), docID: id)
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
    
    @ViewBuilder
    func orderUserInfoUnit(pUserData: PurchasedUserDataModel) -> some View {
        VStack(spacing: 5) {
            shippingTitleAndContain(header: "Name", body: pUserData.userName)
            shippingTitleAndContain(header: "Mobile Number", body: pUserData.userMobileNumber)
            shippingTitleAndContain(header: "Shipping Address", body: pUserData.userAddress)
            shippingTitleAndContain(header: "Payment Status", body: pUserData.paymentStatus)
            shippingTitleAndContain(header: "Shipping Method", body: pUserData.shippingMethod)
            shippingTitleAndContain(header: "Shipping Status", body: pUserData.shippingStatus)
        }
    }
    
    @ViewBuilder
    func productUnit(cartItemData: PurchasedOrdedProductDataModel) -> some View {
        HStack {
            WebImage(url: URL(string: cartItemData.productImageURL))
                .resizable()
                .frame(width: uiScreenWidth / 4 - 30, height: uiScreenHeight / 7 - 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack {
                HStack {
                    Text(cartItemData.productName)
                        .foregroundColor(.primary)
                        .font(.body)
                    Spacer()
                    Text("$\(cartItemData.productPrice)")
                        .foregroundColor(.primary)
                        .font(.title3)
                        .fontWeight(.bold)
                }
                HStack {
                    Text("Order Amount: ")
                        .foregroundColor(.primary)
                        .font(.body)
                        .accessibilityIdentifier("orderAmount")
                    Text(cartItemData.orderAmount)
                        .foregroundColor(.primary)
                        .font(.body)
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    func shippingTitleAndContain(header: String, body: String) -> some View {
        VStack(spacing: 3) {
            HStack {
                Text(LocalizedStringKey(header))
                Spacer()
            }
            .foregroundColor(.white)
            .font(.headline)
            HStack {
                Text(body)
                Spacer()
            }
            .foregroundColor(.white)
            .font(.body)
            Divider()
                .background(.white)
        }
    }
}
