//
//  ProviderSummittedRoomContractView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/2/22.
//

import SwiftUI

struct ProviderSummittedRoomContractView: View {
    
    @State var userName = "some name"
    @State var isAgree = false
    
    //:~ paragraph 1
    var roomAddress = ""
    var town = ""
    var city = ""
    var zipCode = ""
    var roomArea = ""
    var buildNumber = ""
    var buildArea = ""
    var buildingPurpose = ""
    var roomAtFloor = ""
    var floorArea = ""
    var subBuildingPurpose = ""
    var subBuildingArea = ""
    
    var provideForAll = false
    var provideForPart = false
    var provideFloor = ""
    var provideRooms = ""
    var provideRoomNumber = ""
    
    var isVehicle = false
    var isMorto = false
    var parkingUGFloor = ""
    var parkingStyleN = false
    var parkingStyleM = false
    var parkingNumber = ""
    
    var forAllday = false
    var forMorning = false
    var forNight = false
    
    var havingSubFacility = false
    
    //:~ paragraph 2
    var providingTimeRangeStart = ""
    var providingTimeRangeEnd = ""
    
    var body: some View {
        ZStack {
            Group {
                Rectangle()
                    .fill(Color("backgroundBrown"))
                    .edgesIgnoringSafeArea([.top, .bottom])
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white)
                    .frame(width: UIScreen.main.bounds.width - 15)
            }
            VStack {
                ScrollView(.vertical, showsIndicators: true) {
                    Group {
                        VStack(spacing: 2) {
                            Text("租賃住宅委託管理契約書")
                                .font(.title2)
                                .font(.system(size: 15))
                            Text("中華民國108年9月5日內政部台內地字第1080264475號函訂定")
                                .font(.system(size: 12))
                        }
                        .padding(.top, 5)
                        VStack {
                            Text("        立契約書人委託人: \(userName)，受託人(租賃住宅代管業): FranciS有限公司，茲為租賃住宅代管事宜，雙方同意本契約條款如下：")
                                .font(.system(size: 15, weight: .regular))
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                    }
                    
                    Group {
                        //:~ paragraph 1
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第一條   委託管理標的")
                            SubTitleView(subTitleName: "一、租賃住宅標示：")
                            VStack(spacing: 6) {
                                Group {
                                    Text("(一)門牌\(zipCode)\(city)縣(市)\(town)鄉(鎮、市、 區)\(roomAddress)(基地坐落__段__小段__地號)。無門牌者，其房屋稅籍編號：___或其位置略圖。")
                                    LineWithSpacer(contain: "(二)專有部分建號\(buildNumber)，權利範圍\(buildArea)，面積共計\(roomArea)平方公尺。")
                                    LineWithSpacer(contain: "1.主建物面積：")
                                    Text("\(roomAtFloor)層\(floorArea)平方公尺，__層__平方公尺，__層__平方公尺共計__平方公尺，用途\(buildingPurpose)。")
                                    LineWithSpacer(contain: "2.附屬建物用途\(subBuildingPurpose)，面積\(subBuildingArea)平方公尺。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            SubTitleView(subTitleName: "二、委託管理範圍：")
                            
                            VStack(spacing: 6) {
                                Group {
                                    LineWithSpacer(contain: "(一)租賃住宅□全部□部分：第\(provideFloor)層□房間\(provideRooms)間□第\(provideRoomNumber)室，面積\(roomArea)平方公尺。")
                                    LineWithSpacer(contain: "(二)車位：(如無則免填)")
                                    LineWithSpacer(contain: "1.汽車停車位種類及編號：")
                                    Text("地上(下)第\(parkingUGFloor)層□平面式停車位□機械式停車位，編號第\(parkingNumber)號。")
                                    LineWithSpacer(contain: "2.機車停車位：")
                                    HStack {
                                        Text("地上(下)第\(parkingUGFloor)層，編號第\(parkingNumber)號或其位置示意圖。")
                                        Spacer()
                                        
                                    }
                                    LineWithSpacer(contain: "3.使用時間：")
                                    HStack {
                                        Text("□全日□日間□夜間□其他___。")
                                        Spacer()
                                    }
                                    LineWithSpacer(contain: "(三)租賃附屬設備：")
                                    Text("□有□無附屬設備，若有，除另有附屬設備清單外，詳如附件委託管理標的現況確認書。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                    }
                    
                    Group {
                        //:~ paragraph 2
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第二條　委託管理期間")
                            VStack(spacing: 6) {
                                Group {
                                    Text("委託管理期間自\(providingTimeRangeStart)起至\(providingTimeRangeEnd)止。前項委託管理期間屆滿時，委託管理標的之租賃關係仍屬存續者，委任雙方得於租賃期間內約定展延委託管理期間。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        //:~ paragraph 3
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第三條　報酬約定及給付")
                            VStack(spacing: 6) {
                                Group {
                                    Text("委託人於租賃成立時，得向受託人收取房屋租賃費，其數額為協議成交租金之    個月（最高不得超過中央主管機關之規定）；如以押租金所生利息為租金者，其利率以雙方約定為之，未約定者依法定利率。")
                                    Text("前項受託人之服務報酬，委託人於與承租人簽訂租賃契約時，不需支付服務報酬。前項報酬給付方式：□現金繳付□於代為收取之租金內扣付□轉帳繳付：金融機構：____，戶名：____，帳號：____□其他＿＿＿。")
                                    Text("委託管理標的之租賃關係消滅，且委託人未提前終止本契約者，委託人不得向受託人收取報酬。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        //:~ paragraph 4
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第四條　委託管理項目")
                            VStack(spacing: 6) {
                                Group {
                                    LineWithSpacer(contain: "委託管理期間，受託人代為管理項目如下：")
                                    LineWithSpacer(contain: "一、屋況與設備點交。")
                                    LineWithSpacer(contain: "二、居住者身分之確認。")
                                    LineWithSpacer(contain: "三、向承租人催收(繳)租金及相關費用。")
                                    Group {
                                        LineWithSpacer(contain: "四、日常修繕維護事項：")
                                        LineWithSpacer(contain: "(一)租賃住宅及其附屬設備檢查及維護。")
                                        LineWithSpacer(contain: "(二)修繕費用通報及修繕或督促修繕。")
                                    }
                                    LineWithSpacer(contain: "五、糾紛協調處理。")
                                    LineWithSpacer(contain: "六、結算相關費用。")
                                    LineWithSpacer(contain: "七、租賃關係消滅時，督促承租人返還租賃住宅並遷出戶籍或其他登記。")
                                    //                                Group {
                                    //                                    LineWithSpacer(contain: "八、其他項目：")
                                    //
                                    //                                }
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        //:~ paragraph 5
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第五條　違反使用限制之處理")
                            VStack(spacing: 6) {
                                Group {
                                    Text("委託管理標的係供居住使用，承租人如有變更用途、未遵守公寓大廈規約或其他住戶應遵行事項，違法使用、存放有爆炸性或易燃性物品，影響公共安全、公共衛生或居住安寧，受託人應予制止，並得向承租人終止合約且不返還押金。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        //:~ paragraph 6
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第六條　修繕之處理")
                            VStack(spacing: 6) {
                                Group {
                                    Text("委託管理標的經租賃契約約定由委託人負責修繕者，得委由受託人修繕；其費用，由承租人負擔。")
                                    Text("委託管理標的經租賃契約約定由承租人負責修繕及負擔費用者，得由受託人代為督促之；承租人對於應負責修繕之項目或費用有爭執時，受託人應代為協調。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        //:~ paragraph 7
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第七條　委託人之義務及責任")
                            VStack(spacing: 6) {
                                Group {
                                    Text("委託人應據實提供附件之委託管理標的現況確認書相關資訊，並確保合於租賃契約所約定居住使用之狀態。")
                                    Text("簽訂本契約時，委託人應出示有權委託管理本租賃住宅之證明文件、國民身分證或其他足資證明身分之文件，供受託人核對；如有同意受託人代為收取租金、押金者，並應提供交付之方式。")
                                    Text("在契約時間內，委託人不得於委託管理期間內將房屋轉租或賣出，亦不得將委託管理標的轉由其他託管業者。")
                                    Text("簽訂本契約時，受託人應向委託人說明租賃契約約定應由委託人負責修繕之項目、範圍、有修繕必要時之聯絡方式及其他相關事項。")
                                    Text("委託人於委託管理期間內，未經受託人或承租人同意不得進入委託管理標的，且不得干涉受託人對委託管理標的之管理與使用，但涉及結構變更者，不在此限。")
                                    Text("委託人不得於委託管理期間內張貼租屋廣告，或另為房屋租賃契約之要約或要約之引誘。")
                                    Text("委託人應交付本房屋之權狀影本、使用執照影本、鑰匙等予受託人，如有住戶規約等，一併提供其影本。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                    }
                    
                    Group {
                        
                        //:~ paragraph 8
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第八條　受託人之義務及責任")
                            VStack(spacing: 6) {
                                Group {
                                    Group {
                                        LineWithSpacer(contain: "委託管理期間，受託人之義務如下：")
                                        LineWithSpacer(contain: "一、應出示租賃住宅服務業登記證影本，供委託人核對。")
                                        LineWithSpacer(contain: "二、應負責督促承租人以善良管理人之注意，保管、使用租賃住宅。")
                                        Text("三、依第四條第一款規定，代為執行屋況與設備點交者，應於租賃期間屆滿或租賃契約提前終止時，先行協助結算相關費用、製作代收代付清單、結算承租人於租賃期間應繳未繳之費用與協助執行屋況及附屬設備點交，並通知委託人將扣除未繳費用之賸餘押金返還承租人。")
                                        Text("四、依第四條第三款規定，代為向承租人催收(繳)租金及相關費用者，應於繳款期限屆滿後3日內催收(繳)。")
                                        Text("五、依第四條第四款或第八款第五目規定，代為辦理日常修繕維護或清潔事務者，應製作執行紀錄，提供委託人查詢或取閱。")
                                        Text("六、依第四條第五款規定，代為協調處理租賃糾紛者，應包括承租人使用委託管理標的之糾紛。")
                                        Text("七、依第四條第八款第一目或第二目規定，收取租金或押金，應按約定交付方式；根據委託人方案之選擇，倘受託人於簽約日起7日內給付第一年期租金，並以年繳方式給付至委託管理期間屆滿者，委託人不得再對受託人請求受託人向承租人收取之租金；倘委託人選擇每月收取之約定租金新台幣___元，依雙方約定之交付方式及期限(不超過三十日)給付予委託人。")
                                    }
                                    Group {
                                        Text("八、依第四條第八款第三目規定，管理押金者，除於租賃關係消滅時，抵充承租人因租賃契約所生之債務外，不得動支，並應於承租人返還委託管理標的時，不需經委託人同意，返還押金或抵充債務後之賸餘押金予承租人。")
                                        Text("九、應於收受委託人之有關報酬或文件時，開立統一發票或掣給收據。")
                                        LineWithSpacer(contain: "十、應配合委託人申請減徵稅捐需要，提供相關證明。")
                                        Text("十一、不得委託他代管業執行租賃住宅管理業務。因可歸責於受託人之事由而違反前項各款規定，致委託人受有損害者，應負賠償責任。")
                                        
                                    }
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        //:~ paragraph 9
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第九條　租賃住宅返還之處理")
                            VStack(spacing: 6) {
                                Group {
                                    Text("委託管理標的之租賃關係消滅時，受託人應即結算相關費用，督促承租人將租賃住宅返還委託人，並遷出戶籍或其他登記。")
                                    Text("因可歸責於受託人之事由而違反前項規定，致委託人受有損害者，應負賠償責任。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        //:~ paragraph 10
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第十條　委託人提前終止契約")
                            VStack(spacing: 6) {
                                Group {
                                    LineWithSpacer(contain: "委託管理期間有下列情形之一者，委託人得提前終止本契約：")
                                    Text("一、受託人違反第八條第一項第六款代為協調處理租賃糾紛之規定，經委託人定相當期間催告，仍不於期限內處理。")
                                    Text("二、受託人違反第八條第一項第十一款規定，委託他代管業執行租賃住宅管理業務。")
                                    LineWithSpacer(contain: "三、委託管理標的之租賃關係消滅。")
                                    Text("四、委託管理標的全部滅失，或一部滅失且其存餘部分難以繼續居住。")
                                    LineWithSpacer(contain: "五、受託人經主管機關撤銷、廢止許可或租賃住宅服務業登記。")
                                    Text("委託管理期間，若委託人非因於前項規定而提前終止契約，應繳回公司預付租金之未期滿部分外，需繳付年租金之50％作為成法性違約金支付公司損失。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        //:~ paragraph 11
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第十一條　受託人提前終止契約")
                            VStack(spacing: 6) {
                                Group {
                                    LineWithSpacer(contain: "委託管理期間有下列情形之一者，受託人得提前終止本契約：")
                                    Text("一、因委託人違反第七條第一項或第五項或第六項規定，致受託人無法繼續管理委託標的。")
                                    LineWithSpacer(contain: "二、委託管理標的之租賃關係消滅且已完成第九條第一項規定事項。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        //:~ paragraph 12
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第十二條　履行本契約之通知")
                            VStack(spacing: 6) {
                                Group {
                                    Text("除本契約另有約定外，委任雙方相互間之通知，以郵寄為之者，應以本契約所記載之地址為準；如因地址變更未告知他方，致通知無法到達他方時，以第一次郵遞之日期推定為到達日。")
                                    Text("前項之通知得經委任雙方約定以□電子郵件信箱：___□手機簡訊□即時通訊軟體以文字顯示方式為之。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        //:~ paragraph 13
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第十三條　契約及其相關附件效力")
                            VStack(spacing: 6) {
                                Group {
                                    Text("本契約自簽約日起生效，委任雙方各執一份契約正本。受託人之廣告及相關附件視為本契約之一部分。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        //:~ paragraph 14
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第十四條　未盡事宜之處置")
                            VStack(spacing: 6) {
                                Group {
                                    Text("本契約條款如有疑義或未盡事宜，依有關法令、習慣、平等互惠及誠實信用原則公平解決之。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                    }
                    
                    Group {
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "立契約書人")
                            VStack(spacing: 6) {
                                Group {
                                    VStack {
                                        signatureContainer(containerName: "委託人：")
                                        signatureHolder(signatureTitle: "姓名：")
                                        signatureContainer(containerName: "統一編號或身分證明文件編號：")
                                        signatureContainer(containerName: "戶籍地址：")
                                        signatureContainer(containerName: "通訊地址：")
                                        signatureContainer(containerName: "聯絡電話：")
                                        signatureContainer(containerName: "電子郵件信箱：")
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
                                        signatureContainer(containerName: "受託人：")
                                        signatureHolder(signatureTitle: "公司名稱：")
                                        signatureContainer(containerName: "代表人姓名：")
                                        signatureContainer(containerName: "統一編號：")
                                        signatureContainer(containerName: "登記證字號：")
                                        signatureContainer(containerName: "營業地址：")
                                        signatureContainer(containerName: "聯絡電話：")
                                        signatureContainer(containerName: "電子郵件信箱：")
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
                                        signatureContainer(containerName: "租賃住宅管理人員：")
                                        signatureHolder(signatureTitle: "姓名：")
                                        signatureContainer(containerName: "證書字號：")
                                        signatureContainer(containerName: "通訊地址：")
                                        signatureContainer(containerName: "登記證字號：")
                                        signatureContainer(containerName: "聯絡電話：")
                                        signatureContainer(containerName: "電子郵件信箱：")
                                    }
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                    }
                    
                    HStack(alignment: .center, spacing: 5) {
                        Button {
                            isAgree.toggle()
                        } label: {
                            Image(systemName: isAgree ? "checkmark.square.fill" : "checkmark.square")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(Color.green)
                        }
                        Text("I agree and read whole policy.")
                            .font(.system(size: 12))
                    }
                    .padding(.top, 10)
                    
                    Button {
                        
                    } label: {
                        Text("Summit")
                            .foregroundColor(.white)
                            .frame(width: 108, height: 35)
                            .background(Color("buttonBlue"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    .padding(.top, 10)
                    .padding(.horizontal)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 20)
            .padding()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}



struct TitleView: View {
    var titleName: String
    var body: some View {
        HStack {
            Text(titleName)
                .font(.system(size: 15, weight: .regular))
            Spacer()
            //                .frame(width: UIScreen.main.bounds.width / 2)
        }
    }
}

struct SubTitleView: View {
    var subTitleName: String
    var body: some View {
        HStack {
            Text(subTitleName)
                .font(.system(size: 15, weight: .regular))
            Spacer()
            //                .frame(width: UIScreen.main.bounds.width / 2 + 33)
        }
    }
}

struct LineWithSpacer: View {
    var contain: String
    var body: some View {
        HStack {
            Text(contain)
            Spacer()
        }
    }
}

struct signatureContainer: View {
    var containerName: String
    var containHolder = "some info"
    var body: some View {
        HStack {
            Text(containerName)
            Text(containHolder)
            Spacer()
        }
    }
}

struct signatureHolder: View {
    var signatureTitle: String
    var body: some View {
        HStack {
            Text(signatureTitle)
            Text("簽章")
                .padding(.leading)
            Spacer()
        }
    }
}

struct ProviderSummittedRoomContractView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderSummittedRoomContractView()
    }
}
