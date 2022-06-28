//
//  UserPaymentHistoryView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/14.
//

import SwiftUI

struct UserPaymentHistoryView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(\.colorScheme) var colorScheme

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    var body: some View {
        VStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(firestoreToFetchUserinfo.paymentHistory) { paymentH in
                        CusListUnit(paymentH: paymentH)
                    }
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
        .task {
            do {
                try await firestoreToFetchUserinfo.fetchPaymentHistory(uidPath: firebaseAuth.getUID())
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
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

    var paymentH: RentedRoomPaymentHistory

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Text("$\(paymentH.rentalFee)")
                Spacer()
                Text("\(paymentH.paymentDate?.dateValue() ?? Date(), format: Date.FormatStyle().year().month().day())")
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
                Text(paymentH.note ?? "")
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
