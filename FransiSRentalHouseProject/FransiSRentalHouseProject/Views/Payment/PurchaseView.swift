//
//  PurchaseView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct PurchaseView: View {

    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var productDetailViewModel: ProductDetailViewModel
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var paymentSummaryViewModel: PaymentSummaryViewModel
    @EnvironmentObject var purchaseViewModel: PurchaseViewModel
    
    var brandArray = ["apple-pay", "google-pay", "mastercard", "visa"]
    
    @State var cardName = ""
    @State var cardNumber = ""
    @State var expDate = ""
    @State var secCode = ""
    
    var body: some View {
        ZStack {
//            Image("room")
//                .resizable()
//                .blur(radius: 10)
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 428, height: 926)
//                .offset(x: -40)
//                .clipped()
//            Rectangle()
//                .fill(.gray)
//                .blendMode(.multiply)
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea(.all)
            VStack {
                Image("cardPic")
                    .resizable()
                    .frame(width: 300, height: 200)
                HStack(spacing: 10) {
                    ForEach(brandArray, id: \.self) { item in
                        Image(item)
                            .resizable()
                            .frame(width: 48, height: 32)
                    }
                    Spacer()
                        .frame(width: 60)
                }
                .padding(5)
                
                VStack(spacing: 15) {
                    //:Card Name
                    VStack(alignment: .leading, spacing: 1) {
                        HStack {
                            Text("Card Name*")
                                .foregroundColor(.white)
                            Spacer()
                                .frame(width: 40)
                        }
                        ZStack {
                            HStack {
                                TextField("", text: $purchaseViewModel.cardName)
                                    .placeholer(when: purchaseViewModel.cardName.isEmpty) {
                                        Text("Card Holder Name")
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                    .padding()
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .foregroundColor(.red)
                                    .frame(width: 24, height: 24)
                                    .padding(.trailing, 5)
                            }
                        }
                        .modifier(customTextField())
                        Text("Please fill out a card name.")
                            .foregroundColor(.red)
                            .font(.system(size: 12, weight: .heavy))
                            .padding(2)
                        
                    }
                    //: Card Number
                    VStack(alignment: .leading, spacing: 1) {
                        HStack {
                            Text("Card Number*")
                                .foregroundColor(.white)
                            Spacer()
                                .frame(width: 40)
                        }
                        ZStack {
                            HStack {
                                TextField("", text: $purchaseViewModel.cardNumber)
                                    .placeholer(when: purchaseViewModel.cardNumber.isEmpty) {
                                        Text("Card Number")
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                    .padding()
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .foregroundColor(.red)
                                    .frame(width: 24, height: 24)
                                    .padding(.trailing, 5)
                            }
                        }
                        .modifier(customTextField())
                        Text("This card number is not vaild")
                            .foregroundColor(.red)
                            .font(.system(size: 12, weight: .heavy))
                            .padding(2)
                    }
                    HStack(spacing: 60) {
                        //: Card exp.
                        VStack(alignment: .leading, spacing: 1) {
                            HStack {
                                Text("Exp.*")
                                    .foregroundColor(.white)
                                Spacer()
                                    .frame(width: 40)
                            }
                            ZStack {
                                HStack {
                                    TextField("", text: $purchaseViewModel.expDate)
                                        .placeholer(when: purchaseViewModel.expDate.isEmpty) {
                                            Text("x/xx")
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                        .padding()
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .foregroundColor(.red)
                                        .frame(width: 24, height: 24)
                                        .padding(.trailing, 5)
                                }
                            }
                            .frame(width: 150, height: 50)
                            .foregroundColor(.gray)
                            .background(Color("fieldGray").opacity(0.07))
                            .cornerRadius(10)
                            .padding(.top, 10)
                            Text("Please fill out an exp date.")
                                .foregroundColor(.red)
                                .font(.system(size: 12, weight: .heavy))
                                .padding(2)
                        }
                        //: Card security code
                        VStack(alignment: .leading, spacing: 1) {
                            HStack {
                                Text("Security Code*")
                                    .foregroundColor(.white)
                                Spacer()
                                    .frame(width: 40)
                            }
                            ZStack {
                                HStack {
                                    TextField("", text: $secCode)
                                        .placeholer(when: secCode.isEmpty) {
                                            Text("xxx")
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                        .padding()
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .foregroundColor(.red)
                                        .frame(width: 24, height: 24)
                                        .padding(.trailing, 5)
                                }
                            }
                            .frame(width: 150, height: 50)
                            .foregroundColor(.gray)
                            .background(Color("fieldGray").opacity(0.07))
                            .cornerRadius(10)
                            .padding(.top, 10)
                            Text("This security code is not valid")
                                .foregroundColor(.red)
                                .font(.system(size: 12, weight: .heavy))
                                .padding(2)
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    //: pass data to the next view
                    if !localData.summaryItemHolder.isEmpty {
                        //MARK: pay deposit and rent the room also pay for products if user ordered.
                        if firestoreToFetchUserinfo.notRented() {
                            localData.summaryItemHolder.forEach { result in
                                Task {
                                    await rentedRoom(result: result.self)
                                }
                            }
                            if !productDetailViewModel.productOrderCart.isEmpty {
                                productDetailViewModel.productOrderCart.forEach { products in
                                    Task {
                                        await buyProducts(products: products.self)
                                    }
                                }
                            }
                        }
                    } else {
                        //MARK: pay for products that user ordered
                        if !productDetailViewModel.productOrderCart.isEmpty {
                            productDetailViewModel.productOrderCart.forEach { products in
                                Task {
                                    await buyProducts(products: products.self)
                                }
                            }
                        }
                    }
                    
                    //MARK: pay the rental bill
                    Task {
                        await justPayRentBill()
                    }
                    print("test")
                } label: {
                    Text("Pay")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .heavy))
                        .frame(width: 343, height: 50)
                        .background(Color("buttonBlue"))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                
                Spacer()
            }
            .padding()
        }
        //.navigationBarHidden(true)
        //.navigationBarBackButtonHidden(true)
    }
}

struct CardTextField: View {
    
    @State var dataHolder = ""
    //@State var holderName = ""
    
    var body: some View {
        ZStack {
            TextField("", text: $dataHolder)
                .placeholer(when: dataHolder.isEmpty) {
                    Text("Card Holder Name")
                        .foregroundColor(.white)
                }
                .padding()
        }
        .modifier(customTextField())
    }
}


struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView()
    }
}


extension PurchaseView {
    private func rentedRoom(result: SummaryItemHolder) async {
        do {
            try await firestoreToFetchUserinfo.updateUserInformationAsync(uidPath: firebaseAuth.getUID(), roomID: result.roomUID ?? "NA", roomImage: result.roomImage ?? "NA", roomAddress: result.roomAddress, roomTown: result.roomTown, roomCity: result.roomCity, roomPrice: String(result.itemPrice / 3), roomZipCode: result.roomZipCode ?? "", providerUID: result.providerUID, depositFee: String((result.itemPrice / 3) * 2), paymentDate: Date())
            try await firestoreToFetchRoomsData.deleteRentedRoom(docID: result.docID)
            try await firestoreToFetchUserinfo.reloadUserDataTest()
            try await firestoreToFetchRoomsData.updateRentedRoom(uidPath: result.providerUID, docID: result.docID, renterID: firebaseAuth.getUID())
            reset()
        } catch {
            self.errorHandler.handle(error: error)
        }
    }
    
    private func monthlyRentalFeePayment() async {
        do {
            try await firestoreToFetchUserinfo.summitPaidInfo(uidPath: firebaseAuth.getUID(), rentalPrice: firestoreToFetchUserinfo.fetchedUserData.rentedRoomInfo?.roomPrice ?? "", date: Date())
        } catch {
            self.errorHandler.handle(error: error)
        }
    }
    
    private func buyProducts(products: UserOrderProductsDataModel) async {
        do {
            try await firestoreForProducts.makeOrder(uidPath: firebaseAuth.getUID(),
                                                     productName: products.productName,
                                                     productPrice: products.productPrice,
                                                     providerUID: products.providerUID,
                                                     productUID: products.productUID,
                                                     orderAmount: products.orderAmount,
                                                     productImage: products.productImage,
                                                     comment: products.comment,
                                                     rating: products.rating)
            let orderUID = UUID().uuidString
            try await firestoreForProducts.receiveOrder(uidPath: products.providerUID,
                                                        orderUID: orderUID,
                                                        orderShippingAddress: paymentSummaryViewModel.shippingAddress,
                                                        orderName: firestoreToFetchUserinfo.presentUserName(),
                                                        orderAmount: products.orderAmount,
                                                        productUID: products.productUID,
                                                        productImage: products.productImage,
                                                        productPrice: String(products.productPrice))
            reset()
        } catch {
            self.errorHandler.handle(error: error)
        }
    }
    
    private func reset() {
        localData.tempCart.removeAll()
        appViewModel.isRedacted = false
        appViewModel.rentalPolicyisAgree = false
        localData.summaryItemHolder.removeAll()
        productDetailViewModel.productOrderCart.removeAll()
        appViewModel.paymentSummaryTosAgree = false
        appViewModel.paymentSummaryAutoPayAgree = false
    }
    
    private func justPayRentBill() async {
        guard !firestoreToFetchUserinfo.notRented() else { return }
        guard productDetailViewModel.productOrderCart.isEmpty else { return }
        await monthlyRentalFeePayment()
    }
}


class PurchaseViewModel: ObservableObject {
    @Published var cardName = ""
    @Published var cardNumber = ""
    @Published var expDate = ""
    @Published var secCode = ""
    
    
    func blankChecker() throws {
        guard !cardName.isEmpty && !cardNumber.isEmpty && !expDate.isEmpty && !secCode.isEmpty else {
            throw PurchaseError.blankError
        }
    }
}
