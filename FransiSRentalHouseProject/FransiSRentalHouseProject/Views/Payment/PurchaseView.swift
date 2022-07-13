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
    @EnvironmentObject var soldProductCollectionManager: SoldProductCollectionManager

    var brandArray = ["apple-pay", "google-pay", "mastercard", "visa"]

    @State var cardName = ""
    @State var cardNumber = ""
    @State var expDate = ""
    @State var secCode = ""

    var roomsData: RoomDM

    var body: some View {
        ZStack {
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
                    //: Card Name
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
                    let orderID = firestoreForProducts.initOrderID()
                    Task {
                        do {
                            try processChanger()
                            try await paymentIdentity(
                                paymentProcessStatus: purchaseViewModel.paymentProcessStatus,
                                roomData: roomsData,
                                orderID: orderID
                            )
                        } catch {
                            self.errorHandler.handle(error: error)
                        }
                    }
                    print("Payment: \(localData.sumPrice)")
                    print("test")
                    /*
                     //: pass data to the next view
                     if !localData.summaryItemHolder.roomUID.isEmpty {
                         MARK: pay deposit and rent the room also pay for products if user ordered.
                         if firestoreToFetchUserinfo.notRented() {
                             Task {
                                 await rentedRoom(result: roomsData)
                                 localData.sumPrice = 0
                             }
                             if !productDetailViewModel.productOrderCart.isEmpty {
                                 productDetailViewModel.productOrderCart.forEach { products in
                                     Task {
                                         print("subTotal: \(localData.sumPrice)")
                                         await buyProducts(products: products.self, orderID: orderID,
                                                           shippingStatus: firestoreForProducts.shippingStatus.rawValue,
                                                           paymentStatus: purchaseViewModel.paymentStatus.rawValue,
                                                           shippingMethod: firestoreForProducts.shippingMethod.rawValue,
                                                           subTotal: localData.sumPrice)
                                         localData.sumPrice = 0
                                     }
                                 }
                             }
                         }
                     } else {
                         MARK: pay for products that user ordered
                         if !productDetailViewModel.productOrderCart.isEmpty {
                             productDetailViewModel.productOrderCart.forEach { products in
                                 Task {
                                     print("subTotal: \(localData.sumPrice)")
                                     await buyProducts(products: products, orderID: orderID,
                                                       shippingStatus: firestoreForProducts.shippingStatus.rawValue,
                                                       paymentStatus: purchaseViewModel.paymentStatus.rawValue,
                                                       shippingMethod: firestoreForProducts.shippingMethod.rawValue,
                                                       subTotal: localData.sumPrice)
                                     localData.sumPrice = 0
                                 }
                             }
                         }
                     }

                      //MARK: pay the rental bill
                      Task {
                          await justPayRentBill()
                          localData.sumPrice = 0
                      }
                     */
                } label: {
                    Text("Pay")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .heavy))
                        .frame(width: 343, height: 50)
                        .background(Color("buttonBlue"))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .accessibilityIdentifier("pay")

                Spacer()
            }
            .padding()
        }
    }
}

struct CardTextField: View {
    @State var dataHolder = ""
    // @State var holderName = ""

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

extension PurchaseView {
    private func processChanger() throws {
        if !productDetailViewModel.productOrderCart.isEmpty, !localData.roomRenting.roomUID.isEmpty {
            guard firestoreToFetchUserinfo.notRented() else {
                throw RentalError.rentedError
            }
            purchaseViewModel.paymentProcessStatus = .rentRoomAndBuyProduct
        } else {
            if !localData.roomRenting.roomUID.isEmpty {
                guard firestoreToFetchUserinfo.rentedRoom.rentedRoomUID.isEmpty else {
                    throw RentalError.rentedError
                }
                purchaseViewModel.paymentProcessStatus = .rentRoom
            } else if !productDetailViewModel.productOrderCart.isEmpty {
                purchaseViewModel.paymentProcessStatus = .payProductBill
            } else {
                purchaseViewModel.paymentProcessStatus = .payMonthlyRentalBill
            }
        }
        print(purchaseViewModel.paymentProcessStatus)
    }

    private func paymentIdentity(
        paymentProcessStatus: PaymentProcessStatus,
        roomData: RoomDM,
        orderID: String
    ) async throws {
        print("payment process status: \(paymentProcessStatus)")
        switch paymentProcessStatus {
        case .rentRoom:
            return try await rentedRoom(result: roomData)
        case .payMonthlyRentalBill:
            return await justPayRentBill()
        case .rentRoomAndBuyProduct:
            return try await rentRoomAndBuyProduct(orderID: orderID, roomData: roomData)
        case .payProductBill:
            return buyProduct(orderID: orderID)
        }
    }

    private func buyProduct(orderID: String) {
        if !productDetailViewModel.productOrderCart.isEmpty {
            productDetailViewModel.productOrderCart.forEach { products in
                Task {
                    print("subTotal: \(localData.sumPrice)")
                    await buyProducts(
                        //                        products: products,
//                        orderID: orderID,
//                        shippingStatus: firestoreForProducts.shippingStatus.rawValue,
//                        paymentStatus: purchaseViewModel.paymentStatus.rawValue,
//                        shippingMethod: firestoreForProducts.shippingMethod.rawValue,
//                        subTotal: localData.sumPrice
                        products: products.product,
                        user: firestoreToFetchUserinfo.fetchedUserData,
                        orderID: orderID,
                        shippingStatus: firestoreForProducts.shippingStatus.rawValue,
                        paymentStatus: purchaseViewModel.paymentStatus.rawValue,
                        paymentMethod: firestoreForProducts.paymentMethod.rawValue,
                        shippingMethod: firestoreForProducts.shippingMethod.rawValue,
                        orderAmount: products.orderAmount,
                        address: paymentSummaryViewModel.shippingAddress,
                        subTotal: localData.sumPrice
                    )
                    localData.sumPrice = 0
                }
            }
        }
    }

    private func rentRoomAndBuyProduct(orderID: String, roomData _: RoomDM) async throws {
        if firestoreToFetchUserinfo.notRented() {
            Task {
                try await rentedRoom(result: roomsData)
            }
            if !productDetailViewModel.productOrderCart.isEmpty {
                productDetailViewModel.productOrderCart.forEach { products in
                    Task {
                        print("subTotal: \(localData.sumPrice)")
                        await buyProducts(
                            products: products.product,
                            user: firestoreToFetchUserinfo.fetchedUserData,
                            orderID: orderID,
                            shippingStatus: firestoreForProducts.shippingStatus.rawValue,
                            paymentStatus: purchaseViewModel.paymentStatus.rawValue,
                            paymentMethod: firestoreForProducts.paymentMethod.rawValue,
                            shippingMethod: firestoreForProducts.shippingMethod.rawValue,
                            orderAmount: products.orderAmount,
                            address: paymentSummaryViewModel.shippingAddress,
                            subTotal: localData.sumPrice
                        )
                        localData.sumPrice = 0
                    }
                }
            }
        }
    }

    private func rentedRoom(result: RoomDM) async throws {
        do {
            purchaseViewModel.note = .firstRentalFeeWithDeposit
            let roomPrice = (Int(result.rentalPrice) ?? 0) / 3
            debugPrint("Room pice: \(roomPrice)")
            try await firestoreToFetchUserinfo.registertRentedContract(
                uidPath: firebaseAuth.getUID(),
                rentedRoom: RentedRoom(
                    rentedRoomUID: result.roomUID,
                    rentedProvderUID: result.providerUID,
                    depositFee: roomPrice
                )
            )
            
            //MARK: - Update user info in contract then store in local data.
            localData.rentingContractHolder = try await firestoreToFetchRoomsData.summitRenter(
                retner: firebaseAuth.getUID(),
                provider: result.providerGUI,
                roomDM: result,
                renter: firestoreToFetchUserinfo.fetchedUserData
            )
            try await firestoreToFetchUserinfo.summitRentedContractToUserData(
                uidPath: firebaseAuth.getUID(),
                rented: result.roomUID,
                hose: localData.rentingContractHolder
            )
            let converInt = Int(result.rentalPrice) ?? 0
            let rentPriceWithDiposit = converInt * 3
            let convertString = String(rentPriceWithDiposit)
            print("first rent fee with diposit: \(convertString)")
            try await firestoreToFetchUserinfo.summitPaidInfo(
                uidPath: firebaseAuth.getUID(),
                rentalPayment: RentedRoomPaymentHistory(rentalFee: roomPrice)
            )
            print("payment note: \(purchaseViewModel.note.rawValue)")
            try await firestoreToFetchRoomsData.deleteRentedRoom(
                roomUID: result.roomUID
            )
            try await firestoreToFetchUserinfo.reloadUserDataTest(
                renterUID: firebaseAuth.getUID()
            )
            
            reset()
        } catch {
            errorHandler.handle(error: error)
        }
    }

    private func monthlyRentalFeePayment() async {
        do {
            let rentalPrice = Int(firestoreToFetchUserinfo.rentedContract.roomRentalPrice) ?? 0
            try await firestoreToFetchUserinfo.summitPaidInfo(
                //                uidPath: firebaseAuth.getUID(),
//                rentalPrice: firestoreToFetchUserinfo.fetchedUserData.rentedRoomInfo?.roomPrice ?? "",
//                note: purchaseViewModel.note.rawValue
                uidPath: firebaseAuth.getUID(),
                rentalPayment: RentedRoomPaymentHistory(
                    rentalFee: rentalPrice,
                    note: purchaseViewModel.note.rawValue
                )
            )
            print("payment note: \(purchaseViewModel.note.rawValue)")
            print("rental fee: \(rentalPrice)")
        } catch {
            errorHandler.handle(error: error)
        }
    }

    private func buyProducts(
        products: ProductDM,
        user: UserDM,
        orderID: String,
        shippingStatus: String,
        paymentStatus _: String,
        paymentMethod: String,
        shippingMethod: String,
        orderAmount: Int,
        address _: String,
        subTotal: Int
    ) async {
        do {
            var newSub = 0
            if purchaseViewModel.paymentProcessStatus == .rentRoomAndBuyProduct {
                let converInt = Int(roomsData.rentalPrice) ?? 0
                newSub = subTotal - (converInt * 3)
            } else {
                newSub = subTotal
            }
//            let mobileNumber = firestoreToFetchUserinfo.fetchedUserData.mobileNumber
            let address = paymentSummaryViewModel.shippingAddress

            let productPriceConvertInt = Int(products.productPrice) ?? 0
            let orderAmountConvertString = String(orderAmount)
            let userName = user.lastName + user.firstName

            try await firestoreForProducts.makeOrder(
                uidPath: firebaseAuth.getUID(),
                userMake: OrderedListUserSide(
                    orderUID: orderID,
                    paymentMethod: paymentMethod,
                    shippingMethod: shippingMethod,
                    shippingAddress: address,
                    shippingStatus: shippingStatus,
                    subTotal: newSub
                ),
                list: OrderedItem(
                    shippingStatus: shippingStatus,
                    providerUID: products.providerUID,
                    providerGUI: products.providerGUI,
                    productUID: products.productUID,
                    orderProductPrice: productPriceConvertInt,
                    productImage: products.coverImage,
                    productName: products.productName,
                    orderAmount: orderAmount
                ),
                provider: OrderedListProviderSide(
                    orderUID: orderID,
                    orderAmount: orderAmountConvertString,
                    shippingStatus: shippingStatus,
                    shippingAddress: address,
                    orderName: userName,
                    orderMobileNumber: user.mobileNumber,
                    orderPersonUID: firebaseAuth.getUID(),
                    shippingMethod: shippingMethod
                ),
                order: OrderListContain(
                    productUID: products.productUID,
                    productName: products.productName,
                    productPrice: products.productPrice,
                    productImageURL: products.coverImage,
                    productOrderAmount: orderAmount,
                    isPrepare: false
                )
            )

            try await soldProductCollectionManager.postSoldInfo(
                gui: products.providerGUI,
                productUID: products.productUID,
                sold: SoldProductDataModel(
                    productName: products.productName,
                    productUID: products.productUID,
                    buyerUID: firebaseAuth.getUID(),
                    productPrice: Int(products.productPrice) ?? 0,
                    soldAmount: orderAmount
                )
            )
            let netAmount = computeAmount(
                orderAmount: orderAmountConvertString,
                totalAmount: purchaseViewModel.productTotalAmount
            )
            try await firestoreForProducts.updateAmount(
                gui: products.providerGUI,
                productUID: products.productUID,
                netAmount: netAmount
            )
            reset()
        } catch {
            errorHandler.handle(error: error)
        }
    }

    func computeAmount(orderAmount: String, totalAmount: String) -> String {
        let convertInt1 = Int(orderAmount) ?? 0
        let convertInt2 = Int(totalAmount) ?? 0
        print("orderAmount: \(convertInt1)")
        print("totalAmount: \(convertInt2)")
        let resultAmount = convertInt2 - convertInt1
        print("result Amount: \(resultAmount)")
        let convertString = String(resultAmount)
        return convertString
    }

    private func reset() {
        appViewModel.rentalPolicyisAgree = false
        localData.rentingContractHolder = .empty
        localData.roomRenting = .empty
        productDetailViewModel.productOrderCart.removeAll()
        appViewModel.paymentSummaryTosAgree = false
        appViewModel.paymentSummaryAutoPayAgree = false
    }

    private func justPayRentBill() async {
        purchaseViewModel.note = .monthlyRentalFee
        guard !firestoreToFetchUserinfo.notRented() else { return }
        guard productDetailViewModel.productOrderCart.isEmpty else { return }
        await monthlyRentalFeePayment()
    }
}

class PurchaseViewModel: ObservableObject {
    enum PaymentStatus: String {
        case success = "Payment Success"
        case fail = "Payment Denial"
    }

    enum PaymentNote: String {
        case monthlyRentalFee = "Monthly rental fee"
        case firstRentalFeeWithDeposit = "First month rental fee and two months deposit"
    }

    @Published var cardName = ""
    @Published var cardNumber = ""
    @Published var expDate = ""
    @Published var secCode = ""
    @Published var paymentStatus: PaymentStatus = .success
    @Published var productTotalAmount = ""

    @Published var paymentProcessStatus: PaymentProcessStatus = .rentRoom

    @Published var note: PaymentNote = .firstRentalFeeWithDeposit

    func blankChecker() throws {
        guard !cardName.isEmpty, !cardNumber.isEmpty, !expDate.isEmpty, !secCode.isEmpty else {
            throw PurchaseError.blankError
        }
    }
}
