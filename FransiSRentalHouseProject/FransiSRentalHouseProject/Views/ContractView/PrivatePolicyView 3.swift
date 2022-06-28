//
//  PrivatePolicyView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/5/22.
//

import SwiftUI

struct PrivatePolicyView: View {
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
                            Text("隱私權政策")
                                .font(.title2)
                                .font(.system(size: 15))
                        }
                        .padding(.top, 5)
                        VStack {
                            Text("歡迎使用 FranciS租賃管理平台（以下簡稱本網站），為了讓您能夠安心使用本網站的各項服務與資訊，特此向您說明本網站的隱私權保護政策，以保障您的權益，請您詳閱下列內容：")
                                .font(.system(size: 15, weight: .regular))
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "一、隱私權保護政策的適用範圍")
                            VStack(spacing: 6) {
                                Group {
                                    Text("隱私權保護政策內容，包括本網站如何處理在您使用網站服務時收集到的個人識別資料。隱私權保護政策不適用於本網站以外的相關連結網站，也不適用於非本網站所委託或參與管理的人員。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                    }

                    Group {
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "二、個人資料的蒐集、處理及利用方式")
                            VStack(spacing: 6) {
                                Group {
                                    Text("1. 當您造訪本網站或使用本網站所提供之功能服務時，我們將視該服務功能性質，請您提供必要的個人資料，並在該特定目的範圍內處理及利用您的個人資料；非經您書面同意，本網站不會將個人資料用於其他用途。")
                                    Text("2. 在使用本站服務所填寫的個人資訊，會使用於契約的填寫、認證個人資料與分析，以提升本站的使用者體驗。")
                                    Text("3. 本網站在您使用服務信箱、問卷調查等互動性功能時，會保留您所提供的姓名、電子郵件地址、聯絡方式及使用時間等。")
                                    Text("4. 於一般瀏覽時，伺服器會自行記錄相關行徑，包括您使用連線設備的IP位址、使用時間、使用的瀏覽器、瀏覽及點選資料記錄等，做為我們增進網站服務的參考依據，此記錄為內部應用，決不對外公佈。")
                                    Text("5. 為提供精確的服務，我們會將收集的問卷調查內容進行統計與分析，分析結果之統計數據或說明文字呈現，除供內部研究外，我們會視需要公佈統計數據及說明文字，但不涉及特定個人之資料。")
                                    Text("6. 您可以隨時向我們提出請求，以更正或刪除本網站所蒐集您錯誤或不完整的個人資料，請見最下方聯繫管道。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "三、資料之保護")
                            VStack(spacing: 6) {
                                Group {
                                    Text("1. 本站使用由Google 所提供的Firebase，資料庫權限使用會透過嚴謹的程序，過濾不合法的來源以保障使用者資料的安全。")
                                    Text("2. 如因業務需要有必要委託其他單位提供服務時，本網站亦會嚴格要求其遵守保密義務，並且採取必要檢查程序以確定其將確實遵守。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                    }

                    Group {
                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "四、隱私權保護政策之修正")
                            VStack(spacing: 6) {
                                Group {
                                    LineWithSpacer(contain: "本網站隱私權保護政策將因應需求隨時進行修正，修正後的條款將刊登於網站上。")
                                }
                                .font(.system(size: 14, weight: .regular))
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 5) {
                            TitleView(titleName: "五、聯繫管道")
                            VStack(spacing: 6) {
                                Group {
                                    Text("對於本站之隱私權政策有任何疑問，或者想提出變更、移除個人資料之請求，請前往本站「聯絡我們」頁面提交表單。")
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

//                    Group {

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
//                    }
                }
                .frame(width: UIScreen.main.bounds.width - 20)
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PrivatePolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivatePolicyView()
    }
}
