//
//  ProviderRoomSummitView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ProviderRoomSummitView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firebaseStorageInGeneral: FirebaseStorageInGeneral
    @EnvironmentObject var storageForRoomsImage: StorageForRoomsImage
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    
    //    @State var holderName = ""
    //    @State var holderMobileNumber = ""
    //    @State var holderEmailAddress = ""
    //    @State var roomAddress = ""
    //    @State var town = ""
    //    @State var city = ""
    //    @State var zipCode = ""
    //    @State var roomArea = ""
    //    @State var rentalPrice = ""
    @State private var holderTosAgree = false
    @State var image = UIImage()
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(Color("backgroundBrown"))
                    .edgesIgnoringSafeArea([.top, .bottom])
                VStack(spacing: 5) {
                    ScrollView(.vertical, showsIndicators: false){
                        TitleAndDivider(title: "Ready to Post your Room?")
                        StepsTitle(stepsName: "Step1: Upload the room pic.")
                        Button {
                            showSheet.toggle()
                        } label: {
                            ZStack(alignment: .center) {
                                Rectangle()
                                    .fill(Color("fieldGray"))
                                    .frame(width: 378, height: 304)
                                    .cornerRadius(10)
                                Image(systemName: "plus.square")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.gray)
                            }
                        }
                        StepsTitle(stepsName: "Step2: Please provide the necessary information")
                        VStack(spacing: 10) {
                            InfoUnit(title: "Holder Name", bindingString: $appViewModel.holderName)
                            InfoUnit(title: "Mobile Number", bindingString: $appViewModel.holderMobileNumber)
                            Group {
                                InfoUnit(title: "Room Address", bindingString: $appViewModel.roomAddress)
                                InfoUnit(title: "Town", bindingString: $appViewModel.roomTown)
                                InfoUnit(title: "City", bindingString: $appViewModel.roomCity)
                                InfoUnit(title: "Zip Code", bindingString: $appViewModel.roomZipCode)
                            }
                            InfoUnit(title: "Email Address", bindingString: $appViewModel.holderEmailAddress)
                            InfoUnit(title: "Room Area", bindingString: $appViewModel.roomArea)
                            InfoUnit(title: "Rental Price", bindingString: $appViewModel.roomRentalPrice)
                            
                            if firestoreToFetchUserinfo.evaluateProviderType() == "House Owner" {
                                Group {
                                    InfoUnit(title: "專有部分建號：", bindingString: $appViewModel.specificBuildingNumber)
                                    InfoUnit(title: "專有部分權利範圍：", bindingString: $appViewModel.specificBuildingRightRange)
                                    InfoUnit(title: "專有部分面積共計：", bindingString: $appViewModel.specificBuildingArea)
                                    InfoUnit(title: "主建物面積幾層幾平方公尺：", bindingString: $appViewModel.mainBuildArea)
                                    InfoUnit(title: "主建物用途：", bindingString: $appViewModel.mainBuildingPurpose)
                                    InfoUnit(title: "附屬建物用途：", bindingString: $appViewModel.subBuildingPurpose)
                                    InfoUnit(title: "附屬建物面積幾平方公尺：", bindingString: $appViewModel.subBuildingArea)
                                    InfoUnit(title: "共有部分建號：", bindingString: $appViewModel.publicBuildingNumber)
                                    InfoUnit(title: "共有部分權利範圍：", bindingString: $appViewModel.publicBuildingRightRange)
                                    InfoUnit(title: "共有部分持分面積幾平方公尺：", bindingString: $appViewModel.publicBuildingArea)
                                }
                                Group {
                                    HStack(spacing: 3) {
                                        Text("車位")
                                            .foregroundColor(Color.white)
                                        Button {
                                            if appViewModel.hasParkinglotNo == true {
                                                appViewModel.hasParkinglotNo = false
                                            }
                                            if appViewModel.hasParkinglotYes == false {
                                                appViewModel.hasParkinglotYes = true
                                            }
                                        } label: {
                                            HStack {
                                                Image(systemName: appViewModel.hasParkinglotYes ? "checkmark.square.fill" : "checkmark.square")
                                                    .foregroundColor(appViewModel.hasParkinglotYes ? .green : .white)
                                                    .padding(.trailing, 5)
                                                Text("有")
                                                    .foregroundColor(Color.white)
                                            }
                                        }
                                        Button {
                                            if appViewModel.hasParkinglotYes == true {
                                                appViewModel.hasParkinglotYes = false
                                            }
                                            if appViewModel.hasParkinglotNo == false {
                                                appViewModel.hasParkinglotNo = true
                                            }
                                        } label: {
                                            HStack {
                                                Image(systemName: appViewModel.hasParkinglotNo ? "checkmark.square.fill" : "checkmark.square")
                                                    .foregroundColor(appViewModel.hasParkinglotNo ? .green : .white)
                                                    .padding(.trailing, 5)
                                                Text("無")
                                                    .foregroundColor(Color.white)
                                            }
                                        }
                                    }
                                    InfoUnit(title: "汽車/機車車位數量", bindingString: $appViewModel.parkinglotAmount)
                                    Group {
                                        HStack(spacing: 3) {
                                            Text("設定他項權利")
                                                .foregroundColor(Color.white)
                                            Button {
                                                if appViewModel.isSettingTheRightForThirdPersonNo == true {
                                                    appViewModel.isSettingTheRightForThirdPersonNo = false
                                                }
                                                if appViewModel.isSettingTheRightForThirdPersonYes == false {
                                                    appViewModel.isSettingTheRightForThirdPersonYes = true
                                                }
                                            } label: {
                                                HStack {
                                                    Image(systemName: appViewModel.isSettingTheRightForThirdPersonYes ? "checkmark.square.fill" : "checkmark.square")
                                                        .foregroundColor(appViewModel.isSettingTheRightForThirdPersonYes ? .green : .white)
                                                        .padding(.trailing, 5)
                                                    Text("有")
                                                        .foregroundColor(Color.white)
                                                }
                                            }
                                            Button {
                                                if appViewModel.isSettingTheRightForThirdPersonYes == true {
                                                    appViewModel.isSettingTheRightForThirdPersonYes = false
                                                }
                                                if appViewModel.isSettingTheRightForThirdPersonNo == false {
                                                    appViewModel.isSettingTheRightForThirdPersonNo = true
                                                }
                                            } label: {
                                                HStack {
                                                    Image(systemName: appViewModel.isSettingTheRightForThirdPersonNo ? "checkmark.square.fill" : "checkmark.square")
                                                        .foregroundColor(appViewModel.isSettingTheRightForThirdPersonNo ? .green : .white)
                                                        .padding(.trailing, 5)
                                                    Text("無")
                                                        .foregroundColor(Color.white)
                                                }
                                            }
                                        }
                                    }
                                    InfoUnit(title: "權利種類:", bindingString: $appViewModel.SettingTheRightForThirdPersonForWhatKind)
                                    Group {
                                        HStack(spacing: 3) {
                                            Text("查封登記")
                                                .foregroundColor(Color.white)
                                            Button {
                                                if appViewModel.isBlockByBankNo == true {
                                                    appViewModel.isBlockByBankNo = false
                                                }
                                                if appViewModel.isBlockByBankYes == false {
                                                    appViewModel.isBlockByBankYes = true
                                                }
                                            } label: {
                                                HStack {
                                                    Image(systemName: appViewModel.isBlockByBankYes ? "checkmark.square.fill" : "checkmark.square")
                                                        .foregroundColor(appViewModel.isBlockByBankYes ? .green : .white)
                                                        .padding(.trailing, 5)
                                                    Text("有")
                                                        .foregroundColor(Color.white)
                                                }
                                            }
                                            Button {
                                                if appViewModel.isBlockByBankYes == true {
                                                    appViewModel.isBlockByBankYes = false
                                                }
                                                if appViewModel.isBlockByBankNo == false {
                                                    appViewModel.isBlockByBankNo = true
                                                }
                                            } label: {
                                                HStack {
                                                    Image(systemName: appViewModel.isBlockByBankNo ? "checkmark.square.fill" : "checkmark.square")
                                                        .foregroundColor(appViewModel.isBlockByBankNo ? .green : .white)
                                                        .padding(.trailing, 5)
                                                    Text("無")
                                                        .foregroundColor(Color.white)
                                                }
                                            }
                                        }
                                    }
                                }
                                Group {
                                    HStack(spacing: 3) {
                                        Text("租賃住宅管理範圍")
                                            .foregroundColor(Color.white)
                                        Button {
                                            if appViewModel.provideForPart == true {
                                                appViewModel.provideForPart = false
                                            }
                                            if appViewModel.provideForAll == false {
                                                appViewModel.provideForAll = true
                                            }
                                        } label: {
                                            HStack {
                                                Image(systemName: appViewModel.provideForAll ? "checkmark.square.fill" : "checkmark.square")
                                                    .foregroundColor(appViewModel.provideForAll ? .green : .white)
                                                    .padding(.trailing, 5)
                                                Text("全部")
                                                    .foregroundColor(Color.white)
                                            }
                                        }
                                        Button {
                                            if appViewModel.provideForAll == true {
                                                appViewModel.provideForAll = false
                                            }
                                            if appViewModel.provideForPart == false {
                                                appViewModel.provideForPart = true
                                            }
                                        } label: {
                                            HStack {
                                                Image(systemName: appViewModel.provideForPart ? "checkmark.square.fill" : "checkmark.square")
                                                    .foregroundColor(appViewModel.provideForPart ? .green : .white)
                                                    .padding(.trailing, 5)
                                                Text("部分")
                                                    .foregroundColor(Color.white)
                                            }
                                        }
                                    }
                                    InfoUnit(title: "租賃住宅第幾層", bindingString: $appViewModel.provideFloor)
                                    InfoUnit(title: "租賃住宅房間__間", bindingString: $appViewModel.provideRooms)
                                    InfoUnit(title: "租賃住宅第__室", bindingString: $appViewModel.provideRoomNumber)
                                    InfoUnit(title: "租賃住宅面積__平方公尺", bindingString: $appViewModel.provideRoomArea)
                                }
                                
                                if appViewModel.hasParkinglotYes == true && appViewModel.hasParkinglotNo == false {
                                    Group {
                                        HStack(spacing: 3) {
                                            Text("車位")
                                                .foregroundColor(Color.white)
                                            Button {
                                                if appViewModel.isBoth == true || appViewModel.isMorto == true {
                                                    appViewModel.isBoth = false
                                                    appViewModel.isMorto = false
                                                }
                                                if appViewModel.isVehicle == false {
                                                    appViewModel.isVehicle = true
                                                }
                                            } label: {
                                                HStack {
                                                    Image(systemName: appViewModel.isVehicle ? "checkmark.square.fill" : "checkmark.square")
                                                        .foregroundColor(appViewModel.isVehicle ? .green : .white)
                                                        .padding(.trailing, 5)
                                                    Text("汽車")
                                                        .foregroundColor(Color.white)
                                                }
                                            }
                                            Button {
                                                if appViewModel.isVehicle == true || appViewModel.isBoth == true {
                                                    appViewModel.isVehicle = false
                                                    appViewModel.isBoth = false
                                                }
                                                if appViewModel.isMorto == false {
                                                    appViewModel.isMorto = true
                                                }
                                            } label: {
                                                HStack {
                                                    Image(systemName: appViewModel.isMorto ? "checkmark.square.fill" : "checkmark.square")
                                                        .foregroundColor(appViewModel.isMorto ? .green : .white)
                                                        .padding(.trailing, 5)
                                                    Text("機車")
                                                        .foregroundColor(Color.white)
                                                }
                                            }
                                            Button {
                                                if appViewModel.isVehicle == true || appViewModel.isMorto == true {
                                                    appViewModel.isVehicle = false
                                                    appViewModel.isMorto = false
                                                }
                                                if appViewModel.isBoth == false {
                                                    appViewModel.isBoth = true
                                                }
                                            } label: {
                                                HStack {
                                                    Image(systemName: appViewModel.isBoth ? "checkmark.square.fill" : "checkmark.square")
                                                        .foregroundColor(appViewModel.isBoth ? .green : .white)
                                                        .padding(.trailing, 5)
                                                    Text("兩者皆有")
                                                        .foregroundColor(Color.white)
                                                }
                                            }
                                        }
                                        InfoUnit(title: "地上(下)第幾層", bindingString: $appViewModel.parkingUGFloor)
                                        HStack(spacing: 3) {
                                            Text("車位類型")
                                                .foregroundColor(Color.white)
                                            Button {
                                                if appViewModel.parkingStyleM == true {
                                                    appViewModel.parkingStyleM = false
                                                }
                                                if appViewModel.parkingStyleN == false {
                                                    appViewModel.parkingStyleN = true
                                                }
                                            } label: {
                                                HStack {
                                                    Image(systemName: appViewModel.parkingStyleN ? "checkmark.square.fill" : "checkmark.square")
                                                        .foregroundColor(appViewModel.parkingStyleN ? .green : .white)
                                                        .padding(.trailing, 5)
                                                    Text("平面式")
                                                        .foregroundColor(Color.white)
                                                }
                                            }
                                            Button {
                                                if appViewModel.parkingStyleN == true {
                                                    appViewModel.parkingStyleN = false
                                                }
                                                if appViewModel.parkingStyleM == false {
                                                    appViewModel.parkingStyleM = true
                                                }
                                            } label: {
                                                HStack {
                                                    Image(systemName: appViewModel.parkingStyleM ? "checkmark.square.fill" : "checkmark.square")
                                                        .foregroundColor(appViewModel.parkingStyleM ? .green : .white)
                                                        .padding(.trailing, 5)
                                                    Text("機械式")
                                                        .foregroundColor(Color.white)
                                                }
                                            }
                                        }
                                        InfoUnit(title: "編號第幾號", bindingString: $appViewModel.parkingNumber)
                                        HStack(spacing: 3) {
                                            Text("使用時間")
                                                .foregroundColor(Color.white)
                                            Button {
                                                if appViewModel.forMorning == true || appViewModel.forNight == true {
                                                    appViewModel.forMorning = false
                                                    appViewModel.forNight = false
                                                }
                                                if appViewModel.forAllday == false {
                                                    appViewModel.forAllday = true
                                                }
                                            } label: {
                                                HStack {
                                                    Image(systemName: appViewModel.forAllday ? "checkmark.square.fill" : "checkmark.square")
                                                        .foregroundColor(appViewModel.forAllday ? .green : .white)
                                                        .padding(.trailing, 5)
                                                    Text("全日")
                                                        .foregroundColor(Color.white)
                                                }
                                            }
                                            Button {
                                                if appViewModel.forAllday == true || appViewModel.forNight == true {
                                                    appViewModel.forAllday = false
                                                    appViewModel.forNight = false
                                                }
                                                if appViewModel.forMorning == false {
                                                    appViewModel.forMorning = true
                                                }
                                            } label: {
                                                HStack {
                                                    Image(systemName: appViewModel.forMorning ? "checkmark.square.fill" : "checkmark.square")
                                                        .foregroundColor(appViewModel.forMorning ? .green : .white)
                                                        .padding(.trailing, 5)
                                                    Text("日間")
                                                        .foregroundColor(Color.white)
                                                }
                                            }
                                            Button {
                                                if appViewModel.forMorning == true || appViewModel.forAllday == true {
                                                    appViewModel.forMorning = false
                                                    appViewModel.forAllday = false
                                                }
                                                if appViewModel.forNight == false {
                                                    appViewModel.forNight = true
                                                }
                                            } label: {
                                                HStack {
                                                    Image(systemName: appViewModel.forNight ? "checkmark.square.fill" : "checkmark.square")
                                                        .foregroundColor(appViewModel.forNight ? .green : .white)
                                                        .padding(.trailing, 5)
                                                    Text("夜間")
                                                        .foregroundColor(Color.white)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                Group {
                                    HStack(spacing: 3) {
                                        Text("租賃附屬設備")
                                            .foregroundColor(Color.white)
                                        Button {
                                            if appViewModel.havingSubFacilityNo == true {
                                                appViewModel.havingSubFacilityNo = false
                                            }
                                            if appViewModel.havingSubFacilityYes == false {
                                                appViewModel.havingSubFacilityYes = true
                                            }
                                        } label: {
                                            HStack {
                                                Image(systemName: appViewModel.havingSubFacilityYes ? "checkmark.square.fill" : "checkmark.square")
                                                    .foregroundColor(appViewModel.havingSubFacilityYes ? .green : .white)
                                                    .padding(.trailing, 5)
                                                Text("有")
                                                    .foregroundColor(Color.white)
                                            }
                                        }
                                        Button {
                                            if appViewModel.havingSubFacilityYes == true {
                                                appViewModel.havingSubFacilityYes = false
                                            }
                                            if appViewModel.havingSubFacilityNo == false {
                                                appViewModel.havingSubFacilityNo = true
                                            }
                                        } label: {
                                            HStack {
                                                Image(systemName: appViewModel.havingSubFacilityNo ? "checkmark.square.fill" : "checkmark.square")
                                                    .foregroundColor(appViewModel.havingSubFacilityNo ? .green : .white)
                                                    .padding(.trailing, 5)
                                                Text("無")
                                                    .foregroundColor(Color.white)
                                            }
                                        }
                                    }
                                    InfoUnit(title: "委託管理期間自", bindingString: $appViewModel.providingTimeRangeStart)
                                    InfoUnit(title: "委託管理期間至", bindingString: $appViewModel.providingTimeRangeEnd)
                                }
                                Group {
                                    HStack(spacing: 3) {
                                        Text("報酬給付方式")
                                            .foregroundColor(Color.white)
                                        Button {
                                            if appViewModel.paybyTransmission == true {
                                                appViewModel.paybyTransmission = false
                                            }
                                            if appViewModel.paybyCash == false {
                                                appViewModel.paybyCash = true
                                            }
                                        } label: {
                                            HStack {
                                                Image(systemName: appViewModel.paybyCash ? "checkmark.square.fill" : "checkmark.square")
                                                    .foregroundColor(appViewModel.paybyCash ? .green : .white)
                                                    .padding(.trailing, 5)
                                                Text("現金繳付")
                                                    .foregroundColor(Color.white)
                                            }
                                        }
                                        Button {
                                            if appViewModel.paybyCash == true {
                                                appViewModel.paybyCash = false
                                            }
                                            if appViewModel.paybyTransmission == false {
                                                appViewModel.paybyTransmission = true
                                            }
                                        } label: {
                                            HStack {
                                                Image(systemName: appViewModel.paybyTransmission ? "checkmark.square.fill" : "checkmark.square")
                                                    .foregroundColor(appViewModel.paybyTransmission ? .green : .white)
                                                    .padding(.trailing, 5)
                                                Text("轉帳繳付")
                                                    .foregroundColor(Color.white)
                                            }
                                        }
                                    }
                                    InfoUnit(title: "金融機構", bindingString: $appViewModel.bankName)
                                    InfoUnit(title: "戶名", bindingString: $appViewModel.bankOwnerName)
                                    InfoUnit(title: "帳號", bindingString: $appViewModel.bankAccount)
                                }
                                Group {
                                    HStack(spacing: 3) {
                                        Text("履行本契約之通知")
                                            .foregroundColor(Color.white)
                                        Button {
                                            if appViewModel.contractSendbyTextingMessage == true || appViewModel.contractSendbyMessageSoftware == true {
                                                appViewModel.contractSendbyTextingMessage = false
                                                appViewModel.contractSendbyMessageSoftware = false
                                            }
                                            if appViewModel.contractSendbyEmail == false {
                                                appViewModel.contractSendbyEmail = true
                                            }
                                        } label: {
                                            HStack {
                                                Image(systemName: appViewModel.contractSendbyEmail ? "checkmark.square.fill" : "checkmark.square")
                                                    .foregroundColor(appViewModel.contractSendbyEmail ? .green : .white)
                                                    .padding(.trailing, 5)
                                                Text("電子郵件信箱")
                                                    .foregroundColor(Color.white)
                                            }
                                        }
                                        Button {
                                            if appViewModel.contractSendbyEmail == true || appViewModel.contractSendbyMessageSoftware == true {
                                                appViewModel.contractSendbyEmail = false
                                                appViewModel.contractSendbyMessageSoftware = false
                                            }
                                            if appViewModel.contractSendbyTextingMessage == false {
                                                appViewModel.contractSendbyTextingMessage = true
                                            }
                                        } label: {
                                            HStack {
                                                Image(systemName: appViewModel.contractSendbyTextingMessage ? "checkmark.square.fill" : "checkmark.square")
                                                    .foregroundColor(appViewModel.contractSendbyTextingMessage ? .green : .white)
                                                    .padding(.trailing, 5)
                                                Text("手機簡訊")
                                                    .foregroundColor(Color.white)
                                            }
                                        }
                                        Button {
                                            if appViewModel.contractSendbyTextingMessage == true || appViewModel.contractSendbyEmail == true {
                                                appViewModel.contractSendbyTextingMessage = false
                                                appViewModel.contractSendbyEmail = false
                                            }
                                            if appViewModel.contractSendbyMessageSoftware == false {
                                                appViewModel.contractSendbyMessageSoftware = true
                                            }
                                        } label: {
                                            HStack {
                                                Image(systemName: appViewModel.contractSendbyMessageSoftware ? "checkmark.square.fill" : "checkmark.square")
                                                    .foregroundColor(appViewModel.contractSendbyMessageSoftware ? .green : .white)
                                                    .padding(.trailing, 5)
                                                Text("即時通訊軟體")
                                                    .foregroundColor(Color.white)
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        .padding(.top, 5)
                        .frame(width: 350)
                        StepsTitle(stepsName: "Step3: Please check out the terms of service.")
                        VStack(alignment: .leading) {
                            Spacer()
                            HStack {
                                Button {
                                    holderTosAgree.toggle()
                                } label: {
                                    Image(systemName: holderTosAgree ? "checkmark.square.fill" : "checkmark.square")
                                        .foregroundColor(holderTosAgree ? .green : .white)
                                        .padding(.trailing, 5)
                                }
                                Text("I have read and agree the terms of Service.")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .medium))
                            }
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            NavigationLink {
                                if firestoreToFetchUserinfo.evaluateProviderType() == "House Owner" {
                                    ProviderSummittedRoomContractView()
                                } else if firestoreToFetchUserinfo.evaluateProviderType() == "Rental Manager" {
                                    TermOfServiceForRentalManager()
                                }
                            } label: {
                                Text("Next")
                                    .foregroundColor(.white)
                                    .frame(width: 108, height: 35)
                                    .background(Color("buttonBlue"))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                        }
                        .padding(.trailing)
                        .frame(width: 400)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear(perform: {
                firebaseStorageInGeneral.imageUIDHolder = firebaseStorageInGeneral.imgUIDGenerator()
            })
            .sheet(isPresented: $showSheet) {
                if !image.isSymbolImage {
                    storageForRoomsImage.uploadRoomImage(uidPath: firebaseAuth.getUID(), image: image)
                    
                }
            } content: {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
        }
    }
}

struct StepsTitle: View {
    var stepsName = ""
    var body: some View {
        HStack {
            Text(stepsName)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.leading)
    }
}

struct ProviderRoomSummitView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderRoomSummitView()
    }
}


//Button {
//    localData.addRoomDataToArray(holderName: holderName, mobileNumber: holderMobileNumber, roomAddress: roomAddress, town: town, city: city, zipCode: zipCode, emailAddress: holderEmailAddress, roomArea: roomArea, rentalPrice: rentalPrice)
//    print("\(localData.localRoomsHolder)")
//} label: {
//    Text("Next")
//        .foregroundColor(.white)
//        .frame(width: 108, height: 35)
//        .background(Color("buttonBlue"))
//        .clipShape(RoundedRectangle(cornerRadius: 5))
//}
