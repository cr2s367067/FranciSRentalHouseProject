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
    
    var roomsData: RoomInfoDataModel
    
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
                    if !localData.summaryItemHolder.roomUID.isEmpty {
                        //MARK: pay deposit and rent the room also pay for products if user ordered.
                        if firestoreToFetchUserinfo.notRented() {
                            Task {
                                await rentedRoom(result: roomsData)
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

extension PurchaseView {
    private func rentedRoom(result: RoomInfoDataModel) async {
        do {
            let roomPrice = Int(result.rentalPrice) ?? 0 / 3
            try await firestoreToFetchUserinfo.updateUserInformationAsync(uidPath: firebaseAuth.getUID(),
                                                                          roomID: result.roomUID ,
                                                                          roomImage: result.roomImage ?? "NA",
                                                                          roomAddress: result.roomAddress,
                                                                          roomTown: result.town,
                                                                          roomCity: result.city,
                                                                          roomPrice: String(roomPrice),
                                                                          roomZipCode: result.zipCode ,
                                                                          providerUID: result.providedBy,
                                                                          depositFee: String((roomPrice) * 2),
                                                                          paymentDate: Date())
            try await firestoreToFetchRoomsData.summitRenter(uidPath: result.providedBy,
                                                             docID: result.id ?? "",
                                                             renterName: firestoreToFetchUserinfo.presentUserName(),
                                                             renterID: firestoreToFetchUserinfo.presentUserId(),
                                                             renterResidenceAddress: firestoreToFetchUserinfo.presentAddress(),
                                                             renterMailingAddress: firestoreToFetchUserinfo.presentAddress(),
                                                             renterPhoneNumber: firestoreToFetchUserinfo.presentMobileNumber(),
                                                             renterEmailAddress: firestoreToFetchUserinfo.presentEmailAddress(),
                                                             sigurtureDate: Date())
            try await firestoreToFetchUserinfo.uploadRentedRoomInfo(uidPath: firebaseAuth.getUID(),
                                                                    contractBuildDate: result.rentersContractData?.contractBuildDate ?? Date(),
                                                                    contractReviewDays: result.rentersContractData?.contractReviewDays ?? "",
                                                                    providerSignurture: result.rentersContractData?.providerSignurture ?? "",
                                                                    renterSignurture: result.rentersContractData?.renterSignurture ?? "",
                                                                    companyTitle: result.rentersContractData?.companyTitle ?? "",
                                                                    roomAddress: result.rentersContractData?.roomAddress ?? "",
                                                                    roomTown: result.rentersContractData?.roomTown ?? "",
                                                                    roomCity: result.rentersContractData?.roomCity ?? "",
                                                                    roomZipCode: result.rentersContractData?.roomZipCode ?? "",
                                                                    specificBuildingNumber: result.rentersContractData?.specificBuildingNumber ?? "",
                                                                    specificBuildingRightRange: result.rentersContractData?.specificBuildingRightRange ?? "",
                                                                    specificBuildingArea: result.rentersContractData?.specificBuildingArea ?? "",
                                                                    mainBuildArea: result.rentersContractData?.mainBuildArea ?? "",
                                                                    mainBuildingPurpose: result.rentersContractData?.mainBuildingPurpose ?? "",
                                                                    subBuildingPurpose: result.rentersContractData?.subBuildingPurpose ?? "",
                                                                    subBuildingArea: result.rentersContractData?.subBuildingArea ?? "",
                                                                    publicBuildingNumber: result.rentersContractData?.publicBuildingNumber ?? "",
                                                                    publicBuildingRightRange: result.rentersContractData?.publicBuildingRightRange ?? "",
                                                                    publicBuildingArea: result.rentersContractData?.publicBuildingArea ?? "",
                                                                    hasParkinglot: result.rentersContractData?.hasParkinglot ?? false,
                                                                    isSettingTheRightForThirdPerson: result.rentersContractData?.isSettingTheRightForThirdPerson ?? false,
                                                                    settingTheRightForThirdPersonForWhatKind: result.rentersContractData?.settingTheRightForThirdPersonForWhatKind ?? "",
                                                                    isBlockByBank: result.rentersContractData?.isBlockByBank ?? false,
                                                                    provideForAll: result.rentersContractData?.provideForAll ?? false,
                                                                    provideForPart: result.rentersContractData?.provideForPart ?? false,
                                                                    provideFloor: result.rentersContractData?.provideFloor ?? "",
                                                                    provideRooms: result.rentersContractData?.provideRooms ?? "",
                                                                    provideRoomNumber: result.rentersContractData?.provideRoomNumber ?? "",
                                                                    provideRoomArea: result.rentersContractData?.provideRoomArea ?? "",
                                                                    isVehicle: result.rentersContractData?.isVehicle ?? false,
                                                                    isMorto: result.rentersContractData?.isMorto ?? false,
                                                                    parkingUGFloor: result.rentersContractData?.parkingUGFloor ?? "",
                                                                    parkingStyleN: result.rentersContractData?.parkingStyleN ?? false,
                                                                    parkingStyleM: result.rentersContractData?.parkingStyleM ?? false,
                                                                    parkingNumberForVehicle: result.rentersContractData?.parkingNumberForVehicle ?? "",
                                                                    parkingNumberForMortor: result.rentersContractData?.parkingNumberForMortor ?? "",
                                                                    forAllday: result.rentersContractData?.forAllday ?? false,
                                                                    forMorning: result.rentersContractData?.forMorning ?? false,
                                                                    forNight: result.rentersContractData?.forNight ?? false,
                                                                    havingSubFacility: result.rentersContractData?.havingSubFacility ?? false,
                                                                    rentalStartDate: result.rentersContractData?.rentalStartDate ?? Date(),
                                                                    rentalEndDate: result.rentersContractData?.rentalEndDate ?? Date(),
                                                                    paymentdays: result.rentersContractData?.paymentdays ?? "",
                                                                    paybyCash: result.rentersContractData?.paybyCash ?? false,
                                                                    paybyTransmission: result.rentersContractData?.paybyTransmission ?? false,
                                                                    paybyCreditDebitCard: result.rentersContractData?.paybyCreditDebitCard ?? false,
                                                                    bankName: result.rentersContractData?.bankName ?? "",
                                                                    bankOwnerName: result.rentersContractData?.bankOwnerName ?? "",
                                                                    bankAccount: result.rentersContractData?.bankAccount ?? "",
                                                                    payByRenterForManagementPart: result.rentersContractData?.payByRenterForManagementPart ?? false,
                                                                    payByProviderForManagementPart: result.rentersContractData?.payByProviderForManagementPart ?? false,
                                                                    managementFeeMonthly: result.rentersContractData?.managementFeeMonthly ?? "",
                                                                    parkingFeeMonthly: result.rentersContractData?.parkingFeeMonthly ?? "",
                                                                    additionalReqForManagementPart: result.rentersContractData?.additionalReqForManagementPart ?? "",
                                                                    payByRenterForWaterFee: result.rentersContractData?.payByRenterForWaterFee ?? false,
                                                                    payByProviderForWaterFee: result.rentersContractData?.payByProviderForWaterFee ?? false,
                                                                    additionalReqForWaterFeePart: result.rentersContractData?.additionalReqForWaterFeePart ?? "",
                                                                    payByRenterForEletricFee: result.rentersContractData?.payByRenterForEletricFee ?? false,
                                                                    payByProviderForEletricFee: result.rentersContractData?.payByProviderForEletricFee ?? false,
                                                                    additionalReqForEletricFeePart: result.rentersContractData?.additionalReqForEletricFeePart ?? "",
                                                                    payByRenterForGasFee: result.rentersContractData?.payByRenterForGasFee ?? false,
                                                                    payByProviderForGasFee: result.rentersContractData?.payByProviderForGasFee ?? false,
                                                                    additionalReqForGasFeePart: result.rentersContractData?.additionalReqForGasFeePart ?? "",
                                                                    additionalReqForOtherPart: result.rentersContractData?.additionalReqForOtherPart ?? "",
                                                                    contractSigurtureProxyFee: result.rentersContractData?.contractSigurtureProxyFee ?? "",
                                                                    payByRenterForProxyFee: result.rentersContractData?.payByRenterForProxyFee ?? false,
                                                                    payByProviderForProxyFee: result.rentersContractData?.payByProviderForProxyFee ?? false,
                                                                    separateForBothForProxyFee: result.rentersContractData?.separateForBothForProxyFee ?? false,
                                                                    contractIdentitificationFee: result.rentersContractData?.contractIdentitificationFee ?? "",
                                                                    payByRenterForIDFFee: result.rentersContractData?.payByRenterForIDFFee ?? false,
                                                                    payByProviderForIDFFee: result.rentersContractData?.payByProviderForIDFFee ?? false,
                                                                    separateForBothForIDFFee: result.rentersContractData?.separateForBothForIDFFee ?? false,
                                                                    contractIdentitificationProxyFee: result.rentersContractData?.contractIdentitificationProxyFee ?? "",
                                                                    payByRenterForIDFProxyFee: result.rentersContractData?.payByRenterForIDFProxyFee ?? false,
                                                                    payByProviderForIDFProxyFee: result.rentersContractData?.payByProviderForIDFProxyFee ?? false,
                                                                    separateForBothForIDFProxyFee: result.rentersContractData?.separateForBothForIDFProxyFee ?? false,
                                                                    subLeaseAgreement: result.rentersContractData?.subLeaseAgreement ?? false,
                                                                    doCourtIDF: result.rentersContractData?.doCourtIDF ?? false,
                                                                    courtIDFDoc: result.rentersContractData?.courtIDFDoc ?? false,
                                                                    providerName: result.rentersContractData?.providerName ?? "",
                                                                    providerID: result.rentersContractData?.providerID ?? "",
                                                                    providerResidenceAddress: result.rentersContractData?.providerResidenceAddress ?? "",
                                                                    providerMailingAddress: result.rentersContractData?.providerMailingAddress ?? "",
                                                                    providerPhoneNumber: result.rentersContractData?.providerPhoneNumber ?? "",
                                                                    providerPhoneChargeName: result.rentersContractData?.providerPhoneChargeName ?? "",
                                                                    providerPhoneChargeID: result.rentersContractData?.providerPhoneChargeID ?? "",
                                                                    providerPhoneChargeEmailAddress: result.rentersContractData?.providerPhoneChargeEmailAddress ?? "",
                                                                    renterName: result.rentersContractData?.renterName ?? "",
                                                                    renterID: result.rentersContractData?.renterID ?? "",
                                                                    renterResidenceAddress: result.rentersContractData?.renterResidenceAddress ?? "",
                                                                    renterMailingAddress: result.rentersContractData?.renterMailingAddress ?? "",
                                                                    renterPhoneNumber: result.rentersContractData?.renterPhoneNumber ?? "",
                                                                    renterEmailAddress: result.rentersContractData?.renterEmailAddress ?? "",
                                                                    sigurtureDate: result.rentersContractData?.sigurtureDate ?? Date())
            try await firestoreToFetchRoomsData.deleteRentedRoom(docID: result.id ?? "")
            try await firestoreToFetchUserinfo.reloadUserDataTest()
            try await firestoreToFetchRoomsData.updateRentedRoom(uidPath: result.providedBy,
                                                                 docID: result.id ?? "",
                                                                 renterID: firebaseAuth.getUID())
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
        localData.tempCart = []
        appViewModel.isRedacted = false
        appViewModel.rentalPolicyisAgree = false
        localData.summaryItemHolder = .empty
        productDetailViewModel.productOrderCart = []
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
