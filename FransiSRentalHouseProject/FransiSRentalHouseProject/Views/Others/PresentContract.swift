//
//  testKeyboard.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/8.
//

import SwiftUI

struct PresentContract: View {
    var contractData: RentersContractDataModel
    var body: some View {
        VStack {
            presentedContract()
        }
    }
}

//struct PresentContract_Previews: PreviewProvider {
//    static var previews: some View {
//        PresentContract()
//    }
//}

extension PresentContract {
    @ViewBuilder
    func presentedContract() -> some View {
        VStack {
            ScrollView(.vertical, showsIndicators: true) {
                Group {
                    Group {
                        titleAndAbstract()
                        firstParagraphAndFirstSubThenOne()
                        firstParagraphAndFirstSubThenTwo()
                    }
                    Group {
                        firstParagraphAndSecondSub()
                        firstParagraphAndThirdSub()
                        firstParagraphAndFourthSub()
                    }
                    Group {
                        firstParagraphAndFivthSub()
                        firstParagraphAndSixthSub()
                        firstParagraphAndSeventhSub()
                    }
                }
                Group {
                    Group {
                        firstParagraphAndEighthSub()
                        firstParagraphAndNinethSub()
                        firstParagraphAndTenthSub()
                        firstParagraphAndEleventhSub()
                        firstParagraphAndtwelevethSub()
                        fitstParagraphAndThirteenth()
                        fitstParagraphAndFourteenth()
                        fitstParagraphAndFiveteenth()
                    }
                    Group {
                        fitstParagraphAndSixteenth()
                        fitstParagraphAndSeventeenth()
                        fitstParagraphAndEighteenth()
                        fitstParagraphAndNineteenth()
                        fitstParagraphAndtwentyth()
                        fitstParagraphAndtwentyFirst()
                        fitstParagraphAndtwentySecond()
                    }
                    Group {
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "立契約書人")
                            VStack(spacing: 6) {
                                Group {
                                    VStack {
                                        LineWithSpacer(contain: "出租人：")
                                        signatureContainer(containerName: "姓名(名稱)：", containHolder: contractData.providerName )
                                        signatureContainer(containerName: "統一編號：", containHolder: contractData.providerID )
                                        signatureContainer(containerName: "戶籍地址：", containHolder: contractData.providerResidenceAddress )
                                        signatureContainer(containerName: "通訊地址：", containHolder: contractData.providerMailingAddress )
                                        signatureContainer(containerName: "聯絡電話：", containHolder: contractData.providerPhoneNumber )
                                        signatureHolder(signatureTitle: "負責人：", signString: contractData.providerPhoneChargeName )
                                        signatureContainer(containerName: "統一編號：", containHolder: contractData.providerPhoneChargeID )
                                        signatureContainer(containerName: "電子郵件信箱：", containHolder: contractData.providerPhoneChargeEmailAddress )
                                    }
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            VStack(spacing: 6) {
                                Group {
                                    VStack {
                                        LineWithSpacer(contain: "承租人：")
                                        signatureHolder(signatureTitle: "姓名(名稱)：", signString: contractData.renterName )
                                        signatureContainer(containerName: "統一編號：", containHolder: contractData.renterID )
                                        signatureContainer(containerName: "戶籍地址：", containHolder: contractData.renterResidenceAddress )
                                        signatureContainer(containerName: "通訊地址：", containHolder: contractData.renterMailingAddress )
                                        signatureContainer(containerName: "聯絡電話：", containHolder: contractData.renterPhoneNumber )
                                        signatureContainer(containerName: "電子郵件信箱：", containHolder: contractData.renterEmailAddress )
                                        HStack {
                                            Text("\(contractData.sigurtureDate , format: Date.FormatStyle().year().month(.twoDigits).day())")
                                            Spacer()
                                        }
                                    }
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        expressionContractList()
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 20)
        .padding()
        
    }
    
    @ViewBuilder
    func titleAndAbstract() -> some View {
        Group {
            VStack(spacing: 2) {
                Group {
                    Text("中華民國91年1月30日內政部台內中地字第0910083141號公告頒行(行政院消費者保護委員會第86次委員會議通過)")
                    Text("中華民國105年6月23日內政部內授中辦地字第1051305386號公告修正 (行政院消費者保護會第47次會議通過)")
                }
                .font(.system(size: 12))
                Group {
                    SpacerAtRightOfText(contain: "契約審閱權")
                        .font(.system(size: 12))
                    HStack {
                        Spacer()
                        Text("本契約於\n\(contractData.contractBuildDate , format: Date.FormatStyle().year().month(.twoDigits).day())經承租人\n攜回審閱\(contractData.contractReviewDays )日\n(契約審閱期間至少三日)")
                    }
                    .font(.system(size: 12))
                    SpacerAtRightOfText(contain: "承租人簽章：", optionContain: contractData.renterSignurture )
                        .font(.system(size: 12))
                    SpacerAtRightOfText(contain: "出租人簽章：", optionContain: contractData.providerSignurture )
                        .font(.system(size: 12))
                }
                Text("房屋租賃契約書")
                    .font(.title2)
                    .font(.system(size: 15))
                Group {
                    SpacerAtRightOfText(contain: "內 　政　 部  　編")
                    SpacerAtRightOfText(contain: "中華民國105年6月")
                }
                .font(.system(size: 12))
            }
            .padding(.top, 5)
            VStack {
                Text("\t立契約書人承租人__，出租人\(contractData.companyTitle )【為□所有權人□轉租人(應提示經原所有權人同意轉租之證明文件)】茲為房屋租賃事宜，雙方同意本契約條款如下：")
                    .font(.system(size: 15, weight: .regular))
            }
            .padding(.top, 5)
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func firstParagraphAndFirstSubThenOne() -> some View {
        //:~ paragraph 1
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第一條   委託管理標的")
            SubTitleView(subTitleName: "一、房屋標示：")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "(一)門牌：\(contractData.roomZipCode)\(contractData.roomCity)\(contractData.roomTown)\(contractData.roomAddress)。")
                    LineWithSpacer(contain: "(二)專有部分建號\(contractData.specificBuildingNumber )，權利範圍\(contractData.specificBuildingRightRange )，面積共計\(contractData.specificBuildingArea )平方公尺。")
                    LineWithSpacer(contain: "1.主建物面積：")
                    Text("\(contractData.mainBuildArea )層 平方公尺，用途\(contractData.mainBuildingPurpose )。")
                    LineWithSpacer(contain: "2.附屬建物用途\(contractData.subBuildingPurpose )，面積\(contractData.subBuildingArea )平方公尺。")
                    LineWithSpacer(contain: "(三)共有部分建號:\(contractData.publicBuildingNumber )，權利範圍:\(contractData.publicBuildingRightRange )，持分面積\(contractData.publicBuildingArea )平方公尺。")
                    settingTheRightForThirdPerson(_isSettingTheRightForThirdPerson: contractData.isSettingTheRightForThirdPerson ,          _SettingTheRightForThirdPersonForWhatKind: contractData.settingTheRightForThirdPersonForWhatKind )
                     //有無設定他項權利
                    blockByBankCheck(_isBlockByBank: contractData.isBlockByBank )  //有無查封登記
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func settingTheRightForThirdPerson(_isSettingTheRightForThirdPerson: Bool, _SettingTheRightForThirdPersonForWhatKind: String) -> some View {
        if _isSettingTheRightForThirdPerson == true {
            LineWithSpacer(contain: "(四)有設定他項權利，若有，權利種類：\(_SettingTheRightForThirdPersonForWhatKind)。")
        } else {
            
            LineWithSpacer(contain: "(四)無設定他項權利。")
        }
    }
    
    @ViewBuilder
    func firstParagraphAndFirstSubThenTwo() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            SubTitleView(subTitleName: "二、租賃範圍：")
            
            VStack(spacing: 6) {
                Group {
                    buildProvidePart(_entire: contractData.provideForAll ,
                                     _part: contractData.provideForPart ) //租賃住宅全部
                    haveParkingLot(_hasParkingLot: contractData.hasParkinglot ,
                                   _all: contractData.forAllday ,
                                   _morning: contractData.forMorning ,
                                   _night: contractData.forNight,
                                   isVehicle: contractData.isVehicle,
                                   isMorto: contractData.isMorto )
                    LineWithSpacer(contain: "(三)租賃附屬設備：")
                    idfSubFacility(_havingSubFacility: contractData.havingSubFacility )////租賃附屬設備有無
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndSecondSub() -> some View {
        //:~ paragraph 2
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第二條 租賃期間")
            VStack(spacing: 6) {
                Group {
                    Text("租賃期間自\(contractData.rentalStartDate , format: Date.FormatStyle().year().month(.twoDigits).day())起至\(contractData.rentalEndDate, format: Date.FormatStyle().year().month(.twoDigits).day())止。") //租賃期間
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndThirdSub() -> some View {
        //:~ paragraph 3
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第三條 租金約定及支付")
            VStack(spacing: 6) {
                Group {
                    Text("承租人每月租金為新臺幣(下同)\(contractData.roomRentalPrice)元整，每期應繳納1個月租金，並於每月\(contractData.paymentdays)日前支付，不得藉任何理由拖延或拒絕；出租人亦不得任意要求調整租金。") //每月租金
                    idfPaymentMethod(_paybyCash: contractData.paybyCash ,
                                     _paybyTransmission: contractData.paybyTransmission ,
                                     _paybyCreditDebitCard: contractData.paybyCreditDebitCard ) //報酬約定及給付-轉帳繳付
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndFourthSub() -> some View {
        
        let convertIntPrice: Int = Int(contractData.roomRentalPrice) ?? 0
        let multipleTwo = convertIntPrice * 2
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第四條 擔保金（押金）約定及返還")
            VStack(spacing: 6) {
                Group {
                    Text("擔保金（押金）由租賃雙方約定為2個月租金，金額為\(multipleTwo)元整(最高不得超過二個月房屋租金之總額)。承租人應於簽訂本契約之同時給付出租人。")//押金
                    Text("前項擔保金（押金），除有第十一條第三項、第十二條第四項及第十六條第二項之情形外，出租人應於租期屆滿或租賃契約終止，承租人交還房屋時返還之。")
                }
            }
            .font(.system(size: 14, weight: .regular))
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndFivthSub() -> some View {
        //:~ paragraph 5
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第五條 租賃期間相關費用之支付")
            VStack(spacing: 6) {
                Group {
                    SubTitleView(subTitleName: "租賃期間，使用房屋所生之相關費用：")
                    Group {
                        SubTitleView(subTitleName: "一、管理費：")
                        idfPaymentSideMF(_payByRenterForManagementPart: contractData.payByRenterForManagementPart,
                                         _payByProviderForManagementPart: contractData.payByProviderForManagementPart)
                        LineWithSpacer(contain: "房屋每月\(contractData.managementFeeMonthly)元整。")
                        LineWithSpacer(contain: "停車位每月\(contractData.parkingFeeMonthly)元整。")
                        Text("租賃期間因不可歸責於雙方當事人之事由，致本費用增加者，承租人就增加部分之金額，以負擔百分之十為限；如本費用減少者，承租人負擔減少後之金額。")
                        LineWithSpacer(contain: "其他：\(contractData.additionalReqForManagementPart)。")
                    }
                    Group {
                        SubTitleView(subTitleName: "二、水費：")
                        idfPaymentSideWF(_payByRenterForWaterFee: contractData.payByRenterForWaterFee,
                                         _payByProviderForWaterFee: contractData.payByProviderForWaterFee)
                        LineWithSpacer(contain: "其他：\(contractData.additionalReqForWaterFeePart)。(例如每度  元整)")
                    }
                    Group {
                        SubTitleView(subTitleName: "三、電費：")
                        idfPaymentSideEF(_payByRenterForEletricFee: contractData.payByRenterForEletricFee,
                                         _payByProviderForEletricFee: contractData.payByProviderForEletricFee)
                        LineWithSpacer(contain: "其他：\(contractData.additionalReqForEletricFeePart)。(例如每度  元整)")
                    }
                    Group {
                        SubTitleView(subTitleName: "四、瓦斯：")
                        idfPaymentSideGF(_payByRenterForGasFee: contractData.payByRenterForGasFee,
                                         _payByProviderForGasFee: contractData.payByProviderForGasFee)
                        LineWithSpacer(contain: "其他：\(contractData.additionalReqForGasFeePart)。")
                    }
                    Group {
                        LineWithSpacer(contain: "五、其他費用及其支付方式：\(contractData.additionalReqForOtherPart)。")
                    }
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndSixthSub() -> some View {
        //:~ paragraph 6
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第六條 稅費負擔之約定")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "本租賃契約有關稅費、代辦費，依下列約定辦理：")
                    LineWithSpacer(contain: "一、房屋稅、地價稅由出租人負擔。")
                    LineWithSpacer(contain: "二、銀錢收據之印花稅由出租人負擔。")
                    Group {
                        LineWithSpacer(contain: "三、簽約代辦費\(contractData.contractSigurtureProxyFee)元")
                        idfcontractSigurtureProxyFee(_payByRenterForProxyFee: contractData.payByRenterForProxyFee,
                                                     _payByProviderForProxyFee: contractData.payByProviderForProxyFee,
                                                     _separateForBothForProxyFee: contractData.separateForBothForProxyFee)
                    }
                    Group {
                        LineWithSpacer(contain: "四、公證費\(contractData.contractIdentitificationFee)元")
                        idfcontractIdentitificationFee(_payByRenterForIDFFee: contractData.payByRenterForIDFFee,
                                                       _payByProviderForIDFFee: contractData.payByProviderForIDFFee,
                                                       _separateForBothForIDFFee: contractData.separateForBothForIDFFee)
                    }
                    Group {
                        LineWithSpacer(contain: "五、公證代辦費\(contractData.contractIdentitificationProxyFee)元")
                        idfcontractIdentitificationProxyFee(_payByRenterForIDFProxyFee: contractData.payByRenterForIDFProxyFee,
                                                            _payByProviderForIDFProxyFee: contractData.payByProviderForIDFProxyFee,
                                                            _separateForBothForIDFProxyFee: contractData.separateForBothForIDFProxyFee)
                    }
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndSeventhSub() -> some View {
        //:~ paragraph 7
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第七條 使用房屋之限制")
            VStack(spacing: 6) {
                Group {
                    Text("本房屋係供住宅使用。非經出租人同意，不得變更用途。承租人同意遵守住戶規約，不得違法使用，或存放有爆炸性或易燃性物品，影響公共安全。")
                    subLeaseAgreement(_subLeaseAgreement: contractData.subLeaseAgreement)
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndEighthSub() -> some View {
        VStack(spacing: 6) {
            TitleView(titleName: "第八條 修繕及改裝")
            Group {
                Group {
                    Text("房屋或附屬設備損壞而有修繕之必要時，應由出租人負責修繕。但租賃雙方另有約定、習慣或可歸責於承租人之事由者，不在此限。")
                    Text("前項由出租人負責修繕者，如出租人未於承租人所定相當期限內修繕時，承租人得自行修繕並請求出租人償還其費用或於第四條約定之擔保金中扣除，若毀損嚴重者需償付所有修繕費用。")
                    Text("房屋有改裝設施之必要，承租人應經出租人同意，始得依相關法令自行裝設，但不得損害原有建築之結構安全。前項情形承租人返還房屋時，應負責回復原狀。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func firstParagraphAndNinethSub() -> some View {
        //:~ paragraph 9
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第九條 承租人之責任")
            VStack(spacing: 6) {
                Group {
                    Text("承租人應以善良管理人之注意保管房屋，如違反此項義務，致房屋毀損或滅失者，應負損害賠償責任。但依約定之方法或依房屋之性質使用、收益，致房屋有毀損或滅失者，不在此限。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder //:~ paragraph 10
    func firstParagraphAndTenthSub() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十條 房屋部分滅失")
            VStack(spacing: 6) {
                Group {
                    Text("租賃關係存續中，因不可歸責於承租人之事由，致房屋之一部滅失者，承租人得按滅失之部分，請求減少租金。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder //:~ paragraph 11
    func firstParagraphAndEleventhSub() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十一條 提前終止租約")
            VStack(spacing: 6) {
                Group {
                    Text("本契約於期限屆滿前，租賃雙方不得終止租約。依約定得終止租約者，租賃之一方應於一個月前通知他方。一方未為先期通知而逕行終止租約者，應賠償他方一個月(最高不得超過一個月)租金額之違約金。")
                    Text("前項承租人應賠償之違約金得由第四條之擔保金(押金)中扣抵。租期屆滿前，依第二項終止租約者，出租人已預收之租金應返還予承租人。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder //:~ paragraph 12
    func firstParagraphAndtwelevethSub() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十二條 房屋之返還")
            VStack(spacing: 6) {
                Group {
                    Text("租期屆滿或租賃契約終止時，承租人應即將房屋返還出租人並遷出戶籍或其他登記。")
                    Text("前項房屋之返還，應由租賃雙方共同完成屋況及設備之點交手續。租賃之一方未會同點交，經他方定相當期限催告仍不會同者，視為完成點交。")
                    Text("承租人未依第一項約定返還房屋時，出租人得向承租人請求未返還房屋期間之相當月租金額外，並得請求相當月租金額一倍(未足一個月者，以日租金折算)之違約金至返還為止。")
                    Text("前項金額及承租人未繳清之相關費用，出租人得由第四條之擔保金(押金)中扣抵。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndThirteenth() -> some View {
        //:~ paragraph 13
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十三條 房屋所有權之讓與")
            VStack(spacing: 6) {
                Group {
                    Text("出租人於房屋交付後，承租人占有中，縱將其所有權讓與第三人，本契約對於受讓人仍繼續存在。")
                    Text("前項情形，出租人應移交擔保金（押金）及已預收之租金與受讓人，並以書面通知承租人。")
                    Text("本契約如未經公證，其期限逾五年或未定期限者，不適用前二項之約定。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndFourteenth() -> some View {
        //:~ paragraph 14
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十四條 出租人終止租約")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "承租人有下列情形之一者，出租人得終止租約：")
                    Text("一、遲付租金之總額達二個月之金額，並經出租人定相當期限催告，承租人仍不為支付。")
                    LineWithSpacer(contain: "二、違反第七條規定而為使用。")
                    LineWithSpacer(contain: "三、違反第八條第三項規定而為使用。")
                    Text("四、積欠管理費或其他應負擔之費用達相當二個月之租金額，經出租人定相當期限催告，承租人仍不為支付。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndFiveteenth() -> some View {
        //:~ paragraph 15
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十五條 承租人終止租約")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "出租人有下列情形之一者，承租人得終止租約：")
                    Text("一、房屋損害而有修繕之必要時，其應由出租人負責修繕者，經承租人定相當期限催告，仍未修繕完畢。")
                    Text("二、有第十條規定之情形，減少租金無法議定，或房屋存餘部分不能達租賃之目的。")
                    LineWithSpacer(contain: "三、房屋有危及承租人或其同居人之安全或健康之瑕疵時。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndSixteenth() -> some View {
        //:~ paragraph 16
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十六條 遺留物之處理")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "租期屆滿或租賃契約終止後，承租人之遺留物依下列方式處理：")
                    LineWithSpacer(contain: "一、承租人返還房屋時，任由出租人處理。")
                    Text("二、承租人未返還房屋時，經出租人定相當期限催告搬離仍不搬離時，視為廢棄物任由出租人處理。")
                    Text("前項遺留物處理所需費用，由擔保金(押金)先行扣抵，如有不足，出租人得向承租人請求給付不足之費用。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndSeventeenth() -> some View {
        //:~ paragraph 17
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十七條 通知送達及寄送")
            VStack(spacing: 6) {
                Group {
                    Text("除本契約另有約定外，出租人與承租人雙方相互間之通知，以郵寄為之者，應以本契約所記載之地址為準；並得以電子郵件、簡訊等方式為之(無約定通知方式者，應以郵寄為之)；如因地址變更未通知他方，致通知無法到達時（包括拒收），以他方第一次郵遞或通知之日期推定為到達日。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    @ViewBuilder
    func fitstParagraphAndEighteenth() -> some View {
        //:~ paragraph 18
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十八條 疑義處理")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "本契約各條款如有疑義時，應為有利於承租人之解釋。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    @ViewBuilder
    func fitstParagraphAndNineteenth() -> some View {
        //:~ paragraph 19
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第十九條 其他約定")
            VStack(spacing: 6) {
                Group {
                    doCourtIDF(_doCourtIDF: contractData.doCourtIDF)
                    doCourtIDFDoc(_courtIDFDoc: contractData.courtIDFDoc)
                    LineWithSpacer(contain: "一、承租人如於租期屆滿後不返還房屋。")
                    Text("二、承租人未依約給付之欠繳租金、出租人代繳之管理費，或違約時應支付之金額。")
                    Text("三、出租人如於租期屆滿或租賃契約終止時，應返還之全部或一部擔保金（押金）。")
                    Text("公證書載明金錢債務逕受強制執行時，如有保證人者，前項後段第__款之效力及於保證人。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndtwentyth() -> some View {
        //:~ paragraph 20
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第二十條 爭議處理")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "因本契約發生之爭議，雙方得依下列方式處理：")
                    Text("一、向房屋所在地之直轄市、縣（市）不動產糾紛調處委員會申請調處。")
                    LineWithSpacer(contain: "二、向直轄市、縣（市）消費爭議調解委員會申請調解。")
                    LineWithSpacer(contain: "三、向鄉鎮市(區)調解委員會申請調解。")
                    LineWithSpacer(contain: "四、向房屋所在地之法院聲請調解或進行訴訟。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndtwentyFirst() -> some View {
        //:~ paragraph 21
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第二十一條 契約及其相關附件效力")
            VStack(spacing: 6) {
                Group {
                    LineWithSpacer(contain: "本契約自簽約日起生效，雙方各執一份契約正本。")
                    LineWithSpacer(contain: "本契約廣告及相關附件視為本契約之一部分。")
                    LineWithSpacer(contain: "本契約所定之權利義務對雙方之繼受人均有效力。")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fitstParagraphAndtwentySecond() -> some View {
        //:~ paragraph 22
        VStack(alignment: .leading, spacing: 5) {
            TitleView(titleName: "第二十二條 未盡事宜之處置")
            VStack(spacing: 6) {
                Group {
                    Text("本契約如有未盡事宜，依有關法令、習慣、平等互惠及誠實信用原則公平解決之。附件會寄送至電子郵件")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .padding(.top, 5)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func blockByBankCheck(_isBlockByBank: Bool) -> some View {
        if _isBlockByBank == true {
            LineWithSpacer(contain: "(六)有查封登記。")
        } else {
            LineWithSpacer(contain: "(六)無查封登記。")
        }
    }
    
    @ViewBuilder
    func buildProvidePart(_entire: Bool, _part: Bool) -> some View {
        if _entire == true {
            LineWithSpacer(contain: "(一)租賃住宅全部：第\(contractData.provideFloor)層, 房間\(contractData.provideRooms)間, 第\(contractData.provideRoomNumber)室，面積\(contractData.provideFloor)平方公尺。")
        } else if _part == true {
            LineWithSpacer(contain: "(一)租賃住宅部分：第\(contractData.provideFloor)層□房間\(contractData.provideRooms)間□第\(contractData.provideRoomNumber)室，面積\(contractData.provideFloor)平方公尺。")
        }
    }
    
    @ViewBuilder
    func forUsingDay(_all: Bool, _morning: Bool, _night: Bool) -> some View {
        if _all == true {
            HStack {
                Text("全日。") //使用時間全日, 日間, 夜間
                Spacer()
            }        }
        if _morning == true {
            HStack {
                Text("□日間。") //使用時間全日, 日間, 夜間
                Spacer()
            }
        }
        if _night == true {
            HStack {
                Text("夜間。") //使用時間全日, 日間, 夜間
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func idfParkingLotStyle(parkingStyleN: Bool, parkingStyleM: Bool) -> some View {
        if parkingStyleM == true {
            Text("地上(下)第\(contractData.parkingUGFloor)層機械式停車位，編號第\(contractData.parkingNumberForVehicle)號。") //平面式停車位, 機械式停車位
        }
        if parkingStyleN == true {
            Text("地上(下)第\(contractData.parkingUGFloor)層平面式停車位，編號第\(contractData.parkingNumberForVehicle)號。") //平面式停車位, 機械式停車位
        }
    }
    
    @ViewBuilder
    func vehicleType(isVehicle: Bool, isMorto: Bool) -> some View {
        if isVehicle == true {
            LineWithSpacer(contain: "1.汽車停車位種類及編號：")
            idfParkingLotStyle(parkingStyleN: contractData.parkingStyleN, parkingStyleM: contractData.parkingStyleM)
        }
        if isMorto == true {
            LineWithSpacer(contain: "2.機車停車位：")
            HStack {
                Text("地上(下)第\(contractData.parkingNumberForMortor)或其位置示意圖。")
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func haveParkingLot(_hasParkingLot: Bool, _all: Bool, _morning: Bool, _night: Bool, isVehicle: Bool, isMorto: Bool) -> some View {
        if _hasParkingLot == true {
            Group {
                LineWithSpacer(contain: "(二)車位：(如無則免填)")//汽車停車位, 機車停車位
                vehicleType(isVehicle: isVehicle, isMorto: isMorto)
                LineWithSpacer(contain: "3.使用時間：")
                forUsingDay(_all: _all, _morning: _morning, _night: _night)
            }
        } else {
            Group {
                LineWithSpacer(contain: "(二)車位：(如無則免填)")//汽車停車位, 機車停車位
                LineWithSpacer(contain: "1.汽車停車位種類及編號：")
                Text("地上(下)第＿＿層□平面式停車位□機械式停車位，編號第＿＿號。") //平面式停車位, 機械式停車位
                LineWithSpacer(contain: "2.機車停車位：")
                HStack {
                    Text("地上(下)第＿＿層，編號第＿＿號或其位置示意圖。")
                    Spacer()
                    
                }
                LineWithSpacer(contain: "3.使用時間：")
                HStack {
                    Text("□全日□日間□夜間□其他___。") //使用時間全日, 日間, 夜間
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    func idfSubFacility(_havingSubFacility: Bool) -> some View {
        if _havingSubFacility == true {
            Text("有附屬設備，若有，除另有附屬設備清單外，詳如附件委託管理標的現況確認書。") ////租賃附屬設備有無
        } else {
            Text("無附屬設備，若有，除另有附屬設備清單外，詳如附件委託管理標的現況確認書。") ////租賃附屬設備有無
        }
    }
    
    @ViewBuilder
    func idfPaymentMethod(_paybyCash: Bool, _paybyTransmission: Bool, _paybyCreditDebitCard: Bool) -> some View {
        if _paybyCash == true {
            Text("租金支付方式：現金繳付。") //報酬約定及給付-轉帳繳付
        }
        if _paybyTransmission == true {
            Text("租金支付方式：轉帳繳付：金融機構：\(contractData.bankName)，戶名：\(contractData.bankOwnerName)，帳號：\(contractData.bankAccount)。")
        }
        if _paybyCreditDebitCard == true {
            Text("租金支付方式：信用/簽帳卡繳付。")
        }
        if _paybyCash == true && _paybyTransmission == true && _paybyCreditDebitCard == true {
            Text("租金支付方式：現金繳付/轉帳繳付信用/簽帳卡繳付皆可：金融機構：\(contractData.bankName)，戶名：\(contractData.bankOwnerName)，帳號：\(contractData.bankAccount)。")
        }
    }
    
    @ViewBuilder
    func idfPaymentSideMF(_payByRenterForManagementPart: Bool, _payByProviderForManagementPart: Bool) -> some View {
        if _payByRenterForManagementPart == true {
            LineWithSpacer(contain: "由承租人負擔。")
        }
        if _payByProviderForManagementPart == true {
            LineWithSpacer(contain: "由出租人負擔。")
        }
    }
    @ViewBuilder
    func idfPaymentSideWF(_payByRenterForWaterFee: Bool, _payByProviderForWaterFee: Bool) -> some View {
        if _payByRenterForWaterFee == true {
            LineWithSpacer(contain: "由承租人負擔。")
        }
        if _payByProviderForWaterFee == true {
            LineWithSpacer(contain: "由出租人負擔。")
        }
    }
    
    @ViewBuilder
    func idfPaymentSideEF(_payByRenterForEletricFee: Bool, _payByProviderForEletricFee: Bool) -> some View {
        if _payByRenterForEletricFee == true {
            LineWithSpacer(contain: "由承租人負擔。")
        }
        if _payByProviderForEletricFee == true {
            LineWithSpacer(contain: "由出租人負擔。")
        }
    }
    @ViewBuilder
    func idfPaymentSideGF(_payByRenterForGasFee: Bool, _payByProviderForGasFee: Bool) -> some View {
        if _payByRenterForGasFee == true {
            LineWithSpacer(contain: "由承租人負擔。")
        }
        if _payByProviderForGasFee == true {
            LineWithSpacer(contain: "由出租人負擔。")
        }
    }
    
    @ViewBuilder
    func idfcontractSigurtureProxyFee(_payByRenterForProxyFee: Bool, _payByProviderForProxyFee: Bool, _separateForBothForProxyFee: Bool) -> some View {
        if _payByRenterForProxyFee == true {
            LineWithSpacer(contain: "由承租人負擔。")
        }
        if _payByProviderForProxyFee == true {
            LineWithSpacer(contain: "由出租人負擔。")
        }
        if _separateForBothForProxyFee == true {
            LineWithSpacer(contain: "由租賃雙方平均負擔。")
        }
    }
    
    @ViewBuilder
    func idfcontractIdentitificationFee(_payByRenterForIDFFee: Bool, _payByProviderForIDFFee: Bool, _separateForBothForIDFFee: Bool) -> some View {
        if _payByRenterForIDFFee == true {
            LineWithSpacer(contain: "由承租人負擔。")
        }
        if _payByProviderForIDFFee == true {
            LineWithSpacer(contain: "由出租人負擔。")
        }
        if _separateForBothForIDFFee == true {
            LineWithSpacer(contain: "由租賃雙方平均負擔。")
        }
    }
    
    @ViewBuilder
    func idfcontractIdentitificationProxyFee(_payByRenterForIDFProxyFee: Bool, _payByProviderForIDFProxyFee: Bool, _separateForBothForIDFProxyFee: Bool) -> some View {
        if _payByRenterForIDFProxyFee == true {
            LineWithSpacer(contain: "由承租人負擔。")
        }
        if _payByProviderForIDFProxyFee == true {
            LineWithSpacer(contain: "由出租人負擔。")
        }
        if _separateForBothForIDFProxyFee == true {
            LineWithSpacer(contain: "由租賃雙方平均負擔。")
        }
    }
    
    @ViewBuilder
    func subLeaseAgreement(_subLeaseAgreement: Bool) -> some View {
        if _subLeaseAgreement == true {
            Text("出租人同意將本房屋之全部或一部分轉租、出借或 以其他方式供他人使用，或將租賃權轉讓於他人。前項出租人同意轉租者，承租人應提示出租人同意轉租之證明文件。")
        } else {
            Text("出租人不同意將本房屋之全部或一部分轉租、出借或 以其他方式供他人使用，或將租賃權轉讓於他人。前項出租人同意轉租者，承租人應提示出租人同意轉租之證明文件。")
        }
    }
    
    @ViewBuilder
    func doCourtIDF(_doCourtIDF: Bool) -> some View {
        if _doCourtIDF == true {
            LineWithSpacer(contain: "本契約雙方同意辦理公證。")
        } else {
            LineWithSpacer(contain: "本契約雙方同意不辦理公證。")
        }
    }
    
    @ViewBuilder
    func doCourtIDFDoc(_courtIDFDoc: Bool) -> some View {
        if _courtIDFDoc == true {
            Text("本契約經辦理公證者，租賃雙方同意公證書載明下列事項應逕受強制執行：")
        } else {
            Text("本契約經辦理公證者，租賃雙方不同意公證書載明下列事項應逕受強制執行：")
        }
    }
}
