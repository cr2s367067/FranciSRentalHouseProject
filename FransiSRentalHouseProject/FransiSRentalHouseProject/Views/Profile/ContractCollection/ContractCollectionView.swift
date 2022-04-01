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
                            RenterContractView(docId: roomInfo.docID ?? "",
                                               isSummitContract: roomInfo.rentersContractData?.isSummitContract ?? false,
                                               contractBuildDate: roomInfo.rentersContractData?.contractBuildDate ?? Date(),
                                               contractReviewDays: <#T##String#>,
                                               providerSignurture: <#T##String#>,
                                               renterSignurture: <#T##String#>,
                                               companyTitle: <#T##String#>,
                                               roomAddress: <#T##String#>,
                                               roomTown: <#T##String#>,
                                               roomCity: <#T##String#>,
                                               roomZipCode: <#T##String#>,
                                               specificBuildingNumber: <#T##String#>,
                                               specificBuildingRightRange: <#T##String#>,
                                               specificBuildingArea: <#T##String#>,
                                               mainBuildArea: <#T##String#>,
                                               mainBuildingPurpose: <#T##String#>,
                                               subBuildingPurpose: <#T##String#>,
                                               subBuildingArea: <#T##String#>,
                                               publicBuildingNumber: <#T##String#>,
                                               publicBuildingRightRange: <#T##String#>,
                                               publicBuildingArea: <#T##String#>,
                                               hasParkinglotYes: <#T##Bool#>,
                                               hasParkinglotNo: <#T##Bool#>,
                                               parkinglotAmount: <#T##String#>,
                                               isSettingTheRightForThirdPersonYes: <#T##Bool#>,
                                               isSettingTheRightForThirdPersonNo: <#T##Bool#>,
                                               SettingTheRightForThirdPersonForWhatKind: <#T##String#>,
                                               isBlockByBankYes: <#T##Bool#>,
                                               isBlockByBankNo: <#T##Bool#>,
                                               provideForAll: <#T##Bool#>,
                                               provideForPart: <#T##Bool#>,
                                               provideFloor: <#T##String#>,
                                               provideRooms: <#T##String#>,
                                               provideRoomNumber: <#T##String#>,
                                               provideRoomArea: <#T##String#>,
                                               isVehicle: <#T##Bool#>,
                                               isMorto: <#T##Bool#>,
                                               isBoth: <#T##Bool#>,
                                               parkingUGFloor: <#T##String#>,
                                               parkingStyleN: <#T##Bool#>,
                                               parkingStyleM: <#T##Bool#>,
                                               parkingNumberForVehicle: <#T##String#>,
                                               parkingNumberForMortor: <#T##String#>,
                                               forAllday: <#T##Bool#>,
                                               forMorning: <#T##Bool#>,
                                               forNight: <#T##Bool#>,
                                               havingSubFacilityYes: <#T##Bool#>,
                                               havingSubFacilityNo: <#T##Bool#>,
                                               rentalStartDate: <#T##Date#>,
                                               rentalEndDate: <#T##Date#>,
                                               rentalPrice: <#T##String#>,
                                               paymentdays: <#T##String#>,
                                               paybyCash: <#T##Bool#>,
                                               paybyTransmission: <#T##Bool#>,
                                               paybyCreditDebitCard: <#T##Bool#>,
                                               bankName: <#T##String#>, bankOwnerName: <#T##String#>,
                                               bankAccount: <#T##String#>,
                                               payByRenterForManagementPart: <#T##Bool#>,
                                               payByProviderForManagementPart: <#T##Bool#>,
                                               managementFeeMonthly: <#T##String#>,
                                               parkingFeeMonthly: <#T##String#>,
                                               additionalReqForManagementPart: <#T##String#>,
                                               payByRenterForWaterFee: <#T##Bool#>,
                                               payByProviderForWaterFee: <#T##Bool#>,
                                               additionalReqForWaterFeePart: <#T##String#>,
                                               payByRenterForEletricFee: <#T##Bool#>,
                                               payByProviderForEletricFee: <#T##Bool#>,
                                               additionalReqForEletricFeePart: <#T##String#>,
                                               payByRenterForGasFee: <#T##Bool#>,
                                               payByProviderForGasFee: <#T##Bool#>,
                                               additionalReqForGasFeePart: <#T##String#>,
                                               additionalReqForOtherPart: <#T##String#>,
                                               contractSigurtureProxyFee: <#T##String#>,
                                               payByRenterForProxyFee: <#T##Bool#>,
                                               payByProviderForProxyFee: <#T##Bool#>,
                                               separateForBothForProxyFee: <#T##Bool#>,
                                               contractIdentitificationFee: <#T##String#>,
                                               payByRenterForIDFFee: <#T##Bool#>,
                                               payByProviderForIDFFee: <#T##Bool#>,
                                               separateForBothForIDFFee: <#T##Bool#>,
                                               contractIdentitificationProxyFee: <#T##String#>,
                                               payByRenterForIDFProxyFee: <#T##Bool#>,
                                               payByProviderForIDFProxyFee: <#T##Bool#>,
                                               separateForBothForIDFProxyFee: <#T##Bool#>,
                                               subLeaseAgreement: <#T##Bool#>,
                                               contractSendbyEmail: <#T##Bool#>,
                                               contractSendbyTextingMessage: <#T##Bool#>,
                                               contractSendbyMessageSoftware: <#T##Bool#>,
                                               doCourtIDF: <#T##Bool#>,
                                               courtIDFDoc: <#T##Bool#>,
                                               providerName: <#T##String#>,
                                               providerID: <#T##String#>,
                                               providerResidenceAddress: <#T##String#>,
                                               providerMailingAddress: <#T##String#>,
                                               providerPhoneNumber: <#T##String#>,
                                               providerPhoneChargeName: <#T##String#>,
                                               providerPhoneChargeID: <#T##String#>,
                                               providerPhoneChargeEmailAddress: <#T##String#>,
                                               renterName: <#T##String#>,
                                               renterID: <#T##String#>,
                                               renterResidenceAddress: <#T##String#>,
                                               renterMailingAddress: <#T##String#>,
                                               renterPhoneNumber: <#T##String#>,
                                               renterEmailAddress: <#T##String#>,
                                               sigurtureDate: <#T##Date#>)
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
            HStack {
                Spacer()
                    .frame(width: uiScreenWidth - 50)
                Button {
                    withAnimation {
                        showDetail.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .foregroundColor(Color("buttonBlue"))
                        .frame(width: 25, height: 25, alignment: .trailing)
//                        .rotationEffect(showDetail ? .degrees(45) : .degrees(0))
                }
            }
            .padding(.trailing)
            Spacer()
                .frame(height: 30)
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
