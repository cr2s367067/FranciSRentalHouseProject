//
//  ProviderBarChartView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ProviderBarChartView: View {
    
    var data: [Double] = [100, 200, 300, 200, 100, 400]
    
    var highestData: Double {
        let max = data.max() ?? 1.0
        if max == 0 {
            return 1.0
        }
        return max
    }
    
    var body: some View {
        GeometryReader{ geometry in
            HStack(alignment: .bottom, spacing: 4.0) {
                ForEach(data.indices, id: \.self) { index in
                    let wight = (geometry.size.width / CGFloat(data.count)) - 4.0
                    let height = geometry.size.height * data[index] / highestData
                    BarView(datum: data[index])
                        .frame(width: wight, height: height, alignment: .bottom)
                }
            }
        }
    }
}

struct BarView: View {
    var datum: Double = 0.0
    var body: some View {
        Rectangle()
            .fill(Color.black)
    }
}


struct ProviderBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderBarChartView()
    }
}
