//
//  PaymentDetailSessionUnit.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct PaymentDetailSessionUnit: View {
    
    @State var rentalPrice: String = "9000"
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("fieldGray"))
                .cornerRadius(5)
                .frame(width: 354, height: 51)
            HStack {
                Text("$ \(rentalPrice)")
                Spacer()
                    .frame(width: 90)
                Text("1/14/2022")
                    
            }
            .foregroundColor(Color("sessionBackground"))
            .font(.system(size: 16, weight: .heavy))
            .padding()
        }
    }
}

struct PaymentDetailSessionUnit_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetailSessionUnit()
    }
}
