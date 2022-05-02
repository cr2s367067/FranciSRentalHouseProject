//
//  UserOrderedListView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/30.
//

import SwiftUI
import SDWebImageSwiftUI
import LocalAuthentication

struct UserOrderedListView: View {
    
   
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var userOrderedListVM: UserOrderedListViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    let ratingArray: [Int] = UserOrderedListViewModel.RatingStars.allCases.map({$0.rawValue})
    
    @State private var selectedOrderData: OrderedDataModel?
    
    var body: some View {
        VStack {
            arrayEmptyHolder()
        }
        .modifier(ViewBackgroundInitModifier())
        .task {
            do {
                try await firestoreForProducts.fetchOrderedDataUserSide(uidPath: firebaseAuth.getUID())
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
}

extension UserOrderedListView {
    
    @ViewBuilder
    func arrayEmptyHolder() -> some View {
        if firestoreForProducts.userOrderedDataSet.isEmpty {
            Text("You haven't bought anything yet. 😉")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .medium))
                .padding()
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(firestoreForProducts.userOrderedDataSet) { order in
                    orderedUnit(orderedData: order) {                    
                        selectedOrderData = order
                    }
                }
                .sheet(item: $selectedOrderData) { order in
                    customSheetList(orderID: order.orderID)
                }
            }
        }
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
                    Text(cartItemData.orderAmount)
                        .foregroundColor(.primary)
                        .font(.body)
                    Spacer()
                }
            }
        }
    }
    
//    @ViewBuilder
//    func productsListUnit() -> some View {
//        ScrollView(.vertical, showsIndicators: false) {
//            ForEach(firestoreForProducts.fetchOrderedDataSet) { products in
//                UserOrderedListUnitView(productName: products.productName,
//                                        productPrice: String(products.productPrice),
//                                        productImage: products.productImage,
//                                        docID: products.id ?? "")
//            }
//        }
//    }
//
//    @ViewBuilder
//    func productsListUnitWithPlaceholder() -> some View {
//        if firestoreForProducts.fetchOrderedDataSet.isEmpty {
//            VStack(alignment: .center) {
//
//            }
//        } else {
//            productsListUnit()
//        }
//    }
    
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
    func orderedUnit(orderedData: OrderedDataModel, action: (() -> Void)? = nil) -> some View {
        
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
            HStack {
                Spacer()
                Button {
                    action?()
                } label: {
                    Text("Show Contain")
                        .foregroundColor(.white)
                        .frame(width: 125, height: 35)
                        .background(Color("buttonBlue"))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
//            List {
//                ForEach(firestoreForProducts.fetchOrderedDataSet) { item in
//                    NavigationLink {
//                        orderedListDetailView(productsData: item, orderID: orderedData.orderID)
//                    } label: {
//                        productUnit(cartItemData: item)
//                    }
//                }
//            }
//            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Spacer()
        }
        .padding()
        .frame(width: uiScreenWidth - 20, height: uiScreenHeight / 3 + 50)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                .fill(colorScheme == .dark ? .gray.opacity(0.3) : .black.opacity(0.5))
        }
    }
    
    @ViewBuilder
    func customSheetList(orderID: String) -> some View {
        NavigationView {
            VStack {
                SheetPullBar()
                List {
                    ForEach(firestoreForProducts.fetchOrderedDataSet) { item in
                        NavigationLink {
                            orderedListDetailView(productsData: item, orderID: orderID)
                        } label: {
                            productUnit(cartItemData: item)
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .modifier(ViewBackgroundInitModifier())
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .task {
                do {
                    try await firestoreForProducts.fetchOrderedData(uidPath: firebaseAuth.getUID(), docID: orderID)
                } catch {
                    self.errorHandler.handle(error: error)
                }
            }
        }
    }
    
    @ViewBuilder
    func orderedListDetailView(productsData: UserOrderProductsDataModel, orderID: String) -> some View {
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
                    showRattedResult(isSummit: productsData.isUploadComment, ratted: productsData.ratting)
                    Spacer()
                }
                .foregroundColor(.white)
                HStack {
                    Text("Comment: ")
                        .foregroundColor(.white)
                    Spacer()
                }
                
                showComment(isSummit: productsData.isUploadComment, text: productsData.comment)
                
                HStack {
                    Spacer()
                    Button {
                        Task {
                            do {
                                guard let id = productsData.id else { return }
                                try await firestoreForProducts.userToSummitProductComment(uidPath: firebaseAuth.getUID(), comment: userOrderedListVM.comment, ratting: userOrderedListVM.rating, docID: orderID, isUploadComment: true, listID: id)
                                try await firestoreForProducts.summitCommentAndRatting(providerUidPath: productsData.providerUID, productID: productsData.productUID, ratting: userOrderedListVM.rating, comment: userOrderedListVM.comment, summitUserDisplayName: firestoreToFetchUserinfo.fetchedUserData.displayName)
                                try await firestoreForProducts.fetchOrderedData(uidPath: firebaseAuth.getUID(), docID: orderID)
                                userOrderedListVM.reset()
                            } catch {
                                self.errorHandler.handle(error: error)
                            }
                        }
                    } label: {
                        Text(productsData.isUploadComment ? "Thanks" : "Summit")
                            .modifier(ButtonModifier())
                    }
                    .disabled(productsData.isUploadComment ? true : false)
                }
                Spacer()
            }
            .padding()
            .frame(width: uiScreenWidth - 50, height: uiScreenHeight / 2 + 150)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .dark ? .gray.opacity(0.3) : .black.opacity(0.5))
            }
        }
        .modifier(ViewBackgroundInitModifier())
    }
    
    @ViewBuilder
    func showRattedResult(isSummit: Bool, ratted result: Int) -> some View {
        if isSummit {
            HStack {
                ForEach(1..<result + 1, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
        } else {
            RantingView()
        }
    }
    
    @ViewBuilder
    func showComment(isSummit: Bool, text: String) -> some View {
        if isSummit {
            HStack(alignment: .center) {
                Text(text)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .frame(width: uiScreenWidth - 80 , height: uiScreenHeight / 6 - 80)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 1)
                    .fill(.white)
                    
            }
        } else {
            HStack {
                TextEditor(text: $userOrderedListVM.comment)
                    .foregroundColor(.black)
                    .frame(width: uiScreenWidth - 80 , height: uiScreenHeight / 3 - 50)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
}



struct RantingView: View {
    
    @EnvironmentObject var userOrderedListVM: UserOrderedListViewModel
    
    @State var rating: Int = 0
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.white
    var onColor = Color.yellow
    
    let ratingArray: [Int] = UserOrderedListViewModel.RatingStars.allCases.map({$0.rawValue})
    
    func image(number: Int) -> Image {
        if number > userOrderedListVM.rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
    
    var body: some View {
        HStack {
            ForEach(ratingArray, id: \.self) { number in
                Button {
                    userOrderedListVM.rating = number
                    print(userOrderedListVM.rating)
                } label: {
                    image(number: number)
                        .foregroundColor(number > userOrderedListVM.rating ? offColor : onColor)
                }
            }
        }
        .background(alignment: .center) {
            Color.clear
        }
    }
}

//
//extension String: Identifiable {
//    public var id: String { self }
//}
