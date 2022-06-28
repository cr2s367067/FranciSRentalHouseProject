//
//  AutoPaymentSettingView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/11.
//

import SwiftUI

struct AutoPaymentSettingView: View {
    @EnvironmentObject var autoPaymentSettingViewModel: AutoPaymentSettingViewModel
    @EnvironmentObject var firestoreUser: FirestoreToFetchUserinfo
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    var body: some View {
        VStack {
            VStack {
                Text("自動扣款授權書")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold))
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 20) {
                        AutoPayPolicyUnit(policy: "立授權書人(以下稱「使用者」)，為便於FranciS軟體有限公司支付信用卡帳款，謹授權本公司為支付該等帳款之代理人，並同意如下:")
                        AutoPayPolicyUnit(policy: "(1) 使用者謹授權並同意FranciS軟體有限公司以任何形式(如電腦媒體)自帳戶使用者同意之 系統內自動扣款，繳付帳款。")
                        AutoPayPolicyUnit(policy: "(2) 使用者同意撤銷本授權行為時，延至次一繳款截止日始生效力。")
                        AutoPayPolicyUnit(policy: "(3) 使用者授權之支付方式餘額不足而無法如期補足或因其他可歸責於帳戶持有人之原 因，致不能如期支付帳款時，FranciS軟體有限公司有權取消上述付款代理。如因此違約金及其他費用，均由使用者負責支付。")
                        AutoPayPolicyUnit(policy: "(4) 因信用卡帳款遲延繳付時，若非為平台系統所致，導致違約金及其他費用，均由使用者負責支付。")
                        AutoPayPolicyUnit(policy: "(5) 使用者同意若支付過程中所產生的手續費與使用費。")
                    }
                    .foregroundColor(.black)
                    .font(.system(size: 16))
                    .padding()
                }
                .frame(width: uiScreenWidth - 20, height: uiScreenHeight / 2, alignment: .center)
                .background(alignment: .center) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                }
                HStack {
                    Button {
                        autoPaymentSettingViewModel.checkbox.toggle()
                    } label: {
                        Image(systemName: autoPaymentSettingViewModel.checkbox ? "checkmark.square.fill" : "square")
                            .foregroundColor(autoPaymentSettingViewModel.checkbox ? .green : .white)
                            .font(.system(size: 20))
                    }
                    Text("I read and agree these automatic payment policy.")
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                }
            }
            .padding()
            .frame(width: uiScreenWidth - 20)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.7))
            }
            Button {
                Task {
                    do {
                        try await firestoreUser.updateAutoPayAgreement(uidPath: firebaseAuth.getUID(), agreement: autoPaymentSettingViewModel.checkbox)
                    } catch {
                        self.errorHandler.handle(error: error)
                    }
                }
            } label: {
                Text("Summit")
                    .foregroundColor(.white)
                    .frame(width: 108, height: 35)
                    .background(Color("buttonBlue"))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(alignment: .center) {
            LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea([.top, .bottom])
        }
    }
}

struct AutoPaymentSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AutoPaymentSettingView()
    }
}

struct AutoPayPolicyUnit: View {
    var policy: String
    var body: some View {
        HStack {
            Text(policy)
            Spacer()
        }
    }
}

class AutoPaymentSettingViewModel: ObservableObject {
    @Published var checkbox = false
}
