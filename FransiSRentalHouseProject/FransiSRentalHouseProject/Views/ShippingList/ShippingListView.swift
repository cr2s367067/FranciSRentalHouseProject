//
//  ShippingListView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ShippingListView: View {
    
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
//            Button {
//                Task {
//                    do {
//                        try await firestoreForProducts.fetchOrdedDataProviderSide(uidPath: firebaseAuth.getUID())
//
//                    } catch {
//                        self.errorHandler.handle(error: error)
//                    }
//                }
//            } label: {
//                Text("test")
//            }
            TitleAndDivider(title: "Shipping List")
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(firestoreForProducts.purchasedUserDataSet) { pUserData in
                    listUnit(pUserData: pUserData)
                }
            }
        }
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
        }
    }
    
    @ViewBuilder
    func listUnit(pUserData: PurchasedUserDataModel) -> some View {
        VStack(spacing: 10) {
            orderUserInfoUnit(pUserData: pUserData)
            HStack {
                Button {
                    Task {
                        do {
                            _ = stateAdjust(shippingState: FirestoreForProducts.ShippingStatus(rawValue: firestoreForProducts.shippingStatus.rawValue) ?? .orderBuilt)
                            print(firestoreForProducts.shippingStatus.rawValue)
                            guard let id = pUserData.id else { return }
                            try await firestoreForProducts.updateShippingStatus(update: firestoreForProducts.shippingStatus.rawValue, uidPath: firebaseAuth.getUID(), orderID: id)
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
                Spacer()
            }
            List {
                ForEach(firestoreForProducts.cartListDataSet) { item in
                    productUnit(cartItemData: item)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Spacer()
        }
        .padding()
        .frame(width: uiScreenWidth - 20, height: uiScreenHeight / 2 + 200)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                .fill(.black.opacity(0.5))
        }
        .task {
            do {
                guard let id = pUserData.id else { return }
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
                        .foregroundColor(.black)
                        .font(.body)
                    Spacer()
                    Text("$\(cartItemData.productPrice)")
                        .foregroundColor(.black)
                        .font(.title3)
                        .fontWeight(.bold)
                }
                HStack {
                    Text("Order Amount: ")
                        .foregroundColor(.black)
                        .font(.body)
                    Text(cartItemData.orderAmount)
                        .foregroundColor(.black)
                        .font(.body)
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    func shippingTitleAndContain(header: String, body: String) -> some View {
        VStack(spacing: 1) {
            HStack {
                Text("\(header): ")
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
        }
    }
}
