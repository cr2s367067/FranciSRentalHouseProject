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
            try await firestoreToFetchRoomsData.summitRenter(uidPath: result.providerUID,
                                                             docID: result.docID,
                                                             renterName: firestoreToFetchUserinfo.presentUserName(),
                                                             renterID: firestoreToFetchUserinfo.presentUserId(),
                                                             renterResidenceAddress: firestoreToFetchUserinfo.presentAddress(),
                                                             renterMailingAddress: firestoreToFetchUserinfo.presentAddress(),
                                                             renterPhoneNumber: firestoreToFetchUserinfo.presentMobileNumber(),
                                                             renterEmailAddress: firestoreToFetchUserinfo.presentEmailAddress(),
                                                             sigurtureDate: Date())
//            try await firestoreToFetchUserinfo.uploadRentedRoomInfo(uidPath: firebaseAuth.getUID(),
//                                                                   isSummitContract: result.contractDataModel.isSummitContract,
//                                                                   contractBuildDate: result.contractDataModel.contractBuildDate,
//                                                                   contractReviewDays: result.contractDataModel.contractReviewDays,
//                                                                   providerSignurture: result.contractDataModel.providerSignurture,
//                                                                   renterSignurture: result.contractDataModel.renterSignurture,
//                                                                   companyTitle: result.contractDataModel.companyTitle,
//                                                                   roomAddress: result.contractDataModel.roomAddress,
//                                                                   roomTown: result.contractDataModel.roomTown,
//                                                                   roomCity: result.contractDataModel.roomCity,
//                                                                   roomZipCode: result.contractDataModel.roomZipCode,
//                                                                   specificBuildingNumber: result.contractDataModel.specificBuildingNumber,
//                                                                   specificBuildingRightRange: result.contractDataModel.specificBuildingRightRange,
//                                                                   specificBuildingArea: result.contractDataModel.specificBuildingArea,
//                                                                   mainBuildArea: result.contractDataModel.mainBuildArea,
//                                                                   mainBuildingPurpose: result.contractDataModel.mainBuildingPurpose,
//                                                                   subBuildingPurpose: result.contractDataModel.subBuildingPurpose,
//                                                                   subBuildingArea: result.contractDataModel.subBuildingArea,
//                                                                   publicBuildingNumber: result.contractDataModel.publicBuildingNumber,
//                                                                   publicBuildingRightRange: result.contractDataModel.publicBuildingRightRange,
//                                                                   publicBuildingArea: result.contractDataModel.publicBuildingArea,
//                                                                   hasParkinglot: result.contractDataModel.hasParkinglot,
//                                                                   isSettingTheRightForThirdPerson: result.contractDataModel.isSettingTheRightForThirdPerson,
//                                                                   settingTheRightForThirdPersonForWhatKind: result.contractDataModel.settingTheRightForThirdPersonForWhatKind,
//                                                                   isBlockByBank: result.contractDataModel.isBlockByBank,
//                                                                   provideForAll: result.contractDataModel.provideForAll,
//                                                                   provideForPart: result.contractDataModel.provideForPart,
//                                                                   provideFloor: result.contractDataModel.provideFloor,
//                                                                   provideRooms: result.contractDataModel.provideRooms,
//                                                                   provideRoomNumber: result.contractDataModel.provideRoomNumber,
//                                                                   provideRoomArea: result.contractDataModel.provideRoomArea,
//                                                                   isVehicle: result.contractDataModel.isVehicle,
//                                                                   isMorto: result.contractDataModel.isMorto,
//                                                                   parkingUGFloor: result.contractDataModel.parkingUGFloor,
//                                                                   parkingStyleN: result.contractDataModel.parkingStyleN,
//                                                                   parkingStyleM: result.contractDataModel.parkingStyleM,
//                                                                   parkingNumberForVehicle: result.contractDataModel.parkingNumberForVehicle,
//                                                                   parkingNumberForMortor: result.contractDataModel.parkingNumberForMortor,
//                                                                   forAllday: result.contractDataModel.forAllday,
//                                                                   forMorning: result.contractDataModel.forMorning,
//                                                                   forNight: result.contractDataModel.forNight,
//                                                                   havingSubFacility: result.contractDataModel.havingSubFacility,
//                                                                   rentalStartDate: result.contractDataModel.rentalStartDate,
//                                                                   rentalEndDate: result.contractDataModel.rentalEndDate,
//                                                                   paymentdays: result.contractDataModel.paymentdays,
//                                                                   paybyCash: result.contractDataModel.paybyCash,
//                                                                   paybyTransmission: result.contractDataModel.paybyTransmission,
//                                                                   paybyCreditDebitCard: result.contractDataModel.paybyCreditDebitCard,
//                                                                   bankName: result.contractDataModel.bankName,
//                                                                   bankOwnerName: result.contractDataModel.bankOwnerName,
//                                                                   bankAccount: result.contractDataModel.bankAccount,
//                                                                   payByRenterForManagementPart: result.contractDataModel.payByRenterForManagementPart,
//                                                                   payByProviderForManagementPart: result.contractDataModel.payByProviderForManagementPart,
//                                                                   managementFeeMonthly: result.contractDataModel.managementFeeMonthly,
//                                                                   parkingFeeMonthly: result.contractDataModel.parkingFeeMonthly,
//                                                                   additionalReqForManagementPart: result.contractDataModel.additionalReqForManagementPart,
//                                                                   payByRenterForWaterFee: result.contractDataModel.payByRenterForWaterFee,
//                                                                   payByProviderForWaterFee: result.contractDataModel.payByProviderForWaterFee,
//                                                                   additionalReqForWaterFeePart: result.contractDataModel.additionalReqForWaterFeePart,
//                                                                   payByRenterForEletricFee: result.contractDataModel.payByRenterForEletricFee,
//                                                                   payByProviderForEletricFee: result.contractDataModel.payByProviderForEletricFee,
//                                                                   additionalReqForEletricFeePart: result.contractDataModel.additionalReqForEletricFeePart,
//                                                                   payByRenterForGasFee: result.contractDataModel.payByRenterForGasFee,
//                                                                   payByProviderForGasFee: result.contractDataModel.payByProviderForGasFee,
//                                                                   additionalReqForGasFeePart: result.contractDataModel.additionalReqForGasFeePart,
//                                                                   additionalReqForOtherPart: result.contractDataModel.additionalReqForOtherPart,
//                                                                   contractSigurtureProxyFee: result.contractDataModel.contractSigurtureProxyFee,
//                                                                   payByRenterForProxyFee: result.contractDataModel.payByRenterForProxyFee,
//                                                                   payByProviderForProxyFee: result.contractDataModel.payByProviderForProxyFee,
//                                                                   separateForBothForProxyFee: result.contractDataModel.separateForBothForProxyFee,
//                                                                   contractIdentitificationFee: result.contractDataModel.contractIdentitificationFee,
//                                                                   payByRenterForIDFFee: result.contractDataModel.payByRenterForIDFFee,
//                                                                   payByProviderForIDFFee: result.contractDataModel.payByProviderForIDFFee,
//                                                                   separateForBothForIDFFee: result.contractDataModel.separateForBothForIDFFee,
//                                                                   contractIdentitificationProxyFee: result.contractDataModel.contractIdentitificationProxyFee,
//                                                                   payByRenterForIDFProxyFee: result.contractDataModel.payByRenterForIDFProxyFee,
//                                                                   payByProviderForIDFProxyFee: result.contractDataModel.payByProviderForIDFProxyFee,
//                                                                   separateForBothForIDFProxyFee: result.contractDataModel.separateForBothForIDFProxyFee,
//                                                                   subLeaseAgreement: result.contractDataModel.subLeaseAgreement,
//                                                                   doCourtIDF: result.contractDataModel.doCourtIDF,
//                                                                   courtIDFDoc: result.contractDataModel.courtIDFDoc,
//                                                                   providerName: result.contractDataModel.providerName,
//                                                                   providerID: result.contractDataModel.providerID,
//                                                                   providerResidenceAddress: result.contractDataModel.providerResidenceAddress,
//                                                                   providerMailingAddress: result.contractDataModel.providerMailingAddress,
//                                                                   providerPhoneNumber: result.contractDataModel.providerPhoneNumber,
//                                                                   providerPhoneChargeName: result.contractDataModel.providerPhoneChargeName,
//                                                                   providerPhoneChargeID: result.contractDataModel.providerPhoneChargeID,
//                                                                   providerPhoneChargeEmailAddress: result.contractDataModel.providerPhoneChargeEmailAddress)
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
