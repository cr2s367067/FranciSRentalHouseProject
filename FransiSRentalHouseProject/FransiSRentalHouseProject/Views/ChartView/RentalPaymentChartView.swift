//
//  RentalPaymentChartView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/10.
//

import SwiftUI
import Charts

@available(iOS 16, *)
struct RentalPaymentChartView: View {
    @EnvironmentObject var rentalPC: RentalPaymentChartViewModel
    
    let testData: [RentalPaymentChartDataModel] = [
        .init(receiveMonth: "1", receiveAmount: 10),
        .init(receiveMonth: "2", receiveAmount: 20),
        .init(receiveMonth: "3", receiveAmount: 50),
        .init(receiveMonth: "4", receiveAmount: 40),
        .init(receiveMonth: "5", receiveAmount: 50)
    ]
    
    var body: some View {
        Chart {
            ForEach(testData) { data in
                BarMark(
                    x: .value("Monthly", data.receiveMonth),
                    y: .value("Payment Amount", data.receiveAmount)
                )
                .foregroundStyle(Color("barChart1"))
            }
        }
    }
}

struct RentalPaymentChartView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16, *) {        
            RentalPaymentChartView()
        }
    }
}

@available(iOS 16, *)
class RentalPaymentChartViewModel: ObservableObject {
    @Published var rentalPaymentChartData = [RentalPaymentChartDataModel]()
}


struct RentalPaymentChartDataModel: Identifiable, Codable {
    var id = UUID().uuidString
    var receiveMonth: String
    var receiveAmount: Int
}
