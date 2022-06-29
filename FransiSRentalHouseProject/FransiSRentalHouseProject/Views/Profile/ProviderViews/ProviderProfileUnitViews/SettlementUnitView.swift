//
//  SettlementUnitView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/13.
//

import SwiftUI

struct SettlementUnitView: View {
    @EnvironmentObject var providerProfileViewModel: ProviderProfileViewModel
    @EnvironmentObject var paymentMethodManager: PaymentMethodManager
    @EnvironmentObject var providerStoreM: ProviderStoreM
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

//    @State var date = Date()
    @Binding var date: Date
    @Binding var editMode: Bool

    var body: some View {
        isEditMode(editMode: editMode)
    }
}

extension SettlementUnitView {
    @ViewBuilder
    func isEditMode(editMode: Bool) -> some View {
        if editMode == true {
            HStack {
                DatePicker("Settlement", selection: $date, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .applyTextColor(.white)
                    .font(.system(size: 17, weight: .bold))
            }
            .padding()
            .frame(width: uiScreenWidth - 40, height: uiScreenHeight / 8 - 50, alignment: .center)
            .shadow(color: .black.opacity(0.6), radius: 5)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("Shadow"))
            }
        } else {
            HStack {
                if providerStoreM.storesData.isSetConfig {
                    NavigationLink {
                        SettlementPaymentView()
                    } label: {
                        Text("結算日：")
                            .foregroundColor(.white)
                        Text(providerProfileViewModel.providerConfig.settlementDate, format: Date.FormatStyle().year().month().day())
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }
                } else {
                    Text("Please select settlement date.😉")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .frame(width: uiScreenWidth - 40, height: uiScreenHeight / 8 - 50, alignment: .center)
            .shadow(color: .black.opacity(0.6), radius: 5)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("Shadow"))
            }
        }
    }
}
