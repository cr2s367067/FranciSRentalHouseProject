//
//  ProviderBarChartView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ProviderBarChartView: View {
    
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var paymentReceiveManager: PaymentReceiveManager
    @EnvironmentObject var providerBarChartViewModel: ProviderBarChartViewModel
    
    var highestData: Double {
        let max = Double(providerBarChartViewModel.getMax(input: providerBarChartViewModel.tempDataCollection))
        return max
    }
    
    var body: some View {
        VStack {
            GeometryReader{ geometry in
                HStack(alignment: .bottom, spacing: 4.0) {
                    ForEach(paymentReceiveManager.monthlySettlement) { data in
                        let width = (geometry.size.width / CGFloat(paymentReceiveManager.monthlySettlement.count)) - 4.0
                        let height = (geometry.size.height * Double(data.settlementAmount)) / highestData
                        BarView(height: height, paymentData: data)
                            .frame(width: width)
                    }
                }
            }
        }
        .padding()
        .frame(width: 378, height: 304)
        .onAppear {
            providerBarChartViewModel.convertAndStore(input: paymentReceiveManager.monthlySettlement)
        }
    }
}

struct BarView: View {
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var paymentData: ReceivePaymentDateModel
    
    func convertCGFloat(input: Int) -> CGFloat {
        let compute = input / 304 / 304
        return CGFloat(compute)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 20, height: 304)
            VStack {
                Text("\(paymentData.settlementAmount)")
                    .foregroundColor(.white)
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color("barChart1"))
                    .frame(width: 20, height: height)
                Text(paymentData.settlementDate , format: Date.FormatStyle().year(.twoDigits).month(.twoDigits))
                    .foregroundColor(.white)
            }
        }
    }
}
