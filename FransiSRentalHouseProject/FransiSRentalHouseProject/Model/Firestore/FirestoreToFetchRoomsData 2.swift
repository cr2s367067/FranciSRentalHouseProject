//
//  FirestoreToFetchRoomsData.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


class FirestoreToFetchRoomsData: ObservableObject {
    
    let firebaseAuth = FirebaseAuth()
    
    let db = Firestore.firestore()
    
    @Published var fetchRoomInfoFormOwner = [RoomInfoDataModel]()
    @Published var fetchRoomInfoFormPublic = [RoomInfoDataModel]()
    @Published var fetchRoomImages = [RoomImageDataModel]()
    @Published var roomID = ""
    @Published var receivePaymentDataSet = [PaymentHistoryDataModel]()
    @Published var roomCAR: RoomCommentAndRattingDataModel = .empty
    @Published var roomCARDataSet = [RoomCommentAndRattingDataModel]()
    
    func roomIdGenerator() -> String {
        let roomId = UUID().uuidString
        roomID = roomId
        return roomID
    }
    
}

extension FirestoreToFetchRoomsData {
    func summitRoomInfoAsync(docID: String, isPublished: Bool = false, uidPath: String, roomUID: String = "", holderName: String, mobileNumber: String, roomAddress: String, town: String, city: String, zipCode: String, roomArea: String, rentalPrice: String, someoneDeadInRoom: String, waterLeakingProblem: String, roomImageURL: String, isRented: Bool = false, rentedBy: String = "", providerDisplayName: String, providerChatDocId: String, roomDescription: String) async throws {
        let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID)
        _ = try await roomOwerRef.setData([
            "roomUID" : roomUID,
            "isPublished" : isPublished,
            "holderName" : holderName,
            "mobileNumber" : mobileNumber,
            "roomAddress" : roomAddress,
            "town" : town,
            "city" : city,
            "zipCode" : zipCode,
            "roomArea" : roomArea,
            "rentalPrice" : rentalPrice,
            "someoneDeadInRoom" : someoneDeadInRoom,
            "waterLeakingProblem" : waterLeakingProblem,
            "roomImage" : roomImageURL,
            "isRented" : isRented,
            "rentedBy" : rentedBy,
            "providedBy": uidPath,
            "providerDisplayName" : providerDisplayName,
            "roomDescription" : roomDescription,
            "providerChatDocId" : providerChatDocId,
            "rentersContractData" : [
                
                "docID" : docID,
                
                "isSummitContract" : false,
                
                //MARK: Contract's Data Model
                "contractBuildDate" : Date(),
                "contractReviewDays" : "",
                "providerSignurture" : "",
                "renterSignurture" : "",
                "companyTitle" : "",
                "roomAddress" : roomAddress,
                "roomTown" : town,
                "roomCity" : city,
                "roomZipCode" : zipCode,
                
                // MARK: 第一條 委託管理標的 - 房屋標示
                "specificBuildingNumber" : "", //專有部分建號
                "specificBuildingRightRange" : "", //專有部分權利範圍
                "specificBuildingArea" : "", //專有部分面積共計
                
                "mainBuildArea" : "", //主建物面積__層__平方公尺
                "mainBuildingPurpose" : "", //主建物用途
                
                "subBuildingPurpose" : "", //附屬建物用途
                "subBuildingArea" : "", //附屬建物面積__平方公尺
                
                "publicBuildingNumber" : "", //共有部分建號
                "publicBuildingRightRange" : "", //共有部分權利範圍
                "publicBuildingArea" : "", //共有部分持分面積__平方公尺
                
                "hasParkinglot" : false, //車位-有無
                
                "isSettingTheRightForThirdPerson" : false, //設定他項權利-有無
                "settingTheRightForThirdPersonForWhatKind" : "", //權利種類
                
                "isBlockByBank" : false, //查封登記-有無
                
                // MARK: 第一條 委託管理標的 - 租賃範圍
                "provideForAll": false, //租賃住宅全部
                "provideForPart": false, //租賃住宅部分
                "provideFloor": "", //租賃住宅第__層
                "provideRooms": "", //租賃住宅房間__間
                "provideRoomNumber": "", //租賃住宅第__室
                "provideRoomArea": "", //租賃住宅面積__平方公尺
                
                "isVehicle": false, //汽車停車位
                "isMorto": false, //機車停車位
                "parkingUGFloor": "", //地上(下)第__層
                "parkingStyleN": false, //平面式停車位
                "parkingStyleM": false, //機械式停車位
                "parkingNumberForVehicle": "", //編號第__號
                "parkingNumberForMortor": "",
                "forAllday": false, //使用時間全日
                "forMorning": false, //使用時間日間
                "forNight": false, //使用時間夜間
                
                "havingSubFacility": false, //租賃附屬設備-有無
                
                // MARK: 第二條 租賃期間
                "rentalStartDate" : Date(), //委託管理期間自
                "rentalEndDate" : Date(), //委託管理期間至
                
                // MARK: 第三條 租金約定及支付
                "roomRentalPrice" : rentalPrice,
                "paymentdays": "", //每月__日前支付
                "paybyCash": false, //報酬約定及給付-現金繳付
                "paybyTransmission": false, //報酬約定及給付-轉帳繳付
                "paybyCreditDebitCard": false, //報酬約定及給付-信用卡/簽帳卡
                "bankName": "", //金融機構
                "bankOwnerName": "", //戶名
                "bankAccount": "", //帳號
                
                // MARK: 第五條 租賃期間相關費用之支付
                "payByRenterForManagementPart" : false, //承租人負擔
                "payByProviderForManagementPart" : false, //出租人負擔
                "managementFeeMonthly" : "", //房屋每月___元整
                "parkingFeeMonthly" : "", //停車位每月___元整
                "additionalReqForManagementPart" : "",
                
                "payByRenterForWaterFee" : false, //承租人負擔
                "payByProviderForWaterFee" : false, //出租人負擔
                "additionalReqForWaterFeePart" : "",
                
                "payByRenterForEletricFee" : false, //承租人負擔
                "payByProviderForEletricFee" : false, //出租人負擔
                "additionalReqForEletricFeePart" : "",
                
                "payByRenterForGasFee" : false, //承租人負擔
                "payByProviderForGasFee" : false, //出租人負擔
                "additionalReqForGasFeePart" : "",
                
                "additionalReqForOtherPart" : "", //其他費用及其支付方式
                
                // MARK: 第六條 稅費負擔之約定
                "contractSigurtureProxyFee" : "",
                "payByRenterForProxyFee" : false, //承租人負擔
                "payByProviderForProxyFee" : false, //出租人負擔
                "separateForBothForProxyFee" : false, //雙方平均負擔
                
                "contractIdentitificationFee" : "",
                "payByRenterForIDFFee" : false, //承租人負擔
                "payByProviderForIDFFee" : false, //出租人負擔
                "separateForBothForIDFFee" : false, //雙方平均負擔
                
                "contractIdentitificationProxyFee" : "" ,
                "payByRenterForIDFProxyFee" : false, //承租人負擔
                "payByProviderForIDFProxyFee" : false, //出租人負擔
                "separateForBothForIDFProxyFee" : false, //雙方平均負擔
                
                // MARK: 第七條 使用房屋之限制
                "subLeaseAgreement" : false,
                
                // MARK: 第十二條 房屋之返還
//                "contractSendbyEmail" : false, //履行本契約之通知-電子郵件信箱
//                "contractSendbyTextingMessage" : false, //履行本契約之通知-手機簡訊
//                "contractSendbyMessageSoftware" : false, //履行本契約之通知-即時通訊軟體
                
                // MARK: 第十九條 其他約定
                "doCourtIDF" : false, //□辦理公證□不辦理公證
                "courtIDFDoc" : false, //□不同意；□同意公證書
                
                
                // MARK: 立契約書人
                "providerName" : "",
                "providerID" : "",
                "providerResidenceAddress" : "",
                "providerMailingAddress" : "",
                "providerPhoneNumber" : "",
                "providerPhoneChargeName" : "",
                "providerPhoneChargeID" : "",
                "providerPhoneChargeEmailAddress" : "",
                
                "renterName" : "",
                "renterID" : "",
                "renterResidenceAddress" : "",
                "renterMailingAddress" : "",
                "renterPhoneNumber" : "",
                "renterEmailAddress" : "",
                
                //End
                "sigurtureDate" : Date()
            ]
        ])
        
    }
}

extension FirestoreToFetchRoomsData {
    func deleteRentedRoom(docID: String) async throws {
        let roomPublicRef = db.collection("RoomsForPublic")
        try await roomPublicRef.document(docID).delete()
    }
    
    func updateRentedRoom(uidPath: String, docID: String, renterID: String) async throws {
        let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID)
        try await roomOwerRef.updateData([
            "isRented" : true,
            "rentedBy" : renterID
        ])
    }
    
    func updateContractData(uidPath: String,
                            docID: String,
                            isSummitContract: Bool,
                            contractBuildDate: Date,
                            contractReviewDays: String,
                            providerSignurture: String,
                            renterSignurture: String,
                            companyTitle: String,
                            roomAddress: String,
                            roomTown: String,
                            roomCity: String,
                            roomZipCode: String,
                            specificBuildingNumber: String,
                            specificBuildingRightRange: String,
                            specificBuildingArea: String,
                            mainBuildArea: String,
                            mainBuildingPurpose: String,
                            subBuildingPurpose: String,
                            subBuildingArea: String,
                            publicBuildingNumber: String,
                            publicBuildingRightRange: String,
                            publicBuildingArea: String,
                            hasParkinglot: Bool,
                            isSettingTheRightForThirdPerson: Bool,
                            settingTheRightForThirdPersonForWhatKind: String,
                            isBlockByBank: Bool,
                            provideForAll: Bool,
                            provideForPart: Bool,
                            provideFloor: String,
                            provideRooms: String,
                            provideRoomNumber: String,
                            provideRoomArea: String,
                            isVehicle: Bool,
                            isMorto: Bool,
                            parkingUGFloor: String,
                            parkingStyleN: Bool,
                            parkingStyleM: Bool,
                            parkingNumberForVehicle: String,
                            parkingNumberForMortor: String,
                            forAllday: Bool,
                            forMorning: Bool,
                            forNight: Bool,
                            havingSubFacility: Bool,
                            rentalStartDate: Date,
                            rentalEndDate: Date,
                            roomRentalPrice: String,
                            paymentdays: String,
                            paybyCash: Bool,
                            paybyTransmission: Bool,
                            paybyCreditDebitCard: Bool,
                            bankName: String,
                            bankOwnerName: String,
                            bankAccount: String,
                            payByRenterForManagementPart: Bool,
                            payByProviderForManagementPart: Bool,
                            managementFeeMonthly: String,
                            parkingFeeMonthly: String,
                            additionalReqForManagementPart: String,
                            payByRenterForWaterFee: Bool,
                            payByProviderForWaterFee: Bool,
                            additionalReqForWaterFeePart: String,
                            payByRenterForEletricFee: Bool,
                            payByProviderForEletricFee: Bool,
                            additionalReqForEletricFeePart: String,
                            payByRenterForGasFee: Bool,
                            payByProviderForGasFee: Bool,
                            additionalReqForGasFeePart: String,
                            additionalReqForOtherPart: String,
                            contractSigurtureProxyFee: String,
                            payByRenterForProxyFee: Bool,
                            payByProviderForProxyFee: Bool,
                            separateForBothForProxyFee: Bool,
                            contractIdentitificationFee: String,
                            payByRenterForIDFFee: Bool,
                            payByProviderForIDFFee: Bool,
                            separateForBothForIDFFee: Bool,
                            contractIdentitificationProxyFee: String,
                            payByRenterForIDFProxyFee: Bool,
                            payByProviderForIDFProxyFee: Bool,
                            separateForBothForIDFProxyFee: Bool,
                            subLeaseAgreement: Bool,
                            doCourtIDF: Bool,
                            courtIDFDoc: Bool,
                            providerName: String,
                            providerID: String,
                            providerResidenceAddress: String,
                            providerMailingAddress: String,
                            providerPhoneNumber: String,
                            providerPhoneChargeName: String,
                            providerPhoneChargeID: String,
                            providerPhoneChargeEmailAddress: String) async throws {
        let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID)
        try await roomOwerRef.updateData([
            "rentersContractData.isSummitContract" : isSummitContract,
            
            //MARK: Contract's Data Model
            "rentersContractData.contractBuildDate" : contractBuildDate,
            "rentersContractData.contractReviewDays" : contractReviewDays,
            "rentersContractData.providerSignurture" : providerSignurture,
            "rentersContractData.renterSignurture" : renterSignurture,
            "rentersContractData.companyTitle" : companyTitle,
            "rentersContractData.roomAddress" : roomAddress,
            "rentersContractData.roomTown" : roomTown,
            "rentersContractData.roomCity" : roomCity,
            "rentersContractData.roomZipCode" : roomZipCode,
            
            // MARK: 第一條 委託管理標的 - 房屋標示
            "rentersContractData.specificBuildingNumber" : specificBuildingNumber, //專有部分建號
            "rentersContractData.specificBuildingRightRange" : specificBuildingRightRange, //專有部分權利範圍
            "rentersContractData.specificBuildingArea" : specificBuildingArea, //專有部分面積共計
            
            "rentersContractData.mainBuildArea" : mainBuildArea, //主建物面積__層__平方公尺
            "rentersContractData.mainBuildingPurpose" : mainBuildingPurpose, //主建物用途
            
            "rentersContractData.subBuildingPurpose" : subBuildingPurpose, //附屬建物用途
            "rentersContractData.subBuildingArea" : subBuildingArea, //附屬建物面積__平方公尺
            
            "rentersContractData.publicBuildingNumber" : publicBuildingNumber, //共有部分建號
            "rentersContractData.publicBuildingRightRange" : publicBuildingRightRange, //共有部分權利範圍
            "rentersContractData.publicBuildingArea" : publicBuildingArea, //共有部分持分面積__平方公尺
            
            "rentersContractData.hasParkinglot" : hasParkinglot, //車位-有無
            
            "rentersContractData.isSettingTheRightForThirdPerson" : isSettingTheRightForThirdPerson, //設定他項權利-有無
            "rentersContractData.settingTheRightForThirdPersonForWhatKind" : settingTheRightForThirdPersonForWhatKind, //權利種類
            
            "rentersContractData.isBlockByBank" : isBlockByBank, //查封登記-有無
            
            // MARK: 第一條 委託管理標的 - 租賃範圍
            "rentersContractData.provideForAll": provideForAll, //租賃住宅全部
            "rentersContractData.provideForPart": provideForPart, //租賃住宅部分
            "rentersContractData.provideFloor": provideFloor, //租賃住宅第__層
            "rentersContractData.provideRooms": provideRooms, //租賃住宅房間__間
            "rentersContractData.provideRoomNumber": provideRoomNumber, //租賃住宅第__室
            "rentersContractData.provideRoomArea": provideRoomArea, //租賃住宅面積__平方公尺
            
            "rentersContractData.isVehicle": isVehicle, //汽車停車位
            "rentersContractData.isMorto": isMorto, //機車停車位
            "rentersContractData.parkingUGFloor": parkingUGFloor, //地上(下)第__層
            "rentersContractData.parkingStyleN": parkingStyleN, //平面式停車位
            "rentersContractData.parkingStyleM": parkingStyleM, //機械式停車位
            "rentersContractData.parkingNumberForVehicle": parkingNumberForVehicle, //編號第__號
            "rentersContractData.parkingNumberForMortor": parkingNumberForMortor,
            "rentersContractData.forAllday": forAllday, //使用時間全日
            "rentersContractData.forMorning": forMorning, //使用時間日間
            "rentersContractData.forNight": forNight, //使用時間夜間
            
            "rentersContractData.havingSubFacility": havingSubFacility, //租賃附屬設備-有無
            
            // MARK: 第二條 租賃期間
            "rentersContractData.rentalStartDate" : rentalStartDate, //委託管理期間自
            "rentersContractData.rentalEndDate" : rentalEndDate, //委託管理期間至
            
            // MARK: 第三條 租金約定及支付
            "rentersContractData.roomRentalPrice" : roomRentalPrice,
            "rentersContractData.paymentdays": paymentdays, //每月__日前支付
            "rentersContractData.paybyCash": paybyCash, //報酬約定及給付-現金繳付
            "rentersContractData.paybyTransmission": paybyTransmission, //報酬約定及給付-轉帳繳付
            "rentersContractData.paybyCreditDebitCard": paybyCreditDebitCard, //報酬約定及給付-信用卡/簽帳卡
            "rentersContractData.bankName": bankName, //金融機構
            "rentersContractData.bankOwnerName": bankOwnerName, //戶名
            "rentersContractData.bankAccount": bankAccount, //帳號
            
            // MARK: 第五條 租賃期間相關費用之支付
            "rentersContractData.payByRenterForManagementPart" : payByRenterForManagementPart, //承租人負擔
            "rentersContractData.payByProviderForManagementPart" : payByProviderForManagementPart, //出租人負擔
            "rentersContractData.managementFeeMonthly" : managementFeeMonthly, //房屋每月___元整
            "rentersContractData.parkingFeeMonthly" : parkingFeeMonthly, //停車位每月___元整
            "rentersContractData.additionalReqForManagementPart" : additionalReqForManagementPart,
            
            "rentersContractData.payByRenterForWaterFee" : payByRenterForWaterFee, //承租人負擔
            "rentersContractData.payByProviderForWaterFee" : payByProviderForWaterFee, //出租人負擔
            "rentersContractData.additionalReqForWaterFeePart" : additionalReqForWaterFeePart,
            
            "rentersContractData.payByRenterForEletricFee" : payByRenterForEletricFee, //承租人負擔
            "rentersContractData.payByProviderForEletricFee" : payByProviderForEletricFee, //出租人負擔
            "rentersContractData.additionalReqForEletricFeePart" : additionalReqForEletricFeePart,
            
            "rentersContractData.payByRenterForGasFee" : payByRenterForGasFee, //承租人負擔
            "rentersContractData.payByProviderForGasFee" : payByProviderForGasFee, //出租人負擔
            "rentersContractData.additionalReqForGasFeePart" : additionalReqForGasFeePart,
            
            "rentersContractData.additionalReqForOtherPart" : additionalReqForOtherPart, //其他費用及其支付方式
            
            // MARK: 第六條 稅費負擔之約定
            "rentersContractData.contractSigurtureProxyFee" : contractSigurtureProxyFee,
            "rentersContractData.payByRenterForProxyFee" : payByRenterForProxyFee, //承租人負擔
            "rentersContractData.payByProviderForProxyFee" : payByProviderForProxyFee, //出租人負擔
            "rentersContractData.separateForBothForProxyFee" : separateForBothForProxyFee, //雙方平均負擔
            
            "rentersContractData.contractIdentitificationFee" : contractIdentitificationFee,
            "rentersContractData.payByRenterForIDFFee" : payByRenterForIDFFee, //承租人負擔
            "rentersContractData.payByProviderForIDFFee" : payByProviderForIDFFee, //出租人負擔
            "rentersContractData.separateForBothForIDFFee" : separateForBothForIDFFee, //雙方平均負擔
            
            "rentersContractData.contractIdentitificationProxyFee" : contractIdentitificationProxyFee ,
            "rentersContractData.payByRenterForIDFProxyFee" : payByRenterForIDFProxyFee, //承租人負擔
            "rentersContractData.payByProviderForIDFProxyFee" : payByProviderForIDFProxyFee, //出租人負擔
            "rentersContractData.separateForBothForIDFProxyFee" : separateForBothForIDFProxyFee, //雙方平均負擔
            
            // MARK: 第七條 使用房屋之限制
            "rentersContractData.subLeaseAgreement" : subLeaseAgreement,
            
            // MARK: 第十二條 房屋之返還
//            "rentersContractData.contractSendbyEmail" : contractSendbyEmail, //履行本契約之通知-電子郵件信箱
//            "rentersContractData.contractSendbyTextingMessage" : contractSendbyTextingMessage, //履行本契約之通知-手機簡訊
//            "rentersContractData.contractSendbyMessageSoftware" : contractSendbyMessageSoftware, //履行本契約之通知-即時通訊軟體
            
            // MARK: 第十九條 其他約定
            "rentersContractData.doCourtIDF" : doCourtIDF, //□辦理公證□不辦理公證
            "rentersContractData.courtIDFDoc" : courtIDFDoc, //□不同意；□同意公證書
            
            
            // MARK: 立契約書人
            "rentersContractData.providerName" : providerName,
            "rentersContractData.providerID" : providerID,
            "rentersContractData.providerResidenceAddress" : providerResidenceAddress,
            "rentersContractData.providerMailingAddress" : providerMailingAddress,
            "rentersContractData.providerPhoneNumber" : providerPhoneNumber,
            "rentersContractData.providerPhoneChargeName" : providerPhoneChargeName,
            "rentersContractData.providerPhoneChargeID" : providerPhoneChargeID,
            "rentersContractData.providerPhoneChargeEmailAddress" : providerPhoneChargeEmailAddress
        ])
    }
}


extension FirestoreToFetchRoomsData {
    func listeningRoomInfoForPublicRestruct() {
        let roomPublicRef = db.collection("RoomsForPublic")
        roomPublicRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot?.documents else {
                print("Error fetch document: \(error!)")
                return
            }
            self.fetchRoomInfoFormPublic = document.compactMap({ queryDocumentSnapshot in
                let result = Result {
                    try queryDocumentSnapshot.data(as: RoomInfoDataModel.self)
                }
                switch result {
                case .success(let data):
                    return data
                case .failure(let error):
                    print("error: \(error)")
                }
                return nil
            })
        }
    }
    
    @MainActor
    func getRoomInfo(uidPath: String) async throws {
        let roomOwnerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).order(by: "rentersContractData.contractBuildDate", descending: true)
        let document = try await roomOwnerRef.getDocuments().documents
        self.fetchRoomInfoFormOwner = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: RoomInfoDataModel.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print(error.localizedDescription)
            }
            return nil
        })
    }
}

extension FirestoreToFetchRoomsData {
    @MainActor
    func fetchRoomImages(uidPath: String, docID: String) async throws {
        let roomImagesRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID)
            .collection("RoomImages")
        let document = try await roomImagesRef.getDocuments().documents
        self.fetchRoomImages = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: RoomImageDataModel.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print("error: \(error)")
            }
            return nil
        })
    }
}

extension FirestoreToFetchRoomsData {
    func summitRenter(uidPath: String,
                      docID: String,
                      renterName: String,
                      renterID: String,
                      renterResidenceAddress: String,
                      renterMailingAddress: String,
                      renterPhoneNumber: String,
                      renterEmailAddress: String,
                      sigurtureDate: Date) async throws {
        let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID)
        try await roomOwerRef.updateData([
            "rentersContractData.renterName" : renterName,
            "rentersContractData.renterID" : renterID,
            "rentersContractData.renterResidenceAddress" : renterResidenceAddress,
            "rentersContractData.renterMailingAddress" : renterMailingAddress,
            "rentersContractData.renterPhoneNumber" : renterPhoneNumber,
            "rentersContractData.renterEmailAddress" : renterEmailAddress,
            "rentersContractData.sigurtureDate" : sigurtureDate
        ])
    }
    
    func updataRentalPrice(uidPath: String, docID: String, rentalPrice: String) async throws {
        let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID)
        try await roomOwerRef.updateData([
            "rentalPrice" : rentalPrice
        ])
    }
}

extension FirestoreToFetchRoomsData {
    func roomPublish(docID: String,
                     uidPath: String,
                     isPublished: Bool,
                     roomUID: String = "",
                     holderName: String,
                     mobileNumber: String,
                     address: String,
                     town: String,
                     city: String,
                     zipCode: String,
                     roomArea: String,
                     rentalPrice: String,
                     someoneDeadInRoom: String,
                     waterLeakingProblem: String,
                     roomImageURL: String,
                     isRented: Bool = false,
                     rentedBy: String = "",
                     providerDisplayName: String,
                     providerChatDocId: String,
                     roomDescription: String,
                     isSummitContract: Bool,
                     contractBuildDate: Date,
                     contractReviewDays: String,
                     providerSignurture: String,
                     renterSignurture: String,
                     companyTitle: String,
                     roomAddress: String,
                     roomTown: String,
                     roomCity: String,
                     roomZipCode: String,
                     specificBuildingNumber: String,
                     specificBuildingRightRange: String,
                     specificBuildingArea: String,
                     mainBuildArea: String,
                     mainBuildingPurpose: String,
                     subBuildingPurpose: String,
                     subBuildingArea: String,
                     publicBuildingNumber: String,
                     publicBuildingRightRange: String,
                     publicBuildingArea: String,
                     hasParkinglot: Bool,
                     isSettingTheRightForThirdPerson: Bool,
                     settingTheRightForThirdPersonForWhatKind: String,
                     isBlockByBank: Bool,
                     provideForAll: Bool,
                     provideForPart: Bool,
                     provideFloor: String,
                     provideRooms: String,
                     provideRoomNumber: String,
                     provideRoomArea: String,
                     isVehicle: Bool,
                     isMorto: Bool,
                     parkingUGFloor: String,
                     parkingStyleN: Bool,
                     parkingStyleM: Bool,
                     parkingNumberForVehicle: String,
                     parkingNumberForMortor: String,
                     forAllday: Bool,
                     forMorning: Bool,
                     forNight: Bool,
                     havingSubFacility: Bool,
                     rentalStartDate: Date,
                     rentalEndDate: Date,
                     roomRentalPrice: String,
                     paymentdays: String,
                     paybyCash: Bool,
                     paybyTransmission: Bool,
                     paybyCreditDebitCard: Bool,
                     bankName: String,
                     bankOwnerName: String,
                     bankAccount: String,
                     payByRenterForManagementPart: Bool,
                     payByProviderForManagementPart: Bool,
                     managementFeeMonthly: String,
                     parkingFeeMonthly: String,
                     additionalReqForManagementPart: String,
                     payByRenterForWaterFee: Bool,
                     payByProviderForWaterFee: Bool,
                     additionalReqForWaterFeePart: String,
                     payByRenterForEletricFee: Bool,
                     payByProviderForEletricFee: Bool,
                     additionalReqForEletricFeePart: String,
                     payByRenterForGasFee: Bool,
                     payByProviderForGasFee: Bool,
                     additionalReqForGasFeePart: String,
                     additionalReqForOtherPart: String,
                     contractSigurtureProxyFee: String,
                     payByRenterForProxyFee: Bool,
                     payByProviderForProxyFee: Bool,
                     separateForBothForProxyFee: Bool,
                     contractIdentitificationFee: String,
                     payByRenterForIDFFee: Bool,
                     payByProviderForIDFFee: Bool,
                     separateForBothForIDFFee: Bool,
                     contractIdentitificationProxyFee: String,
                     payByRenterForIDFProxyFee: Bool,
                     payByProviderForIDFProxyFee: Bool,
                     separateForBothForIDFProxyFee: Bool,
                     subLeaseAgreement: Bool,
                     doCourtIDF: Bool,
                     courtIDFDoc: Bool,
                     providerName: String,
                     providerID: String,
                     providerResidenceAddress: String,
                     providerMailingAddress: String,
                     providerPhoneNumber: String,
                     providerPhoneChargeName: String,
                     providerPhoneChargeID: String,
                     providerPhoneChargeEmailAddress: String,
                     renterName: String,
                     renterID: String,
                     renterResidenceAddress: String,
                     renterMailingAddress: String,
                     renterPhoneNumber: String,
                     renterEmailAddress: String,
                     sigurtureDate: Date) async throws {
        let roomPublicRef = db.collection("RoomsForPublic").document(docID)
        _ = try await roomPublicRef.setData([
            "roomUID" : roomUID,
            "isPublished" : isPublished,
            "holderName" : holderName,
            "mobileNumber" : mobileNumber,
            "roomAddress" : address,
            "town" : town,
            "city" : city,
            "zipCode" : zipCode,
            "roomArea" : roomArea,
            "rentalPrice" : rentalPrice,
            "someoneDeadInRoom" : someoneDeadInRoom,
            "waterLeakingProblem" : waterLeakingProblem,
            "roomImage" : roomImageURL,
            "providedBy": uidPath,
            "providerDisplayName" : providerDisplayName,
            "roomDescription" : roomDescription,
            "providerChatDocId" : providerChatDocId,
            "rentersContractData" : [
                "docID" : docID,
                "isSummitContract" : isSummitContract,
                "contractBuildDate" : contractBuildDate,
                "contractReviewDays" : contractReviewDays,
                "providerSignurture" : providerSignurture,
                "renterSignurture" : renterSignurture,
                "companyTitle" : companyTitle,
                "roomAddress" : roomAddress,
                "roomTown" : roomTown,
                "roomCity" : roomCity,
                "roomZipCode" : roomZipCode,
                "specificBuildingNumber" : specificBuildingNumber,
                "specificBuildingRightRange" : specificBuildingRightRange,
                "specificBuildingArea" : specificBuildingArea,
                "mainBuildArea" : mainBuildArea,
                "mainBuildingPurpose" : mainBuildingPurpose,
                "subBuildingPurpose" : subBuildingPurpose,
                "subBuildingArea" : subBuildingArea,
                "publicBuildingNumber" : publicBuildingNumber,
                "publicBuildingRightRange" : publicBuildingRightRange,
                "publicBuildingArea" : publicBuildingArea,
                "hasParkinglot" : hasParkinglot,
                "isSettingTheRightForThirdPerson" : isSettingTheRightForThirdPerson,
                "settingTheRightForThirdPersonForWhatKind" : settingTheRightForThirdPersonForWhatKind,
                "isBlockByBank" : isBlockByBank,
                "provideForAll":  provideForAll,
                "provideForPart":  provideForPart,
                "provideFloor":  provideFloor,
                "provideRooms":  provideRooms,
                "provideRoomNumber":  provideRoomNumber,
                "provideRoomArea":  provideRoomArea,
                "isVehicle":  isVehicle,
                "isMorto":  isMorto,
                "parkingUGFloor":  parkingUGFloor,
                "parkingStyleN":  parkingStyleN,
                "parkingStyleM":  parkingStyleM,
                "parkingNumberForVehicle":  parkingNumberForVehicle,
                "parkingNumberForMortor":  parkingNumberForMortor,
                "forAllday":  forAllday,
                "forMorning":  forMorning,
                "forNight":  forNight,
                "havingSubFacility":  havingSubFacility,
                "rentalStartDate" : rentalStartDate,
                "rentalEndDate" : rentalEndDate,
                "roomRentalPrice" : roomRentalPrice,
                "paymentdays":  paymentdays,
                "paybyCash":  paybyCash,
                "paybyTransmission":  paybyTransmission,
                "paybyCreditDebitCard":  paybyCreditDebitCard,
                "bankName":  bankName,
                "bankOwnerName":  bankOwnerName,
                "bankAccount":  bankAccount,
                "payByRenterForManagementPart" : payByRenterForManagementPart,
                "payByProviderForManagementPart" : payByProviderForManagementPart,
                "managementFeeMonthly" : managementFeeMonthly,
                "parkingFeeMonthly" : parkingFeeMonthly,
                "additionalReqForManagementPart" : additionalReqForManagementPart,
                "payByRenterForWaterFee" : payByRenterForWaterFee,
                "payByProviderForWaterFee" : payByProviderForWaterFee,
                "additionalReqForWaterFeePart" : additionalReqForWaterFeePart,
                "payByRenterForEletricFee" : payByRenterForEletricFee,
                "payByProviderForEletricFee" : payByProviderForEletricFee,
                "additionalReqForEletricFeePart" : additionalReqForEletricFeePart,
                "payByRenterForGasFee" : payByRenterForGasFee,
                "payByProviderForGasFee" : payByProviderForGasFee,
                "additionalReqForGasFeePart" : additionalReqForGasFeePart,
                "additionalReqForOtherPart" : additionalReqForOtherPart,
                "contractSigurtureProxyFee" : contractSigurtureProxyFee,
                "payByRenterForProxyFee" : payByRenterForProxyFee,
                "payByProviderForProxyFee" : payByProviderForProxyFee,
                "separateForBothForProxyFee" : separateForBothForProxyFee,
                "contractIdentitificationFee" : contractIdentitificationFee,
                "payByRenterForIDFFee" : payByRenterForIDFFee,
                "payByProviderForIDFFee" : payByProviderForIDFFee,
                "separateForBothForIDFFee" : separateForBothForIDFFee,
                "contractIdentitificationProxyFee" : contractIdentitificationProxyFee,
                "payByRenterForIDFProxyFee" : payByRenterForIDFProxyFee,
                "payByProviderForIDFProxyFee" : payByProviderForIDFProxyFee,
                "separateForBothForIDFProxyFee" : separateForBothForIDFProxyFee,
                "subLeaseAgreement" : subLeaseAgreement,
                "doCourtIDF" : doCourtIDF,
                "courtIDFDoc" : courtIDFDoc,
                "providerName" : providerName,
                "providerID" : providerID,
                "providerResidenceAddress" : providerResidenceAddress,
                "providerMailingAddress" : providerMailingAddress,
                "providerPhoneNumber" : providerPhoneNumber,
                "providerPhoneChargeName" : providerPhoneChargeName,
                "providerPhoneChargeID" : providerPhoneChargeID,
                "providerPhoneChargeEmailAddress" : providerPhoneChargeEmailAddress,
                "renterName" : renterName,
                "renterID" : renterID,
                "renterResidenceAddress" : renterResidenceAddress,
                "renterMailingAddress" : renterMailingAddress,
                "renterPhoneNumber" : renterPhoneNumber,
                "renterEmailAddress" : renterEmailAddress,
                "sigurtureDate" : sigurtureDate
            ]
        ])
        
        let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID)
        try await roomOwerRef.updateData([
            "isPublished" : isPublished
        ])
    }
}


extension FirestoreToFetchRoomsData {
    //erase user rented info when it's expired
    func expiredRoom(uidPath: String, docID: String) async throws {
        let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID)
        try await roomOwerRef.updateData([
            "rentedBy" : "",
            "isRented" : false,
            "isPublished" : false
        ])
    }
}

extension FirestoreToFetchRoomsData {
    @MainActor
    func loopTofetchPaymentData(renterUidPath: String) async throws {
        let paymentHistoryRef = db.collection("users").document(renterUidPath).collection("PaymentHistory").order(by: "paymentDate", descending: false)
        print("ref: \(paymentHistoryRef)")
        let document = try await paymentHistoryRef.getDocuments().documents
        print("document: \(document)")
        self.receivePaymentDataSet = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: PaymentHistoryDataModel.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print("some error eccure: \(error.localizedDescription)")
            }
            return nil
        })
    }
}

extension FirestoreToFetchRoomsData {
    
    @MainActor
    func postRoomCommetAndRatting(roomUID: String, comment: String, neighborRate: Int, pricingRate: Int, convenienceRate: Int, trafficRate: Int, userDisplayName: String, uidPath: String) async throws {
        let roomCARRef = db.collection("RoomsCommentAndRatting").document(roomUID).collection("CommentAndRate").document(uidPath)
        _ = try await roomCARRef.setData([
            "isPost" : true,
            "userDisplayName" : userDisplayName,
            "trafficRate" : trafficRate,
            "convenienceRate" : convenienceRate,
            "pricingRate" : pricingRate,
            "neighborRate" : neighborRate,
            "comment" : comment,
            "postTimestamp" : Date()
        ])
        let document = try await roomCARRef.getDocument(as: RoomCommentAndRattingDataModel.self)
        roomCAR = document
    }
    
    @MainActor
    func getPostComment(roomUID: String, uidPath: String) async throws {
        let roomCARRef = db.collection("RoomsCommentAndRatting").document(roomUID).collection("CommentAndRate").document(uidPath)
        let document = try await roomCARRef.getDocument(as: RoomCommentAndRattingDataModel.self)
        roomCAR = document
    }
    
    @MainActor
    func getCommentDataSet(roomUID: String) async throws {
        let roomCARRef = db.collection("RoomsCommentAndRatting").document(roomUID).collection("CommentAndRate")
        let document = try await roomCARRef.getDocuments().documents
        roomCARDataSet = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: RoomCommentAndRattingDataModel.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print(error.localizedDescription)
            }
            return nil
        })
    }
}
