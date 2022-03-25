//
//  RoomsDataModel.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift


struct RoomImageCovers: Codable {
    var roomImagURL: String
}

struct RoomInfoDataModel: Identifiable, Codable {
    @DocumentID var docID: String?
    var id = UUID().uuidString
    var roomUID: String?
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
    
}

extension RoomInfoDataModel {
    static let empty = RoomInfoDataModel(roomUID: "",
                                         holderName: "",
                                         mobileNumber: "",
                                         roomAddress: "",
                                         town: "",
                                         city: "",
                                         zipCode: "",
                                         roomArea: "",
                                         rentalPrice: "",
                                         someoneDeadInRoom: "",
                                         waterLeakingProblem: "",
                                         roomImage: nil,
                                         isRented: false,
                                         rentedBy: "",
                                         providedBy: "",
                                         providerDisplayName: "",
                                         providerChatDocId: "",
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
                                         parkinglotAmount: "",
                                         SettingTheRightForThirdPersonForWhatKind: "",
                                         provideFloor: "",
                                         provideRooms: "",
                                         provideRoomNumber: "",
                                         provideRoomArea: "",
                                         parkingUGFloor: "",
                                         parkingNumber: "",
                                         providingTimeRangeStart: "",
                                         providingTimeRangeEnd: "",
                                         bankName: "",
                                         bankOwnerName: "",
                                         bankAccount: "")
}


/*
 struct RoomsDataModel: Identifiable, Codable {
     var id = UUID()
     var roomImage: String
     var roomName: String
     var roomDescribtion: String
     var roomPrice: Int
     var ranking: Int
     var isSelected: Bool
     
     enum CodingKeys: String, CodingKey {
         case id
         case roomImage
         case roomName
         case roomDescribtion
         case roomPrice
         case ranking
         case isSelected
     }
     
 }
*/
