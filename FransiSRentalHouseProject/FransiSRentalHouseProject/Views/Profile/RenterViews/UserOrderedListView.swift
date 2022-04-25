//
//  UserOrderedListView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/30.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserOrderedListView: View {
    
    enum RatingStars: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3
        case four = 4
        case five = 5
    }
    
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    @State private var text = ""
    
    let ratingArray: [Int] = RatingStars.allCases.map({$0.rawValue})
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(firestoreForProducts.userOrderedDataSet) { order in
                    orderedUnit(orderedData: order)
                }
            }
        }
        .modifier(ViewBackgroundInitModifier())
        .task {
            do {
//                try await firestoreForProducts.fetchOrderedData(uidPath: firebaseAuth.getUID())
                try await firestoreForProducts.fetchOrderedDataUserSide(uidPath: firebaseAuth.getUID())
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
}

//struct UserOrderedListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserOrderedListView()
//    }
//}

extension UserOrderedListView {
    
    func evaluateRange(set: [Int], compare: Int) {
        let range = 1..<set.count
        print(range.indices)
    }
    
    
    @ViewBuilder
    func productUnit(cartItemData: UserOrderProductsDataModel) -> some View {
        HStack {
            WebImage(url: URL(string: cartItemData.productImage))
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
    func productsListUnit() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(firestoreForProducts.fetchOrderedDataSet) { products in
                UserOrderedListUnitView(productName: products.productName,
                                        productPrice: String(products.productPrice),
                                        productImage: products.productImage,
                                        docID: products.id ?? "")
            }
        }
    }
    
    @ViewBuilder
    func productsListUnitWithPlaceholder() -> some View {
        if firestoreForProducts.fetchOrderedDataSet.isEmpty {
            VStack(alignment: .center) {
                Text("You haven't bought anything yet. 😉")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .medium))
                    .padding()
            }
        } else {
            productsListUnit()
        }
    }
    
    @ViewBuilder
    func orderTitleAndContain(header: String, body: String) -> some View {
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
    
    @ViewBuilder
    func orderedUnit(orderedData: OrderedDataModel) -> some View {
        
        VStack(spacing: 10) {
            
            VStack(spacing: 5) {
                orderTitleAndContain(header: "Order ID", body: orderedData.orderID)
                VStack(spacing: 1) {
                    HStack {
                        Text("Order Date: ")
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .font(.headline)
                    HStack {
                        Text(orderedData.orderDate, format: Date.FormatStyle().year().month().day())
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .font(.body)
                }
                orderTitleAndContain(header: "Shipping Address", body: orderedData.shippingAddress)
                orderTitleAndContain(header: "Payment Sataus", body: orderedData.paymentStatus)
                orderTitleAndContain(header: "Subtotal", body: String(orderedData.subTotal))
                orderTitleAndContain(header: "Shipping Status", body: orderedData.shippingStatus)
            }
            List {
                ForEach(firestoreForProducts.fetchOrderedDataSet) { item in
                    NavigationLink {
                        orderedListDetailView(productsData: item)
                    } label: {
                        productUnit(cartItemData: item)
                    }
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
                guard let id = orderedData.id else { return }
                try await firestoreForProducts.fetchOrderedData(uidPath: firebaseAuth.getUID(), docID: id)
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
    
    @ViewBuilder
    func orderedListDetailView(productsData: UserOrderProductsDataModel) -> some View {
        VStack {
            VStack(spacing: 10) {
                HStack {
                    WebImage(url: URL(string: productsData.productImage))
                        .resizable()
                        .frame(width: uiScreenWidth / 3 - 20, height: uiScreenHeight / 5 - 60)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    Spacer()
                }
                HStack {
                    Text(productsData.productName)
                        .foregroundColor(.white)
                    Spacer()
                }
                HStack {
                    Text("Rate: ")
                    ForEach(ratingArray, id: \.self) { star in
                        Button {
                            evaluateRange(set: ratingArray, compare: star)
                            print("number: \(star)")
                        } label: {
//                            if star == 2 {
                                Image(systemName: "star")
//                                    .foregroundColor(evaluateRange(set: ratingArray, compare: star) ? .yellow : .white)
                                    .font(.system(size: 15))
//                            } else {
//                                Image(systemName: "star")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 15))
//                            }
                        }
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                HStack {
                    Text("Comment: ")
                        .foregroundColor(.white)
                    Spacer()
                }
                HStack {
                    TextEditor(text: $text)
                        .foregroundColor(.black)
                        .frame(width: uiScreenWidth - 80 , height: uiScreenHeight / 3 - 50, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Summit")
                            .modifier(ButtonModifier())
                    }
                }
                Spacer()
            }
            .padding()
            .frame(width: uiScreenWidth - 50, height: uiScreenHeight / 2 + 150)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.black.opacity(0.4))
            }
        }
        .modifier(ViewBackgroundInitModifier())
    }
}
