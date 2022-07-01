//
//  houseDMForInternal.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

// MARK: - House Rental Provider basic information

// struct RoomsConfig: Codable {
//    var uidPath: String
//    var roomUID: [String]
//    var providerChatDocID: String
//    var companyName: String
//    var companyProfileImageURL: String
// }

// extension RoomsConfig {
//    static let empty = RoomsConfig(uidPath: "", roomUID: [], companyName: "", companyProfileImageURL: "")
// }

// MARK: - Rooms data model and provider could publish or modify contract

struct RoomDM: Identifiable, Codable {
    @DocumentID var id: String?
    var isPublish: Bool
    var roomUID: String
    var providerUID: String
    var providerGUI: String
    var renterUID: String
    var roomsCoverImageURL: String
    var rentalPrice: String
    var zipCode: String
    var city: String
    var town: String
    var address: String
    var roomDescription: String
    var someoneDeadInRoom: Bool
    var waterLeakingProblem: Bool
    @ServerTimestamp var contractBuildDate: Timestamp?
}

extension RoomDM {
    static let empty = RoomDM(isPublish: false, roomUID: "", providerUID: "", providerGUI: "", renterUID: "", roomsCoverImageURL: "", rentalPrice: "", zipCode: "", city: "", town: "", address: "", roomDescription: "", someoneDeadInRoom: false, waterLeakingProblem: false)
//    static func fillGUI(
//        gui: String,
//        room data: RoomDM
//    ) -> RoomDM {
//        return RoomDM(
//            isPublish: false,
//            roomUID: data.roomUID,
//            providerUID: data.providerUID,
//            providerGUI: gui,
//            renterUID: data.renterUID,
//            roomsCoverImageURL: data.roomsCoverImageURL,
//            rentalPrice: data.rentalPrice,
//            zipCode: data.zipCode,
//            city: data.city,
//            town: data.town,
//            address: data.address,
//            roomDescription: data.roomDescription,
//            someoneDeadInRoom: data.someoneDeadInRoom,
//            waterLeakingProblem: data.waterLeakingProblem
//        )
//    }
}

// MARK: - Room's image set

struct RoomImageSet: Identifiable, Codable {
    @DocumentID var id: String?
    var roomImageURL: String
}

// MARK: - Contract data model

struct HouseContract: Codable {
    // MARK: Contract's Data Model

    var contractBuildDate: Date
    var contractReviewDays: String

    var providerSignurture: String
    var renterSignurture: String

    var companyTitle: String
    var roomAddress: String
    var roomTown: String
    var roomCity: String
    var roomZipCode: String

    // MARK: 第一條 委託管理標的 - 房屋標示

    var specificBuildingNumber: String // 專有部分建號
    var specificBuildingRightRange: String // 專有部分權利範圍
    var specificBuildingArea: String // 專有部分面積共計

    var mainBuildArea: String // 主建物面積__層__平方公尺
    var mainBuildingPurpose: String // 主建物用途

    var subBuildingPurpose: String // 附屬建物用途
    var subBuildingArea: String // 附屬建物面積__平方公尺

    var publicBuildingNumber: String // 共有部分建號
    var publicBuildingRightRange: String // 共有部分權利範圍
    var publicBuildingArea: String // 共有部分持分面積__平方公尺

    var hasParkinglot: Bool // 車位-有
//    var parkinglotAmount: String //汽機車車位數量

    var isSettingTheRightForThirdPerson: Bool // 設定他項權利-有無
    var settingTheRightForThirdPersonForWhatKind: String // 權利種類

    var isBlockByBank: Bool // 查封登記-有

    // MARK: 第一條 委託管理標的 - 租賃範圍

    var provideForAll: Bool // 租賃住宅全部
    var provideForPart: Bool // 租賃住宅部分
    var provideFloor: String // 租賃住宅第__層
    var provideRooms: String // 租賃住宅房間__間
    var provideRoomNumber: String // 租賃住宅第__室
    var provideRoomArea: String // 租賃住宅面積__平方公尺

    var isVehicle: Bool // 汽車停車位
    var isMorto: Bool // 機車停車位
//    var isBoth: Bool //汽車機車皆有
    var parkingUGFloor: String // 地上(下)第__層
    var parkingStyleN: Bool // 平面式停車位ㄩ
    var parkingStyleM: Bool // 機械式停車位
    var parkingNumberForVehicle: String // 編號第__號
    var parkingNumberForMortor: String // 編號第__號
    var forAllday: Bool // 使用時間全日
    var forMorning: Bool // 使用時間日間
    var forNight: Bool // 使用時間夜間

    var havingSubFacility: Bool // 租賃附屬設備-有

    // MARK: 第二條 租賃期間

    var rentalStartDate: Date // 委託管理期間自
    var rentalEndDate: Date // 委託管理期間至

    // MARK: 第三條 租金約定及支付

    var roomRentalPrice: String
    var paymentdays: String // 每月__日前支付
    var paybyCash: Bool // 報酬約定及給付-現金繳付
    var paybyTransmission: Bool // 報酬約定及給付-轉帳繳付
    var paybyCreditDebitCard: Bool // 報酬約定及給付-信用卡/簽帳卡
    var bankName: String // 金融機構
    var bankOwnerName: String // 戶名
    var bankAccount: String // 帳號

    // MARK: 第五條 租賃期間相關費用之支付

    var payByRenterForManagementPart: Bool // 承租人負擔
    var payByProviderForManagementPart: Bool // 出租人負擔
    var managementFeeMonthly: String // 房屋每月___元整
    var parkingFeeMonthly: String // 停車位每月___元整
    var additionalReqForManagementPart: String

    var payByRenterForWaterFee: Bool // 承租人負擔
    var payByProviderForWaterFee: Bool // 出租人負擔
    var additionalReqForWaterFeePart: String

    var payByRenterForEletricFee: Bool // 承租人負擔
    var payByProviderForEletricFee: Bool // 出租人負擔
    var additionalReqForEletricFeePart: String

    var payByRenterForGasFee: Bool // 承租人負擔
    var payByProviderForGasFee: Bool // 出租人負擔
    var additionalReqForGasFeePart: String

    var additionalReqForOtherPart: String // 其他費用及其支付方式

    // MARK: 第六條 稅費負擔之約定

    var contractSigurtureProxyFee: String
    var payByRenterForProxyFee: Bool // 承租人負擔
    var payByProviderForProxyFee: Bool // 出租人負擔
    var separateForBothForProxyFee: Bool // 雙方平均負擔

    var contractIdentitificationFee: String
    var payByRenterForIDFFee: Bool // 承租人負擔
    var payByProviderForIDFFee: Bool // 出租人負擔
    var separateForBothForIDFFee: Bool // 雙方平均負擔

    var contractIdentitificationProxyFee: String
    var payByRenterForIDFProxyFee: Bool // 承租人負擔
    var payByProviderForIDFProxyFee: Bool // 出租人負擔
    var separateForBothForIDFProxyFee: Bool // 雙方平均負擔

    // MARK: 第七條 使用房屋之限制

    var subLeaseAgreement: Bool

    // MARK: 第十二條 房屋之返還

//    var contractSendbyEmail: Bool //履行本契約之通知-電子郵件信箱
//    var contractSendbyTextingMessage: Bool //履行本契約之通知-手機簡訊
//    var contractSendbyMessageSoftware: Bool //履行本契約之通知-即時通訊軟體

    // MARK: 第十九條 其他約定

    var doCourtIDF: Bool // □辦理公證□不辦理公證
    var courtIDFDoc: Bool // □不同意；□同意公證書

    // MARK: 立契約書人

    var providerName: String
    var providerID: String
    var providerResidenceAddress: String
    var providerMailingAddress: String
    var providerPhoneNumber: String
    var providerPhoneChargeName: String
    var providerPhoneChargeID: String
    var providerPhoneChargeEmailAddress: String

    var renterName: String
    var renterID: String
    var renterResidenceAddress: String
    var renterMailingAddress: String
    var renterPhoneNumber: String
    var renterEmailAddress: String

    // End
    var sigurtureDate: Date

    init(contractBuildDate: Date, contractReviewDays: String, providerSignurture: String, renterSignurture: String, companyTitle: String, roomAddress: String, roomTown: String, roomCity: String, roomZipCode: String, specificBuildingNumber: String, specificBuildingRightRange: String, specificBuildingArea: String, mainBuildArea: String, mainBuildingPurpose: String, subBuildingPurpose: String, subBuildingArea: String, publicBuildingNumber: String, publicBuildingRightRange: String, publicBuildingArea: String, hasParkinglot: Bool, isSettingTheRightForThirdPerson: Bool, settingTheRightForThirdPersonForWhatKind: String, isBlockByBank: Bool, provideForAll: Bool, provideForPart: Bool, provideFloor: String, provideRooms: String, provideRoomNumber: String, provideRoomArea: String, isVehicle: Bool, isMorto: Bool, parkingUGFloor: String, parkingStyleN: Bool, parkingStyleM: Bool, parkingNumberForVehicle: String, parkingNumberForMortor: String, forAllday: Bool, forMorning: Bool, forNight: Bool, havingSubFacility: Bool, rentalStartDate: Date, rentalEndDate: Date, roomRentalPrice: String, paymentdays: String, paybyCash: Bool, paybyTransmission: Bool, paybyCreditDebitCard: Bool, bankName: String, bankOwnerName: String, bankAccount: String, payByRenterForManagementPart: Bool, payByProviderForManagementPart: Bool, managementFeeMonthly: String, parkingFeeMonthly: String, additionalReqForManagementPart: String, payByRenterForWaterFee: Bool, payByProviderForWaterFee: Bool, additionalReqForWaterFeePart: String, payByRenterForEletricFee: Bool, payByProviderForEletricFee: Bool, additionalReqForEletricFeePart: String, payByRenterForGasFee: Bool, payByProviderForGasFee: Bool, additionalReqForGasFeePart: String, additionalReqForOtherPart: String, contractSigurtureProxyFee: String, payByRenterForProxyFee: Bool, payByProviderForProxyFee: Bool, separateForBothForProxyFee: Bool, contractIdentitificationFee: String, payByRenterForIDFFee: Bool, payByProviderForIDFFee: Bool, separateForBothForIDFFee: Bool, contractIdentitificationProxyFee: String, payByRenterForIDFProxyFee: Bool, payByProviderForIDFProxyFee: Bool, separateForBothForIDFProxyFee: Bool, subLeaseAgreement: Bool, doCourtIDF: Bool, courtIDFDoc: Bool, providerName: String, providerID: String, providerResidenceAddress: String, providerMailingAddress: String, providerPhoneNumber: String, providerPhoneChargeName: String, providerPhoneChargeID: String, providerPhoneChargeEmailAddress: String, renterName: String, renterID: String, renterResidenceAddress: String, renterMailingAddress: String, renterPhoneNumber: String, renterEmailAddress: String, sigurtureDate: Date) {
        self.contractBuildDate = contractBuildDate
        self.contractReviewDays = contractReviewDays
        self.providerSignurture = providerSignurture
        self.renterSignurture = renterSignurture
        self.companyTitle = companyTitle
        self.roomAddress = roomAddress
        self.roomTown = roomTown
        self.roomCity = roomCity
        self.roomZipCode = roomZipCode
        self.specificBuildingNumber = specificBuildingNumber
        self.specificBuildingRightRange = specificBuildingRightRange
        self.specificBuildingArea = specificBuildingArea
        self.mainBuildArea = mainBuildArea
        self.mainBuildingPurpose = mainBuildingPurpose
        self.subBuildingPurpose = subBuildingPurpose
        self.subBuildingArea = subBuildingArea
        self.publicBuildingNumber = publicBuildingNumber
        self.publicBuildingRightRange = publicBuildingRightRange
        self.publicBuildingArea = publicBuildingArea
        self.hasParkinglot = hasParkinglot
        self.isSettingTheRightForThirdPerson = isSettingTheRightForThirdPerson
        self.settingTheRightForThirdPersonForWhatKind = settingTheRightForThirdPersonForWhatKind
        self.isBlockByBank = isBlockByBank
        self.provideForAll = provideForAll
        self.provideForPart = provideForPart
        self.provideFloor = provideFloor
        self.provideRooms = provideRooms
        self.provideRoomNumber = provideRoomNumber
        self.provideRoomArea = provideRoomArea
        self.isVehicle = isVehicle
        self.isMorto = isMorto
        self.parkingUGFloor = parkingUGFloor
        self.parkingStyleN = parkingStyleN
        self.parkingStyleM = parkingStyleM
        self.parkingNumberForVehicle = parkingNumberForVehicle
        self.parkingNumberForMortor = parkingNumberForMortor
        self.forAllday = forAllday
        self.forMorning = forMorning
        self.forNight = forNight
        self.havingSubFacility = havingSubFacility
        self.rentalStartDate = rentalStartDate
        self.rentalEndDate = rentalEndDate
        self.roomRentalPrice = roomRentalPrice
        self.paymentdays = paymentdays
        self.paybyCash = paybyCash
        self.paybyTransmission = paybyTransmission
        self.paybyCreditDebitCard = paybyCreditDebitCard
        self.bankName = bankName
        self.bankOwnerName = bankOwnerName
        self.bankAccount = bankAccount
        self.payByRenterForManagementPart = payByRenterForManagementPart
        self.payByProviderForManagementPart = payByProviderForManagementPart
        self.managementFeeMonthly = managementFeeMonthly
        self.parkingFeeMonthly = parkingFeeMonthly
        self.additionalReqForManagementPart = additionalReqForManagementPart
        self.payByRenterForWaterFee = payByRenterForWaterFee
        self.payByProviderForWaterFee = payByProviderForWaterFee
        self.additionalReqForWaterFeePart = additionalReqForWaterFeePart
        self.payByRenterForEletricFee = payByRenterForEletricFee
        self.payByProviderForEletricFee = payByProviderForEletricFee
        self.additionalReqForEletricFeePart = additionalReqForEletricFeePart
        self.payByRenterForGasFee = payByRenterForGasFee
        self.payByProviderForGasFee = payByProviderForGasFee
        self.additionalReqForGasFeePart = additionalReqForGasFeePart
        self.additionalReqForOtherPart = additionalReqForOtherPart
        self.contractSigurtureProxyFee = contractSigurtureProxyFee
        self.payByRenterForProxyFee = payByRenterForProxyFee
        self.payByProviderForProxyFee = payByProviderForProxyFee
        self.separateForBothForProxyFee = separateForBothForProxyFee
        self.contractIdentitificationFee = contractIdentitificationFee
        self.payByRenterForIDFFee = payByRenterForIDFFee
        self.payByProviderForIDFFee = payByProviderForIDFFee
        self.separateForBothForIDFFee = separateForBothForIDFFee
        self.contractIdentitificationProxyFee = contractIdentitificationProxyFee
        self.payByRenterForIDFProxyFee = payByRenterForIDFProxyFee
        self.payByProviderForIDFProxyFee = payByProviderForIDFProxyFee
        self.separateForBothForIDFProxyFee = separateForBothForIDFProxyFee
        self.subLeaseAgreement = subLeaseAgreement
        self.doCourtIDF = doCourtIDF
        self.courtIDFDoc = courtIDFDoc
        self.providerName = providerName
        self.providerID = providerID
        self.providerResidenceAddress = providerResidenceAddress
        self.providerMailingAddress = providerMailingAddress
        self.providerPhoneNumber = providerPhoneNumber
        self.providerPhoneChargeName = providerPhoneChargeName
        self.providerPhoneChargeID = providerPhoneChargeID
        self.providerPhoneChargeEmailAddress = providerPhoneChargeEmailAddress
        self.renterName = renterName
        self.renterID = renterID
        self.renterResidenceAddress = renterResidenceAddress
        self.renterMailingAddress = renterMailingAddress
        self.renterPhoneNumber = renterPhoneNumber
        self.renterEmailAddress = renterEmailAddress
        self.sigurtureDate = sigurtureDate
    }
}

extension HouseContract {
    static let empty = HouseContract(
        contractBuildDate: Date(),
        contractReviewDays: "",
        providerSignurture: "",
        renterSignurture: "",
        companyTitle: "",
        roomAddress: "",
        roomTown: "",
        roomCity: "",
        roomZipCode: "",
        specificBuildingNumber: "",
        specificBuildingRightRange: "",
        specificBuildingArea: "",
        mainBuildArea: "",
        mainBuildingPurpose: "",
        subBuildingPurpose: "",
        subBuildingArea: "",
        publicBuildingNumber: "",
        publicBuildingRightRange: "",
        publicBuildingArea: "",
        hasParkinglot: false,
        isSettingTheRightForThirdPerson: false,
        settingTheRightForThirdPersonForWhatKind: "",
        isBlockByBank: false,
        provideForAll: false,
        provideForPart: false,
        provideFloor: "",
        provideRooms: "",
        provideRoomNumber: "",
        provideRoomArea: "",
        isVehicle: false,
        isMorto: false,
        parkingUGFloor: "",
        parkingStyleN: false,
        parkingStyleM: false,
        parkingNumberForVehicle: "",
        parkingNumberForMortor: "",
        forAllday: false,
        forMorning: false,
        forNight: false,
        havingSubFacility: false,
        rentalStartDate: Date(),
        rentalEndDate: Date(),
        roomRentalPrice: "",
        paymentdays: "",
        paybyCash: false,
        paybyTransmission: false,
        paybyCreditDebitCard: false,
        bankName: "",
        bankOwnerName: "",
        bankAccount: "",
        payByRenterForManagementPart: false,
        payByProviderForManagementPart: false,
        managementFeeMonthly: "",
        parkingFeeMonthly: "",
        additionalReqForManagementPart: "",
        payByRenterForWaterFee: false,
        payByProviderForWaterFee: false,
        additionalReqForWaterFeePart: "",
        payByRenterForEletricFee: false,
        payByProviderForEletricFee: false,
        additionalReqForEletricFeePart: "",
        payByRenterForGasFee: false,
        payByProviderForGasFee: false,
        additionalReqForGasFeePart: "",
        additionalReqForOtherPart: "",
        contractSigurtureProxyFee: "",
        payByRenterForProxyFee: false,
        payByProviderForProxyFee: false,
        separateForBothForProxyFee: false,
        contractIdentitificationFee: "",
        payByRenterForIDFFee: false,
        payByProviderForIDFFee: false,
        separateForBothForIDFFee: false,
        contractIdentitificationProxyFee: "",
        payByRenterForIDFProxyFee: false,
        payByProviderForIDFProxyFee: false,
        separateForBothForIDFProxyFee: false,
        subLeaseAgreement: false,
        doCourtIDF: false,
        courtIDFDoc: false,
        providerName: "",
        providerID: "",
        providerResidenceAddress: "",
        providerMailingAddress: "",
        providerPhoneNumber: "",
        providerPhoneChargeName: "",
        providerPhoneChargeID: "",
        providerPhoneChargeEmailAddress: "",
        renterName: "",
        renterID: "",
        renterResidenceAddress: "",
        renterMailingAddress: "",
        renterPhoneNumber: "",
        renterEmailAddress: "",
        sigurtureDate: Date()
    )
    static func roomCreate(zipCode: String, city: String, town: String, address: String, rentalPrice: String) -> HouseContract {
        return HouseContract(
            contractBuildDate: Date(),
            contractReviewDays: "",
            providerSignurture: "",
            renterSignurture: "",
            companyTitle: "",
            roomAddress: address,
            roomTown: town,
            roomCity: city,
            roomZipCode: zipCode,
            specificBuildingNumber: "",
            specificBuildingRightRange: "",
            specificBuildingArea: "",
            mainBuildArea: "",
            mainBuildingPurpose: "",
            subBuildingPurpose: "",
            subBuildingArea: "",
            publicBuildingNumber: "",
            publicBuildingRightRange: "",
            publicBuildingArea: "",
            hasParkinglot: false,
            isSettingTheRightForThirdPerson: false,
            settingTheRightForThirdPersonForWhatKind: "",
            isBlockByBank: false,
            provideForAll: false,
            provideForPart: false,
            provideFloor: "",
            provideRooms: "",
            provideRoomNumber: "",
            provideRoomArea: "",
            isVehicle: false,
            isMorto: false,
            parkingUGFloor: "",
            parkingStyleN: false,
            parkingStyleM: false,
            parkingNumberForVehicle: "",
            parkingNumberForMortor: "",
            forAllday: false,
            forMorning: false,
            forNight: false,
            havingSubFacility: false,
            rentalStartDate: Date(),
            rentalEndDate: Date(),
            roomRentalPrice: rentalPrice,
            paymentdays: "",
            paybyCash: false,
            paybyTransmission: false,
            paybyCreditDebitCard: false,
            bankName: "",
            bankOwnerName: "",
            bankAccount: "",
            payByRenterForManagementPart: false,
            payByProviderForManagementPart: false,
            managementFeeMonthly: "",
            parkingFeeMonthly: "",
            additionalReqForManagementPart: "",
            payByRenterForWaterFee: false,
            payByProviderForWaterFee: false,
            additionalReqForWaterFeePart: "",
            payByRenterForEletricFee: false,
            payByProviderForEletricFee: false,
            additionalReqForEletricFeePart: "",
            payByRenterForGasFee: false,
            payByProviderForGasFee: false,
            additionalReqForGasFeePart: "",
            additionalReqForOtherPart: "",
            contractSigurtureProxyFee: "",
            payByRenterForProxyFee: false,
            payByProviderForProxyFee: false,
            separateForBothForProxyFee: false,
            contractIdentitificationFee: "",
            payByRenterForIDFFee: false,
            payByProviderForIDFFee: false,
            separateForBothForIDFFee: false,
            contractIdentitificationProxyFee: "",
            payByRenterForIDFProxyFee: false,
            payByProviderForIDFProxyFee: false,
            separateForBothForIDFProxyFee: false,
            subLeaseAgreement: false,
            doCourtIDF: false,
            courtIDFDoc: false,
            providerName: "",
            providerID: "",
            providerResidenceAddress: "",
            providerMailingAddress: "",
            providerPhoneNumber: "",
            providerPhoneChargeName: "",
            providerPhoneChargeID: "",
            providerPhoneChargeEmailAddress: "",
            renterName: "",
            renterID: "",
            renterResidenceAddress: "",
            renterMailingAddress: "",
            renterPhoneNumber: "",
            renterEmailAddress: "",
            sigurtureDate: Date()
        )
    }
}

struct RoomCommentRatting: Identifiable, Codable {
    @DocumentID var id: String?
    var roomUID: String
    var providerUID: String
    var comment: String
    var convenienceRate: Int
    var pricingRate: Int
    var neighborRate: Int
    var userDisplayName: String
    var isPost: Bool
    @ServerTimestamp var postTimestamp: Timestamp?
}

extension RoomCommentRatting {
    static let empty = RoomCommentRatting(
        roomUID: "",
        providerUID: "",
        comment: "",
        convenienceRate: 0,
        pricingRate: 0,
        neighborRate: 0,
        userDisplayName: "",
        isPost: false
    )

    static func postCAR(
        roomUID: String,
        providerUID: String,
        user nickeName: String,
        room commentRatting: RoomCommentRatting
    ) -> RoomCommentRatting {
        return RoomCommentRatting(
            roomUID: roomUID,
            providerUID: providerUID,
            comment: commentRatting.comment,
            convenienceRate: commentRatting.convenienceRate,
            pricingRate: commentRatting.pricingRate,
            neighborRate: commentRatting.neighborRate,
            userDisplayName: nickeName,
            isPost: true
        )
    }
}
