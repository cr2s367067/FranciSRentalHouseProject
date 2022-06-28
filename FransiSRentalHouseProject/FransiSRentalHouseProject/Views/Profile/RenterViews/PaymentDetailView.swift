//
//  PaymentDetailView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct PaymentDetailView: View {
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firebaseAuth: FirebaseAuth

    var heightData: Double {
        let amount = Double(firestoreToFetchUserinfo.paymentHistory.count)
        if amount == 0 {
            return 1.0
        }
        return amount
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack(alignment: .center) {
                HStack {
                    Text("Payment History: ")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .heavy))
                    Spacer()
                }
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height - 660 + (Double(firestoreToFetchUserinfo.paymentHistory.count) * 80)
                    VStack(spacing: 10) {
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(firestoreToFetchUserinfo.paymentHistory) { history in
                                PaymentDetailSessionUnit(
                                    rentalPrice: history.rentalFee,
                                    paymentDate: history.paymentDate?.dateValue() ?? Date()
                                )
                            }
                            .padding(.top)
                            Spacer()
                        }
                    }
                    .frame(width: width, height: height)
                    .background(alignment: .center) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color("sessionBackground"))
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .task {
            do {
                try await firestoreToFetchUserinfo.fetchPaymentHistory(uidPath: firebaseAuth.getUID())
            } catch {
                self.errorHandler.handle(error: error)
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
