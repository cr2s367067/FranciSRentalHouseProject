//
//  UserPaymentHistoryView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/14.
//

import SwiftUI

struct UserPaymentHistoryView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    CusListUnit(rentalPrice: "9000", paymentDate: Date())
                }
            }
            .padding()
            .frame(width: uiScreenWidth - 20, height: uiScreenHeight - 200, alignment: .center)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .dark ? .gray.opacity(0.3) : .black.opacity(0.4))
            }
        }
        .modifier(ViewBackgroundInitModifier())
    }
}

struct UserPaymentHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        UserPaymentHistoryView()
    }
}

struct CusListUnit: View {
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var rentalPrice = "9000"
    var paymentDate = Date()
    
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Text("$\(rentalPrice)")
                Spacer()
                Text("\(paymentDate, format: Date.FormatStyle().year().month().day())")
            }
            .foregroundColor(.white)
            .font(.body)
            .padding()
            .frame(width: uiScreenWidth - 50, height: 40, alignment: .center)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray)
            }
            HStack {
                Text("Notes:")
                Text("Rental fee")
                Spacer()
            }
            .foregroundColor(.gray)
            .font(.caption)
            Divider()
                .frame(width: uiScreenWidth - 50, height: 1)
                .background(.white)
        }
    }
}
