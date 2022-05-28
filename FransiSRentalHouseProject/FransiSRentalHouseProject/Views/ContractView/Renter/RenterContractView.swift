//
//  RenterContractView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/10/22.
//

import SwiftUI
struct RenterContractView: View {
    
    @EnvironmentObject var productDetailViewModel: ProductDetailViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firestoreToFetchUserinfo:  FirestoreToFetchUserinfo
    @EnvironmentObject var renterContractVM: RenterContractViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var storageForRoomsImage: StorageForRoomsImage
    @Environment(\.colorScheme) var colorScheme
    
    
    private func agreementCheckerThows() throws {
        guard appViewModel.rentalPolicyisAgree == true else {
            throw ContractError.agreemnetError
        }
    }
    
    var roomsData: RoomInfoDataModel
    
    var body: some View {
        ZStack {
            Group {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                    .edgesIgnoringSafeArea([.top, .bottom])
                RoundedRectangle(cornerRadius: 30)
                    .fill(colorScheme == .dark ? .gray.opacity(0.3) : .white)
                    .frame(width: UIScreen.main.bounds.width - 15)
            }
            viewSwitch(paymentH: renterContractVM.showPaymentHistory, contractData: roomsData.rentersContractData ?? .empty)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if firestoreToFetchUserinfo.fetchedUserData.providerType == "Rental Manager" {
                        HStack {
                            if roomsData.isRented == true {
                                Button {
                                    renterContractVM.showPaymentHistory.toggle()
                                } label: {
                                    Image(systemName: renterContractVM.showPaymentHistory ? "list.bullet.rectangle.portrait.fill" : "list.bullet.rectangle.portrait")
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25)
                                }
                            }
                            Button {
                                renterContractVM.showEditMode.toggle()
                            } label: {
                                Image(systemName: "gearshape")
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                            }
                        }
                    }
            }
        }
    }
}
struct SpacerAtRightOfText: View {
    var contain: String
    var optionContain: String?
    var body: some View {
        HStack {
            Spacer()
            Text(contain)
            Text(optionContain ?? "")
        }
    }
}

extension RenterContractView {
    
    @ViewBuilder
    func viewSwitch(paymentH: Bool, contractData: RentersContractDataModel = .empty) -> some View {
        if paymentH {
            RentedPaymentHistoryView(paymentHistory: firestoreToFetchUserinfo.paymentHistory, roomsData: roomsData)
        } else {
            idfEditMode(showEditMode: renterContractVM.showEditMode, docID: roomsData.id ?? "", contractData: contractData)
        }
    }
    
    @ViewBuilder
    func idfEditMode(showEditMode: Bool, docID: String, contractData: RentersContractDataModel) -> some View {
        if showEditMode == true {
            RenterContractEditView(docID: docID, contractData: contractData)
        } else {
            VStack {
                HStack {
                    Spacer()
                    if firestoreToFetchUserinfo.fetchedUserData.providerType == "Rental Manager" {
                        Button {
                            Task {
                                do {
                                    try await firestoreToFetchRoomsData.roomPublish(docID: roomsData.id ?? "",
                                                                                    uidPath: firebaseAuth.getUID(),
                                                                                    isPublished: true,
                                                                                    roomUID: roomsData.roomUID,
                                                                                    holderName: roomsData.holderName,
                                                                                    mobileNumber: roomsData.mobileNumber,
                                                                                    address: roomsData.roomAddress,
                                                                                    town: roomsData.town,
                                                                                    city: roomsData.city,
                                                                                    zipCode: roomsData.zipCode,
                                                                                    roomArea: roomsData.roomArea,
                                                                                    rentalPrice: roomsData.rentalPrice,
                                                                                    someoneDeadInRoom: roomsData.someoneDeadInRoom,
                                                                                    waterLeakingProblem: roomsData.waterLeakingProblem,
                                                                                    roomImageURL: roomsData.roomImage ?? "",
                                                                                    isRented: roomsData.isRented ?? false,
                                                                                    rentedBy: roomsData.rentedBy ?? "",
                                                                                    providerDisplayName: roomsData.providerDisplayName,
                                                                                    providerChatDocId: roomsData.providerChatDocId,
                                                                                    roomDescription: roomsData.roomDescription,
                                                                                    isSummitContract: roomsData.rentersContractData?.isSummitContract ?? false,
                                                                                    contractBuildDate: roomsData.rentersContractData?.contractBuildDate ?? Date(),
                                                                                    contractReviewDays: roomsData.rentersContractData?.contractReviewDays ?? "",
                                                                                    providerSignurture: roomsData.rentersContractData?.providerSignurture ?? "",
                                                                                    renterSignurture: roomsData.rentersContractData?.renterSignurture ?? "",
                                                                                    companyTitle: roomsData.rentersContractData?.companyTitle ?? "",
                                                                                    roomAddress: roomsData.rentersContractData?.roomAddress ?? "",
                                                                                    roomTown: roomsData.rentersContractData?.roomTown ?? "",
                                                                                    roomCity: roomsData.rentersContractData?.roomCity ?? "",
                                                                                    roomZipCode: roomsData.rentersContractData?.roomZipCode ?? "",
                                                                                    specificBuildingNumber: roomsData.rentersContractData?.specificBuildingNumber ?? "",
                                                                                    specificBuildingRightRange: roomsData.rentersContractData?.specificBuildingRightRange ?? "",
                                                                                    specificBuildingArea: roomsData.rentersContractData?.specificBuildingArea ?? "",
                                                                                    mainBuildArea: roomsData.rentersContractData?.mainBuildArea ?? "",
                                                                                    mainBuildingPurpose: roomsData.rentersContractData?.mainBuildingPurpose ?? "",
                                                                                    subBuildingPurpose: roomsData.rentersContractData?.subBuildingPurpose ?? "",
                                                                                    subBuildingArea: roomsData.rentersContractData?.subBuildingArea ?? "",
                                                                                    publicBuildingNumber: roomsData.rentersContractData?.publicBuildingNumber ?? "",
                                                                                    publicBuildingRightRange: roomsData.rentersContractData?.publicBuildingRightRange ?? "",
                                                                                    publicBuildingArea: roomsData.rentersContractData?.publicBuildingArea ?? "",
                                                                                    hasParkinglot: roomsData.rentersContractData?.hasParkinglot ?? false,
                                                                                    isSettingTheRightForThirdPerson: roomsData.rentersContractData?.isSettingTheRightForThirdPerson ?? false,
                                                                                    settingTheRightForThirdPersonForWhatKind: roomsData.rentersContractData?.settingTheRightForThirdPersonForWhatKind ?? "",
                                                                                    isBlockByBank: roomsData.rentersContractData?.isBlockByBank ?? false,
                                                                                    provideForAll: roomsData.rentersContractData?.provideForAll ?? false,
                                                                                    provideForPart: roomsData.rentersContractData?.provideForPart ?? false,
                                                                                    provideFloor: roomsData.rentersContractData?.provideFloor ?? "",
                                                                                    provideRooms: roomsData.rentersContractData?.provideRooms ?? "",
                                                                                    provideRoomNumber: roomsData.rentersContractData?.provideRoomNumber ?? "",
                                                                                    provideRoomArea: roomsData.rentersContractData?.provideRoomArea ?? "",
                                                                                    isVehicle: roomsData.rentersContractData?.isVehicle ?? false,
                                                                                    isMorto: roomsData.rentersContractData?.isMorto ?? false,
                                                                                    parkingUGFloor: roomsData.rentersContractData?.parkingUGFloor ?? "",
                                                                                    parkingStyleN: roomsData.rentersContractData?.parkingStyleN ?? false,
                                                                                    parkingStyleM: roomsData.rentersContractData?.parkingStyleM ?? false,
                                                                                    parkingNumberForVehicle: roomsData.rentersContractData?.parkingNumberForVehicle ?? "",
                                                                                    parkingNumberForMortor: roomsData.rentersContractData?.parkingNumberForMortor ?? "",
                                                                                    forAllday: roomsData.rentersContractData?.forAllday ?? false,
                                                                                    forMorning: roomsData.rentersContractData?.forMorning ?? false,
                                                                                    forNight: roomsData.rentersContractData?.forNight ?? false,
                                                                                    havingSubFacility: roomsData.rentersContractData?.havingSubFacility ?? false,
                                                                                    rentalStartDate: roomsData.rentersContractData?.rentalStartDate ?? Date(),
                                                                                    rentalEndDate: roomsData.rentersContractData?.rentalEndDate ?? Date(),
                                                                                    roomRentalPrice: roomsData.rentersContractData?.roomRentalPrice ?? "",
                                                                                    paymentdays: roomsData.rentersContractData?.paymentdays ?? "",
                                                                                    paybyCash: roomsData.rentersContractData?.paybyCash ?? false,
                                                                                    paybyTransmission: roomsData.rentersContractData?.paybyTransmission ?? false,
                                                                                    paybyCreditDebitCard: roomsData.rentersContractData?.paybyCreditDebitCard ?? false,
                                                                                    bankName: roomsData.rentersContractData?.bankName ?? "",
                                                                                    bankOwnerName: roomsData.rentersContractData?.bankOwnerName ?? "",
                                                                                    bankAccount: roomsData.rentersContractData?.bankAccount ?? "",
                                                                                    payByRenterForManagementPart: roomsData.rentersContractData?.payByRenterForManagementPart ?? false,
                                                                                    payByProviderForManagementPart: roomsData.rentersContractData?.payByProviderForManagementPart ?? false,
                                                                                    managementFeeMonthly: roomsData.rentersContractData?.managementFeeMonthly ?? "",
                                                                                    parkingFeeMonthly: roomsData.rentersContractData?.parkingFeeMonthly ?? "",
                                                                                    additionalReqForManagementPart: roomsData.rentersContractData?.additionalReqForManagementPart ?? "",
                                                                                    payByRenterForWaterFee: roomsData.rentersContractData?.payByRenterForWaterFee ?? false,
                                                                                    payByProviderForWaterFee: roomsData.rentersContractData?.payByProviderForWaterFee ?? false,
                                                                                    additionalReqForWaterFeePart: roomsData.rentersContractData?.additionalReqForWaterFeePart ?? "",
                                                                                    payByRenterForEletricFee: roomsData.rentersContractData?.payByRenterForEletricFee ?? false,
                                                                                    payByProviderForEletricFee: roomsData.rentersContractData?.payByProviderForEletricFee ?? false,
                                                                                    additionalReqForEletricFeePart: roomsData.rentersContractData?.additionalReqForEletricFeePart ?? "",
                                                                                    payByRenterForGasFee: roomsData.rentersContractData?.payByRenterForGasFee ?? false,
                                                                                    payByProviderForGasFee: roomsData.rentersContractData?.payByProviderForGasFee ?? false,
                                                                                    additionalReqForGasFeePart: roomsData.rentersContractData?.additionalReqForGasFeePart ?? "",
                                                                                    additionalReqForOtherPart: roomsData.rentersContractData?.additionalReqForOtherPart ?? "",
                                                                                    contractSigurtureProxyFee: roomsData.rentersContractData?.contractSigurtureProxyFee ?? "",
                                                                                    payByRenterForProxyFee: roomsData.rentersContractData?.payByRenterForProxyFee ?? false,
                                                                                    payByProviderForProxyFee: roomsData.rentersContractData?.payByProviderForProxyFee ?? false,
                                                                                    separateForBothForProxyFee: roomsData.rentersContractData?.separateForBothForProxyFee ?? false,
                                                                                    contractIdentitificationFee: roomsData.rentersContractData?.contractIdentitificationFee ?? "",
                                                                                    payByRenterForIDFFee: roomsData.rentersContractData?.payByRenterForIDFFee ?? false,
                                                                                    payByProviderForIDFFee: roomsData.rentersContractData?.payByProviderForIDFFee ?? false,
                                                                                    separateForBothForIDFFee: roomsData.rentersContractData?.separateForBothForIDFFee ?? false,
                                                                                    contractIdentitificationProxyFee: roomsData.rentersContractData?.contractIdentitificationProxyFee ?? "",
                                                                                    payByRenterForIDFProxyFee: roomsData.rentersContractData?.payByRenterForIDFProxyFee ?? false,
                                                                                    payByProviderForIDFProxyFee: roomsData.rentersContractData?.payByProviderForIDFProxyFee ?? false,
                                                                                    separateForBothForIDFProxyFee: roomsData.rentersContractData?.separateForBothForIDFProxyFee ?? false,
                                                                                    subLeaseAgreement: roomsData.rentersContractData?.subLeaseAgreement ?? false,
                                                                                    doCourtIDF: roomsData.rentersContractData?.doCourtIDF ?? false,
                                                                                    courtIDFDoc: roomsData.rentersContractData?.courtIDFDoc ?? false,
                                                                                    providerName: roomsData.rentersContractData?.providerName ?? "",
                                                                                    providerID: roomsData.rentersContractData?.providerID ?? "",
                                                                                    providerResidenceAddress: roomsData.rentersContractData?.providerResidenceAddress ?? "",
                                                                                    providerMailingAddress: roomsData.rentersContractData?.providerMailingAddress ?? "",
                                                                                    providerPhoneNumber: roomsData.rentersContractData?.providerPhoneNumber ?? "",
                                                                                    providerPhoneChargeName: roomsData.rentersContractData?.providerPhoneChargeName ?? "",
                                                                                    providerPhoneChargeID: roomsData.rentersContractData?.providerPhoneChargeID ?? "",
                                                                                    providerPhoneChargeEmailAddress: roomsData.rentersContractData?.providerPhoneChargeEmailAddress ?? "",
                                                                                    renterName: roomsData.rentersContractData?.renterName ?? "",
                                                                                    renterID: roomsData.rentersContractData?.renterID ?? "",
                                                                                    renterResidenceAddress: roomsData.rentersContractData?.renterResidenceAddress ?? "",
                                                                                    renterMailingAddress: roomsData.rentersContractData?.renterMailingAddress ?? "",
                                                                                    renterPhoneNumber: roomsData.rentersContractData?.renterPhoneNumber ?? "",
                                                                                    renterEmailAddress: roomsData.rentersContractData?.renterEmailAddress ?? "",
                                                                                    sigurtureDate: roomsData.rentersContractData?.sigurtureDate ?? Date())
                                    try await firestoreToFetchRoomsData.getRoomInfo(uidPath: firebaseAuth.getUID())
                                } catch {
                                    self.errorHandler.handle(error: error)
                                }
                            }
                        } label: {
                            withAnimation {
                                HStack(alignment: .center, spacing: 5) {
                                    Image(systemName: roomsData.isPublished ? "checkmark.circle.fill" : "checkmark.circle")
                                        .resizable()
                                        .foregroundColor(roomsData.isPublished ? Color.green : Color.gray)
                                        .frame(width: 25, height: 25)
                                    Text(roomsData.isPublished ? "Published" : "Publish")
                                        .foregroundColor(.white)
                                        .frame(width: 108, height: 35)
                                        .background(Color("buttonBlue"))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                            }
                        }
                    }
                }
                ScrollView(.vertical, showsIndicators: true) {
                    Group {
                        Group {
                            titleAndAbstract()
                            firstParagraphAndFirstSubThenOne()
                            firstParagraphAndFirstSubThenTwo()
                        }
                        Group {
                            firstParagraphAndSecondSub()
                            firstParagraphAndThirdSub()
                            firstParagraphAndFourthSub()
                        }
                        Group {
                            firstParagraphAndFivthSub()
                            firstParagraphAndSixthSub()
                            firstParagraphAndSeventhSub()
                        }
                    }
                    Group {
                        Group {
                            firstParagraphAndEighthSub()
                            firstParagraphAndNinethSub()
                            firstParagraphAndTenthSub()
                            firstParagraphAndEleventhSub()
                            firstParagraphAndtwelevethSub()
                            fitstParagraphAndThirteenth()
                            fitstParagraphAndFourteenth()
                            fitstParagraphAndFiveteenth()
                        }
                        Group {
                            fitstParagraphAndSixteenth()
                            fitstParagraphAndSeventeenth()
                            fitstParagraphAndEighteenth()
                            fitstParagraphAndNineteenth()
                            fitstParagraphAndtwentyth()
                            fitstParagraphAndtwentyFirst()
                            fitstParagraphAndtwentySecond()
                        }
                        Group {
                            VStack(alignment: .leading, spacing: 5) {
                                TitleView(titleName: "立契約書人")
                                VStack(spacing: 6) {
                                    Group {
                                        VStack {
                                            LineWithSpacer(contain: "出租人：")
                                            signatureContainer(containerName: "姓名(名稱)：", containHolder: roomsData.rentersContractData?.providerName ?? "")
                                            signatureContainer(containerName: "統一編號：", containHolder: roomsData.rentersContractData?.providerID ?? "")
                                            signatureContainer(containerName: "戶籍地址：", containHolder: roomsData.rentersContractData?.providerResidenceAddress ?? "")
                                            signatureContainer(containerName: "通訊地址：", containHolder: roomsData.rentersContractData?.providerMailingAddress ?? "")
                                            signatureContainer(containerName: "聯絡電話：", containHolder: roomsData.rentersContractData?.providerPhoneNumber ?? "")
                                            signatureHolder(signatureTitle: "負責人：", signString: roomsData.rentersContractData?.providerPhoneChargeName ?? "")
                                            signatureContainer(containerName: "統一編號：", containHolder: roomsData.rentersContractData?.providerPhoneChargeID ?? "")
                                            signatureContainer(containerName: "電子郵件信箱：", containHolder: roomsData.rentersContractData?.providerPhoneChargeEmailAddress ?? "")
                                        }
                                    }
                                    .font(.system(size: 14, weight: .regular))
                                }
                            }
                            .padding(.top, 5)
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                VStack(spacing: 6) {
                                    Group {
                                        VStack {
                                            LineWithSpacer(contain: "承租人：")
                                            signatureHolder(signatureTitle: "姓名(名稱)：", signString: roomsData.rentersContractData?.renterName ?? "")
                                            signatureContainer(containerName: "統一編號：", containHolder: roomsData.rentersContractData?.renterID ?? "")
                                            signatureContainer(containerName: "戶籍地址：", containHolder: roomsData.rentersContractData?.renterResidenceAddress ?? "")
                                            signatureContainer(containerName: "通訊地址：", containHolder: roomsData.rentersContractData?.renterMailingAddress ?? "")
                                            signatureContainer(containerName: "聯絡電話：", containHolder: roomsData.rentersContractData?.renterPhoneNumber ?? "")
                                            signatureContainer(containerName: "電子郵件信箱：", containHolder: roomsData.rentersContractData?.renterEmailAddress ?? "")
                                            HStack {
                                                Text("\(roomsData.rentersContractData?.sigurtureDate ?? Date(), format: Date.FormatStyle().year().month(.twoDigits).day())")
                                                Spacer()
                                            }
                                        }
                                    }
                                    .font(.system(size: 14, weight: .regular))
                                }
                            }
                            .padding(.top, 5)
                            .padding(.horizontal)
                            
                            expressionContractList()
                        }
                    }
                    
                    if firestoreToFetchUserinfo.fetchedUserData.userType == SignUpType.isNormalCustomer.rawValue {
                        HStack(alignment: .center, spacing: 5) {
                            Button {
                                appViewModel.rentalPolicyisAgree.toggle()
                            } label: {
                                Image(systemName: appViewModel.rentalPolicyisAgree ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color.green)
                            }
                            Text("I agree and read whole policy.")
                                .font(.system(size: 12))
                        }
                        .padding(.top, 10)
                        if appViewModel.rentalPolicyisAgree == false {
                            Button {
                                do {
                                    try agreementCheckerThows()
                                } catch {
                                    self.errorHandler.handle(error: error)
                                }
                            } label: {
                                Text("I want this!")
                                    .foregroundColor(.white)
                                    .frame(width: 120, height: 35)
                                    .background(Color("buttonBlue"))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                            .padding(.top, 10)
                            .padding(.horizontal)
                        } else if appViewModel.rentalPolicyisAgree == true {
                            Button {
//                                if localData.tempCart.roomUID.isEmpty {
                                    localData.tempCart = roomsData
                                    localData.addItem(roomsInfo: roomsData)
//                                } else {
//                                    localData.tempCart.removeAll()
//                                    localData.summaryItemHolder = .empty
//                                    if localData.tempCart.isEmpty {
//                                        localData.tempCart.append(roomsData)
//                                        localData.addItem(roomsInfo: roomsData)
//                                    }
//                                }
                                
                                if appViewModel.isPresent == false {
                                    appViewModel.isPresent = true
                                }
                                localData.sumPrice = localData.compute(source: localData.summaryItemHolder)
                                if !productDetailViewModel.productOrderCart.isEmpty {                                
                                    localData.sumPrice = localData.sum(productSource: productDetailViewModel.productOrderCart)
                                }
                                appViewModel.isAddNewItem = true
                                print(localData.sumPrice)
                            } label: {
                                Text("I want this!")
                                    .foregroundColor(.white)
                                    .frame(width: 120, height: 35)
                                    .background(Color("buttonBlue"))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .alert(isPresented: $appViewModel.isPresent) {
                                        Alert(title: Text("Congrate!"), message: Text("The room is adding in the chart, also check out the furnitures if needing. Please see Payment session."), dismissButton: .default(Text("Sure")))
                                    }
                            }
                        }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 20)
            .padding()
        }
    }
    
    @ViewBuilder
    func titleAndAbstract() -> some View {
        Group {
            VStack(spacing: 2) {
                Group {
                    Text("中華民國91年1月30日內政部台內中地字第0910083141號公告頒行(行政院消費者保護委員會第86次委員會議通過)")
                    Text("中華民國105年6月23日內政部內授中辦地字第1051305386號公告修正 (行政院消費者保護會第47次會議通過)")
                }
                .font(.system(size: 12))
                Group {
                    SpacerAtRightOfText(contain: "契約審閱權")
                        .font(.system(size: 12))
                    HStack {
                        Spacer()
                        Text("本契約於\n\(roomsData.rentersContractData?.contractBuildDate ?? Date(), format: Date.FormatStyle().year().month(.twoDigits).day())經承租人\n攜回審閱\(roomsData.rentersContractData?.contractReviewDays ?? "")日\n(契約審閱期間至少三日)")
                    }
                    .font(.system(size: 12))
                    SpacerAtRightOfText(contain: "承租人簽章：", optionContain: roomsData.rentersContractData?.renterSignurture ?? "")
                        .font(.system(size: 12))
                    SpacerAtRightOfText(contain: "出租人簽章：", optionContain: roomsData.rentersContractData?.providerSignurture ?? "")
                        .font(.system(size: 12))
                }
                Text("房屋租賃契約書")
                    .font(.title2)
                    .font(.system(size: 15))
                Group {
                    SpacerAtRightOfText(contain: "內 　政　 部  　編")
                    SpacerAtRightOfText(contain: "中華民國105年6月")
                }
                .font(.system(size: 12))
            }
            .padding(.top, 5)
            VStack {
                Text("\t立契約書人承租人__，出租人\(roomsData.rentersContractData?.companyTitle ?? "")【為□所有權人□轉租人(應提示經原所有權人同意轉租之證明文件)】茲為房屋租賃事宜，雙方同意本契約條款如下：")
                    .font(.system(size: 15, weight: .regular))
            }
            .padding(.top, 5)
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func firstParagraphAndFirstSubThenOne() -> some View {
        //:~ paragraph 1
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第一條   委託管理標的")
            SubTitleView(subTitleName: "一、房屋標示：")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "(一)門牌：\(roomsData.zipCode)\(roomsData.city)\(roomsData.town)\(roomsData.roomAddress)。")
                    LineWithSpacer(contain: "(二)專有部分建號\(roomsData.rentersContractData?.specificBuildingNumber ?? "")，權利範圍\(roomsData.rentersContractData?.specificBuildingRightRange ?? "")，面積共計\(roomsData.rentersContractData?.specificBuildingArea ?? "")平方公尺。")
                    LineWithSpacer(contain: "1.主建物面積：")
                    Text("\(roomsData.rentersContractData?.mainBuildArea ?? "")層 平方公尺，用途\(roomsData.rentersContractData?.mainBuildingPurpose ?? "")。")
                    LineWithSpacer(contain: "2.附屬建物用途\(roomsData.rentersContractData?.subBuildingPurpose ?? "")，面積\(roomsData.rentersContractData?.subBuildingArea ?? "")平方公尺。")
                    LineWithSpacer(contain: "(三)共有部分建號:\(roomsData.rentersContractData?.publicBuildingNumber ?? "")，權利範圍:\(roomsData.rentersContractData?.publicBuildingRightRange ?? "")，持分面積\(roomsData.rentersContractData?.publicBuildingArea ?? "")平方公尺。")
                    settingTheRightForThirdPerson(_isSettingTheRightForThirdPerson: roomsData.rentersContractData?.isSettingTheRightForThirdPerson ?? false,          _SettingTheRightForThirdPersonForWhatKind: roomsData.rentersContractData?.settingTheRightForThirdPersonForWhatKind ?? "")
                     //有無設定他項權利
                    blockByBankCheck(_isBlockByBank: roomsData.rentersContractData?.isBlockByBank ?? false)  //有無查封登記
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func settingTheRightForThirdPerson(_isSettingTheRightForThirdPerson: Bool, _SettingTheRightForThirdPersonForWhatKind: String) -> some View {
        if _isSettingTheRightForThirdPerson == true {
            LineWithSpacer(contain: "(四)有設定他項權利，若有，權利種類：\(_SettingTheRightForThirdPersonForWhatKind)。")
        } else {
            
            LineWithSpacer(contain: "(四)無設定他項權利。")
        }
    }
    
    @ViewBuilder
    func firstParagraphAndFirstSubThenTwo() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            SubTitleView(subTitleName: "二、租賃範圍：")
            
            VStack(spacing: 6) {
                Group {
                    buildProvidePart(_entire: roomsData.rentersContractData?.provideForAll ?? false,
                                     _part: roomsData.rentersContractData?.provideForPart ?? false) //租賃住宅全部
                    haveParkingLot(_hasParkingLot: roomsData.rentersContractData?.hasParkinglot ?? false,
                                   _all: roomsData.rentersContractData?.forAllday ?? false,
                                   _morning: roomsData.rentersContractData?.forMorning ?? false,
                                   _night: roomsData.rentersContractData?.forNight ?? false, isVehicle: roomsData.rentersContractData?.isVehicle ?? false, isMorto: roomsData.rentersContractData?.isMorto ?? false)
                    LineWithSpacer(contain: "(三)租賃附屬設備：")
                    idfSubFacility(_havingSubFacility: roomsData.rentersContractData?.havingSubFacility ?? false)////租賃附屬設備有無
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndSecondSub() -> some View {
        //:~ paragraph 2
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第二條 租賃期間")
            VStack(spacing: 6) {
                Group {
                    Text("租賃期間自\(roomsData.rentersContractData?.rentalStartDate ?? Date(), format: Date.FormatStyle().year().month(.twoDigits).day())起至\(roomsData.rentersContractData?.rentalEndDate ?? Date(), format: Date.FormatStyle().year().month(.twoDigits).day())止。") //租賃期間
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndThirdSub() -> some View {
        //:~ paragraph 3
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第三條 租金約定及支付")
            VStack(spacing: 6) {
                Group {
                    Text("承租人每月租金為新臺幣(下同)\(roomsData.rentalPrice)元整，每期應繳納1個月租金，並於每月\(roomsData.rentersContractData?.paymentdays ?? "")日前支付，不得藉任何理由拖延或拒絕；出租人亦不得任意要求調整租金。") //每月租金
                    idfPaymentMethod(_paybyCash: roomsData.rentersContractData?.paybyCash ?? false,
                                     _paybyTransmission: roomsData.rentersContractData?.paybyTransmission ?? false,
                                     _paybyCreditDebitCard: roomsData.rentersContractData?.paybyCreditDebitCard ?? false) //報酬約定及給付-轉帳繳付
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndFourthSub() -> some View {
        
        let convertIntPrice: Int = Int(roomsData.rentalPrice) ?? 0
        let multipleTwo = convertIntPrice * 2
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第四條 擔保金（押金）約定及返還")
            VStack(spacing: 6) {
                Group {
                    Text("擔保金（押金）由租賃雙方約定為2個月租金，金額為\(multipleTwo)元整(最高不得超過二個月房屋租金之總額)。承租人應於簽訂本契約之同時給付出租人。")//押金
                    Text("前項擔保金（押金），除有第十一條第三項、第十二條第四項及第十六條第二項之情形外，出租人應於租期屆滿或租賃契約終止，承租人交還房屋時返還之。")
                }
            }
            .font(.system(size: 14, weight: .regular))
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndFivthSub() -> some View {
        //:~ paragraph 5
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第五條 租賃期間相關費用之支付")
            VStack(spacing: 6) {
                Group {
                    SubTitleView(subTitleName: "租賃期間，使用房屋所生之相關費用：")
                    Group {
                        SubTitleView(subTitleName: "一、管理費：")
                        idfPaymentSideMF(_payByRenterForManagementPart: roomsData.rentersContractData?.payByRenterForManagementPart ?? false,
                                         _payByProviderForManagementPart: roomsData.rentersContractData?.payByProviderForManagementPart ?? false)
                        LineWithSpacer(contain: "房屋每月\(roomsData.rentersContractData?.managementFeeMonthly ?? "")元整。")
                        LineWithSpacer(contain: "停車位每月\(roomsData.rentersContractData?.parkingFeeMonthly ?? "")元整。")
                        Text("租賃期間因不可歸責於雙方當事人之事由，致本費用增加者，承租人就增加部分之金額，以負擔百分之十為限；如本費用減少者，承租人負擔減少後之金額。")
                        LineWithSpacer(contain: "其他：\(roomsData.rentersContractData?.additionalReqForManagementPart ?? "")。")
                    }
                    Group {
                        SubTitleView(subTitleName: "二、水費：")
                        idfPaymentSideWF(_payByRenterForWaterFee: roomsData.rentersContractData?.payByRenterForWaterFee ?? false,
                                         _payByProviderForWaterFee: roomsData.rentersContractData?.payByProviderForWaterFee ?? false)
                        LineWithSpacer(contain: "其他：\(roomsData.rentersContractData?.additionalReqForWaterFeePart ?? "")。(例如每度  元整)")
                    }
                    Group {
                        SubTitleView(subTitleName: "三、電費：")
                        idfPaymentSideEF(_payByRenterForEletricFee: roomsData.rentersContractData?.payByRenterForEletricFee ?? false,
                                         _payByProviderForEletricFee: roomsData.rentersContractData?.payByProviderForEletricFee ?? false)
                        LineWithSpacer(contain: "其他：\(roomsData.rentersContractData?.additionalReqForEletricFeePart ?? "")。(例如每度  元整)")
                    }
                    Group {
                        SubTitleView(subTitleName: "四、瓦斯：")
                        idfPaymentSideGF(_payByRenterForGasFee: roomsData.rentersContractData?.payByRenterForGasFee ?? false,
                                         _payByProviderForGasFee: roomsData.rentersContractData?.payByProviderForGasFee ?? false)
                        LineWithSpacer(contain: "其他：\(roomsData.rentersContractData?.additionalReqForGasFeePart ?? "")。")
                    }
                    Group {
                        LineWithSpacer(contain: "五、其他費用及其支付方式：\(roomsData.rentersContractData?.additionalReqForOtherPart ?? "")。")
                    }
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndSixthSub() -> some View {
        //:~ paragraph 6
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第六條 稅費負擔之約定")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "本租賃契約有關稅費、代辦費，依下列約定辦理：")
                    LineWithSpacer(contain: "一、房屋稅、地價稅由出租人負擔。")
                    LineWithSpacer(contain: "二、銀錢收據之印花稅由出租人負擔。")
                    Group {
                        LineWithSpacer(contain: "三、簽約代辦費\(roomsData.rentersContractData?.contractSigurtureProxyFee ?? "")元")
                        idfcontractSigurtureProxyFee(_payByRenterForProxyFee: roomsData.rentersContractData?.payByRenterForProxyFee ?? false,
                                                     _payByProviderForProxyFee: roomsData.rentersContractData?.payByProviderForProxyFee ?? false,
                                                     _separateForBothForProxyFee: roomsData.rentersContractData?.separateForBothForProxyFee ?? false)
                    }
                    Group {
                        LineWithSpacer(contain: "四、公證費\(roomsData.rentersContractData?.contractIdentitificationFee ?? "")元")
                        idfcontractIdentitificationFee(_payByRenterForIDFFee: roomsData.rentersContractData?.payByRenterForIDFFee ?? false,
                                                       _payByProviderForIDFFee: roomsData.rentersContractData?.payByProviderForIDFFee ?? false,
                                                       _separateForBothForIDFFee: roomsData.rentersContractData?.separateForBothForIDFFee ?? false)
                    }
                    Group {
                        LineWithSpacer(contain: "五、公證代辦費\(roomsData.rentersContractData?.contractIdentitificationProxyFee ?? "")元")
                        idfcontractIdentitificationProxyFee(_payByRenterForIDFProxyFee: roomsData.rentersContractData?.payByRenterForIDFProxyFee ?? false,
                                                            _payByProviderForIDFProxyFee: roomsData.rentersContractData?.payByProviderForIDFProxyFee ?? false,
                                                            _separateForBothForIDFProxyFee: roomsData.rentersContractData?.separateForBothForIDFProxyFee ?? false)
                    }
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndSeventhSub() -> some View {
        //:~ paragraph 7
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第七條 使用房屋之限制")
            VStack(spacing: 6) {
                Group {
                    Text("本房屋係供住宅使用。非經出租人同意，不得變更用途。承租人同意遵守住戶規約，不得違法使用，或存放有爆炸性或易燃性物品，影響公共安全。")
                    subLeaseAgreement(_subLeaseAgreement: roomsData.rentersContractData?.subLeaseAgreement ?? false)
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndEighthSub() -> some View {
        VStack(spacing: 6) {
            TitleView(titleName: "第八條 修繕及改裝")
            Group {
                Group {
                    Text("房屋或附屬設備損壞而有修繕之必要時，應由出租人負責修繕。但租賃雙方另有約定、習慣或可歸責於承租人之事由者，不在此限。")
                    Text("前項由出租人負責修繕者，如出租人未於承租人所定相當期限內修繕時，承租人得自行修繕並請求出租人償還其費用或於第四條約定之擔保金中扣除，若毀損嚴重者需償付所有修繕費用。")
                    Text("房屋有改裝設施之必要，承租人應經出租人同意，始得依相關法令自行裝設，但不得損害原有建築之結構安全。前項情形承租人返還房屋時，應負責回復原狀。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndNinethSub() -> some View {
        //:~ paragraph 9
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第九條 承租人之責任")
            VStack(spacing: 6) {
                Group {
                    Text("承租人應以善良管理人之注意保管房屋，如違反此項義務，致房屋毀損或滅失者，應負損害賠償責任。但依約定之方法或依房屋之性質使用、收益，致房屋有毀損或滅失者，不在此限。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder //:~ paragraph 10
    func firstParagraphAndTenthSub() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十條 房屋部分滅失")
            VStack(spacing: 6) {
                Group {
                    Text("租賃關係存續中，因不可歸責於承租人之事由，致房屋之一部滅失者，承租人得按滅失之部分，請求減少租金。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder //:~ paragraph 11
    func firstParagraphAndEleventhSub() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十一條 提前終止租約")
            VStack(spacing: 6) {
                Group {
                    Text("本契約於期限屆滿前，租賃雙方不得終止租約。依約定得終止租約者，租賃之一方應於一個月前通知他方。一方未為先期通知而逕行終止租約者，應賠償他方一個月(最高不得超過一個月)租金額之違約金。")
                    Text("前項承租人應賠償之違約金得由第四條之擔保金(押金)中扣抵。租期屆滿前，依第二項終止租約者，出租人已預收之租金應返還予承租人。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder //:~ paragraph 12
    func firstParagraphAndtwelevethSub() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十二條 房屋之返還")
            VStack(spacing: 6) {
                Group {
                    Text("租期屆滿或租賃契約終止時，承租人應即將房屋返還出租人並遷出戶籍或其他登記。")
                    Text("前項房屋之返還，應由租賃雙方共同完成屋況及設備之點交手續。租賃之一方未會同點交，經他方定相當期限催告仍不會同者，視為完成點交。")
                    Text("承租人未依第一項約定返還房屋時，出租人得向承租人請求未返還房屋期間之相當月租金額外，並得請求相當月租金額一倍(未足一個月者，以日租金折算)之違約金至返還為止。")
                    Text("前項金額及承租人未繳清之相關費用，出租人得由第四條之擔保金(押金)中扣抵。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndThirteenth() -> some View {
        //:~ paragraph 13
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十三條 房屋所有權之讓與")
            VStack(spacing: 6) {
                Group {
                    Text("出租人於房屋交付後，承租人占有中，縱將其所有權讓與第三人，本契約對於受讓人仍繼續存在。")
                    Text("前項情形，出租人應移交擔保金（押金）及已預收之租金與受讓人，並以書面通知承租人。")
                    Text("本契約如未經公證，其期限逾五年或未定期限者，不適用前二項之約定。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndFourteenth() -> some View {
        //:~ paragraph 14
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十四條 出租人終止租約")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "承租人有下列情形之一者，出租人得終止租約：")
                    Text("一、遲付租金之總額達二個月之金額，並經出租人定相當期限催告，承租人仍不為支付。")
                    LineWithSpacer(contain: "二、違反第七條規定而為使用。")
                    LineWithSpacer(contain: "三、違反第八條第三項規定而為使用。")
                    Text("四、積欠管理費或其他應負擔之費用達相當二個月之租金額，經出租人定相當期限催告，承租人仍不為支付。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndFiveteenth() -> some View {
        //:~ paragraph 15
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十五條 承租人終止租約")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "出租人有下列情形之一者，承租人得終止租約：")
                    Text("一、房屋損害而有修繕之必要時，其應由出租人負責修繕者，經承租人定相當期限催告，仍未修繕完畢。")
                    Text("二、有第十條規定之情形，減少租金無法議定，或房屋存餘部分不能達租賃之目的。")
                    LineWithSpacer(contain: "三、房屋有危及承租人或其同居人之安全或健康之瑕疵時。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndSixteenth() -> some View {
        //:~ paragraph 16
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十六條 遺留物之處理")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "租期屆滿或租賃契約終止後，承租人之遺留物依下列方式處理：")
                    LineWithSpacer(contain: "一、承租人返還房屋時，任由出租人處理。")
                    Text("二、承租人未返還房屋時，經出租人定相當期限催告搬離仍不搬離時，視為廢棄物任由出租人處理。")
                    Text("前項遺留物處理所需費用，由擔保金(押金)先行扣抵，如有不足，出租人得向承租人請求給付不足之費用。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndSeventeenth() -> some View {
        //:~ paragraph 17
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十七條 通知送達及寄送")
            VStack(spacing: 6) {
                Group {
                    Text("除本契約另有約定外，出租人與承租人雙方相互間之通知，以郵寄為之者，應以本契約所記載之地址為準；並得以電子郵件、簡訊等方式為之(無約定通知方式者，應以郵寄為之)；如因地址變更未通知他方，致通知無法到達時（包括拒收），以他方第一次郵遞或通知之日期推定為到達日。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    @ViewBuilder
    func fitstParagraphAndEighteenth() -> some View {
        //:~ paragraph 18
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十八條 疑義處理")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "本契約各條款如有疑義時，應為有利於承租人之解釋。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    @ViewBuilder
    func fitstParagraphAndNineteenth() -> some View {
        //:~ paragraph 19
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十九條 其他約定")
            VStack(spacing: 6) {
                Group {
                    doCourtIDF(_doCourtIDF: roomsData.rentersContractData?.doCourtIDF ?? false)
                    doCourtIDFDoc(_courtIDFDoc: roomsData.rentersContractData?.courtIDFDoc ?? false)
                    LineWithSpacer(contain: "一、承租人如於租期屆滿後不返還房屋。")
                    Text("二、承租人未依約給付之欠繳租金、出租人代繳之管理費，或違約時應支付之金額。")
                    Text("三、出租人如於租期屆滿或租賃契約終止時，應返還之全部或一部擔保金（押金）。")
                    Text("公證書載明金錢債務逕受強制執行時，如有保證人者，前項後段第__款之效力及於保證人。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndtwentyth() -> some View {
        //:~ paragraph 20
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第二十條 爭議處理")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "因本契約發生之爭議，雙方得依下列方式處理：")
                    Text("一、向房屋所在地之直轄市、縣（市）不動產糾紛調處委員會申請調處。")
                    LineWithSpacer(contain: "二、向直轄市、縣（市）消費爭議調解委員會申請調解。")
                    LineWithSpacer(contain: "三、向鄉鎮市(區)調解委員會申請調解。")
                    LineWithSpacer(contain: "四、向房屋所在地之法院聲請調解或進行訴訟。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndtwentyFirst() -> some View {
        //:~ paragraph 21
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第二十一條 契約及其相關附件效力")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "本契約自簽約日起生效，雙方各執一份契約正本。")
                    LineWithSpacer(contain: "本契約廣告及相關附件視為本契約之一部分。")
                    LineWithSpacer(contain: "本契約所定之權利義務對雙方之繼受人均有效力。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndtwentySecond() -> some View {
        //:~ paragraph 22
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第二十二條 未盡事宜之處置")
            VStack(spacing: 6) {
                Group {
                    Text("本契約如有未盡事宜，依有關法令、習慣、平等互惠及誠實信用原則公平解決之。附件會寄送至電子郵件")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func blockByBankCheck(_isBlockByBank: Bool) -> some View {
        if _isBlockByBank == true {
            LineWithSpacer(contain: "(六)有查封登記。")
        } else {
            LineWithSpacer(contain: "(六)無查封登記。")
        }
    }
    
    @ViewBuilder
    func buildProvidePart(_entire: Bool, _part: Bool) -> some View {
        if _entire == true {
            LineWithSpacer(contain: "(一)租賃住宅全部：第\(roomsData.rentersContractData?.provideFloor ?? "")層, 房間\(roomsData.rentersContractData?.provideRooms ?? "")間, 第\(roomsData.rentersContractData?.provideRoomNumber ?? "")室，面積\(roomsData.rentersContractData?.provideFloor ?? "")平方公尺。")
        } else if _part == true {
            LineWithSpacer(contain: "(一)租賃住宅部分：第\(roomsData.rentersContractData?.provideFloor ?? "")層□房間\(roomsData.rentersContractData?.provideRooms ?? "")間□第\(roomsData.rentersContractData?.provideRoomNumber ?? "")室，面積\(roomsData.rentersContractData?.provideFloor ?? "")平方公尺。")
        }
    }
    
    @ViewBuilder
    func forUsingDay(_all: Bool, _morning: Bool, _night: Bool) -> some View {
        if _all == true {
            HStack {
                Text("全日。") //使用時間全日, 日間, 夜間
                Spacer()
            }        }
        if _morning == true {
            HStack {
                Text("□日間。") //使用時間全日, 日間, 夜間
                Spacer()
            }
        }
        if _night == true {
            HStack {
                Text("夜間。") //使用時間全日, 日間, 夜間
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func idfParkingLotStyle(parkingStyleN: Bool, parkingStyleM: Bool) -> some View {
        if parkingStyleM == true {
            Text("地上(下)第\(roomsData.rentersContractData?.parkingUGFloor ?? "")層機械式停車位，編號第\(roomsData.rentersContractData?.parkingNumberForVehicle ?? "")號。") //平面式停車位, 機械式停車位
        }
        if parkingStyleN == true {
            Text("地上(下)第\(roomsData.rentersContractData?.parkingUGFloor ?? "")層平面式停車位，編號第\(roomsData.rentersContractData?.parkingNumberForVehicle ?? "")號。") //平面式停車位, 機械式停車位
        }
    }
    
    @ViewBuilder
    func vehicleType(isVehicle: Bool, isMorto: Bool) -> some View {
        if isVehicle == true {
            LineWithSpacer(contain: "1.汽車停車位種類及編號：")
            idfParkingLotStyle(parkingStyleN: roomsData.rentersContractData?.parkingStyleN ?? false, parkingStyleM: roomsData.rentersContractData?.parkingStyleM ?? false)
        }
        if isMorto == true {
            LineWithSpacer(contain: "2.機車停車位：")
            HStack {
                Text("地上(下)第\(roomsData.rentersContractData?.parkingNumberForMortor ?? "")或其位置示意圖。")
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func haveParkingLot(_hasParkingLot: Bool, _all: Bool, _morning: Bool, _night: Bool, isVehicle: Bool, isMorto: Bool) -> some View {
        if _hasParkingLot == true {
            Group {
                LineWithSpacer(contain: "(二)車位：(如無則免填)")//汽車停車位, 機車停車位
                vehicleType(isVehicle: isVehicle, isMorto: isMorto)
                LineWithSpacer(contain: "3.使用時間：")
                forUsingDay(_all: _all, _morning: _morning, _night: _night)
            }
        } else {
            Group {
                LineWithSpacer(contain: "(二)車位：(如無則免填)")//汽車停車位, 機車停車位
                LineWithSpacer(contain: "1.汽車停車位種類及編號：")
                Text("地上(下)第＿＿層□平面式停車位□機械式停車位，編號第＿＿號。") //平面式停車位, 機械式停車位
                LineWithSpacer(contain: "2.機車停車位：")
                HStack {
                    Text("地上(下)第＿＿層，編號第＿＿號或其位置示意圖。")
                    Spacer()
                    
                }
                LineWithSpacer(contain: "3.使用時間：")
                HStack {
                    Text("□全日□日間□夜間□其他___。") //使用時間全日, 日間, 夜間
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    func idfSubFacility(_havingSubFacility: Bool) -> some View {
        if _havingSubFacility == true {
            Text("有附屬設備，若有，除另有附屬設備清單外，詳如附件委託管理標的現況確認書。") ////租賃附屬設備有無
        } else {
            Text("無附屬設備，若有，除另有附屬設備清單外，詳如附件委託管理標的現況確認書。") ////租賃附屬設備有無
        }
    }
    
    @ViewBuilder
    func idfPaymentMethod(_paybyCash: Bool, _paybyTransmission: Bool, _paybyCreditDebitCard: Bool) -> some View {
        if _paybyCash == true {
            Text("租金支付方式：現金繳付。") //報酬約定及給付-轉帳繳付
        }
        if _paybyTransmission == true {
            Text("租金支付方式：轉帳繳付：金融機構：\(roomsData.rentersContractData?.bankName ?? "")，戶名：\(roomsData.rentersContractData?.bankOwnerName ?? "")，帳號：\(roomsData.rentersContractData?.bankAccount ?? "")。")
        }
        if _paybyCreditDebitCard == true {
            Text("租金支付方式：信用/簽帳卡繳付。")
        }
        if _paybyCash == true && _paybyTransmission == true && _paybyCreditDebitCard == true {
            Text("租金支付方式：現金繳付/轉帳繳付信用/簽帳卡繳付皆可：金融機構：\(roomsData.rentersContractData?.bankName ?? "")，戶名：\(roomsData.rentersContractData?.bankOwnerName ?? "")，帳號：\(roomsData.rentersContractData?.bankAccount ?? "")。")
        }
    }
    
    @ViewBuilder
    func idfPaymentSideMF(_payByRenterForManagementPart: Bool, _payByProviderForManagementPart: Bool) -> some View {
        if _payByRenterForManagementPart == true {
            LineWithSpacer(contain: "由承租人負擔。")
        }
        if _payByProviderForManagementPart == true {
            LineWithSpacer(contain: "由出租人負擔。")
        }
    }
    @ViewBuilder
    func idfPaymentSideWF(_payByRenterForWaterFee: Bool, _payByProviderForWaterFee: Bool) -> some View {
        if _payByRenterForWaterFee == true {
            LineWithSpacer(contain: "由承租人負擔。")
        }
        if _payByProviderForWaterFee == true {
            LineWithSpacer(contain: "由出租人負擔。")
        }
    }
    
    @ViewBuilder
    func idfPaymentSideEF(_payByRenterForEletricFee: Bool, _payByProviderForEletricFee: Bool) -> some View {
        if _payByRenterForEletricFee == true {
            LineWithSpacer(contain: "由承租人負擔。")
        }
        if _payByProviderForEletricFee == true {
            LineWithSpacer(contain: "由出租人負擔。")
        }
    }
    @ViewBuilder
    func idfPaymentSideGF(_payByRenterForGasFee: Bool, _payByProviderForGasFee: Bool) -> some View {
        if _payByRenterForGasFee == true {
            LineWithSpacer(contain: "由承租人負擔。")
        }
        if _payByProviderForGasFee == true {
            LineWithSpacer(contain: "由出租人負擔。")
        }
    }
    
    @ViewBuilder
    func idfcontractSigurtureProxyFee(_payByRenterForProxyFee: Bool, _payByProviderForProxyFee: Bool, _separateForBothForProxyFee: Bool) -> some View {
        if _payByRenterForProxyFee == true {
            LineWithSpacer(contain: "由承租人負擔。")
        }
        if _payByProviderForProxyFee == true {
            LineWithSpacer(contain: "由出租人負擔。")
        }
        if _separateForBothForProxyFee == true {
            LineWithSpacer(contain: "由租賃雙方平均負擔。")
        }
    }
    
    @ViewBuilder
    func idfcontractIdentitificationFee(_payByRenterForIDFFee: Bool, _payByProviderForIDFFee: Bool, _separateForBothForIDFFee: Bool) -> some View {
        if _payByRenterForIDFFee == true {
            LineWithSpacer(contain: "由承租人負擔。")
        }
        if _payByProviderForIDFFee == true {
            LineWithSpacer(contain: "由出租人負擔。")
        }
        if _separateForBothForIDFFee == true {
            LineWithSpacer(contain: "由租賃雙方平均負擔。")
        }
    }
    
    @ViewBuilder
    func idfcontractIdentitificationProxyFee(_payByRenterForIDFProxyFee: Bool, _payByProviderForIDFProxyFee: Bool, _separateForBothForIDFProxyFee: Bool) -> some View {
        if _payByRenterForIDFProxyFee == true {
            LineWithSpacer(contain: "由承租人負擔。")
        }
        if _payByProviderForIDFProxyFee == true {
            LineWithSpacer(contain: "由出租人負擔。")
        }
        if _separateForBothForIDFProxyFee == true {
            LineWithSpacer(contain: "由租賃雙方平均負擔。")
        }
    }
    
    @ViewBuilder
    func subLeaseAgreement(_subLeaseAgreement: Bool) -> some View {
        if _subLeaseAgreement == true {
            Text("出租人同意將本房屋之全部或一部分轉租、出借或 以其他方式供他人使用，或將租賃權轉讓於他人。前項出租人同意轉租者，承租人應提示出租人同意轉租之證明文件。")
        } else {
            Text("出租人不同意將本房屋之全部或一部分轉租、出借或 以其他方式供他人使用，或將租賃權轉讓於他人。前項出租人同意轉租者，承租人應提示出租人同意轉租之證明文件。")
        }
    }
    
    @ViewBuilder
    func doCourtIDF(_doCourtIDF: Bool) -> some View {
        if _doCourtIDF == true {
            LineWithSpacer(contain: "本契約雙方同意辦理公證。")
        } else {
            LineWithSpacer(contain: "本契約雙方同意不辦理公證。")
        }
    }
    
    @ViewBuilder
    func doCourtIDFDoc(_courtIDFDoc: Bool) -> some View {
        if _courtIDFDoc == true {
            Text("本契約經辦理公證者，租賃雙方同意公證書載明下列事項應逕受強制執行：")
        } else {
            Text("本契約經辦理公證者，租賃雙方不同意公證書載明下列事項應逕受強制執行：")
        }
    }
    
}

struct expressionContractList: View {
    var body: some View {
        VStack {
            Group {
                VStack(alignment: .leading, spacing: 5) {
                    TitleView(titleName: "簽約注意事項")
                    SubTitleView(subTitleName: "一、適用範圍")
                    VStack(spacing: 6) {
                        Group {
                            Text("本契約書範本之租賃房屋用途，係由承租人供作住宅使用，並提供消費者與企業經營者簽訂房屋租賃契約時參考使用。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "二、契約審閱權")
                    VStack(spacing: 6) {
                        Group {
                            Text("房屋出租人為企業經營者，其與承租人訂立定型化契約前，應有三十日以內之合理期間，供承租人審閱全部條款內容。")
                            LineWithSpacer(contain: "出租人以定型化契約條款使承租人拋棄前項權利者，無效。")
                            Text("出租人與承租人訂立定型化契約未提供第一項之契約審閱期間者，其條款不構成契約之內容。但承租人得主張該條款仍構成契約之內容。（消費者保護法第十一條之一第一項至第三項）")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "三、租賃意義")
                    VStack(spacing: 6) {
                        Group {
                            Text("稱租賃者，謂當事人約定，一方以物租與他方使用收益，他方支付租金之契約(民法第四百二十一條)。當事人就標的物及租金為同意時，租賃契約即為成立。為使租賃當事人清楚了解自己所處之立場與權利義務關係，乃簡稱支付租金之人為承租人，交付租賃標的物之人為出租人。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "四、房屋租賃標的")
                    VStack(spacing: 6) {
                        Group {
                            Text("(一)房屋租賃範圍屬已登記者，以登記簿記載為準；未登記者以房屋稅籍證明或實際測繪結果為準。")
                            Text("(二）房屋租賃範圍非屬全部者(如部分樓層之套房或雅房出租)，應由出租人出具「房屋位置格局示意圖」標註租賃範圍，以確認實際房屋租賃位置或範圍。")
                            Text("(三)為避免租賃雙方對於租賃房屋是否包含未登記之改建、增建、加建及違建部分，或冷氣、傢俱等其他附屬設備認知差異，得參依本契約範本附件「房屋租賃標的現況確認書」，由租賃雙方互為確認，以杜糾紛。")
                            Text("(四)承租人遷入房屋時，可請出租人會同檢查房屋設備現況並拍照存證，如有附屬設備，並得以清單列明，以供返還租屋回復原狀之參考。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
            }
            Group {
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "五、租賃期間")
                    VStack(spacing: 6) {
                        Group {
                            Text("(一)房屋租賃之期間超過一年者，應訂立契約，未訂立契約者，視為不定期限之租賃。租賃契約之期限，不得超過二十年，超過二十年者，縮短為二十年。")
                            Text("(二)房屋租賃契約未定期限者，租賃雙方當事人得隨時終止租約。但有利於承租人之習慣者，從其習慣。故租賃雙方簽約時宜明訂租賃期間，以保障雙方權益。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "六、租金約定及支付")
                    VStack(spacing: 6) {
                        Group {
                            Text("(一)土地法第九十七條第一項之規定，城市地方房屋之租金， 以不超過土地及其建築物申報總價額年息百分之十為限。")
                            Text("(二)土地法第九十七條所稱「城市地方」，依內政部六十七年九月十五日台內地字第八○五四四七號函釋，係指已依法公布實施都市計畫之地方。又同條所稱「房屋」，依內政部七十一年五月二十四日台內地字第八七一○三號函釋，係指供住宅用之房屋。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "七、擔保金(押金)約定及返還")
                    VStack(spacing: 6) {
                        Group {
                            Text("(一)土地法第九十九條規定，擔保金(押金)以不得超過二個月之租金總額為宜，超過部分，承租人得以超過之部分抵付房租。承租人仍得於二個月之租金總額範圍內與出租人議定擔保金(押金)額度，如經約定承租人無須支付者，因屬私權行為，尚非法所不許。有關擔保金額之限制，依內政部一百零二年十月三日內授中辦地字第一○二六○三八九○八號函釋，係指供住宅用之房屋，至營業用房屋，其應付擔保金額，不受土地法第九十九條之限制。")
                            Text("(二)承租人於支付擔保金(押金)或租金時，應要求出租人簽寫收據或於承租人所持有之租賃契約書上註明收訖為宜；若以轉帳方式支付，應保留轉帳收據。同時出租人返還擔保金(押金)予承租人時，亦應要求承租人簽寫收據或於出租人所持有之租賃契約書上記明收訖為宜。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "八、租賃期間相關費用之支付")
                    VStack(spacing: 6) {
                        Group {
                            Text("(一)有關使用房屋而連帶產生之相關費用如水、電、瓦斯及管理費等，實務上有不同類型，部分契約係包含於租金中，部分則約定由承租人另行支付，亦有係由租賃雙方共同分擔等情形，宜事先於契約中明訂數額或雙方分擔之方式，以免日後產生爭議。")
                            Text("(二)房屋租賃範圍非屬全部者(如部分樓層之套房或雅房出租)，相關費用及其支付方式，宜由租賃雙方依實際租賃情形事先於契約中明訂數額或雙方分擔之方式，例如以房間分度表數計算每度電費應支付之金額。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "九、使用房屋之限制")
                    VStack(spacing: 6) {
                        Group {
                            Text("(一)承租人應依約定方法，為租賃房屋之使用、收益，並應遵守規約所定之一切權利義務及住戶共同約定事項。")
                            Text("(二)租賃物為房屋者，依民法第四百四十三條第一項規定，除出租人有反對轉租之約定外，承租人得將其一部分轉租他人。故出租人未於契約中約定不得轉租，則承租人即得將房屋之一部分轉租他人。")
                            Text("(三)本契約書範本之租賃房屋用途，係由承租人供作住宅使用，而非營業使用，出租人得不同意承租人為公司登記、商業登記及營業(稅籍)登記。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "十、修繕及改裝")
                    VStack(spacing: 6) {
                        Group {
                            Text("(一)房屋或附屬設備之修繕，依民法第四百二十九條第一項規定，除契約另有訂定或另有習慣外，由出租人負擔。")
                            Text("(二)出租人之修繕義務，在使承租人就租賃物能為約定之使用收益，如承租人就租賃物以外有所增設時，該增設物即不在出租人修繕義務範圍。(最高法院六十三年台上字第九九號判例）")
                            Text("(三)房屋有無滲漏水之情形，租賃雙方宜於交屋前確認，若有滲漏水，宜約定其處理方式(如由出租人修繕後交屋、以現況交屋、減租或由承租人自行修繕等)。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "十一、提前終止租約")
                    VStack(spacing: 6) {
                        Group {
                            Text("(一)租賃定有期限者，其租賃關係，於期限屆滿時消滅。未定期限者，租賃雙方得隨時終止契約。故契約當事人於簽訂契約時，請記得約定得否於租賃期間終止租約，以保障自身權益。")
                            Text("(二)租賃雙方雖約定不得終止租約，但如有本契約書範本第十四條或第十五條得終止租約之情形，因係屬法律規定，仍得終止租約。")
                            Text("(三)定有期限之租賃契約，如約定租賃之一方於期限屆滿前，得終止契約者，其終止契約，應按照本契約書範本第十一條約定先期通知他方。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "十二、房屋之返還")
                    VStack(spacing: 6) {
                        Group {
                            Text("(一)承租人返還房屋時，如有附屬設備清單或拍照存證相片，宜由租賃雙方會同逐一檢視點交返還。")
                            Text("(二)承租人返還房屋時，如未將戶籍或商業登記或營業(稅籍)登記遷出，房屋所有權人得依戶籍法或商業登記法或營業登記規則等相關規定，證明無租借房屋情事，向房屋所在地戶政事務所或主管機關申請遷離或廢止。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
            }
            Group {
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "十三、出租人終止租約")
                    VStack(spacing: 6) {
                        Group {
                            Text("不定期之房屋租賃，承租人積欠租金除擔保金抵償外達二個月以上時，依土地法第一百條第三款之規定，出租人固得收回房屋。惟該條款所謂因承租人積欠租金之事由收回房屋，應仍依民法第四百四十條第一項規定，對於支付租金遲延之承租人，定相當期限催告其支付，承租人於其期限內不為支付者，始得終止租賃契約。在租賃契約得為終止前，尚難謂出租人有收回房屋請求權存在。（最高法院四十二年台上字第一一八六號判例）")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "十四、疑義處理")
                    VStack(spacing: 6) {
                        Group {
                            LineWithSpacer(contain: "(一)本契約書範本所訂之條款，均不影響承租人依消費者保護法規定之權利。")
                            Text("(二)本契約各條款如有疑義時，依消費者保護法第十一條第二項規定，應為有利於承租人之解釋。惟承租人為再轉租之二房東者，因二房東所承租之房屋非屬最終消費，如有契約條款之疑義，尚無消費者保護法有利於承租人解釋之適用。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "十五、消費爭議處理")
                    VStack(spacing: 6) {
                        Group {
                            LineWithSpacer(contain: "因本契約發生之消費爭議，雙方得依下列方式處理：")
                            LineWithSpacer(contain: "(一)依直轄市縣（市）不動產糾紛調處委員會設置及調處辦法規定申請調處。")
                            Text("(二)依消費者保護法第四十三條及第四十四條規定，承租人得向出租人、消費者保護團體或消費者服務中心申訴；未獲妥適處理時，得向租賃房屋所在地之直轄市或縣（市）政府消費者保護官申訴；再未獲妥適處理時得向直轄市或縣（市）消費爭議調解委員會申請調解。")
                            Text("(三)依鄉鎮市調解條例規定向鄉鎮市(區)調解委員會申請調解，或依民事訴訟法第四百零三條及第四百零四條規定，向房屋所在地之法院聲請調解或進行訴訟。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "十六、租賃契約之效力")
                    VStack(spacing: 6) {
                        Group {
                            Text("為確保私權及避免爭議，簽訂房屋租賃契約時不宜輕率，宜請求公證人就法律行為或私權事實作成公證書或認證文書。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "十七、契約分存")
                    VStack(spacing: 6) {
                        Group {
                            Text("訂約時務必詳審契約條文，由雙方簽章或按手印，寫明戶籍、通訊住址及統一編號並分存契約，以免權益受損。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "十八、確定訂約者之身分")
                    VStack(spacing: 6) {
                        Group {
                            Text("一)簽約時應先確定簽訂人之身分，例如國民身分證、駕駛執照或健保卡等身分證明文件之提示。如未成年人(除已結婚者外)訂定本契約，應依民法規定，經法定代理人或監護人之允許或承認。若非租賃雙方本人簽約時，應請簽約人出具授權簽約同意書。")
                            Text("(二)出租人是否為屋主或二房東，可要求出租人提示產權證明如所有權狀、登記謄本或原租賃契約書（應注意其租賃期間有無禁止轉租之約定）。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    SubTitleView(subTitleName: "十九、經紀人簽章")
                    VStack(spacing: 6) {
                        Group {
                            LineWithSpacer(contain: "房屋租賃若透過不動產經紀業辦理者，應由該經紀業指派經紀人於本契約簽章。")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
            }
        }
    }
}


