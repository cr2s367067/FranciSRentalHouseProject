//
//  PaymentDetailView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct PaymentDetailView: View {
    
    @State var rentalPrice = "9000"
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea(.all)
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color("sessionBackground"))
                        .cornerRadius(4)
                        .frame(width: 378, height: 263)
                    VStack(spacing: 10) {
                        HStack {
                            Text("Payment History: ")
                                .font(.system(size: 20, weight: .heavy))
                            Spacer()
                                .frame(width: 180)
                        }
                        
                        PaymentDetailSessionUnit(rentalPrice: rentalPrice)
                        PaymentDetailSessionUnit(rentalPrice: rentalPrice)
                        PaymentDetailSessionUnit(rentalPrice: rentalPrice)
                        
                        
                        Spacer()
                            .frame(height: 40)
                    }
                    .foregroundColor(.white)
                    .padding(.leading, 2)
                    .padding(.top, 3)
                }
                Spacer()
                    .frame(height: 450)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PaymentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetailView()
    }
}
