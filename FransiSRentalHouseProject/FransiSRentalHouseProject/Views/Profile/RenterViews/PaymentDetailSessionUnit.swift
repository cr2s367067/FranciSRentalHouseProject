//
//  PaymentDetailSessionUnit.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct PaymentDetailSessionUnit: View {
    
    var rentalPrice: Int
    var paymentDate: Date
    
    var body: some View {
        HStack {
            Text("$ \(rentalPrice)")
            Spacer()
            Text("\(paymentDate, format: Date.FormatStyle().year().month().day())")
            
        }
        .padding()
        .foregroundColor(Color("sessionBackground"))
        .font(.system(size: 16, weight: .heavy))
        .frame(width: 354, height: 50)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("fieldGray"))
                .shadow(color: .black, radius: 2)
        }
    }
}

//struct PaymentDetailSessionUnit_Previews: PreviewProvider {
//    static var previews: some View {
//        PaymentDetailSessionUnit()
//    }
//}
