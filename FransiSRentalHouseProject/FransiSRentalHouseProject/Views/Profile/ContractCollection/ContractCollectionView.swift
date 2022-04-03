//
//  ContractCollectionView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/9/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContractCollectionView: View {
    
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData

    @State private var showDetail = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea(.all)
            VStack {
                TitleAndDivider(title: "Contract Collection")
                Spacer()
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(firestoreToFetchRoomsData.fetchRoomInfoFormOwner) { roomInfo in
                        NavigationLink {
                            RenterContractView(roomsData: roomInfo)
                        } label: {
                            ContractReusableUnit(showDetail: $showDetail, roomAddress: roomInfo.roomAddress, roomTown: roomInfo.town, roomCity: roomInfo.city, roomZipCode: roomInfo.zipCode, renter: roomInfo.rentedBy ?? "", roomImage: roomInfo.roomImage ?? "")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}



struct ContractReusableUnit: View {
    
    @Binding var showDetail: Bool
    
    var roomAddress: String = ""
    var roomTown: String = ""
    var roomCity: String = ""
    var roomZipCode: String = ""
    var renter: String
    var roomImage: String
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    func address() -> String {
        var tempAddressHolder = ""
        tempAddressHolder = address(roomAddress: roomAddress, roomTown: roomTown, roomCity: roomCity, roomZipCode: roomZipCode)
        return tempAddressHolder
    }
    
   private func address(roomAddress: String, roomTown: String, roomCity: String, roomZipCode: String) -> String {
        return roomZipCode + roomCity + roomTown + roomAddress
    }
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Image(systemName: "photo")
                        .font(.system(size: 50))
                        .frame(width: 130, height: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.brown)
                        )
                    WebImage(url: URL(string: roomImage))
                        .resizable()
                        .frame(width: 130, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Spacer()
                    .frame(width: uiScreenWidth - 200)
            }
            VStack(spacing: 3) {
                HStack {
                    Text("Address: ")
                    Text("\(address())")
                    Spacer()
                }
                .padding(.leading)
                .padding(.top, 3)
                HStack {
                    Text("Renter: ")
                    Text(renter)
                    Spacer()
                }
                .padding(.leading)
            }
//            HStack {
//                Spacer()
//                    .frame(width: uiScreenWidth - 50)
//                Button {
//                    withAnimation {
//                        showDetail.toggle()
//                    }
//                } label: {
//                    Image(systemName: "arrow.right.circle.fill")
//                        .resizable()
//                        .foregroundColor(Color("buttonBlue"))
//                        .frame(width: 25, height: 25, alignment: .trailing)
////                        .rotationEffect(showDetail ? .degrees(45) : .degrees(0))
//                }
//            }
//            .padding(.trailing)
            Spacer()
        }
        .frame(width: uiScreenWidth - 20, height: uiScreenHeight - 700)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("fieldGray"))
                .frame(width: uiScreenWidth - 30, height: uiScreenHeight - 750)
        }
    }
}

struct ContractCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ContractCollectionView()
    }
}


/*
 RenterContractView(docId: roomInfo.docID ?? "",
                    isSummitContract: contractData.isSummitContract ?? false,
                    contractBuildDate: contractData.contractBuildDate ?? Date(),
                    contractReviewDays: contractData.contractReviewDays ?? "",
                    providerSignurture: contractData.providerSignurture ?? "",
                    renterSignurture: contractData.renterSignurture ?? "",
                    companyTitle: contractData.companyTitle ?? "",
                    roomAddress: contractData.roomAddress ?? "",
                    roomTown: contractData.roomTown ?? "",
                    roomCity: contractData.roomCity ?? "",
                    roomZipCode: contractData.roomZipCode ?? "",
                    specificBuildingNumber: contractData.specificBuildingNumber ?? "",
                    specificBuildingRightRange: contractData.specificBuildingRightRange ?? "",
                    specificBuildingArea: contractData.specificBuildingArea ?? "",
                    mainBuildArea: contractData.mainBuildArea ?? "",
                    mainBuildingPurpose: contractData.mainBuildingPurpose ?? "",
                    subBuildingPurpose: contractData.subBuildingPurpose ?? "",
                    subBuildingArea: contractData.subBuildingArea ?? "",
                    publicBuildingNumber: contractData.publicBuildingNumber ?? "",
                    publicBuildingRightRange: contractData.publicBuildingRightRange ?? "",
                    publicBuildingArea: contractData.publicBuildingArea ?? "",
                    hasParkinglotYes: contractData.hasParkinglotYes ?? false,
                    hasParkinglotNo: contractData.hasParkinglotNo ?? false,
                    parkinglotAmount: contractData.parkinglotAmount ?? "",
                    isSettingTheRightForThirdPersonYes: contractData.isSettingTheRightForThirdPersonYes ?? false,
                    isSettingTheRightForThirdPersonNo: contractData.isSettingTheRightForThirdPersonNo ?? false,
                    SettingTheRightForThirdPersonForWhatKind: contractData.SettingTheRightForThirdPersonForWhatKind ?? "",
                    isBlockByBankYes: contractData.isBlockByBankYes ?? false,
                    isBlockByBankNo: contractData.isBlockByBankNo ?? false,
                    provideForAll: contractData.provideForAll ?? false,
                    provideForPart: contractData.provideForPart ?? false,
                    provideFloor: contractData.provideFloor ?? "",
                    provideRooms: contractData.provideRooms ?? "",
                    provideRoomNumber: contractData.provideRoomNumber ?? "",
                    provideRoomArea: contractData.provideRoomArea ?? "",
                    isVehicle: contractData.isVehicle ?? false,
                    isMorto: contractData.isMorto ?? false,
                    isBoth: contractData.isBoth ?? false,
                    parkingUGFloor: contractData.parkingUGFloor ?? "",
                    parkingStyleN: contractData.parkingStyleN ?? false,
                    parkingStyleM: contractData.parkingStyleM ?? false,
                    parkingNumberForVehicle: contractData.parkingNumberForVehicle ?? "",
                    parkingNumberForMortor: contractData.parkingNumberForMortor ?? "",
                    forAllday: contractData.forAllday ?? false,
                    forMorning: contractData.forMorning ?? false,
                    forNight: contractData.forNight ?? false,
                    havingSubFacilityYes: contractData.havingSubFacilityYes ?? false,
                    havingSubFacilityNo: contractData.havingSubFacilityNo ?? false,
                    rentalStartDate: contractData.rentalStartDate ?? Date(),
                    rentalEndDate: contractData.rentalEndDate ?? Date(),
                    rentalPrice: contractData.rentalPrice ?? "",
                    paymentdays: contractData.paymentdays ?? "",
                    paybyCash: contractData.paybyCash ?? false,
                    paybyTransmission: contractData.paybyTransmission ?? false,
                    paybyCreditDebitCard: contractData.paybyCreditDebitCard ?? false,
                    bankName: contractData.bankName ?? "",
                    bankOwnerName: contractData.bankOwnerName ?? "",
                    bankAccount: contractData.bankAccount ?? "",
                    payByRenterForManagementPart: contractData.payByRenterForManagementPart ?? false,
                    payByProviderForManagementPart: contractData.payByProviderForManagementPart ?? false,
                    managementFeeMonthly: contractData.managementFeeMonthly ?? "",
                    parkingFeeMonthly: contractData.parkingFeeMonthly ?? "",
                    additionalReqForManagementPart: contractData.additionalReqForManagementPart ?? "",
                    payByRenterForWaterFee: contractData.payByRenterForWaterFee ?? false,
                    payByProviderForWaterFee: contractData.payByProviderForWaterFee ?? false,
                    additionalReqForWaterFeePart: contractData.additionalReqForWaterFeePart ?? "",
                    payByRenterForEletricFee: contractData.payByRenterForEletricFee ?? false,
                    payByProviderForEletricFee: contractData.payByProviderForEletricFee ?? false,
                    additionalReqForEletricFeePart: contractData.additionalReqForEletricFeePart ?? "",
                    payByRenterForGasFee: contractData.payByRenterForGasFee ?? false,
                    payByProviderForGasFee: contractData.payByProviderForGasFee ?? false,
                    additionalReqForGasFeePart: contractData.additionalReqForGasFeePart ?? "",
                    additionalReqForOtherPart: contractData.additionalReqForOtherPart ?? "",
                    contractSigurtureProxyFee: contractData.contractSigurtureProxyFee ?? "",
                    payByRenterForProxyFee: contractData.payByRenterForProxyFee ?? false,
                    payByProviderForProxyFee: contractData.payByProviderForProxyFee ?? false,
                    separateForBothForProxyFee: contractData.separateForBothForProxyFee ?? false,
                    contractIdentitificationFee: contractData.contractIdentitificationFee ?? "",
                    payByRenterForIDFFee: contractData.payByRenterForIDFFee ?? false,
                    payByProviderForIDFFee: contractData.payByProviderForIDFFee ?? false,
                    separateForBothForIDFFee: contractData.separateForBothForIDFFee ?? false,
                    contractIdentitificationProxyFee: contractData.contractIdentitificationProxyFee ?? "",
                    payByRenterForIDFProxyFee: contractData.payByRenterForIDFProxyFee ?? false,
                    payByProviderForIDFProxyFee: contractData.payByProviderForIDFProxyFee ?? false,
                    separateForBothForIDFProxyFee: contractData.separateForBothForIDFProxyFee ?? false,
                    subLeaseAgreement: contractData.subLeaseAgreement ?? false,
                    contractSendbyEmail: contractData.contractSendbyEmail ?? false,
                    contractSendbyTextingMessage: contractData.contractSendbyTextingMessage ?? false,
                    contractSendbyMessageSoftware: contractData.contractSendbyMessageSoftware ?? false,
                    doCourtIDF: contractData.doCourtIDF ?? false,
                    courtIDFDoc: contractData.courtIDFDoc ?? false,
                    providerName: contractData.providerName ?? "",
                    providerID: contractData.providerID ?? "",
                    providerResidenceAddress: contractData.providerResidenceAddress ?? "",
                    providerMailingAddress: contractData.providerMailingAddress ?? "",
                    providerPhoneNumber: contractData.providerPhoneNumber ?? "",
                    providerPhoneChargeName: contractData.providerPhoneChargeName ?? "",
                    providerPhoneChargeID: contractData.providerPhoneChargeID ?? "",
                    providerPhoneChargeEmailAddress: contractData.providerPhoneChargeEmailAddress ?? "",
                    renterName: contractData.renterName ?? "",
                    renterID: contractData.renterID ?? "",
                    renterResidenceAddress: contractData.renterResidenceAddress ?? "",
                    renterMailingAddress: contractData.renterMailingAddress ?? "",
                    renterPhoneNumber: contractData.renterPhoneNumber ?? "",
                    renterEmailAddress: contractData.renterEmailAddress ?? "",
                    sigurtureDate: contractData.sigurtureDate ?? Date())
*/
