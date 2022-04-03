//
//  RenterContractEditView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/2.
//

import SwiftUI

struct RenterContractEditView: View {
    
    @EnvironmentObject var rentEditVM: RenterContractEditViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack {
            Form {
                Group {
                    TextField("出租人簽章", text: $rentEditVM.contractDataModel.providerSignurture)
                    TextField("出租人 (公司名稱)", text: $rentEditVM.contractDataModel.companyTitle)
                    Section {
                        TextField("專有部分建號", text: $rentEditVM.contractDataModel.specificBuildingNumber)
                        TextField("權利範圍", text: $rentEditVM.contractDataModel.specificBuildingRightRange)
                        TextField("面積共計幾平方公尺", text: $rentEditVM.contractDataModel.specificBuildingArea)
                    } header: {
                        Text("專有部分")
                            .foregroundColor(Color.white)
                    }
                    Section {
                        TextField("主建物平方公尺", text: $rentEditVM.contractDataModel.mainBuildArea)
                        TextField("用途", text: $rentEditVM.contractDataModel.mainBuildingPurpose)
                    } header: {
                        Text("主建物面積")
                            .foregroundColor(.white)
                    }
                    Section {
                        TextField("附屬建物用途", text: $rentEditVM.contractDataModel.subBuildingPurpose)
                        TextField("面積幾平方公尺", text: $rentEditVM.contractDataModel.subBuildingArea)
                    } header: {
                        Text("附屬建物")
                            .foregroundColor(.white)
                    }
                    Section {
                        TextField("共有部分建號", text: $rentEditVM.contractDataModel.publicBuildingNumber)
                        TextField("權利範圍", text: $rentEditVM.contractDataModel.publicBuildingRightRange)
                        TextField("面積幾平方公尺", text: $rentEditVM.contractDataModel.publicBuildingArea)
                    } header: {
                        Text("共有部分")
                            .foregroundColor(.white)
                    }
                    Section {
                        Toggle("有無他項權利", isOn: $rentEditVM.contractDataModel.isSettingTheRightForThirdPerson)
                        if rentEditVM.contractDataModel.isSettingTheRightForThirdPerson == true {
                            withAnimation(.easeInOut) {
                                TextField("權利種類", text: $rentEditVM.contractDataModel.settingTheRightForThirdPersonForWhatKind)
                            }
                        }
                    } header: {
                        Text("設定他項權利")
                            .foregroundColor(.white)
                    }
                    Section {
                        Toggle("有無查封登記", isOn: $rentEditVM.contractDataModel.isBlockByBank)
                    } header: {
                        Text("查封登記")
                            .foregroundColor(.white)
                    }
                    Section {
                        Toggle("租賃住宅全部", isOn: $rentEditVM.contractDataModel.provideForAll)
                        if rentEditVM.contractDataModel.provideForAll == true {
                            withAnimation(.easeInOut) {
                                roomsInfoTextFields()
                            }
                        }
                        Toggle("租賃住宅部分", isOn: $rentEditVM.contractDataModel.provideForPart)
                        if rentEditVM.contractDataModel.provideForPart == true {
                            withAnimation(.easeInOut) {
                                roomsInfoTextFields()
                            }
                        }
                    } header: {
                        Text("租賃範圍")
                            .foregroundColor(.white)
                    }
                    Section {
                        Toggle("車位有無", isOn: $rentEditVM.contractDataModel.hasParkinglot)
                        if rentEditVM.contractDataModel.hasParkinglot == true {
                            Toggle("汽車停車位", isOn: $rentEditVM.contractDataModel.isVehicle)
                            Toggle("機車停車位", isOn: $rentEditVM.contractDataModel.isMorto)
                            if rentEditVM.contractDataModel.isVehicle == true {
                                HStack {
                                    Button {
                                        if rentEditVM.contractDataModel.parkingStyleM == false {
                                            rentEditVM.contractDataModel.parkingStyleM = true
                                        }
                                        if rentEditVM.contractDataModel.parkingStyleN == true {
                                            rentEditVM.contractDataModel.parkingStyleN = false
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "checkmark.square")
                                                .resizable()
                                                .foregroundColor(rentEditVM.contractDataModel.parkingStyleM ? .green : .white)
                                                .frame(width: 20, height: 20, alignment: .center)
                                            Text("機械式停車位")
                                                .foregroundColor(.black)
                                        }
                                    }
                                    Button {
                                        if rentEditVM.contractDataModel.parkingStyleN == false {
                                            rentEditVM.contractDataModel.parkingStyleN = true
                                        }
                                        if rentEditVM.contractDataModel.parkingStyleM == true {
                                            rentEditVM.contractDataModel.parkingStyleM = false
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "checkmark.square")
                                                .resizable()
                                                .foregroundColor(rentEditVM.contractDataModel.parkingStyleN ? .green : .white)
                                                .frame(width: 20, height: 20, alignment: .center)
                                            Text("機械式停車位")
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                                HStack {
                                    Button {
                                        if rentEditVM.contractDataModel.forAllday == false {
                                            rentEditVM.contractDataModel.forAllday = true
                                        }
                                        if rentEditVM.contractDataModel.forMorning == true  {
                                            rentEditVM.contractDataModel.forMorning = false
                                        }
                                        if rentEditVM.contractDataModel.forNight == true {
                                            rentEditVM.contractDataModel.forNight = false
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "checkmark.square")
                                                .resizable()
                                                .foregroundColor(rentEditVM.contractDataModel.forAllday ? .green : .white)
                                                .frame(width: 20, height: 20, alignment: .center)
                                            Text("全日")
                                                .foregroundColor(.black)
                                        }
                                    }
                                    Button {
                                        if rentEditVM.contractDataModel.forMorning == false {
                                            rentEditVM.contractDataModel.forMorning = true
                                        }
                                        if rentEditVM.contractDataModel.forAllday == true  {
                                            rentEditVM.contractDataModel.forAllday = false
                                        }
                                        if rentEditVM.contractDataModel.forNight == true {
                                            rentEditVM.contractDataModel.forNight = false
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "checkmark.square")
                                                .resizable()
                                                .foregroundColor(rentEditVM.contractDataModel.forMorning ? .green : .white)
                                                .frame(width: 20, height: 20, alignment: .center)
                                            Text("日間")
                                                .foregroundColor(.black)
                                        }
                                    }
                                    Button {
                                        if rentEditVM.contractDataModel.forNight == false {
                                            rentEditVM.contractDataModel.forNight = true
                                        }
                                        if rentEditVM.contractDataModel.forAllday == true  {
                                            rentEditVM.contractDataModel.forAllday = false
                                        }
                                        if rentEditVM.contractDataModel.forMorning == true {
                                            rentEditVM.contractDataModel.forMorning = false
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "checkmark.square")
                                                .resizable()
                                                .foregroundColor(rentEditVM.contractDataModel.forNight ? .green : .white)
                                                .frame(width: 20, height: 20, alignment: .center)
                                            Text("夜間")
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                                parkingLotInfo()
                            }
                        }
                        
                    } header: {
                        Text("車位")
                            .foregroundColor(.white)
                    }
                }
                Group {
                    Section {
                        Toggle("有無附屬設備", isOn: $rentEditVM.contractDataModel.havingSubFacility)
                    } header: {
                        Text("租賃附屬設備")
                            .foregroundColor(.white)
                    }
                    Section {
                        DatePicker("租賃期間自起", selection: $rentEditVM.contractDataModel.rentalStartDate, in: Date()..., displayedComponents: .date)
                        DatePicker("租賃期間自止", selection: $rentEditVM.contractDataModel.rentalEndDate, in: Date()..., displayedComponents: .date)
                    } header: {
                        Text("租賃期間")
                            .foregroundColor(.white)
                    }
                    Section {
                        TextField("每月支付日", text: $rentEditVM.contractDataModel.paymentdays)
                    } header: {
                        Text("租金約定及支付")
                            .foregroundColor(.white)
                    }
                    Section {
                        Toggle("由承租人負擔", isOn: $rentEditVM.contractDataModel.payByRenterForManagementPart)
                        Toggle("由出租人負擔", isOn: $rentEditVM.contractDataModel.payByProviderForManagementPart)
                        TextField("房屋每月", text: $rentEditVM.contractDataModel.managementFeeMonthly)
                        TextField("停車位每月", text: $rentEditVM.contractDataModel.parkingFeeMonthly)
                        TextField("其他", text: $rentEditVM.contractDataModel.additionalReqForManagementPart)
                        
                    } header: {
                        Text("管理費")
                            .foregroundColor(.white)
                    }
                    Section {
                        Toggle("由承租人負擔", isOn: $rentEditVM.contractDataModel.payByRenterForWaterFee)
                        Toggle("由出租人負擔", isOn: $rentEditVM.contractDataModel.payByProviderForWaterFee)
                        TextField("其他", text: $rentEditVM.contractDataModel.additionalReqForWaterFeePart)
                    } header: {
                         Text("水費")
                            .foregroundColor(.white)
                    }
                    Section {
                        Toggle("由承租人負擔", isOn: $rentEditVM.contractDataModel.payByRenterForEletricFee)
                        Toggle("由出租人負擔", isOn: $rentEditVM.contractDataModel.payByProviderForEletricFee)
                        TextField("其他", text: $rentEditVM.contractDataModel.additionalReqForEletricFeePart)
                    } header: {
                        Text("電費")
                            .foregroundColor(.white)
                    }
                    Section {
                        Toggle("由承租人負擔", isOn: $rentEditVM.contractDataModel.payByRenterForGasFee)
                        Toggle("由出租人負擔", isOn: $rentEditVM.contractDataModel.payByProviderForGasFee)
                        TextField("其他", text: $rentEditVM.contractDataModel.additionalReqForGasFeePart)
                    } header: {
                        Text("瓦斯")
                            .foregroundColor(.white)
                    }
                }
                TextField("其他費用及其支付方式", text: $rentEditVM.contractDataModel.additionalReqForOtherPart)
                Section {
                    TextField("代辦費", text: $rentEditVM.contractDataModel.contractSigurtureProxyFee)
                    Toggle("由承租人負擔", isOn: $rentEditVM.contractDataModel.payByRenterForProxyFee)
                    Toggle("由出租人負擔", isOn: $rentEditVM.contractDataModel.payByProviderForProxyFee)
                    Toggle("由雙方平均負擔", isOn: $rentEditVM.contractDataModel.separateForBothForProxyFee)
                } header: {
                    Text("簽約代辦")
                        .foregroundColor(.white)
                }
                Section {
                    TextField("公證費", text: $rentEditVM.contractDataModel.contractIdentitificationFee)
                    Toggle("由承租人負擔", isOn: $rentEditVM.contractDataModel.payByRenterForIDFFee)
                    Toggle("由出租人負擔", isOn: $rentEditVM.contractDataModel.payByProviderForIDFFee)
                    Toggle("由雙方平均負擔", isOn: $rentEditVM.contractDataModel.separateForBothForIDFFee)
                } header: {
                    Text("公證費")
                        .foregroundColor(.white)
                }

                Section {
                    TextField("公證代辦費", text: $rentEditVM.contractDataModel.contractIdentitificationProxyFee)
                    Toggle("由承租人負擔", isOn: $rentEditVM.contractDataModel.payByRenterForIDFProxyFee)
                    Toggle("由出租人負擔", isOn: $rentEditVM.contractDataModel.payByProviderForIDFProxyFee)
                    Toggle("由雙方平均負擔", isOn: $rentEditVM.contractDataModel.separateForBothForIDFProxyFee)
                } header: {
                    Text("公證代辦費")
                        .foregroundColor(.white)
                }
                Section {
                    Toggle("是否同意轉租", isOn: $rentEditVM.contractDataModel.subLeaseAgreement)
                } header: {
                    Text("使用房屋之限制")
                        .foregroundColor(.white)
                }
                
            }
            Button {
                
            } label: {
                Text("Update")
                    .foregroundColor(.white)
                    .frame(width: 108, height: 35)
                    .background(Color("buttonBlue"))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
        })
        .onDisappear(perform: {
            UITableView.appearance().backgroundColor = .systemBackground
        })
        .background(alignment: .center) {
            LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea([.top, .bottom])
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct RenterContractEditView_Previews: PreviewProvider {
    static var previews: some View {
        RenterContractEditView()
    }
}



extension RenterContractEditView {
    @ViewBuilder
    func roomsInfoTextFields() -> some View {
        TextField("第幾層", text: $rentEditVM.contractDataModel.provideFloor)
        TextField("房間數", text: $rentEditVM.contractDataModel.provideRooms)
        TextField("第幾室", text: $rentEditVM.contractDataModel.provideRoomNumber)
        TextField("面積幾平方公尺", text: $rentEditVM.contractDataModel.provideFloor)
    }
    
    @ViewBuilder
    func parkingLotInfo() -> some View {
        TextField("地上(下)第幾層", text: $rentEditVM.contractDataModel.parkingUGFloor)
        TextField("編號", text: $rentEditVM.contractDataModel.parkingNumberForVehicle)
    }
}
