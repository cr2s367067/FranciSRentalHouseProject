//
//  FirestoreToFetchUserInfo.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SwiftUI

class FirestoreToFetchUserinfo: ObservableObject {
    let firebaseAuth = FirebaseAuth()
    let db = Firestore.firestore()

    // MARK: - User data

    @Published var fetchedUserData: UserDM = .empty

    // MARK: - User rented room

    @Published var rentedRoom: RentedRoom = .empty

    // MARK: - User could have room contract

    @Published var rentedContract: HouseContract = .empty

    // MARK: - Payment history for each month

    @Published var paymentHistory = [RentedRoomPaymentHistory]()

    // MARK: - For user get provider info <Haven't create func>

    @Published var providerInfo: ProviderDM = .empty

    // MARK: - Present provider config <Haven't create func>

    @Published var providerStoreConfig: ProviderStore = .empty

    func userIDisEmpty() -> Bool {
        return fetchedUserData.id.isEmpty
    }

    func notRented() -> Bool {
        return rentedRoom.rentedRoomUID.isEmpty
    }
}

extension FirestoreToFetchUserinfo {
    
    @MainActor
    func createProviderData(
        user uidPath: String,
        provider data: ProviderDM
    ) async throws {
        let storeProviderRef = db.collection("Stores").document(data.gui).collection("ProviderData").document(uidPath)
        _ = try await storeProviderRef.setData([
            "gui" : data.gui,
            "companyName" : data.companyName,
            "chargeName" : data.chargeName,
            "city" : data.city,
            "town" : data.town,
            "address" : data.address,
            "email" : data.email,
            "companyProfileImageURL" : data.companyProfileImageURL
        ])
        providerInfo = try await storeProviderRef.getDocument(as: ProviderDM.self)
    }
    
    @MainActor
    func updateProviderData(
        user uidPath: String,
        provider data: ProviderDM
    ) async throws {
        let storeProviderRef = db.collection("Stores").document(data.gui).collection("ProviderData").document(uidPath)
        _ = try await storeProviderRef.updateData([
            "gui" : data.gui,
            "companyName" : data.companyName,
            "chargeName" : data.chargeName,
            "city" : data.city,
            "town" : data.town,
            "address" : data.address,
            "email" : data.email,
            "companyProfileImageURL" : data.companyProfileImageURL
        ])
        providerInfo = try await storeProviderRef.getDocument(as: ProviderDM.self)
    }
    
    @MainActor
    func getProviderData(
        gui: String,
        provider uidPath: String
    ) async throws {
        let storeProviderRef = db.collection("Stores").document(gui).collection("ProviderData").document(uidPath)
        providerInfo = try await storeProviderRef.getDocument(as: ProviderDM.self)
    }
}

extension FirestoreToFetchUserinfo {
    func updateDisplayName(uidPath: String, nickName: String) async throws {
        let userRef = db.collection("User").document(uidPath)
        try await userRef.updateData([
            "nickName": nickName,
        ])
    }

    func updateUserInfomationAsync(
        uidPath: String,
        userDM: UserDM
    ) async throws {
        let userRef = db.collection("User").document(uidPath)
        try await userRef.updateData([
            "id": userDM.id,
            "firstName": userDM.firstName,
            "lastName": userDM.lastName,
            "nickName": userDM.nickName,
            "mobileNumber": userDM.mobileNumber,
            "zipCode": userDM.zipCode,
            "city": userDM.city,
            "town": userDM.town,
            "address": userDM.address,
            "dob": userDM.dob,
//            "country": country,
            "gender": userDM.gender,
        ])
    }

    func createUserInfomationAsync(
        uidPath: String,
        userDM: UserDM
    ) async throws {
        let userRef = db.collection("User").document(uidPath)
        try await userRef.setData([
            "id" : userDM.id,
            "firstName" : userDM.firstName,
            "lastName" : userDM.lastName,
            "nickName" : userDM.nickName,
            "mobileNumber" : userDM.mobileNumber,
            "zipCode" : userDM.zipCode,
            "city" : userDM.city,
            "town" : userDM.town,
            "address" : userDM.address,
            "email" : userDM.email,
            "dob" : userDM.dob,
            "gender" : userDM.gender,
            "profileImageURL" : userDM.profileImageURL,
            "userType" : userDM.userType,
            "providerType" : userDM.providerType,

            // MARK: If is founder then create `providerDM` otherwise enter gui to join exist store

            "isFounder" : userDM.isFounder ?? false,
            "isEmployee" : userDM.isEmployee ?? false,

            // MARK: if user type is provider and `isFounder` is false then fill out the value

            "providerGUI" : userDM.providerGUI ?? "",
            "isSignByApple" : userDM.isSignByApple,
            "agreeAutoPay" : userDM.agreeAutoPay,
            "isRented" : userDM.isRented
        ])
        try await fetchUploadUserDataAsync()
    }

    func reloadUserData() async throws {
        try await fetchUploadUserDataAsync()
    }

    @MainActor
    func fetchUploadUserDataAsync() async throws {
        fetchedUserData = try await fetchUploadedUserDataAsync(uidPath: firebaseAuth.getUID())
//        self.userLastName = self.getUserLastName(lastName: self.fetchedUserData)
    }

    @MainActor
    private func fetchUploadedUserDataAsync(uidPath: String) async throws -> UserDM {
        let userRef = db.collection("User").document(uidPath)
        let userData = try await userRef.getDocument(as: UserDM.self)
        fetchedUserData = userData
        return fetchedUserData
    }

    // MARK: - Create and store information

    func registertRentedContract(
        uidPath: String,
        rentedRoom: RentedRoom
    ) async throws {
        let rentedRoomRef = db.collection("RentedRoom").document(uidPath)
        try await rentedRoomRef.setData([
            "rentedRoomUID": rentedRoom.rentedRoomUID,
            "rentedProvderUID": rentedRoom.rentedProvderUID,
            "depositFee": rentedRoom.depositFee,
            "paymentDate": Date(),
        ])
    }

    // MARK: - Get user rented contract detail and provider info

    @MainActor
    func getRentedContract(
        uidPath: String
    ) async throws {
        let rentedRoomRef = db.collection("RentedRoom").document(uidPath)
        rentedRoom = try await rentedRoomRef.getDocument(as: RentedRoom.self)
        let rentedRoomContractRef = rentedRoomRef.collection("Contract").document(rentedRoom.rentedRoomUID)
        rentedContract = try await rentedRoomContractRef.getDocument(as: HouseContract.self)
    }

    func summitRentedContractToUserData(
        uidPath: String,
        rented roomUID: String,
        hose contract: HouseContract
    ) async throws {
        let rentedRoomContractRef = db.collection("RentedRoom").document(uidPath).collection("Contract").document(roomUID)
        try await rentedRoomContractRef.setData([
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

//    @MainActor
//    func getSummittedContract(uidPath: String, rented roomUID: String) async throws -> HouseContract {
//        let rentedRoomContractRef = db.collection("RentedRoom").document(uidPath).collection("Contract").document(roomUID)
//        rentedContract = try await rentedRoomContractRef.getDocument(as: HouseContract.self)
//        return rentedContract
//    }

    func clearExpiredContract(uidPath: String, rented roomUID: String) async throws {
        let rentedRoomContractRef = db.collection("RentedRoom").document(uidPath).collection("Contract").document(roomUID)
        try await rentedRoomContractRef.delete()
    }
}

extension FirestoreToFetchUserinfo {
    // MARK: - Reload rented contract Data.

    func reloadUserDataTest(renterUID uidPath: String) async throws {
//        try await fetchUploadUserDataAsync()
//        userRentedRoomInfo()

        // MARK: "New Method" Reload rented contract

        let rentedRoomRef = db.collection("RentedRoom").document(uidPath)
        rentedRoom = try await rentedRoomRef.getDocument(as: RentedRoom.self)
    }
}

extension FirestoreToFetchUserinfo {
    func summitPaidInfo(
        uidPath: String,
        rentalPayment: RentedRoomPaymentHistory
    ) async throws {
        let paymentHistoryRef = db.collection("RentedRoom").document(uidPath).collection("PaymentHistory")
        _ = try await paymentHistoryRef.addDocument(data: [
            "pastPaymentFee": rentalPayment.rentalFee,
            "paymentDate": Date(),
            "note": rentalPayment.note ?? "",
        ])
    }

    @MainActor
    func fetchPaymentHistory(uidPath: String) async throws {
        let paymentHistoryRef = db.collection("User").document(uidPath).collection("PaymentHistory").order(by: "paymentDate", descending: false)
        let document = try await paymentHistoryRef.getDocuments().documents
        paymentHistory = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: RentedRoomPaymentHistory.self)
            }
            switch result {
            case let .success(data):
                return data
            case let .failure(error):
                print("error eccure: \(error)")
            }
            return nil
        }
    }
}

extension FirestoreToFetchUserinfo {
    func updateAutoPayAgreement(uidPath: String, agreement: Bool) async throws {
        let userRef = db.collection("User").document(uidPath)
        try await userRef.updateData([
            "agreeAutoPay": agreement,
        ])
    }
}

extension FirestoreToFetchUserinfo {
    func presentUserName() -> String {
        return presentUserName(input: fetchedUserData)
    }

    private func presentUserName(input: UserDM) -> String {
        let tempFirstName = input.firstName
        let tempLastName = input.lastName
        return tempFirstName + tempLastName
    }

    func checkRoosStatus(roomUID: String) throws {
        guard !roomUID.isEmpty else {
            throw UserInformationError.userRentalError
        }
    }

    func checkMaintainFilled(description: String, appointmentDate _: Date) throws {
        guard description.isEmpty || description != "Please describe what stuff needs to fix." else {
            throw MaintainError.maintianFillingError
        }
    }
}

// extension FirestoreToFetchUserinfo {

// MARK: - User rented room

//    func userRentedRoomInfo() {
//        rentingRoomInfo = dataInLocalRentedRoomInfo(input: fetchedUserData)
//    }
//    private func dataInLocalRentedRoomInfo(input: RentedRoom) {
//        let contractData = input.contract ?? nil
//        let roomUID = input.rentedRoomUID
//        let roomAddress = contractData?.roomAddress
//        let roomTown = contractData?.roomTown
//        let roomCity = contractData?.roomCity
//        let roomPrice = contractData?.roomRentalPrice
//        let roomZipCode = contractData?.roomZipCode
//        let providerUID = input.rentedProvderUID
//        self.rentingRoomInfo = RentedRoomInfo(roomUID: roomUID,
//                                                roomAddress: roomAddress,
//                                                roomTown: roomTown,
//                                                roomCity: roomCity,
//                                                roomPrice: roomPrice,
//                                                roomZipCode: roomZipCode,
//                                              roomImageCover: roomImageCover,
//                                              providerUID: providerUID
//                                               )
//    }

//    func getRoomUID() -> String {
//        var holderRoomUID = ""
//            holderRoomUID = getRoomUID(input: rentingRoomInfo)
//        return holderRoomUID
//    }
//    func getRoomUID(input: RentedRoomInfo) -> String {
//        var rentedRoomUID = ""
//        rentedRoomUID = input.roomUID ?? ""
//        return rentedRoomUID
//    }
//
//
//
// }

// extension FirestoreToFetchUserinfo {
// "Notice": haven't update method
//    func uploadOrder(uidPath: String, furnitureName: String, furniturePrice: String, orderName: String, orderShippingAddress: String) async throws {
//        let furnitureOrderRef = db.collection("FurnitureOrderList").document(uidPath).collection(uidPath)
//        _ = try await furnitureOrderRef.addDocument(data: [
//            "furnitureName" : furnitureName,
//            "furniturePrice" : furniturePrice,
//            "orderName" : orderName,
//            "orderShippingAddress" : orderShippingAddress
//        ])
//    }
// }

// extension FirestoreToFetchUserinfo {
/*
 //MARK: Upload the contact data to user's data set
 func uploadRentedRoomInfo(uidPath: String,
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
     let userRentedContractRef = db.collection("User").document(uidPath).collection("MyRoomContract").document(uidPath)
     try await userRentedContractRef.setData([
         "isSummitContract" : isSummitContract,
         //MARK: Contract's Data Model
         "contractBuildDate" : contractBuildDate,
         "contractReviewDays" : contractReviewDays,
         "providerSignurture" : providerSignurture,
         "renterSignurture" : renterSignurture,
         "companyTitle" : companyTitle,
         "roomAddress" : roomAddress,
         "roomTown" : roomTown,
         "roomCity" : roomCity,
         "roomZipCode" : roomZipCode,

         // MARK: 第一條 委託管理標的 - 房屋標示
         "specificBuildingNumber" : specificBuildingNumber, //專有部分建號
         "specificBuildingRightRange" : specificBuildingRightRange, //專有部分權利範圍
         "specificBuildingArea" : specificBuildingArea, //專有部分面積共計

         "mainBuildArea" : mainBuildArea, //主建物面積__層__平方公尺
         "mainBuildingPurpose" : mainBuildingPurpose, //主建物用途

         "subBuildingPurpose" : subBuildingPurpose, //附屬建物用途
         "subBuildingArea" : subBuildingArea, //附屬建物面積__平方公尺

         "publicBuildingNumber" : publicBuildingNumber, //共有部分建號
         "publicBuildingRightRange" : publicBuildingRightRange, //共有部分權利範圍
         "publicBuildingArea" : publicBuildingArea, //共有部分持分面積__平方公尺

         "hasParkinglot" : hasParkinglot, //車位-有無

         "isSettingTheRightForThirdPerson" : isSettingTheRightForThirdPerson, //設定他項權利-有無
         "settingTheRightForThirdPersonForWhatKind" : settingTheRightForThirdPersonForWhatKind, //權利種類

         "isBlockByBank" : isBlockByBank, //查封登記-有無

         // MARK: 第一條 委託管理標的 - 租賃範圍
         "provideForAll": provideForAll, //租賃住宅全部
         "provideForPart": provideForPart, //租賃住宅部分
         "provideFloor": provideFloor, //租賃住宅第__層
         "provideRooms": provideRooms, //租賃住宅房間__間
         "provideRoomNumber": provideRoomNumber, //租賃住宅第__室
         "provideRoomArea": provideRoomArea, //租賃住宅面積__平方公尺

         "isVehicle": isVehicle, //汽車停車位
         "isMorto": isMorto, //機車停車位
         "parkingUGFloor": parkingUGFloor, //地上(下)第__層
         "parkingStyleN": parkingStyleN, //平面式停車位
         "parkingStyleM": parkingStyleM, //機械式停車位
         "parkingNumberForVehicle": parkingNumberForVehicle, //編號第__號
         "parkingNumberForMortor": parkingNumberForMortor,
         "forAllday": forAllday, //使用時間全日
         "forMorning": forMorning, //使用時間日間
         "forNight": forNight, //使用時間夜間

         "havingSubFacility": havingSubFacility, //租賃附屬設備-有無

         // MARK: 第二條 租賃期間
         "rentalStartDate" : rentalStartDate, //委託管理期間自
         "rentalEndDate" : rentalEndDate, //委託管理期間至

         // MARK: 第三條 租金約定及支付
         "paymentdays": paymentdays, //每月__日前支付
         "paybyCash": paybyCash, //報酬約定及給付-現金繳付
         "paybyTransmission": paybyTransmission, //報酬約定及給付-轉帳繳付
         "paybyCreditDebitCard": paybyCreditDebitCard, //報酬約定及給付-信用卡/簽帳卡
         "bankName": bankName, //金融機構
         "bankOwnerName": bankOwnerName, //戶名
         "bankAccount": bankAccount, //帳號

         // MARK: 第五條 租賃期間相關費用之支付
         "payByRenterForManagementPart" : payByRenterForManagementPart, //承租人負擔
         "payByProviderForManagementPart" : payByProviderForManagementPart, //出租人負擔
         "managementFeeMonthly" : managementFeeMonthly, //房屋每月___元整
         "parkingFeeMonthly" : parkingFeeMonthly, //停車位每月___元整
         "additionalReqForManagementPart" : additionalReqForManagementPart,

         "payByRenterForWaterFee" : payByRenterForWaterFee, //承租人負擔
         "payByProviderForWaterFee" : payByProviderForWaterFee, //出租人負擔
         "additionalReqForWaterFeePart" : additionalReqForWaterFeePart,

         "payByRenterForEletricFee" : payByRenterForEletricFee, //承租人負擔
         "payByProviderForEletricFee" : payByProviderForEletricFee, //出租人負擔
         "additionalReqForEletricFeePart" : additionalReqForEletricFeePart,

         "payByRenterForGasFee" : payByRenterForGasFee, //承租人負擔
         "payByProviderForGasFee" : payByProviderForGasFee, //出租人負擔
         "additionalReqForGasFeePart" : additionalReqForGasFeePart,

         "additionalReqForOtherPart" : additionalReqForOtherPart, //其他費用及其支付方式

         // MARK: 第六條 稅費負擔之約定
         "contractSigurtureProxyFee" : contractSigurtureProxyFee,
         "payByRenterForProxyFee" : payByRenterForProxyFee, //承租人負擔
         "payByProviderForProxyFee" : payByProviderForProxyFee, //出租人負擔
         "separateForBothForProxyFee" : separateForBothForProxyFee, //雙方平均負擔

         "contractIdentitificationFee" : contractIdentitificationFee,
         "payByRenterForIDFFee" : payByRenterForIDFFee, //承租人負擔
         "payByProviderForIDFFee" : payByProviderForIDFFee, //出租人負擔
         "separateForBothForIDFFee" : separateForBothForIDFFee, //雙方平均負擔

         "contractIdentitificationProxyFee" : contractIdentitificationProxyFee ,
         "payByRenterForIDFProxyFee" : payByRenterForIDFProxyFee, //承租人負擔
         "payByProviderForIDFProxyFee" : payByProviderForIDFProxyFee, //出租人負擔
         "separateForBothForIDFProxyFee" : separateForBothForIDFProxyFee, //雙方平均負擔

         // MARK: 第七條 使用房屋之限制
         "subLeaseAgreement" : subLeaseAgreement,

         // MARK: 第十九條 其他約定
         "doCourtIDF" : doCourtIDF, //□辦理公證□不辦理公證
         "courtIDFDoc" : courtIDFDoc, //□不同意；□同意公證書

         // MARK: 立契約書人
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
     ])
 }
  */
// }

//    func presentUserId() -> String {
//        var userId = ""
//        userId = presentUserId(input: fetchedUserData)
//        return userId
//    }
//
//    private func presentUserId(input: UserDataModel) -> String {
//        var tempIdholder = ""
//        tempIdholder = input.id
//        return tempIdholder
//    }
//
//    func presentAddress() -> String {
//        var tempAddressHolder = ""
//        tempAddressHolder = presentAddress(input: fetchedUserData)
//        return tempAddressHolder
//    }
//
//    private func presentAddress(input: UserDataModel) -> String {
//        var tempAddressHolder = ""
//        var tempTownHolder = ""
//        var tempCityHolder = ""
//        var tempZipCodeHolder = ""
//        tempAddressHolder = input.address
//        tempTownHolder = input.town
//        tempCityHolder = input.city
//        tempZipCodeHolder = input.zip
//        return tempZipCodeHolder + tempCityHolder + tempTownHolder + tempAddressHolder
//    }
//
//    func presentMobileNumber() -> String {
//        var tempMobileNumberHolder = ""
//        tempMobileNumberHolder = presentMobileNumber(input: fetchedUserData)
//        return tempMobileNumberHolder
//    }
//
//    private func presentMobileNumber(input: UserDataModel) -> String {
//        var tempMobileNumberHolder = ""
//        tempMobileNumberHolder = input.mobileNumber
//        return tempMobileNumberHolder
//    }
//
//    func presentEmailAddress() -> String {
//        var tempEmailAddress = ""
//        tempEmailAddress = presentEmailAddress(input: fetchedUserData)
//        return tempEmailAddress
//    }
//
//    private func presentEmailAddress(input: UserDataModel) -> String {
//        var tempEmailAddress = ""
//        tempEmailAddress = input.emailAddress ?? ""
//        return tempEmailAddress
//    }

//    private func getUserLastName(lastName: UserDataModel) -> String{
//        var tempLastNameHolder = ""
//        tempLastNameHolder = lastName.displayName
//        return tempLastNameHolder
//    }
//
//    func getUserType(input: UserDataModel) -> String {
//        var tempHolder = ""
//        tempHolder = input.userType
//        return tempHolder
//    }

//    func evaluateProviderType() -> String {
//        var tempHoler = ""
//        tempHoler = evaluateProviderType(input: fetchedUserData)
//        return tempHoler
//    }
//
//    private func evaluateProviderType(input: UserDataModel) -> String {
//        var tempHolder = ""
//        tempHolder = input.providerType
//        return tempHolder
//    }
//
//
