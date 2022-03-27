//
//  ProviderBarChartView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ProviderBarChartView: View {
    
    var data: [Double] = [100, 200, 300, 200, 100, 500]
    
    var highestData: Double {
        let max = data.max() ?? 1.0
        if max == 0 {
            return 1.0
        }
        return max
    }
    
    var body: some View {
        VStack {
            GeometryReader{ geometry in
                HStack(alignment: .bottom, spacing: 4.0) {
                    ForEach(data.indices, id: \.self) { index in
                        let width = (geometry.size.width / CGFloat(data.count)) - 4.0
                        let height = geometry.size.height * data[index] / highestData
                        BarView(width: width, height: height, num: String(data[index]))
                            .frame(width: width)
                    }
                }
            }
        }
        .padding()
        .frame(width: 378, height: 304)
//        .background(alignment: .center) {
//            RoundedRectangle(cornerRadius: 10)
//                .fill(Color("fieldGray"))
//        }
//        BarView()
    }
}

struct BarView: View {
//    var datum: Double = 0.0
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var num: String
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 20, height: 304)
            VStack {
                RoundedRectangle(cornerRadius: 50)
//                    .fill(LinearGradient(gradient: Gradient(colors: [Color("barChart1"), Color("barChart2")]), startPoint: .bottom, endPoint: .top))
                    .fill(Color("barChart1"))
                    .frame(width: 20, height: height)
                Text(num)
                    .foregroundColor(.white)
            }
        }
    }
}


struct ProviderBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderBarChartView()
    }
}
