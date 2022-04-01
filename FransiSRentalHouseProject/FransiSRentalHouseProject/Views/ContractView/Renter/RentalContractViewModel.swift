//
//  RentalContractViewModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/1.
//

import Foundation

class RentalContractViewModel: ObservableObject {
    
    @Published var contractBuildDate = Date()
    @Published var contractReviewDays = 3
    
    @Published var providerSignurture = ""
    @Published var renterSignurture = ""
    
    @Published var companyTitle = ""
    @Published var roomAddress = ""
    @Published var roomTown = ""
    @Published var roomCity = ""
    @Published var roomZipCode = ""
    
    // MARK: 第一條 委託管理標的 - 房屋標示
    @Published var specificBuildingNumber = "" //專有部分建號
    @Published var specificBuildingRightRange = "" //專有部分權利範圍
    @Published var specificBuildingArea = "" //專有部分面積共計
    
    @Published var mainBuildArea = "" //主建物面積__層__平方公尺
    @Published var mainBuildingPurpose = "" //主建物用途
    
    @Published var subBuildingPurpose = "" //附屬建物用途
    @Published var subBuildingArea = "" //附屬建物面積__平方公尺
    
    @Published var publicBuildingNumber = "" //共有部分建號
    @Published var publicBuildingRightRange = "" //共有部分權利範圍
    @Published var publicBuildingArea = "" //共有部分持分面積__平方公尺
    
    @Published var hasParkinglotYes = false //車位-有
    @Published var hasParkinglotNo = false //車位-無
    @Published var parkinglotAmount = "" //汽機車車位數量
    
    @Published var isSettingTheRightForThirdPersonYes = false //設定他項權利-有
    @Published var isSettingTheRightForThirdPersonNo = false //設定他項權利-無
    @Published var SettingTheRightForThirdPersonForWhatKind = "" //權利種類
    
    @Published var isBlockByBankYes = false //查封登記-有
    @Published var isBlockByBankNo = false //查封登記-無
    
    // MARK: 第一條 委託管理標的 - 租賃範圍
    @Published var provideForAll = false //租賃住宅全部
    @Published var provideForPart = false //租賃住宅部分
    @Published var provideFloor = "" //租賃住宅第__層
    @Published var provideRooms = "" //租賃住宅房間__間
    @Published var provideRoomNumber = "" //租賃住宅第__室
    @Published var provideRoomArea = "" //租賃住宅面積__平方公尺
    
    @Published var isVehicle = false //汽車停車位
    @Published var isMorto = false //機車停車位
    @Published var isBoth = false //汽車機車皆有
    @Published var parkingUGFloor = "" //地上(下)第__層
    @Published var parkingStyleN = false //平面式停車位ㄩ
    @Published var parkingStyleM = false //機械式停車位
    @Published var parkingNumber = "" //編號第__號
    @Published var forAllday = false //使用時間全日
    @Published var forMorning = false //使用時間日間
    @Published var forNight = false //使用時間夜間
    
    @Published var havingSubFacilityYes = false //租賃附屬設備-有
    @Published var havingSubFacilityNo = false //租賃附屬設備-無
    
    // MARK: 第二條 租賃期間
    @Published var rentalStartDate = Date() //委託管理期間自
    @Published var rentalEndDate = Date() //委託管理期間至
    
    // MARK: 第三條 租金約定及支付
    @Published var paymentdays = "" //每月__日前支付
    @Published var paybyCash = false //報酬約定及給付-現金繳付
    @Published var paybyTransmission = false //報酬約定及給付-轉帳繳付
    @Published var paybyCreditDebitCard = false //報酬約定及給付-信用卡/簽帳卡
    @Published var bankName = "" //金融機構
    @Published var bankOwnerName = "" //戶名
    @Published var bankAccount = "" //帳號
    
    // MARK: 第五條 租賃期間相關費用之支付
    @Published var payByRenterForManagementPart = false //承租人負擔
    @Published var payByProviderForManagementPart = false //出租人負擔
    @Published var managementFeeMonthly = "" //房屋每月___元整
    @Published var parkingFeeMonthly = "" //停車位每月___元整
    @Published var additionalReqForManagementPart = ""
    
    @Published var payByRenterForWaterFee = false //承租人負擔
    @Published var payByProviderForWaterFee = false //出租人負擔
    @Published var additionalReqForWaterFeePart = ""
    
    @Published var payByRenterForEletricFee = false //承租人負擔
    @Published var payByProviderForEletricFee = false //出租人負擔
    @Published var additionalReqForEletricFeePart = ""
    
    @Published var payByRenterForGasFee = false //承租人負擔
    @Published var payByProviderForGasFee = false //出租人負擔
    @Published var additionalReqForGasFeePart = ""
    
    @Published var additionalReqForOtherPart = "" //其他費用及其支付方式
    
    // MARK: 第六條 稅費負擔之約定
    @Published var contractSigurtureProxyFee = ""
    @Published var payByRenterForProxyFee = false //承租人負擔
    @Published var payByProviderForProxyFee = false //出租人負擔
    @Published var separateForBothForProxyFee = false //雙方平均負擔
    
    @Published var contractIdentitificationFee = ""
    @Published var payByRenterForIDFFee = false //承租人負擔
    @Published var payByProviderForIDFFee = false //出租人負擔
    @Published var separateForBothForIDFFee = false //雙方平均負擔
    
    @Published var contractIdentitificationProxyFee = ""
    @Published var payByRenterForIDFProxyFee = false //承租人負擔
    @Published var payByProviderForIDFProxyFee = false //出租人負擔
    @Published var separateForBothForIDFProxyFee = false //雙方平均負擔
    
    // MARK: 第七條 使用房屋之限制
    @Published var subLeaseAgreement = false
    
    // MARK: 第十二條 房屋之返還
    @Published var contractSendbyEmail = false //履行本契約之通知-電子郵件信箱
    @Published var contractSendbyTextingMessage = false //履行本契約之通知-手機簡訊
    @Published var contractSendbyMessageSoftware = false //履行本契約之通知-即時通訊軟體
    
    // MARK: 第十九條 其他約定
    @Published var doCourtIDF = false //□辦理公證□不辦理公證
    @Published var courtIDFDoc = false //□不同意；□同意公證書
    
    
    // MARK: 立契約書人
    @Published var providerName = ""
    @Published var providerID = ""
    @Published var providerResidenceAddress = ""
    @Published var providerMailingAddress = ""
    @Published var providerPhoneNumber = ""
    @Published var providerPhoneChargeName = ""
    @Published var providerPhoneChargeID = ""
    @Published var providerPhoneChargeEmailAddress = ""
    
    @Published var renterName = ""
    @Published var renterID = ""
    @Published var renterResidenceAddress = ""
    @Published var renterMailingAddress = ""
    @Published var renterPhoneNumber = ""
    @Published var renterEmailAddress = ""
    
    //End
    @Published var sigurtureDate = Date()
}
