//
//  FirestoreToFetchRoomsData.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SwiftUI

class FirestoreToFetchRoomsData: ObservableObject {
    let firebaseAuth = FirebaseAuth()

    let db = Firestore.firestore()

    // MARK: - For provider to store and check room is publish or modiy.

    @Published var roomDMInternal = [RoomDM]()
    @Published var fetchRoomInfoFormPublic = [RoomDM]()
    @Published var fetchRoomInfoFormOwner = [RoomDM]()
    @Published var fetchRoomImages = [RoomImageSet]()
    @Published var receivePaymentDataSet = [RentedRoomPaymentHistory]()
    @Published var roomContract: HouseContract = .empty
    @Published var roomID = ""
<<<<<<< HEAD
    @Published var receivePaymentDataSet = [PaymentHistoryDataModel]()
    @Published var roomCAR: RoomCommentAndRattingDataModel = .empty
    @Published var roomCARDataSet = [RoomCommentAndRattingDataModel]()
    @Published var roomVideoPath: RoomVideoDataModel = .empty
    
=======
    @Published var roomCAR: RoomCommentRatting = .empty
    @Published var roomCARDataSet = [RoomCommentRatting]()
    @Published var roomVideoPath = [VideoDM]()

>>>>>>> PodsAdding
    func roomIdGenerator() -> String {
        return UUID().uuidString
    }
}

extension FirestoreToFetchRoomsData {
    func summitRoomInfoAsync(
        //        room rUid: String,
        gui: String,
        roomDM config: RoomDM,
        house contract: HouseContract
    ) async throws {
        let roomOwerRef = db.collection("RoomsForOwner").document(gui).collection("Rooms").document(config.roomUID)
        _ = try await roomOwerRef.setData([
            "isPublish" : config.isPublish,
            "roomUID" : config.roomUID,
            "providerUID" : config.providerUID,
            "providerGUI" : config.providerGUI,
            "renterUID" : config.renterUID,
            "roomsCoverImageURL" : config.roomsCoverImageURL,
            "rentalPrice" : config.rentalPrice,
            "zipCode" : config.zipCode,
            "city" : config.city,
            "town" : config.town,
            "address" : config.address,
            "roomDescription" : config.roomDescription,
            "someoneDeadInRoom" : config.someoneDeadInRoom,
            "waterLeakingProblem" : config.waterLeakingProblem,
            "contractBuildDate" : Date()
        ])
        let roomContractRef = roomOwerRef.collection("RoomContract").document(config.roomUID)
        _ = try await roomContractRef.setData([
            // MARK: Contract's Data Model

            "contractBuildDate": Date(),
            "contractReviewDays": "",
            "providerSignurture": "",
            "renterSignurture": "",
            "companyTitle": "",
            "roomAddress": contract.roomAddress,
            "roomTown": contract.roomTown,
            "roomCity": contract.roomCity,
            "roomZipCode": contract.roomZipCode,

            // MARK: 第一條 委託管理標的 - 房屋標示

            "specificBuildingNumber": "", // 專有部分建號
            "specificBuildingRightRange": "", // 專有部分權利範圍
            "specificBuildingArea": "", // 專有部分面積共計

            "mainBuildArea": "", // 主建物面積__層__平方公尺
            "mainBuildingPurpose": "", // 主建物用途

            "subBuildingPurpose": "", // 附屬建物用途
            "subBuildingArea": "", // 附屬建物面積__平方公尺

            "publicBuildingNumber": "", // 共有部分建號
            "publicBuildingRightRange": "", // 共有部分權利範圍
            "publicBuildingArea": "", // 共有部分持分面積__平方公尺

            "hasParkinglot": false, // 車位-有無

            "isSettingTheRightForThirdPerson": false, // 設定他項權利-有無
            "settingTheRightForThirdPersonForWhatKind": "", // 權利種類

            "isBlockByBank": false, // 查封登記-有無

            // MARK: 第一條 委託管理標的 - 租賃範圍

            "provideForAll": false, // 租賃住宅全部
            "provideForPart": false, // 租賃住宅部分
            "provideFloor": "", // 租賃住宅第__層
            "provideRooms": "", // 租賃住宅房間__間
            "provideRoomNumber": "", // 租賃住宅第__室
            "provideRoomArea": "", // 租賃住宅面積__平方公尺

            "isVehicle": false, // 汽車停車位
            "isMorto": false, // 機車停車位
            "parkingUGFloor": "", // 地上(下)第__層
            "parkingStyleN": false, // 平面式停車位
            "parkingStyleM": false, // 機械式停車位
            "parkingNumberForVehicle": "", // 編號第__號
            "parkingNumberForMortor": "",
            "forAllday": false, // 使用時間全日
            "forMorning": false, // 使用時間日間
            "forNight": false, // 使用時間夜間

            "havingSubFacility": false, // 租賃附屬設備-有無

            // MARK: 第二條 租賃期間

            "rentalStartDate": Date(), // 委託管理期間自
            "rentalEndDate": Date(), // 委託管理期間至

            // MARK: 第三條 租金約定及支付

            "roomRentalPrice": contract.roomRentalPrice,
            "paymentdays": "", // 每月__日前支付
            "paybyCash": false, // 報酬約定及給付-現金繳付
            "paybyTransmission": false, // 報酬約定及給付-轉帳繳付
            "paybyCreditDebitCard": false, // 報酬約定及給付-信用卡/簽帳卡
            "bankName": "", // 金融機構
            "bankOwnerName": "", // 戶名
            "bankAccount": "", // 帳號

            // MARK: 第五條 租賃期間相關費用之支付

            "payByRenterForManagementPart": false, // 承租人負擔
            "payByProviderForManagementPart": false, // 出租人負擔
            "managementFeeMonthly": "", // 房屋每月___元整
            "parkingFeeMonthly": "", // 停車位每月___元整
            "additionalReqForManagementPart": "",

            "payByRenterForWaterFee": false, // 承租人負擔
            "payByProviderForWaterFee": false, // 出租人負擔
            "additionalReqForWaterFeePart": "",

            "payByRenterForEletricFee": false, // 承租人負擔
            "payByProviderForEletricFee": false, // 出租人負擔
            "additionalReqForEletricFeePart": "",

            "payByRenterForGasFee": false, // 承租人負擔
            "payByProviderForGasFee": false, // 出租人負擔
            "additionalReqForGasFeePart": "",

            "additionalReqForOtherPart": "", // 其他費用及其支付方式

            // MARK: 第六條 稅費負擔之約定

            "contractSigurtureProxyFee": "",
            "payByRenterForProxyFee": false, // 承租人負擔
            "payByProviderForProxyFee": false, // 出租人負擔
            "separateForBothForProxyFee": false, // 雙方平均負擔

            "contractIdentitificationFee": "",
            "payByRenterForIDFFee": false, // 承租人負擔
            "payByProviderForIDFFee": false, // 出租人負擔
            "separateForBothForIDFFee": false, // 雙方平均負擔

            "contractIdentitificationProxyFee": "",
            "payByRenterForIDFProxyFee": false, // 承租人負擔
            "payByProviderForIDFProxyFee": false, // 出租人負擔
            "separateForBothForIDFProxyFee": false, // 雙方平均負擔

            // MARK: 第七條 使用房屋之限制

            "subLeaseAgreement": false,

            // MARK: 第十二條 房屋之返還

//                "contractSendbyEmail" : false, //履行本契約之通知-電子郵件信箱
//                "contractSendbyTextingMessage" : false, //履行本契約之通知-手機簡訊
//                "contractSendbyMessageSoftware" : false, //履行本契約之通知-即時通訊軟體

            // MARK: 第十九條 其他約定

            "doCourtIDF": false, // □辦理公證□不辦理公證
            "courtIDFDoc": false, // □不同意；□同意公證書

            // MARK: 立契約書人

            "providerName": "",
            "providerID": "",
            "providerResidenceAddress": "",
            "providerMailingAddress": "",
            "providerPhoneNumber": "",
            "providerPhoneChargeName": "",
            "providerPhoneChargeID": "",
            "providerPhoneChargeEmailAddress": "",

            "renterName": "",
            "renterID": "",
            "renterResidenceAddress": "",
            "renterMailingAddress": "",
            "renterPhoneNumber": "",
            "renterEmailAddress": "",

            // End
            "sigurtureDate": Date(),
        ])
    }
    
    @MainActor
    func fetchRoomContract(provider gui: String, roomUID: String) async throws {
        let roomContractRef = db.collection("RoomsForOwner").document(gui).collection("Rooms").document(roomUID).collection("RoomContract").document(roomUID)
        roomContract = try await roomContractRef.getDocument(as: HouseContract.self)
    }

    // MARK: - Fetch rooms address

//    func fetchRoomAddress(uidPath: String, docID: String, roomUID: String) async throws -> String {
//        let roomContractRef = db.collection("RoomsForOwner").document(uidPath).collection("Rooms").document(docID).collection("RoomContractAndImage").document(roomUID)
//        let getDoc = try await roomContractRef.getDocument(as: HouseContract.self)
//        let zipCode = getDoc.roomZipCode
//        let city =  getDoc.roomCity
//        let town = getDoc.roomTown
//        let address = getDoc.roomAddress
//        return zipCode + city + town + address
//    }

    // MARK: - Get first Image

//    func fetchFirstImage(uidPath: String, docID: String) async throws {
//        let roomImagesRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID)
//            .collection("RoomImages").limit(to: 1)
//        let document = try await roomImagesRef.getDocuments().documents
//        self.fetchRoomImages = document.compactMap ({ queryDocumentSnapshot in
//            let result = Result {
//                try queryDocumentSnapshot.data(as: RoomImageSet.self)
//            }
//            switch result {
//            case .success(let data):
//                return data
//            case .failure(let error):
//                print("error: \(error.localizedDescription)")
//            }
//            return nil
//        })
//    }
}

extension FirestoreToFetchRoomsData {
    func deleteRentedRoom(roomUID: String) async throws {
        let roomPublicRef = db.collection("RoomsForPublic")
        try await roomPublicRef.document(roomUID).delete()
    }

//    func updateRentedRoom(
//        uidPath: String,
//        roomUID: String,
//        renterUID: String
//    ) async throws {
//        let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection("Rooms").document(roomUID)
//        try await roomOwerRef.updateData([
//            "renterUID": renterUID,
//        ])
//    }

    func updateContractData(
        gui: String,
        roomDM config: RoomDM,
        house contract: HouseContract
    ) async throws {
        let roomContractRef = db.collection("RoomsForOwner").document(gui).collection("Rooms").document(config.roomUID).collection("RoomContract").document(config.roomUID)
        try await roomContractRef.updateData([
            // MARK: Contract's Data Model

            "contractBuildDate": contract.contractBuildDate,
            "contractReviewDays": contract.contractReviewDays,
            "providerSignurture": contract.providerSignurture,
            "renterSignurture": contract.renterSignurture,
            "companyTitle": contract.companyTitle,
            "roomAddress": contract.roomAddress,
            "roomTown": contract.roomTown,
            "roomCity": contract.roomCity,
            "roomZipCode": contract.roomZipCode,

            // MARK: 第一條 委託管理標的 - 房屋標示

            "specificBuildingNumber": contract.specificBuildingNumber, // 專有部分建號
            "specificBuildingRightRange": contract.specificBuildingRightRange, // 專有部分權利範圍
            "specificBuildingArea": contract.specificBuildingArea, // 專有部分面積共計

            "mainBuildArea": contract.mainBuildArea, // 主建物面積__層__平方公尺
            "mainBuildingPurpose": contract.mainBuildingPurpose, // 主建物用途

            "subBuildingPurpose": contract.subBuildingPurpose, // 附屬建物用途
            "subBuildingArea": contract.subBuildingArea, // 附屬建物面積__平方公尺

            "publicBuildingNumber": contract.publicBuildingNumber, // 共有部分建號
            "publicBuildingRightRange": contract.publicBuildingRightRange, // 共有部分權利範圍
            "publicBuildingArea": contract.publicBuildingArea, // 共有部分持分面積__平方公尺

            "hasParkinglot": contract.hasParkinglot, // 車位-有無

            "isSettingTheRightForThirdPerson": contract.isSettingTheRightForThirdPerson, // 設定他項權利-有無
            "settingTheRightForThirdPersonForWhatKind": contract.settingTheRightForThirdPersonForWhatKind, // 權利種類

            "isBlockByBank": contract.isBlockByBank, // 查封登記-有無

            // MARK: 第一條 委託管理標的 - 租賃範圍

            "provideForAll": contract.provideForAll, // 租賃住宅全部
            "provideForPart": contract.provideForPart, // 租賃住宅部分
            "provideFloor": contract.provideFloor, // 租賃住宅第__層
            "provideRooms": contract.provideRooms, // 租賃住宅房間__間
            "provideRoomNumber": contract.provideRoomNumber, // 租賃住宅第__室
            "provideRoomArea": contract.provideRoomArea, // 租賃住宅面積__平方公尺

            "isVehicle": contract.isVehicle, // 汽車停車位
            "isMorto": contract.isMorto, // 機車停車位
            "parkingUGFloor": contract.parkingUGFloor, // 地上(下)第__層
            "parkingStyleN": contract.parkingStyleN, // 平面式停車位
            "parkingStyleM": contract.parkingStyleM, // 機械式停車位
            "parkingNumberForVehicle": contract.parkingNumberForVehicle, // 編號第__號
            "parkingNumberForMortor": contract.parkingNumberForMortor,
            "forAllday": contract.forAllday, // 使用時間全日
            "forMorning": contract.forMorning, // 使用時間日間
            "forNight": contract.forNight, // 使用時間夜間

            "havingSubFacility": contract.havingSubFacility, // 租賃附屬設備-有無

            // MARK: 第二條 租賃期間

            "rentalStartDate": contract.rentalStartDate, // 委託管理期間自
            "rentalEndDate": contract.rentalEndDate, // 委託管理期間至

            // MARK: 第三條 租金約定及支付

            "roomRentalPrice": contract.roomRentalPrice,
            "paymentdays": contract.paymentdays, // 每月__日前支付
            "paybyCash": contract.paybyCash, // 報酬約定及給付-現金繳付
            "paybyTransmission": contract.paybyTransmission, // 報酬約定及給付-轉帳繳付
            "paybyCreditDebitCard": contract.paybyCreditDebitCard, // 報酬約定及給付-信用卡/簽帳卡
            "bankName": contract.bankName, // 金融機構
            "bankOwnerName": contract.bankOwnerName, // 戶名
            "bankAccount": contract.bankAccount, // 帳號

            // MARK: 第五條 租賃期間相關費用之支付

            "payByRenterForManagementPart": contract.payByRenterForManagementPart, // 承租人負擔
            "payByProviderForManagementPart": contract.payByProviderForManagementPart, // 出租人負擔
            "managementFeeMonthly": contract.managementFeeMonthly, // 房屋每月___元整
            "parkingFeeMonthly": contract.parkingFeeMonthly, // 停車位每月___元整
            "additionalReqForManagementPart": contract.additionalReqForManagementPart,

            "payByRenterForWaterFee": contract.payByRenterForWaterFee, // 承租人負擔
            "payByProviderForWaterFee": contract.payByProviderForWaterFee, // 出租人負擔
            "additionalReqForWaterFeePart": contract.additionalReqForWaterFeePart,

            "payByRenterForEletricFee": contract.payByRenterForEletricFee, // 承租人負擔
            "payByProviderForEletricFee": contract.payByProviderForEletricFee, // 出租人負擔
            "additionalReqForEletricFeePart": contract.additionalReqForEletricFeePart,

            "payByRenterForGasFee": contract.payByRenterForGasFee, // 承租人負擔
            "payByProviderForGasFee": contract.payByProviderForGasFee, // 出租人負擔
            "additionalReqForGasFeePart": contract.additionalReqForGasFeePart,

            "additionalReqForOtherPart": contract.additionalReqForOtherPart, // 其他費用及其支付方式

            // MARK: 第六條 稅費負擔之約定

            "contractSigurtureProxyFee": contract.contractSigurtureProxyFee,
            "payByRenterForProxyFee": contract.payByRenterForProxyFee, // 承租人負擔
            "payByProviderForProxyFee": contract.payByProviderForProxyFee, // 出租人負擔
            "separateForBothForProxyFee": contract.separateForBothForProxyFee, // 雙方平均負擔

            "contractIdentitificationFee": contract.contractIdentitificationFee,
            "payByRenterForIDFFee": contract.payByRenterForIDFFee, // 承租人負擔
            "payByProviderForIDFFee": contract.payByProviderForIDFFee, // 出租人負擔
            "separateForBothForIDFFee": contract.separateForBothForIDFFee, // 雙方平均負擔

            "contractIdentitificationProxyFee": contract.contractIdentitificationProxyFee,
            "payByRenterForIDFProxyFee": contract.payByRenterForIDFProxyFee, // 承租人負擔
            "payByProviderForIDFProxyFee": contract.payByProviderForIDFProxyFee, // 出租人負擔
            "separateForBothForIDFProxyFee": contract.separateForBothForIDFProxyFee, // 雙方平均負擔

            // MARK: 第七條 使用房屋之限制

            "subLeaseAgreement": contract.subLeaseAgreement,

            // MARK: 第十二條 房屋之返還

//            "contractSendbyEmail" : contract.contractSendbyEmail, //履行本契約之通知-電子郵件信箱
//            "contractSendbyTextingMessage" : contract.contractSendbyTextingMessage, //履行本契約之通知-手機簡訊
//            "contractSendbyMessageSoftware" : contract.contractSendbyMessageSoftware, //履行本契約之通知-即時通訊軟體

            // MARK: 第十九條 其他約定

            "doCourtIDF": contract.doCourtIDF, // □辦理公證□不辦理公證
            "courtIDFDoc": contract.courtIDFDoc, // □不同意；□同意公證書

            // MARK: 立契約書人

            "providerName": contract.providerName,
            "providerID": contract.providerID,
            "providerResidenceAddress": contract.providerResidenceAddress,
            "providerMailingAddress": contract.providerMailingAddress,
            "providerPhoneNumber": contract.providerPhoneNumber,
            "providerPhoneChargeName": contract.providerPhoneChargeName,
            "providerPhoneChargeID": contract.providerPhoneChargeID,
            "providerPhoneChargeEmailAddress": contract.providerPhoneChargeEmailAddress,
        ])
    }
}

extension FirestoreToFetchRoomsData {
    func listeningRoomInfoForPublic() {
        let roomPublicRef = db.collection("RoomsForPublic")
        roomPublicRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot?.documents else {
                print("Error fetch document: \(error!)")
                return
            }
            self.fetchRoomInfoFormPublic = document.compactMap { queryDocumentSnapshot in
                let result = Result {
                    try queryDocumentSnapshot.data(as: RoomDM.self)
                }
                switch result {
                case .success(let data):
                    return data
                case .failure(let error):
                    print(error.localizedDescription)
                }
                return nil
            }
        }
    }

    @MainActor
    func getRoomInfo(gui: String) async throws {
        let roomOwerRef = db.collection("RoomsForOwner").document(gui).collection("Rooms").order(by: "contractBuildDate", descending: true)
        let document = try await roomOwerRef.getDocuments().documents
        fetchRoomInfoFormOwner = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: RoomDM.self)
            }
            switch result {
            case let .success(data):
                return data
            case let .failure(error):
                print(error.localizedDescription)
            }
            return nil
        }
    }
}

extension FirestoreToFetchRoomsData {
    @MainActor
    func fetchRoomImages(gui: String, roomUID: String) async throws {
        let roomOwerRef = db.collection("RoomsForOwner").document(gui).collection("Rooms").document(roomUID)
            .collection("RoomImages")
        let document = try await roomOwerRef.getDocuments().documents
        fetchRoomImages = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: RoomImageSet.self)
            }
            switch result {
            case let .success(data):
                return data
            case let .failure(error):
                print("error: \(error)")
            }
            return nil
        }
    }
}

extension FirestoreToFetchRoomsData {
    // MARK: "Notice">> Create another function to summit and fetch video

//    @MainActor
//    func fetchRoomVideo(uidPath: String, docID: String) async throws {
//        let roomVideoRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID)
//            .collection("RoomVideo")
//        let document = try await roomVideoRef.getDocument()
//    }
}

extension FirestoreToFetchRoomsData {
    // MARK: - Sign renter data in contract

    func summitRenter(
        retner uid: String,
        provider gui: String,
        roomDM config: RoomDM,
        renter user: UserDM
    ) async throws -> HouseContract {
        let roomInfoRef = db.collection("RoomsForOwner").document(gui).collection("Rooms").document(config.roomUID)
        try await roomInfoRef.updateData([
            "renterUID" : uid
        ])
        let roomContractRef = roomInfoRef.collection("RoomContract").document(config.roomUID)
        let renterName = user.firstName + user.lastName
        let resisdenceAddress = user.zipCode + user.city + user.town + user.address
        try await roomContractRef.updateData([
            "renterName": renterName,
            "renterID": user.id,
            "renterResidenceAddress": resisdenceAddress,
            "renterMailingAddress": resisdenceAddress,
            "renterPhoneNumber": user.mobileNumber,
            "renterEmailAddress": user.email,
            "sigurtureDate": Date(),
        ])
        
        let userRef = db.collection("User").document(uid)
        try await userRef.updateData([
            "isRented" : true
        ])
        
        return try await roomContractRef.getDocument(as: HouseContract.self)
    }

    func updataRentalPrice(
        uidPath: String,
        docID: String,
        rentalPrice: String
    ) async throws {
        let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID)
        try await roomOwerRef.updateData([
            "rentalPrice": rentalPrice,
        ])
    }
}

extension FirestoreToFetchRoomsData {
    
    @MainActor
    func test() async throws {
        let roomPublicRef = db.collection("RoomsForPublic")
        let document = try await roomPublicRef.getDocuments().documents
        fetchRoomInfoFormPublic = document.compactMap({ queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: RoomDM.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print(error.localizedDescription)
            }
            return nil
        })
<<<<<<< HEAD
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
    @MainActor
    func fetchRoomVideo(uidPath: String, docID: String) async throws {
        let roomVideoRef = db.collection("RoomsForOwner").document(uidPath).collection(uidPath).document(docID)
            .collection("RoomVideo").document("video")
        roomVideoPath = try await roomVideoRef.getDocument(as: RoomVideoDataModel.self)
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
=======
        
>>>>>>> PodsAdding
    }
    
    func roomPublish(
        gui: String,
        roomDM config: RoomDM,
        house contract: HouseContract
    ) async throws {
        let roomOwerRef = db.collection("RoomsForOwner").document(gui).collection("Rooms").document(config.roomUID)
        try await roomOwerRef.updateData([
            "isPublish": true,
        ])

        let roomPublicRef = db.collection("RoomsForPublic").document(config.roomUID)
        _ = try await roomPublicRef.setData([
            "isPublish" : config.isPublish,
            "roomUID" : config.roomUID,
            "providerUID" : config.providerUID,
            "providerGUI" : config.providerGUI,
            "renterUID" : config.renterUID,
            "roomsCoverImageURL" : config.roomsCoverImageURL,
            "rentalPrice" : config.rentalPrice,
            "zipCode" : config.zipCode,
            "city" : config.city,
            "town" : config.town,
            "address" : config.address,
            "roomDescription" : config.roomDescription,
            "someoneDeadInRoom" : config.someoneDeadInRoom,
            "waterLeakingProblem" : config.waterLeakingProblem,
            "contractBuildDate" : Date()
        ])
        let roomPublicContractRef = roomPublicRef.collection("Contract").document(config.roomUID)
        _ = try await roomPublicContractRef.setData([
            "contractBuildDate": contract.contractBuildDate,
            "contractReviewDays": contract.contractReviewDays,
            "providerSignurture": contract.providerSignurture,
            "renterSignurture": contract.renterSignurture,
            "companyTitle": contract.companyTitle,
            "roomAddress": contract.roomAddress,
            "roomTown": contract.roomTown,
            "roomCity": contract.roomCity,
            "roomZipCode": contract.roomZipCode,
            "specificBuildingNumber": contract.specificBuildingNumber,
            "specificBuildingRightRange": contract.specificBuildingRightRange,
            "specificBuildingArea": contract.specificBuildingArea,
            "mainBuildArea": contract.mainBuildArea,
            "mainBuildingPurpose": contract.mainBuildingPurpose,
            "subBuildingPurpose": contract.subBuildingPurpose,
            "subBuildingArea": contract.subBuildingArea,
            "publicBuildingNumber": contract.publicBuildingNumber,
            "publicBuildingRightRange": contract.publicBuildingRightRange,
            "publicBuildingArea": contract.publicBuildingArea,
            "hasParkinglot": contract.hasParkinglot,
            "isSettingTheRightForThirdPerson": contract.isSettingTheRightForThirdPerson,
            "settingTheRightForThirdPersonForWhatKind": contract.settingTheRightForThirdPersonForWhatKind,
            "isBlockByBank": contract.isBlockByBank,
            "provideForAll": contract.provideForAll,
            "provideForPart": contract.provideForPart,
            "provideFloor": contract.provideFloor,
            "provideRooms": contract.provideRooms,
            "provideRoomNumber": contract.provideRoomNumber,
            "provideRoomArea": contract.provideRoomArea,
            "isVehicle": contract.isVehicle,
            "isMorto": contract.isMorto,
            "parkingUGFloor": contract.parkingUGFloor,
            "parkingStyleN": contract.parkingStyleN,
            "parkingStyleM": contract.parkingStyleM,
            "parkingNumberForVehicle": contract.parkingNumberForVehicle,
            "parkingNumberForMortor": contract.parkingNumberForMortor,
            "forAllday": contract.forAllday,
            "forMorning": contract.forMorning,
            "forNight": contract.forNight,
            "havingSubFacility": contract.havingSubFacility,
            "rentalStartDate": contract.rentalStartDate,
            "rentalEndDate": contract.rentalEndDate,
            "roomRentalPrice": contract.roomRentalPrice,
            "paymentdays": contract.paymentdays,
            "paybyCash": contract.paybyCash,
            "paybyTransmission": contract.paybyTransmission,
            "paybyCreditDebitCard": contract.paybyCreditDebitCard,
            "bankName": contract.bankName,
            "bankOwnerName": contract.bankOwnerName,
            "bankAccount": contract.bankAccount,
            "payByRenterForManagementPart": contract.payByRenterForManagementPart,
            "payByProviderForManagementPart": contract.payByProviderForManagementPart,
            "managementFeeMonthly": contract.managementFeeMonthly,
            "parkingFeeMonthly": contract.parkingFeeMonthly,
            "additionalReqForManagementPart": contract.additionalReqForManagementPart,
            "payByRenterForWaterFee": contract.payByRenterForWaterFee,
            "payByProviderForWaterFee": contract.payByProviderForWaterFee,
            "additionalReqForWaterFeePart": contract.additionalReqForWaterFeePart,
            "payByRenterForEletricFee": contract.payByRenterForEletricFee,
            "payByProviderForEletricFee": contract.payByProviderForEletricFee,
            "additionalReqForEletricFeePart": contract.additionalReqForEletricFeePart,
            "payByRenterForGasFee": contract.payByRenterForGasFee,
            "payByProviderForGasFee": contract.payByProviderForGasFee,
            "additionalReqForGasFeePart": contract.additionalReqForGasFeePart,
            "additionalReqForOtherPart": contract.additionalReqForOtherPart,
            "contractSigurtureProxyFee": contract.contractSigurtureProxyFee,
            "payByRenterForProxyFee": contract.payByRenterForProxyFee,
            "payByProviderForProxyFee": contract.payByProviderForProxyFee,
            "separateForBothForProxyFee": contract.separateForBothForProxyFee,
            "contractIdentitificationFee": contract.contractIdentitificationFee,
            "payByRenterForIDFFee": contract.payByRenterForIDFFee,
            "payByProviderForIDFFee": contract.payByProviderForIDFFee,
            "separateForBothForIDFFee": contract.separateForBothForIDFFee,
            "contractIdentitificationProxyFee": contract.contractIdentitificationProxyFee,
            "payByRenterForIDFProxyFee": contract.payByRenterForIDFProxyFee,
            "payByProviderForIDFProxyFee": contract.payByProviderForIDFProxyFee,
            "separateForBothForIDFProxyFee": contract.separateForBothForIDFProxyFee,
            "subLeaseAgreement": contract.subLeaseAgreement,
            "doCourtIDF": contract.doCourtIDF,
            "courtIDFDoc": contract.courtIDFDoc,
            "providerName": contract.providerName,
            "providerID": contract.providerID,
            "providerResidenceAddress": contract.providerResidenceAddress,
            "providerMailingAddress": contract.providerMailingAddress,
            "providerPhoneNumber": contract.providerPhoneNumber,
            "providerPhoneChargeName": contract.providerPhoneChargeName,
            "providerPhoneChargeID": contract.providerPhoneChargeID,
            "providerPhoneChargeEmailAddress": contract.providerPhoneChargeEmailAddress,
            "renterName": contract.renterName,
            "renterID": contract.renterID,
            "renterResidenceAddress": contract.renterResidenceAddress,
            "renterMailingAddress": contract.renterMailingAddress,
            "renterPhoneNumber": contract.renterPhoneNumber,
            "renterEmailAddress": contract.renterEmailAddress,
            "sigurtureDate": contract.sigurtureDate,
        ])
    }
}

extension FirestoreToFetchRoomsData {
    // erase user rented info when it's expired
    func expiredRoom(uidPath: String, roomUID: String) async throws {
        let roomOwerRef = db.collection("RoomsForOwner").document(uidPath).collection("Rooms").document(roomUID)
        try await roomOwerRef.updateData([
            "renterUID": "",
            "isPublished": false,
        ])
    }
}

extension FirestoreToFetchRoomsData {
    @MainActor
    func loopTofetchPaymentData(renter uidPath: String) async throws {
        let paymentHistoryRef = db.collection("RentedRoom").document(uidPath).collection("PaymentHistory").order(by: "paymentDate", descending: false)
        print("ref: \(paymentHistoryRef)")
        let document = try await paymentHistoryRef.getDocuments().documents
        print("document: \(document)")
        receivePaymentDataSet = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: RentedRoomPaymentHistory.self)
            }
            switch result {
            case let .success(data):
                return data
            case let .failure(error):
                print("some error eccure: \(error.localizedDescription)")
            }
            return nil
        }
    }
}

extension FirestoreToFetchRoomsData {
    @MainActor
    func postRoomCommetAndRatting(
        renter uidPath: String,
        room commentAndRatting: RoomCommentRatting
    ) async throws {
        let roomCARRef = db.collection("RoomsCommentAndRatting").document(commentAndRatting.roomUID).collection("CommentAndRate").document(uidPath)
        _ = try await roomCARRef.setData([
            "roomUID": commentAndRatting.roomUID,
            "providerUID": commentAndRatting.providerUID,
            "comment": commentAndRatting.comment,
            "convenienceRate": commentAndRatting.convenienceRate,
            "pricingRate": commentAndRatting.pricingRate,
            "neighborRate": commentAndRatting.neighborRate,
            "userDisplayName": commentAndRatting.userDisplayName,
            "isPost": commentAndRatting.isPost,
            "postTimestamp": Date(),
        ])
        let document = try await roomCARRef.getDocument(as: RoomCommentRatting.self)
        roomCAR = document
    }

//    func resetRoomCommentAndRatting(roomUID: String)

    // MARK: - For user who rented the room and leave comment

    @MainActor
    func getPostComment(roomUID: String, uidPath: String) async throws {
        let roomCARRef = db.collection("RoomsCommentAndRatting").document(roomUID).collection("CommentAndRate").document(uidPath)
        let document = try await roomCARRef.getDocument(as: RoomCommentRatting.self)
        roomCAR = document
    }

    // MARK: - For all user could review comment

    @MainActor
    func getCommentDataSet(roomUID: String) async throws {
        let roomCARRef = db.collection("RoomsCommentAndRatting").document(roomUID).collection("CommentAndRate")
        let document = try await roomCARRef.getDocuments().documents
        roomCARDataSet = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: RoomCommentRatting.self)
            }
            switch result {
            case let .success(data):
                return data
            case let .failure(error):
                print(error.localizedDescription)
            }
            return nil
        }
    }
}

/*
 //                            isSummitContract: Bool,
 //                            contractBuildDate: Date,
 //                            contractReviewDays: String,
 //                            providerSignurture: String,
 //                            renterSignurture: String,
 //                            companyTitle: String,
 //                            roomAddress: String,
 //                            roomTown: String,
 //                            roomCity: String,
 //                            roomZipCode: String,
 //                            specificBuildingNumber: String,
 //                            specificBuildingRightRange: String,
 //                            specificBuildingArea: String,
 //                            mainBuildArea: String,
 //                            mainBuildingPurpose: String,
 //                            subBuildingPurpose: String,
 //                            subBuildingArea: String,
 //                            publicBuildingNumber: String,
 //                            publicBuildingRightRange: String,
 //                            publicBuildingArea: String,
 //                            hasParkinglot: Bool,
 //                            isSettingTheRightForThirdPerson: Bool,
 //                            settingTheRightForThirdPersonForWhatKind: String,
 //                            isBlockByBank: Bool,
 //                            provideForAll: Bool,
 //                            provideForPart: Bool,
 //                            provideFloor: String,
 //                            provideRooms: String,
 //                            provideRoomNumber: String,
 //                            provideRoomArea: String,
 //                            isVehicle: Bool,
 //                            isMorto: Bool,
 //                            parkingUGFloor: String,
 //                            parkingStyleN: Bool,
 //                            parkingStyleM: Bool,
 //                            parkingNumberForVehicle: String,
 //                            parkingNumberForMortor: String,
 //                            forAllday: Bool,
 //                            forMorning: Bool,
 //                            forNight: Bool,
 //                            havingSubFacility: Bool,
 //                            rentalStartDate: Date,
 //                            rentalEndDate: Date,
 //                            roomRentalPrice: String,
 //                            paymentdays: String,
 //                            paybyCash: Bool,
 //                            paybyTransmission: Bool,
 //                            paybyCreditDebitCard: Bool,
 //                            bankName: String,
 //                            bankOwnerName: String,
 //                            bankAccount: String,
 //                            payByRenterForManagementPart: Bool,
 //                            payByProviderForManagementPart: Bool,
 //                            managementFeeMonthly: String,
 //                            parkingFeeMonthly: String,
 //                            additionalReqForManagementPart: String,
 //                            payByRenterForWaterFee: Bool,
 //                            payByProviderForWaterFee: Bool,
 //                            additionalReqForWaterFeePart: String,
 //                            payByRenterForEletricFee: Bool,
 //                            payByProviderForEletricFee: Bool,
 //                            additionalReqForEletricFeePart: String,
 //                            payByRenterForGasFee: Bool,
 //                            payByProviderForGasFee: Bool,
 //                            additionalReqForGasFeePart: String,
 //                            additionalReqForOtherPart: String,
 //                            contractSigurtureProxyFee: String,
 //                            payByRenterForProxyFee: Bool,
 //                            payByProviderForProxyFee: Bool,
 //                            separateForBothForProxyFee: Bool,
 //                            contractIdentitificationFee: String,
 //                            payByRenterForIDFFee: Bool,
 //                            payByProviderForIDFFee: Bool,
 //                            separateForBothForIDFFee: Bool,
 //                            contractIdentitificationProxyFee: String,
 //                            payByRenterForIDFProxyFee: Bool,
 //                            payByProviderForIDFProxyFee: Bool,
 //                            separateForBothForIDFProxyFee: Bool,
 //                            subLeaseAgreement: Bool,
 //                            doCourtIDF: Bool,
 //                            courtIDFDoc: Bool,
 //                            providerName: String,
 //                            providerID: String,
 //                            providerResidenceAddress: String,
 //                            providerMailingAddress: String,
 //                            providerPhoneNumber: String,
 //                            providerPhoneChargeName: String,
 //                            providerPhoneChargeID: String,
 //                            providerPhoneChargeEmailAddress: String
 */
