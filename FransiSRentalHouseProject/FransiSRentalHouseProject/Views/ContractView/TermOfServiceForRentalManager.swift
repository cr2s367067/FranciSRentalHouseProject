//
//  TermOfServiceForRentalManager.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/5/22.
//

import SwiftUI

struct TermOfServiceForRentalManager: View {
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
                            Text("FranciS 平台使用授權合約")
                                .font(.title2)
                                .font(.system(size: 15))
                        }
                        .padding(.top, 5)
                        VStack {
                            Text("若透過本軟體所公開發佈標的物，即表示您同意本平台使用授權合約的條款，若有牴觸部分以使用者授權合約的條款為主。如果您代表他人、公司或其他法定實體接受這些條款，則您即聲明並保證您擁有完全的授權，可使該人員、公司或法定實體受這些條款的約束。若您不同意這些條款:")
                                .font(.system(size: 15, weight: .regular))
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                    }
                    
                    Group {
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第一條 定義")
                            VStack(spacing: 6) {
                                Group {
                                    Text("1. 「房型」或「智慧房型」是指 FranciS 所提供之平台上的標的物，每項標的物都經過與提供者的「租賃住宅委託管理契約書」簽署。")
                                    Text("2. 「合作夥伴」是指 FranciS 之合作廠商，所提供產品，讓使用者選購，或為他方租賃管理業所提供之房型。")
                                    LineWithSpacer(contain: "3. 「合約文件」是指承租人、委託人所簽署之規範，以保障雙方權利。")
                                    Text("4. 「付款」是指FranciS 與合作夥伴 綠界科技所提供之付款系統，進行扣款與轉帳之功能。")
                                    Text("5. 「個人資訊」是指由 FranciS 向您請求個人資訊，使用於合約文件的資料導入，且個人資訊，不會提供給第三房存取。")
                                    LineWithSpacer(contain: "6. 「維修服務」是指FranciS 所提供之房型，有直接管理權限，所提供之服務。")
                                    Text("7. 「FransiS」是指: 位於（地址），提供租賃管理服務與租賃服務平台之租賃管理科技有限公司。")
                                    Text("8. 「軟體」是指由FranciS所開發之租賃平台，提供承租人承租也提供委託人發佈空屋予承租人。")
                                    LineWithSpacer(contain: "「支援」或「技術支援」是指 FranciS 所提供之軟體的除錯或故障排除之解決方法。")
                                    Text("9. 「「升級」是指軟體中的任何和所有改進，這些改進通常作為提升軟體效能，提供更多支援服務。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第二條 使用權授權/所有權")
                            VStack(spacing: 6) {
                                Group {
                                    Text("1. 根據本合約的條款與條件，FranciS 特此向您授予非獨占、不可轉讓的權利。但不包含，其物件碼和原始程式碼 (無論是否提供給您) 為 FranciS 的高度機密。FranciS (或其授權人)獨家擁有並保留所有與軟體相關之權利、所有權和利益，且您不得行使上述任何權利、所有權和利益，包括但不 限於，所有與軟體相關之智慧財產權，在本合約中授予您的有限軟體使用授權除外。本合約並非銷售合約，且根 據本合約，軟體之權利、智慧財產權或所有權均不會轉移予您。您確認並同意，軟體、用於開發或納入軟體的所 有創意、方法、演算法、公式、程序和概念、所有未來更新和升級，及所有其他改進、修改、更正、錯誤修復、 熱修復、修補程式、修改、增強、發佈、升級、原則和資料庫更新，以及其他與軟體相關的更新， 以及前述任何一項的所有衍生作品和複本，均為 FranciS 的商業秘密和專有財產，並且對 FranciS 而言具有巨大的商業價值。")
                                    Text("2. 在平台上所發佈的標的物之所有權，除原管理者為FranciS所有，為原發佈者所有，但須繳付平台使用費。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                    }
                    
                    Group {
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第三條 複製及使用條款")
                            VStack(spacing: 6) {
                                Group {
                                    LineWithSpacer(contain: "1. 多平台：若軟體支援多個平台，可在各個平台商店搜尋功能中找到本軟體。")
                                    Text("2. 期限：若為一般使用者或房屋擁有者，使用期限為永久，若為租賃管理人員需每月繳付軟體使用費，使用期限至停止繳交時日之當月。")
                                    LineWithSpacer(contain: "3. 複本:您可以因備份、存檔或嚴重損壞復原等用途的合理需要，複製軟體。")
                                    Text("4. 一般限制:您不得從事下列行為，同時亦不得導致或允許任何第三方從事下列行為:對軟體進行反編譯、解譯或反向工程;或建立或重建軟體的原始程式碼;移除、清除、掩蓋或篡改任何軟體和說明文件中所印刷或加戳記、附加，或編碼或記錄的任何版權或任何其他產品標識或所有權聲明、密封，或指示標籤;或者在您所製作的軟體和說明文件的所有複本中不保留所有版權和其他所有權聲明;出租、出借或使用軟體以供分時或服務中心使用之目的;在本合約中明確允許的範圍之外，銷售、行銷、授權、子授權、分發或以其他方式授予任何個人或實體任何權利以使用軟體;或使用軟體為任何個人或實體提供(單獨或與任何其他產品或服務結合)任何產品或服務，無論是否收費;修改、改編、篡改、翻譯或建立軟體或說明文件的衍生作品;將軟體或說明文件的任何部分與其他任何軟體或說明文件結合或合併;或參考或使用該軟體協助開發具有任何類似於軟體的功能屬性、視覺表現或其他特點或具備與 FanciS 抗衡之能力的軟體 (包括但不限於，任何常式、指令碼、程式碼或程式); 未取得 FranciS 的事先書面許可，發佈有關軟體的任何性能或基準測試或分析結果；或試圖從事上述任何一項行為。您不得在雲端、以網際網路為基礎的運算，或類似的隨需運算環境中執行或操作軟體，除非您的授權 信具體提供此類授權。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第四條 技術支援與維護")
                            VStack(spacing: 6) {
                                Group {
                                    Text("1. 責任排除規定:未依照本合約或說明文件使用軟體;軟體或任何相關部分已由 FranciS 之外的任何實體進行改動;因非 FranciS 提供的任何設備或軟體而導致軟體故障。")
                                    Text("2. 免責聲明:除上述外，軟體是依據「現狀」提供，FranciS 不作任何陳述或保證，且 FranciS 不承擔 交易過程、履約過程或交易中使用等所產生的所有陳述、條件 (不論是口頭或書面、明示或暗示)，包括但不限於，適銷性、品質、特定用途的適用性、所有權、非侵權或系統整合的默示保證。若承租人，承租之房屋提供者不為FranciS所有，則FranciS不會承擔交易過程、履約事項、到期後所產生之陳述、問題。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第五條 補償及損害限制")
                            VStack(spacing: 6) {
                                Group {
                                    Text("1. 在任何情況或在任何法律理論下，無論是以侵權、疏忽、合約或其他方式，依據本合約或與其主題內容相關之條件，針對任何形式的任何間接、特殊、偶然、懲罰性、懲戒性、間接或合約外損害賠償、商譽損失、人員工資損 失，利潤和收入損失、由於停工和/或電腦故障或失效而產生的損害賠償，和/或採購替代軟體或服務的成本，任 何一方當事人均不對另一方承擔任何責任，無論是否可預見，即使本合約所提供之全部補償無法達成其基本目的， 而且即使任何一方已被告知發生此類損害的可能性或機率亦同。")
                                    Text("2. 不論此類賠償要求是否基於合約、侵權和/或任何其他法律理論，在任何情況下，依據本合約或與其主題內容相關 之條件，任一方對另一方直接損失的累計賠償責任均不得超過您為引起此類索賠之軟體於引起此類索賠之事件發 生前 12 個月內所支付或應付的費用總額。")
                                    Text("3. 本合約中的條款不得以任何方式排除或限制，任一方因疏忽造成的死亡或人身傷害應負之責任。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                      
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第六條 智慧財產權賠償")
                            VStack(spacing: 6) {
                                Group {
                                    Text("1. 賠償:在訴訟中，若針對以下情況對您提出索賠，FranciS 將對您作出賠償，並依其選擇進行抗辯:索賠是針對直接專利侵權或直接著作權侵權，或 FranciS 的商業秘密侵佔，且索賠是 僅針對軟體而非與任何其他項目的組合，或針對軟體的組合而提出。")
                                    Text("2. 排除限制:儘管本合約中可能另有規定，FranciS 並無義務針對以下情況所提出的索賠 (全部或部分) 對您作出賠償或進行抗辯:您提供給 FranciS 的技術或設計；由 FranciS 以外的任何人對軟體進行的修改或程式設計；或軟體對標準部分或全部的宣稱性實作。")
                                    Text("3. 條件:FranciS 履行前項規定之義務的條件是，您必須向 FranciS 提供:即時的書面索賠通知，和授予 FranciS 全權控制索賠抗辯及和解的同意書;以及充分且及時的合作。")
                                    Text("4. FranciS 的同意:FranciS 不對未經 FranciS 事先書面同意而由您做出或招致的任何費用、開支或任何妥協負責。")
                                    LineWithSpacer(contain: "5. 個人賠償:上述賠償是針對您個人而言。您不得轉讓或轉讓給任何人，包括您的客戶。")
                                    Text("6. 全部補償:賠償章節規定了對於針對全部或部分軟體的專利或著作權侵權，或商業秘密侵佔所提出的索賠， FranciS 應承擔的全部義務及您應得的全部補償。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第七條 終止")
                            VStack(spacing: 6) {
                                Group {
                                    Text("在不違背付款義務的情況下，您可以隨時透過解除安裝軟體終止授權。若您對於本合約條款有重大違約行為，且在收到 此類違約事項通知後三十日內未能予以糾正，則 FranciS 可終止您的授權。授權終止後，您必須立即返還或銷毀軟 體及說明文件的所有複本。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                    }
                    
                    Group {
                        
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第八條 隱私與個人或系統資訊的收集")
                            VStack(spacing: 6) {
                                Group {
                                    Group {
                                        Text("1. 軟體、支援或服務訂閱可透過各種應用程式和工具來收集個人身分識別的相關資訊、敏感資訊或與您及使用者有 關的其他資訊，包括：身分證字號，姓名，出生年月日，電電子郵件，居住地址，證書字號，電話，房屋之必要資訊等。 (統稱「資料」)。")
                                        Text("2. 收集此類資料可能是必要的，目的是為了填寫契約與認證使用者身份或向您及使用者提供所訂閱的相關支援或服務等功能，以及提升或改進您及使用者的總體安全性。如果要停止 支援這些功能的進一步資料收集，您可能需要解除安裝軟體或停用支援或其服務訂閱。")
                                        Text("3. 同意本合約或使用軟體、支援或服務訂閱，即代表您及使用者同意 FranciS 的隱私權政策，並且同意 FranciS 及其服務供應商收集、處理、複製、備份、儲存、傳送和使用此類資料，並將此作為軟體、支援或服務訂閱的一 部分。 FranciS 僅將隱私權政策，收集、處理、複製、備份、儲存、 傳送和使用個人身分識別資訊。")
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
                                    Text("第九條 機密性各方於本「合約」確認，由於其與另一方依本「合約」建立的關係，其可能有權存取有關另一方業務、技術和/或產品的 機密資訊和資料，這些資訊和資料是另一方的機密(以下稱「機密資訊」)。每一方的「機密資訊」對該當事方而言均 具有重大的價值，若將此類資訊披露予第三方或以違反本「合約」的方式使用，其價值可能會減損。書面或其他有形的 機密資訊必須在揭露時確認並標示為屬於揭露方的機密資訊。以口頭或視覺方式揭露時，必須在揭露時確認其為機密資 訊，並於揭露後十五 (15) 日內以書面方式確認。各方同意，除非經本合約授權，否則不會以任何方式為其自身或任何第 三方使用此等機密資訊，並且將保護此等機密資訊，至少如同保護其自身的機密資訊，或如同理智的人員保護此等機密 資訊。除非為依據本「合約」履行其職責或行使其權利所必需，否則任何一方均不得使用另一方的「機密資訊」。有關 機密資訊的限制不適用於下列機密資訊：在依本「合約」存取時接收方已知；並非由於接收方的過錯而為公眾所知；由接收方獨立開發而未得益於揭露方的機密資訊；從沒有保密義務的第三方正當地取得；或法律要求揭露，惟被要求揭露之一方須向擁有機密資訊之一方提供有關該揭露的事先書面通知，足以使其在合理可行的情況下採取合理措施避免此等揭露。除非雙方另有約定，否則本合約終止後，或加入適用的附錄後，各方須返還另一方的機密資訊。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "第十條 其他")
                            VStack(spacing: 6) {
                                Group {
                                    Text("1. 除有關拒付或侵犯軟體及說明文件之 FranciS 所有權的訴訟外，因本合約而產生的任何訴訟，無論其形式如何，其追訴期限均以任一方知悉或應知悉之日起兩年內為限。")
                                    Text("2. 本合約中任何本質上應在合約終止後繼續生效的條款，應在此類終止發生時繼續生效。")
                                    Text("3. FranciS 可隨時依據您的事先書面同意，指派本合約的全部內容;不過，從兼併、合併、收購全部或實質上全部的 FranciS 資產，或內部重組或重整所產生或作為其一部分的任何指派，則不需取得您的同意。")
                                    Text("4. 本合約，包括所有因引用而併入的文件，為雙方針對此處所述主題所達成的完整合約，明確替代和撤銷所有其他 口頭或書面通訊、陳述或聲明。如果您向授權合作夥伴或 FranciS 發出訂單，而此訂單中的條款與條件與本合約條款和條件相衝突，將按本合約規定的條款與條件執行。 若合約中的任何規定被視為無效、不可執行，或根據法律禁止，則此類條款將依據適用的法律重新表述，以盡可能地反映和貼近各方的初衷，且本合約的其餘部分仍應具有完整效力。")
                                    Text("FranciS 租賃管理科技有限公司平台使用授權合約 (2022 年 7 月)")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
//                        HStack(alignment: .center, spacing: 5) {
//                            Button {
//                                isAgree.toggle()
//                            } label: {
//                                Image(systemName: isAgree ? "checkmark.square.fill" : "checkmark.square")
//                                    .resizable()
//                                    .frame(width: 15, height: 15)
//                                    .foregroundColor(Color.green)
//                            }
//                            Text("I agree and read whole policy.")
//                                .font(.system(size: 12))
//                        }
//                        .padding(.top, 10)
//
//                        Button {
//
//                        } label: {
//                            Text("Summit")
//                                .foregroundColor(.white)
//                                .frame(width: 108, height: 35)
//                                .background(Color("buttonBlue"))
//                                .clipShape(RoundedRectangle(cornerRadius: 5))
//                        }
//                        .padding(.top, 10)
//                        .padding(.horizontal)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 20)
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct TermOfServiceForRentalManager_Previews: PreviewProvider {
    static var previews: some View {
        TermOfServiceForRentalManager()
    }
}
