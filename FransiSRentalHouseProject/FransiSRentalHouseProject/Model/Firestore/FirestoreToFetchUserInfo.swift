//
//  FirestoreToFetchUserInfo.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/1/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth



class FirestoreToFetchUserinfo: ObservableObject {
    
    let firebaseAuth = FirebaseAuth()
    let db = Firestore.firestore()
    
    
    @Published var rentedContract: RentersContractDataModel = .empty
    @Published var fetchedUserData: UserDataModel = .empty
    @Published var rentingRoomInfo: RentedRoomInfo = .empty
    @Published var userLastName = ""
    @Published var paymentHistory = [PaymentHistoryDataModel]()
    
    private func getUserLastName(lastName: UserDataModel) -> String{
        var tempLastNameHolder = ""
        tempLastNameHolder = lastName.displayName
        return tempLastNameHolder
    }
    
    func getUserType(input: UserDataModel) -> String {
        var tempHolder = ""
        tempHolder = input.userType 
        return tempHolder
    }
    
    
    
    func evaluateProviderType() -> String {
        var tempHoler = ""
        tempHoler = evaluateProviderType(input: fetchedUserData)
        return tempHoler
    }
    
    private func evaluateProviderType(input: UserDataModel) -> String {
        var tempHolder = ""
        tempHolder = input.providerType
        return tempHolder
    }
    
    func presentUserName() -> String {
        var userName = ""
        userName = presentUserName(input: fetchedUserData)
        return userName
    }
    
    private func presentUserName(input: UserDataModel) -> String {
        var tempFirstName = ""
        var tempLastName = ""
        tempFirstName = input.firstName
        tempLastName = input.lastName
        return tempFirstName + tempLastName
    }
    
    func presentUserId() -> String {
        var userId = ""
        userId = presentUserId(input: fetchedUserData)
        return userId
    }
    
    private func presentUserId(input: UserDataModel) -> String {
        var tempIdholder = ""
        tempIdholder = input.id
        return tempIdholder
    }
    
    func presentAddress() -> String {
        var tempAddressHolder = ""
        tempAddressHolder = presentAddress(input: fetchedUserData)
        return tempAddressHolder
    }
    
    private func presentAddress(input: UserDataModel) -> String {
        var tempAddressHolder = ""
        var tempTownHolder = ""
        var tempCityHolder = ""
        var tempZipCodeHolder = ""
        tempAddressHolder = input.address
        tempTownHolder = input.town
        tempCityHolder = input.city
        tempZipCodeHolder = input.zip
        return tempZipCodeHolder + tempCityHolder + tempTownHolder + tempAddressHolder
    }
    
    func presentMobileNumber() -> String {
        var tempMobileNumberHolder = ""
        tempMobileNumberHolder = presentMobileNumber(input: fetchedUserData)
        return tempMobileNumberHolder
    }
    
    private func presentMobileNumber(input: UserDataModel) -> String {
        var tempMobileNumberHolder = ""
        tempMobileNumberHolder = input.mobileNumber
        return tempMobileNumberHolder
    }
    
    func presentEmailAddress() -> String {
        var tempEmailAddress = ""
        tempEmailAddress = presentEmailAddress(input: fetchedUserData)
        return tempEmailAddress
    }
    
    private func presentEmailAddress(input: UserDataModel) -> String {
        var tempEmailAddress = ""
        tempEmailAddress = input.emailAddress ?? ""
        return tempEmailAddress
    }
    
    func notRented() -> Bool {
        return fetchedUserData.rentedRoomInfo?.roomUID?.isEmpty ?? false
    }
    
    
}

extension FirestoreToFetchUserinfo {
    func userRentedRoomInfo() {
        rentingRoomInfo = dataInLocalRentedRoomInfo(input: fetchedUserData)
    }
    private func dataInLocalRentedRoomInfo(input: UserDataModel) -> RentedRoomInfo {
        let roomUID = input.rentedRoomInfo?.roomUID
        let roomAddress = input.rentedRoomInfo?.roomAddress
        let roomTown = input.rentedRoomInfo?.roomTown
        let roomCity = input.rentedRoomInfo?.roomCity
        let roomPrice = input.rentedRoomInfo?.roomPrice
        let roomZipCode = input.rentedRoomInfo?.roomZipCode
        let roomImageCover = input.rentedRoomInfo?.roomImageCover
        let providerUID = input.rentedRoomInfo?.providerUID
        self.rentingRoomInfo = RentedRoomInfo(roomUID: roomUID,
                                                roomAddress: roomAddress,
                                                roomTown: roomTown,
                                                roomCity: roomCity,
                                                roomPrice: roomPrice,
                                                roomZipCode: roomZipCode,
                                              roomImageCover: roomImageCover,
                                              providerUID: providerUID
                                               )
        return rentingRoomInfo
    }
    
    func getRoomUID() -> String {
        var holderRoomUID = ""
            holderRoomUID = getRoomUID(input: rentingRoomInfo)
        return holderRoomUID
    }
    func getRoomUID(input: RentedRoomInfo) -> String {
        var rentedRoomUID = ""
        rentedRoomUID = input.roomUID ?? ""
        return rentedRoomUID
    }
    
    func checkRoosStatus(roomUID: String) throws {
        guard !roomUID.isEmpty else {
            throw UserInformationError.userRentalError
        }
    }
    func checkMaintainFilled(description: String, appointmentDate: Date) throws {
        guard description.isEmpty || description != "Please describe what stuff needs to fix." else {
            throw MaintainError.maintianFillingError
        }
    }
}

extension FirestoreToFetchUserinfo {
    
    func updateDisplayName(uidPath: String, displayName: String) async throws {
        let userRef = db.collection("users").document(uidPath)
        try await userRef.updateData([
            "displayName" : displayName
        ])
    }
    
    func updateUserInfomationAsync(uidPath: String, id: String , firstName: String, lastName: String, mobileNumber: String, dob: Date, address: String, town: String, city: String, zip: String, country: String, gender: String, userType: String, emailAddress: String?, providerType: String = "House Owner", RLNumber: String? = "", displayName: String) async throws {
        let userRef = db.collection("users").document(uidPath)
        try await userRef.updateData([
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
            "displayName" : displayName,
            "mobileNumber": mobileNumber,
            "dob": dob,
            "address": address,
            "town": town,
            "city": city,
            "zip": zip,
            "country": country,
            "gender": gender
        ])
    }
    
    func createUserInfomationAsync(uidPath: String, id: String , firstName: String, lastName: String, displayName: String, mobileNumber: String, dob: Date, address: String, town: String, city: String, zip: String, country: String, gender: String, userType: String, emailAddress: String?, providerType: String, RLNumber: String? = "") async throws {
        let userRef = db.collection("users").document(uidPath)
            try await userRef.setData([
                "id": id,
                "firstName": firstName,
                "lastName": lastName,
                "displayName" : displayName,
                "mobileNumber": mobileNumber,
                "dob": dob,
                "address": address,
                "town": town,
                "city": city,
                "zip": zip,
                "country": country,
                "gender": gender,
                "userType": userType,
                "providerType": providerType,
                "rentalManagerLicenseNumber": RLNumber ?? "",
                "emailAddress": emailAddress ?? "",
                "agreeAutoPay" : false,
                "rentedRoomInfo": [
                    "roomUID" : "",
                    "roomAddress" : "",
                    "roomTown" : "",
                    "roomCity" : "",
                    "roomPrice" : "",
                    "roomImageCover" : "",
                    "providerUID" : "",
                    "rentalDepositFee": [
                        "paymentDate": Date(),
                        "depositFee": ""
                    ]
                ]
            ])
    }
    
    
    
    
    func reloadUserData() async throws {
        try await fetchUploadUserDataAsync()
    }
    
    
    func fetchUploadUserDataAsync() async throws {
        fetchedUserData = try await fetchUploadedUserDataAsync(uidPath: firebaseAuth.getUID())
        self.userLastName = self.getUserLastName(lastName: self.fetchedUserData)
    }
    
    @MainActor
    private func fetchUploadedUserDataAsync(uidPath: String) async throws -> UserDataModel {
        let userRef = db.collection("users").document(uidPath)
        let userData = try await userRef.getDocument(as: UserDataModel.self)
        self.fetchedUserData = userData
        return fetchedUserData
    }
    
    func updateUserInformationAsync(uidPath: String, roomID: String = "", roomImage: String, roomAddress: String, roomTown: String, roomCity: String, roomPrice: String, roomZipCode: String, providerUID: String, depositFee: String, paymentDate: Date) async throws {
        let userRef = db.collection("users").document(uidPath)
        try await userRef.updateData([
            "rentedRoomInfo.roomUID" : roomID,
            "rentedRoomInfo.roomAddress" : roomAddress,
            "rentedRoomInfo.roomTown" : roomTown,
            "rentedRoomInfo.roomCity" : roomCity,
            "rentedRoomInfo.roomPrice" : roomPrice,
            "rentedRoomInfo.roomZipCode" : roomZipCode,
            "rentedRoomInfo.roomImageCover" : roomImage,
            "rentedRoomInfo.providerUID" : providerUID,
            "rentedRoomInfo.rentalDepositFee.depositFee" : depositFee,
            "rentedRoomInfo.rentalDepositFee.paymentDate" : paymentDate
        ])
    }
    
}

extension FirestoreToFetchUserinfo {
    func reloadUserDataTest() async throws {
        try await fetchUploadUserDataAsync()
        userRentedRoomInfo()
    }
}


extension FirestoreToFetchUserinfo {
    func summitPaidInfo(uidPath: String, rentalPrice: String, date: Date) async throws {
        let paymentHistoryRef = db.collection("users").document(uidPath).collection("PaymentHistory")
        _ = try await paymentHistoryRef.addDocument(data: [
            "pastPaymentFee" : rentalPrice,
            "paymentDate" : date
        ])
        
    }
    
    @MainActor
    func fetchPaymentHistory(uidPath: String) async throws {
        let paymentHistoryRef = db.collection("users").document(uidPath).collection("PaymentHistory").order(by: "paymentDate", descending: false)
        let document = try await paymentHistoryRef.getDocuments().documents
        self.paymentHistory = document.compactMap { queryDocumentSnapshot in
            let result = Result {
                try queryDocumentSnapshot.data(as: PaymentHistoryDataModel.self)
            }
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                print("error eccure: \(error)")
            }
            return nil
        }
    }
}

extension FirestoreToFetchUserinfo {
    func uploadOrder(uidPath: String, furnitureName: String, furniturePrice: String, orderName: String, orderShippingAddress: String) async throws {
        let furnitureOrderRef = db.collection("FurnitureOrderList").document(uidPath).collection(uidPath)
        _ = try await furnitureOrderRef.addDocument(data: [
            "furnitureName" : furnitureName,
            "furniturePrice" : furniturePrice,
            "orderName" : orderName,
            "orderShippingAddress" : orderShippingAddress
        ])
    }
}

extension FirestoreToFetchUserinfo {
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
        let userRentedContractRef = db.collection("users").document(uidPath).collection("MyRoomContract").document(uidPath)
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
}

extension FirestoreToFetchUserinfo {
    func summitRentedContractToUserData(uidPath: String,
                                        docID: String,
                                        isSummitContract: Bool,
                                        contractBuildDate: Date,
                                        contractReviewDays:String,
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
                                        sigurtureDate: Date
    ) async throws {
        let userRentedContractRef = db.collection("users").document(uidPath).collection("MyRoomContract").document(uidPath)
        try await userRentedContractRef.setData([
            "docID" : docID,
            "isSummitContract" : isSummitContract,
            "contractBuildDate": contractBuildDate,
            "contractReviewDays": contractReviewDays,
            "providerSignurture": providerSignurture,
            "renterSignurture": renterSignurture,
            "companyTitle": companyTitle,
            "roomAddress": roomAddress,
            "roomTown": roomTown,
            "roomCity": roomCity,
            "roomZipCode": roomZipCode,
            "specificBuildingNumber": specificBuildingNumber,
            "specificBuildingRightRange": specificBuildingRightRange,
            "specificBuildingArea": specificBuildingArea,
            "mainBuildArea": mainBuildArea,
            "mainBuildingPurpose": mainBuildingPurpose,
            "subBuildingPurpose": subBuildingPurpose,
            "subBuildingArea": subBuildingArea,
            "publicBuildingNumber": publicBuildingNumber,
            "publicBuildingRightRange": publicBuildingRightRange,
            "publicBuildingArea": publicBuildingArea,
            "hasParkinglot": hasParkinglot,
            "isSettingTheRightForThirdPerson": isSettingTheRightForThirdPerson,
            "settingTheRightForThirdPersonForWhatKind": settingTheRightForThirdPersonForWhatKind,
            "isBlockByBank": isBlockByBank,
            "provideForAll": provideForAll,
            "provideForPart": provideForPart,
            "provideFloor": provideFloor,
            "provideRooms": provideRooms,
            "provideRoomNumber": provideRoomNumber,
            "provideRoomArea": provideRoomArea,
            "isVehicle": isVehicle,
            "isMorto": isMorto,
            "parkingUGFloor": parkingUGFloor,
            "parkingStyleN": parkingStyleN,
            "parkingStyleM": parkingStyleM,
            "parkingNumberForVehicle": parkingNumberForVehicle,
            "parkingNumberForMortor": parkingNumberForMortor,
            "forAllday": forAllday,
            "forMorning": forMorning,
            "forNight": forNight,
            "havingSubFacility": havingSubFacility,
            "rentalStartDate": rentalStartDate,
            "rentalEndDate": rentalEndDate,
            "roomRentalPrice": roomRentalPrice,
            "paymentdays": paymentdays,
            "paybyCash": paybyCash,
            "paybyTransmission": paybyTransmission,
            "paybyCreditDebitCard": paybyCreditDebitCard,
            "bankName": bankName,
            "bankOwnerName": bankOwnerName,
            "bankAccount": bankAccount,
            "payByRenterForManagementPart": payByRenterForManagementPart,
            "payByProviderForManagementPart": payByProviderForManagementPart,
            "managementFeeMonthly": managementFeeMonthly,
            "parkingFeeMonthly": parkingFeeMonthly,
            "additionalReqForManagementPart": additionalReqForManagementPart,
            "payByRenterForWaterFee": payByRenterForWaterFee,
            "payByProviderForWaterFee": payByProviderForWaterFee,
            "additionalReqForWaterFeePart": additionalReqForWaterFeePart,
            "payByRenterForEletricFee": payByRenterForEletricFee,
            "payByProviderForEletricFee": payByProviderForEletricFee,
            "additionalReqForEletricFeePart": additionalReqForEletricFeePart,
            "payByRenterForGasFee": payByRenterForGasFee,
            "payByProviderForGasFee": payByProviderForGasFee,
            "additionalReqForGasFeePart": additionalReqForGasFeePart,
            "additionalReqForOtherPart": additionalReqForOtherPart,
            "contractSigurtureProxyFee": contractSigurtureProxyFee,
            "payByRenterForProxyFee": payByRenterForProxyFee,
            "payByProviderForProxyFee": payByProviderForProxyFee,
            "separateForBothForProxyFee": separateForBothForProxyFee,
            "contractIdentitificationFee": contractIdentitificationFee,
            "payByRenterForIDFFee": payByRenterForIDFFee,
            "payByProviderForIDFFee": payByProviderForIDFFee,
            "separateForBothForIDFFee": separateForBothForIDFFee,
            "contractIdentitificationProxyFee": contractIdentitificationProxyFee,
            "payByRenterForIDFProxyFee": payByRenterForIDFProxyFee,
            "payByProviderForIDFProxyFee": payByProviderForIDFProxyFee,
            "separateForBothForIDFProxyFee": separateForBothForIDFProxyFee,
            "subLeaseAgreement": subLeaseAgreement,
            "doCourtIDF": doCourtIDF,
            "courtIDFDoc": courtIDFDoc,
            "providerName": providerName,
            "providerID": providerID,
            "providerResidenceAddress": providerResidenceAddress,
            "providerMailingAddress": providerMailingAddress,
            "providerPhoneNumber": providerPhoneNumber,
            "providerPhoneChargeName": providerPhoneChargeName,
            "providerPhoneChargeID": providerPhoneChargeID,
            "providerPhoneChargeEmailAddress": providerPhoneChargeEmailAddress,
            "renterName": renterName,
            "renterID": renterID,
            "renterResidenceAddress": renterResidenceAddress,
            "renterMailingAddress": renterMailingAddress,
            "renterPhoneNumber": renterPhoneNumber,
            "renterEmailAddress": renterEmailAddress,
            "sigurtureDate": sigurtureDate
        ])
    }
    
    @MainActor
    func getSummittedContract(uidPath: String) async throws -> RentersContractDataModel {
        let userContractRef = db.collection("users").document(uidPath).collection("MyRoomContract").document(uidPath)
        rentedContract = try await userContractRef.getDocument(as: RentersContractDataModel.self)
        return rentedContract
    }
}

extension FirestoreToFetchUserinfo {
    func clearExpiredContract(uidPath: String) async throws {
        let userContractRef = db.collection("users").document(uidPath).collection("MyRoomContract").document(uidPath)
        try await userContractRef.delete()
    }
}


extension FirestoreToFetchUserinfo {
    func updateAutoPayAgreement(uidPath: String, agreement: Bool) async throws {
        let userRef = db.collection("users").document(uidPath)
        try await userRef.updateData([
            "agreeAutoPay" : agreement
        ])
    }
}
