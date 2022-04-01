//
//  RoomsDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift


struct RentersContractDataModel: Codable {
    
    var isSummitContract: Bool
    
    //MARK: Contract's Data Model
    var contractBuildDate: Date
    var contractReviewDays:String
    
    var providerSignurture: String
    var renterSignurture: String
    
    var companyTitle: String
    var roomAddress: String
    var roomTown: String
    var roomCity: String
    var roomZipCode: String
    
    // MARK: 第一條 委託管理標的 - 房屋標示
    var specificBuildingNumber: String //專有部分建號
    var specificBuildingRightRange: String //專有部分權利範圍
    var specificBuildingArea: String //專有部分面積共計
    
    var mainBuildArea: String //主建物面積__層__平方公尺
    var mainBuildingPurpose: String //主建物用途
    
    var subBuildingPurpose: String //附屬建物用途
    var subBuildingArea: String //附屬建物面積__平方公尺
    
    var publicBuildingNumber: String //共有部分建號
    var publicBuildingRightRange: String //共有部分權利範圍
    var publicBuildingArea: String //共有部分持分面積__平方公尺
    
    var hasParkinglotYes: Bool //車位-有
    var hasParkinglotNo: Bool //車位-無
    var parkinglotAmount: String //汽機車車位數量
    
    var isSettingTheRightForThirdPersonYes: Bool //設定他項權利-有
    var isSettingTheRightForThirdPersonNo: Bool //設定他項權利-無
    var SettingTheRightForThirdPersonForWhatKind: String //權利種類
    
    var isBlockByBankYes: Bool //查封登記-有
    var isBlockByBankNo: Bool //查封登記-無
    
    // MARK: 第一條 委託管理標的 - 租賃範圍
    var provideForAll: Bool //租賃住宅全部
    var provideForPart: Bool //租賃住宅部分
    var provideFloor: String //租賃住宅第__層
    var provideRooms: String //租賃住宅房間__間
    var provideRoomNumber: String //租賃住宅第__室
    var provideRoomArea: String //租賃住宅面積__平方公尺
    
    var isVehicle: Bool //汽車停車位
    var isMorto: Bool //機車停車位
    var isBoth: Bool //汽車機車皆有
    var parkingUGFloor: String //地上(下)第__層
    var parkingStyleN: Bool //平面式停車位ㄩ
    var parkingStyleM: Bool //機械式停車位
    var parkingNumber: String //編號第__號
    var forAllday: Bool //使用時間全日
    var forMorning: Bool //使用時間日間
    var forNight: Bool //使用時間夜間
    
    var havingSubFacilityYes: Bool //租賃附屬設備-有
    var havingSubFacilityNo: Bool //租賃附屬設備-無
    
    // MARK: 第二條 租賃期間
    var rentalStartDate: Date //委託管理期間自
    var rentalEndDate: Date //委託管理期間至
    
    // MARK: 第三條 租金約定及支付
    var paymentdays: String //每月__日前支付
    var paybyCash: Bool //報酬約定及給付-現金繳付
    var paybyTransmission: Bool //報酬約定及給付-轉帳繳付
    var paybyCreditDebitCard: Bool //報酬約定及給付-信用卡/簽帳卡
    var bankName: String //金融機構
    var bankOwnerName: String //戶名
    var bankAccount: String //帳號
    
    // MARK: 第五條 租賃期間相關費用之支付
    var payByRenterForManagementPart: Bool //承租人負擔
    var payByProviderForManagementPart: Bool //出租人負擔
    var managementFeeMonthly: String //房屋每月___元整
    var parkingFeeMonthly: String //停車位每月___元整
    var additionalReqForManagementPart: String
    
    var payByRenterForWaterFee: Bool //承租人負擔
    var payByProviderForWaterFee: Bool //出租人負擔
    var additionalReqForWaterFeePart: String
    
    var payByRenterForEletricFee: Bool //承租人負擔
    var payByProviderForEletricFee: Bool //出租人負擔
    var additionalReqForEletricFeePart: String
    
    var payByRenterForGasFee: Bool //承租人負擔
    var payByProviderForGasFee: Bool //出租人負擔
    var additionalReqForGasFeePart: String
    
    var additionalReqForOtherPart: String //其他費用及其支付方式
    
    // MARK: 第六條 稅費負擔之約定
    var contractSigurtureProxyFee: String
    var payByRenterForProxyFee: Bool //承租人負擔
    var payByProviderForProxyFee: Bool //出租人負擔
    var separateForBothForProxyFee: Bool //雙方平均負擔
    
    var contractIdentitificationFee: String
    var payByRenterForIDFFee: Bool //承租人負擔
    var payByProviderForIDFFee: Bool //出租人負擔
    var separateForBothForIDFFee: Bool //雙方平均負擔
    
    var contractIdentitificationProxyFee: String
    var payByRenterForIDFProxyFee: Bool //承租人負擔
    var payByProviderForIDFProxyFee: Bool //出租人負擔
    var separateForBothForIDFProxyFee: Bool //雙方平均負擔
    
    // MARK: 第七條 使用房屋之限制
    var subLeaseAgreement: Bool
    
    // MARK: 第十二條 房屋之返還
    var contractSendbyEmail: Bool //履行本契約之通知-電子郵件信箱
    var contractSendbyTextingMessage: Bool //履行本契約之通知-手機簡訊
    var contractSendbyMessageSoftware: Bool //履行本契約之通知-即時通訊軟體
    
    // MARK: 第十九條 其他約定
    var doCourtIDF: Bool //□辦理公證□不辦理公證
    var courtIDFDoc: Bool //□不同意；□同意公證書
    
    
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
    
    //End
    var sigurtureDate: Date
}

struct RoomImageCovers: Codable {
    var roomImagURL: String
}

struct RoomInfoDataModel: Identifiable, Codable {
    @DocumentID var docID: String?
    var id = UUID().uuidString
    var roomUID: String
    var holderName: String
    var mobileNumber: String
    var roomAddress: String
    var town: String
    var city: String
    var zipCode: String
    var roomArea: String
    var rentalPrice: String
    var someoneDeadInRoom: String
    var waterLeakingProblem: String
    var roomImage: String?
    var isRented: Bool?
    var rentedBy: String?
    var providedBy: String
    var providerDisplayName: String
    var providerChatDocId: String
    var rentersContractData: RentersContractDataModel?
    
    
    
}



/*
 //: At below these fields are for house owner
 //:~ Paragrah1
 var specificBuildingNumber: String? //專有部分建號
 var specificBuildingRightRange: String? //專有部分權利範圍
 var specificBuildingArea: String? //專有部分面積共計
 
 var mainBuildArea: String? //主建物面積__層__平方公尺
 var mainBuildingPurpose: String? //主建物用途
 
 var subBuildingPurpose: String? //附屬建物用途
 var subBuildingArea: String? //附屬建物面積__平方公尺
 
 var publicBuildingNumber: String? //共有部分建號
 var publicBuildingRightRange: String? //共有部分權利範圍
 var publicBuildingArea: String? //共有部分持分面積__平方公尺
 
 var hasParkinglot: Bool? //車位有無
 var parkinglotAmount: String? //汽機車車位數量
 
 var isSettingTheRightForThirdPerson: Bool? //有無設定他項權利
 
 var SettingTheRightForThirdPersonForWhatKind: String? //權利種類
 var isBlockByBank: Bool? //有無查封登記
 
 var provideForAll: Bool? //租賃住宅全部
 var provideForPart: Bool? //租賃住宅部分
 var provideFloor: String? //租賃住宅第__層
 var provideRooms: String? //租賃住宅房間__間
 var provideRoomNumber: String? //租賃住宅第__室
 var provideRoomArea: String? //租賃住宅面積__平方公尺
 
 var isVehicle: Bool? //汽車停車位
 var isMorto: Bool? //機車停車位
 var parkingUGFloor: String? //地上(下)第__層
 var parkingStyleN: Bool? //平面式停車位
 var parkingStyleM: Bool? //機械式停車位
 var parkingNumber: String? //編號第__號
 var forAllday: Bool? //使用時間全日
 var forMorning: Bool? //使用時間日間
 var forNight: Bool? //使用時間夜間
 
 var havingSubFacility: Bool? //租賃附屬設備有無
 
 //:~ paragraph 2
 var providingTimeRangeStart: String? //委託管理期間自
 var providingTimeRangeEnd: String? //委託管理期間至
 
 //:~ paragraph3
 var paybyCash: Bool? //報酬約定及給付-現金繳付
 var paybyTransmission: Bool? //報酬約定及給付-轉帳繳付
 var bankName: String? //金融機構
 var bankOwnerName: String? //戶名
 var bankAccount: String? //帳號
 
 //:~ paragraph12
 var contractSendbyEmail: Bool? //履行本契約之通知-電子郵件信箱
 var contractSendbyTextingMessage: Bool? //履行本契約之通知-手機簡訊
 var contractSendbyMessageSoftware: Bool? //履行本契約之通知-即時通訊軟體
 
 //:~ ProviderInfo
 var providerName: String?
 var providerID: String?
 var providerResidenceAddress: String?
 var providerMailingAddress: String?
 var providerEmaillAddress: String?
 
 //:~ ComapnyInfo
 var companyName: String?
 var compnayCharger: String?
 var companyID: String?
 var companyRegisID: String? //登記證字號
 var companyMailingAddress: String?
 var companytellNumber: String?
 var companyEmaillAddress: String?
 
 //:~RentalMagagerInfo
 var rmName: String?
 var rmLicenseID: String?
 var rmMailingAddress: String?
 var rmTellNumber: String?
 var rmEmailAddress: String?
*/
