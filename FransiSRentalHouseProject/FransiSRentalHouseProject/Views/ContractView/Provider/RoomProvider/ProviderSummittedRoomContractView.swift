//
//  ProviderSummittedRoomContractView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/2/22.
//

import SwiftUI

/*
 struct ProviderSummittedRoomContractView: View {

     @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
     @EnvironmentObject var appViewModel: AppViewModel

     @State var userName = "some name"
     @State var isAgree = false

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
                                     Text("(一)門牌\(appViewModel.roomZipCode)\(appViewModel.roomCity)縣(市)\(appViewModel.roomTown)鄉(鎮、市、 區)\(appViewModel.roomAddress)(基地坐落__段__小段__地號)。無門牌者，其房屋稅籍編號：___或其位置略圖。")
                                     LineWithSpacer(contain: "(二)專有部分建號\(appViewModel.specificBuildingNumber)，權利範圍\(appViewModel.specificBuildingRightRange)，面積共計\(appViewModel.specificBuildingArea)平方公尺。")
                                     LineWithSpacer(contain: "1.主建物面積：")
                                     Text("\(appViewModel.mainBuildArea)層 平方公尺，__層__平方公尺，__層__平方公尺共計__平方公尺，用途\(appViewModel.mainBuildingPurpose)。")
                                     LineWithSpacer(contain: "2.附屬建物用途\(appViewModel.subBuildingPurpose)，面積\(appViewModel.subBuildingArea)平方公尺。")
                                     LineWithSpacer(contain: "(三)共有部分建號:\(appViewModel.publicBuildingNumber)，權利範圍:\(appViewModel.publicBuildingRightRange)，持分面積\(appViewModel.publicBuildingArea)平方公尺。")
                                     LineWithSpacer(contain: "(四)車位：□有(汽車停車位\(appViewModel.parkinglotAmount)個、機車停車位__個)□無。") //車位有無
                                     LineWithSpacer(contain: "(五)□有□無設定他項權利，若有，權利種類：\(appViewModel.SettingTheRightForThirdPersonForWhatKind)。") //有無設定他項權利
                                     LineWithSpacer(contain: "(六)□有□無查封登記。") //有無查封登記
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
                                     LineWithSpacer(contain: "(一)租賃住宅□全部□部分：第\(appViewModel.provideFloor)層□房間\(appViewModel.provideRooms)間□第\(appViewModel.provideRoomNumber)室，面積\(appViewModel.provideFloor)平方公尺。") //租賃住宅全部
                                     if appViewModel.hasParkinglotYes == true && appViewModel.hasParkinglotNo == false {
                                         Group {
                                             LineWithSpacer(contain: "(二)車位：(如無則免填)")//汽車停車位, 機車停車位
                                             LineWithSpacer(contain: "1.汽車停車位種類及編號：")
                                             Text("地上(下)第\(appViewModel.parkingUGFloor)層□平面式停車位□機械式停車位，編號第\(appViewModel.parkingNumber)號。") //平面式停車位, 機械式停車位
                                             LineWithSpacer(contain: "2.機車停車位：")
                                             HStack {
                                                 Text("地上(下)第層，編號第 號或其位置示意圖。")
                                                 Spacer()

                                             }
                                             LineWithSpacer(contain: "3.使用時間：")
                                             HStack {
                                                 Text("□全日□日間□夜間□其他___。") //使用時間全日, 日間, 夜間
                                                 Spacer()
                                             }
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
                                     LineWithSpacer(contain: "(三)租賃附屬設備：")
                                     Text("□有□無附屬設備，若有，除另有附屬設備清單外，詳如附件委託管理標的現況確認書。") ////租賃附屬設備有無
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
                                     Text("委託管理期間自\(appViewModel.providingTimeRangeStart)起至\(appViewModel.providingTimeRangeEnd)止。前項委託管理期間屆滿時，委託管理標的之租賃關係仍屬存續者，委任雙方得於租賃期間內約定展延委託管理期間。")
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
                                     Text("前項受託人之服務報酬，委託人於與承租人簽訂租賃契約時，不需支付服務報酬。前項報酬給付方式：□現金繳付□於代為收取之租金內扣付□轉帳繳付：金融機構：\(appViewModel.bankName)，戶名：\(appViewModel.bankOwnerName)，帳號：\(appViewModel.bankAccount)□其他＿＿＿。") //報酬約定及給付-現金繳付, 轉帳繳付
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
                                         Text("七、依第四條第八款第一目或第二目規定，收取租金或押金，應按約定交付方式；根據委託人方案之選擇，倘受託人於簽約日起7日內給付第一年期租金，並以年繳方式給付至委託管理期間屆滿者，委託人不得再對受託人請求受託人向承租人收取之租金；倘委託人選擇每月收取之約定租金新台幣\(appViewModel.roomRentalPrice)元，依雙方約定之交付方式及期限(不超過三十日)給付予委託人。")
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
                                     Text("前項之通知得經委任雙方約定以□電子郵件信箱：___□手機簡訊□即時通訊軟體以文字顯示方式為之。") //履行本契約之通知-電子郵件信箱, 手機簡訊, 即時通訊軟體
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
                                         LineWithSpacer(contain: "委託人：")
                                         signatureHolder(signatureTitle: "姓名：", signString: "\(firestoreToFetchUserinfo.presentUserName())")
                                         signatureContainer(containerName: "統一編號或身分證明文件編號：", containHolder: "\(firestoreToFetchUserinfo.presentUserId())")
                                         signatureContainer(containerName: "戶籍地址：", containHolder: "\(firestoreToFetchUserinfo.presentAddress())")
                                         signatureContainer(containerName: "通訊地址：", containHolder: "\(firestoreToFetchUserinfo.presentAddress())")
                                         signatureContainer(containerName: "聯絡電話：", containHolder: "\(firestoreToFetchUserinfo.presentMobileNumber())")
                                         signatureContainer(containerName: "電子郵件信箱：", containHolder: "\(firestoreToFetchUserinfo.presentEmailAddress())")
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
                                         LineWithSpacer(contain: "受託人：")
                                         signatureHolder(signatureTitle: "公司名稱：", signString: "")
                                         signatureContainer(containerName: "代表人姓名：", containHolder: "")
                                         signatureContainer(containerName: "統一編號：", containHolder: "")
                                         signatureContainer(containerName: "登記證字號：", containHolder: "")
                                         signatureContainer(containerName: "營業地址：", containHolder: "")
                                         signatureContainer(containerName: "聯絡電話：", containHolder: "")
                                         signatureContainer(containerName: "電子郵件信箱：", containHolder: "")
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
                                         signatureContainer(containerName: "租賃住宅管理人員：", containHolder: "")
                                         signatureHolder(signatureTitle: "姓名：", signString: "")
                                         signatureContainer(containerName: "證書字號：", containHolder: "")
                                         signatureContainer(containerName: "通訊地址：", containHolder: "")
                                         signatureContainer(containerName: "登記證字號：", containHolder: "")
                                         signatureContainer(containerName: "聯絡電話：", containHolder: "")
                                         signatureContainer(containerName: "電子郵件信箱：", containHolder: "")
                                         LineWithSpacer(contain: "民國＿年＿月＿日")
                                     }
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)

                         VStack(alignment: .leading, spacing: 5) {
                             TitleView(titleName: "簽約注意事項")
                             SubTitleView(subTitleName: "一、適用範圍")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("(一)本契約書範本，係提供委託人(屬企業經營者之出租人)與受託人(租賃住宅代管業)簽訂租賃住宅委託管理契約(以下簡稱本契約)時參考使用，且該委託管理標的之用途，係供居住使用。")
                                     Text("(二)按行政院消費者保護處一百零五年五月三十日院臺消保字第一０五０一六五二七四號函「不論公司、團體或個人，亦不論其營業於行政上是否經合法登記或許可經營，若反覆實施出租行為，非屬偶一為之，並以出租為業者，均可認定為企業經營者。」出租人為企業經營者，其支付報酬委託租賃住宅代管業(以下簡稱代管業)管理租賃住宅，係企業經營者接受代管業提供租賃住宅管理服務，不具消費關係，從而應適用本契約書範本。")
                                     Text("(三)基於受託人應提供之代管專業服務內容，及保障委託人之租賃或委託管理之權益，受託人依本契約執行租賃關係消滅後之相關事項時，本契約之委託人仍視為具出租人地位。")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)

                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "二、委任關係")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("稱委任者，謂當事人約定，一方委託他方處理事務，他方允為處理之契約(民法第五百二十八條)。委託處理事務之一方，稱為委託人，同意受託代為處理事務之一方，稱為受託人。")
                                     Text("本契約之受託人為代管業，指受出租人之委託，經營租賃住宅管理業務之公司(租賃住宅市場發展及管理條例第三條第四款)。該租賃住宅管理業務，指租賃住宅之屋況與設備點交、收租與押金管理、日常修繕維護、糾紛協調處理及其他與租賃住宅管理有關之事項(租賃住宅市場發展及管理條例第三條第六款)。本契約之委託人與受託人係屬委任關係(民法第五百二十八條)。")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)

                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "三、委託管理標的")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("(一)委託管理標的範圍，指住宅租賃契約中有關租賃住宅專有、專用部分而屬私領域居住空間，或本契約所衍生之相關管理事務，尚不包含公寓大廈公共使用空間之管理維護。")
                                     Text("(二)委託管理標的範圍屬已登記者，以登記簿記載為準；未登記者以房屋稅籍證明或實際測繪之位置略圖為準，位置略圖並宜清楚標示該租賃住宅之坐落位置，如重要路口或地標等資訊，以利辨識委託管理標的。")
                                     Text("(三)委託管理租賃標的範圍非屬全部者(如部分樓層之套房或雅房)，得由委託人出具「租賃住宅位置格局示意圖」標註委託管理範圍，以確認實際租賃住宅位置或範圍。")
                                     Text("(四)為避免委任雙方對於委託管理標的範圍是否包含未登記之改建、增建、加建及違建部分，或冷氣、傢俱等其他附屬設備認知差異，得參依本契約書範本附件「委託管理標的現況確認書」，由委任雙方互為確認，以杜糾紛。")
                                     Text("(五)委託人可與受託人會同檢查租賃住宅設備現況並拍照存證，如有附屬設備，並得以清單列明，以供受託人協助處理返還租賃住宅回復原狀之參考。")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)

                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "四、委託管理期間及契約方式")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("(一)為舉證方便及保障委任雙方之權益，雙方應以書面簽訂本契約並明定委託管理期間，且受託人應與委託人簽訂本契約後，始得執行租賃住宅管理業務。(租賃住宅市場發展及管理條例第二十八條第一項)")
                                     Text("(二)又為避免委託人及受託人間之糾紛，委託管理期間以定有期限為原則。倘委託管理期間屆滿時，委託管理標的之租賃關係尚屬存續者，委任雙方得於租賃期限內協議是否同意展延委託管理期間。")
                                     Text("(三)個人住宅所有權人(即出租人、委託人)將住宅委託代管業管理，並簽訂一年以上之委託管理契約，且與承租人簽訂一年以上租賃契約者，享有租稅優惠(租賃住宅市場發展及管理條例第十七條、第十八條及其施行細則第四條、第五條)。")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)
                     }

                     Group {
                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "五、報酬約定及給付")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("(一)委託管理報酬，委任雙方得約定以月租金額一定比例為計算基準或約定一定數額，按月或約定數月為一期，按期給付，並應約定每次支付報酬之方式(如現金繳付、轉帳繳付、於月租金內扣付等)。")
                                     Text("(二)委託管理標的之租賃關係消滅且委託人無提前終止本契約時，委託人與受託人得自行約定是否收取報酬，如仍得收取報酬，應約定金額多寡，以避免爭議。")
                                     Text("(三)委任雙方當事人應約定每月或每期支付報酬之期限，委託人不得藉任何理由於委託管理期間要求調漲報酬。")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)

                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "六、委託管理項目")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("租賃住宅管理業務，包括租賃住宅之屋況與設備點交、收租與押金管理、日常修繕維護、糾紛協調處理及其他與租賃住宅管理有關之事項(租賃住宅市場發展及管理條例第三條第六款)，惟代管業之管理權限係來自於委託人之委任授權，故委託管理事項仍宜由雙方以契約約定，以資明確。(民法第五百三十二條)")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)

                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "七、違反使用限制之處理")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("(一)受託人應督促承租人依照公寓大廈管理條例規定，遵守住戶規約，不得違法使用、存放有爆炸性或易燃性物品，影響公共安全、公共衛生或居住安寧。")
                                     Text("(二)本委託管理標的僅供居住使用，受託人應要求承租人對委託管理標的之用途以住宅為限，倘承租人未經受託人同意變更用途，受託人得終止租賃契約且不返還押金。")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)

                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "八、修繕之處理")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("(一)委託管理標的或附屬設備損壞，依租賃契約約定由受託人負責修繕者，由受託人負責修繕者，併負修繕費用之責。")
                                     Text("(二)依租賃契約約定由承租人負責修繕及負擔費用者，受託人應負責督促承租人修繕；承租人對於應負責修繕之項目或費用有爭執時，受託人應代為協調。")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)

                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "九、委託人之義務及責任")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("(一)為確認委託管理標的現況，委託人應據實提供「委託管理標的現況確認書」相關資訊，並確保合於租賃契約所約定居住使用狀態，故簽訂本契約時，應敘明由受託人負責修繕項目、範圍、有修繕必要時之聯絡方式及其他相關事項；簽訂本契約書後，受託人應將本契約相關事項以書面方式告知承租人，以利承租人配合受託人執行業務及維護承租人權益。")
                                     Text("(二)簽訂本契約時，委託人應出示有權委託管理標的之證明文件(如為住宅所有權人得提供權利書狀、建物登記謄本、房屋稅單等，如非住宅所有權人，得提供經所有權人授權委託之證明文件)、國民身分證或其他足資證明身分之文件供受託人核對；如有同意受託人代為收取租金、押金者，並應提供交付之方式(如現金交付、轉帳等)，俾受託人代為收取後得交付委託人。")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)

                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "十、受託人之義務及責任")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("(一)承租人在租賃期間負有保管租賃住宅及對其同居人或允許使用租賃住宅之第三人行為負損害賠償責任(民法第四百三十二條、第四百三十三條)，受託人應督促承租人以善良管理人之注意，保管、使用租賃住宅。")
                                     Text("(二)租期屆滿或租賃契約提前終止時，受託人應先行協助結算相關費用、製作代收代付清單、結算承租人在租賃期間應繳未繳之費用，與協助執行屋況及附屬設備點交，不需經委託人同意後代為返還押金或賸餘押金予承租人。")
                                     Text("(三)承租人未依租賃契約約定繳納租金及相關費用(水電費、瓦斯費、管理費、有線電視費、網路費等)者，受託人應於收款期限屆滿後，依雙方約定期日內履行催收、催繳之義務。")
                                     Text("(四)受託人對於日常修繕維護或清潔事務應製作執行紀錄，以利委託人查詢或取閱。")
                                     LineWithSpacer(contain: "(五)承租人使用委託管理標的所發生之糾紛，受託人應依約定代為協調處理。")
                                     Text("(六)代為收取租金及押金係受託人專業經營之重要業務，根據委託人方案之選擇，倘受託人於簽約日起7日內給付第一年期租金，並以年繳方式給付至委託管理期間屆滿者，委託人不得再對受託人請求受託人向承租人收取之租金；倘委託人選擇每月收取之約定租金新台幣      元，依雙方約定之交付方式及期限(不超過三十日)給付予委託人。")
                                     Text("(七)押金係承租人為擔保租賃住宅之損害賠償行為及處理遺留物責任所預為支付之金錢，如約定由受託人代為管理者，受託人自應秉持專業管理之注意義務，除有返還租賃住宅時，清償租賃契約所生之債務得動支押金之情形外，不得挪為其他用途使用。")
                                     Text("(八)受託人收受委託人之有關費用或文件，應掣給收據，以避免雙方爭議，及利於日後查證。")
                                     Text("(九)委託人如有申請減徵稅捐需要(租賃住宅市場發展及管理條例第十七條、第十八條及其施行細則第四條、第五條)，受託人應配合提供相關證明文件。")
                                     Text("(十)為落實受託人專業經營之責任與避免執業過程權責不清，受託人不得委託他代管業執行租賃住宅管理業務。")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)

                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "十一、租賃住宅返還之處理")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("委託管理標的租期屆滿或租賃契約提前終止時，承租人如未將原設籍之戶籍及其他法人或團體等登記遷出，經委託人授權之受託人得依戶籍法第十六條等相關規定，證明無租借住宅情事，向住宅所在地戶政事務所或主管機關申請遷離或廢止。")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)

                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "十二、委託人提前終止契約")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("(一)租賃住宅管理業務中之糾紛協調處理，屬受託人經委託人信任之專業經營管理服務業，涉及委託人重大權益，若受託人違約不為處理，經委託人定相當期間催告，屆期仍不處理，委託人有終止本契約之權。")
                                     Text("(二)委託人依照方案選擇同意受託人代為收取租金或押金者，應於代為收取之日起不超過三十日內交付委託人，受託人屆期如未將代為收取之租金或押金交付委託人，屬受託人重大違約事項，委託人得終止本契約。")
                                     Text("(三)為落實代管業專業經營制度，避免執業過程權責不清，受託人再委託他代管業執行租賃住宅管理業務，委託人得終止本契約。")
                                     LineWithSpacer(contain: "(四)委託管理標的之租賃關係消滅時，委託人有提前終止本契約之權利。")
                                     Text("(五)委託管理標的全部滅失，或一部滅失且其存餘部分難以繼續居住時，委託人有提前終止本契約之權利。")
                                     Text("(六)租賃住宅服務業因違反相關法令規定，經直轄市、縣(市)主管機關撤銷、廢止許可或租賃住宅服務業登記者，該業者即無法再行營業，委託人得終止本契約。")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)
                     }

                     Group {
                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "十三、受託人提前終止契約")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("(一)因委託人違反本契約委由受託人修繕而未償還其修繕費用、未據實提供委託管理標的現況確認書資訊並確保合於租賃契約所約定居住使用之狀態，或未以書面方式告知承租人本契約相關事項等規定，致受託人無法繼續管理委託標的，受託人得終止本契約。")
                                     Text("(二)委託管理標的之租賃關係消滅，無論是租賃雙方合意或因一方違約而致他方終止租賃契約等原因，將導致受託人無法繼續管理，受託人得終止本契約，但為保障委託人權益，受託人仍應以已完成結算費用、督促承租人返還租賃住宅及遷出戶籍或其他登記等事項為前提，始得主張提前終止本契約。")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)

                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "十四、消費爭議處理")
                             VStack(spacing: 6) {
                                 Group {
                                     LineWithSpacer(contain: "(一)本契約發生之消費爭議，雙方得依下列方式處理：")
                                     LineWithSpacer(contain: "1.依鄉鎮市調解條例規定，向鄉、鎮、市(區)調解委員會聲請調解。")
                                     LineWithSpacer(contain: "2.依民事訴訟法第四百零三條及第四百零四條規定，向法院聲請調解。")
                                     Text("3.依仲裁法規定，向仲裁機構聲請調解，或另行訂立仲裁協議後向仲裁機構聲請仲裁。")
                                     Text("(二)鄉、鎮、市(區)調解委員會調解成立之調解書經法院核定後與民事確定判決有同一效力；仲裁人作成之調解書，與仲裁判斷有同一效力；仲裁判斷，於當事人間，與法院之確定判決，有同一效力。")
                                     LineWithSpacer(contain: "(三)司法院訴訟外紛爭解決機構查詢平台：http://adrmap.judicial.gov.tw/")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)

                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "十五、契約分存")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("(一)訂約時務必詳審契約條文，由委任雙方簽章或按手印，寫明代管業公司名稱、代表人、統一編號、營業地址、登記證字號及其指派租賃住宅管理人員姓名、證書字號等，及委託人姓名、戶籍、通訊地址及聯絡電話等，契約應一式二份，由委任雙方各自留存一份契約正本。")
                                     Text("(二)若本契約超過二頁以上，委任雙方最好加蓋騎縫章，以避免被抽換；若契約內容有任何塗改，亦必須於更改處簽名或蓋章，以保障自身權益受損。")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)

                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "十六、確定訂約者之身分")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("(一)簽約時，委託人應請代管業提示其公司名稱、代表人、統一編號、地址、登記證字號及其指派租賃住宅管理人員姓名、證書字號等文件，確認其為合法業者；而代管業應先確定委託人之身分，例如國民身分證、駕駛執照或健保卡等身分證明文件之提示。如限制行為能力人(除已結婚者外)訂定契約，應依民法規定，經法定代理人或監護人之允許或承認。若非雙方本人簽約時，應請簽約人出具授權簽約之同意書。")
                                     Text("(二)委託人是否為屋主(即租賃住宅所有權人)，影響委託人與受託人雙方權益甚大，故受託人可要求委託人提示產權證明(如所有權狀、登記謄本)；如委託人非屋主，則應提出經授權委託之證明文件。")
                                 }
                                 .font(.system(size: 14, weight: .regular))
                             }
                         }
                         .padding(.top, 5)
                         .padding(.horizontal)

                         VStack(alignment: .leading, spacing: 5) {
                             SubTitleView(subTitleName: "十七、租賃住宅管理人員簽章")
                             VStack(spacing: 6) {
                                 Group {
                                     Text("租賃住宅管理人員，係指租賃住宅代管業(受託人)依租賃住宅市場發展及管理條例所置從事代管業務之人員，依該條例規定應於本契約及其附件(委託管理標的現況確認書)上簽章")
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
                             Image(systemName: isAgree ? "checkmark.square.fill" : "square")
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
 */

// struct ProviderSummittedRoomContractView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProviderSummittedRoomContractView()
//    }
// }
