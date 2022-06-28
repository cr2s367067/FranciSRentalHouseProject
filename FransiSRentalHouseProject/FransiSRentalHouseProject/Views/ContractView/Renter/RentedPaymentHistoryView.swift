//
//  RentedPaymentHistoryView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/20.
//

import SwiftUI

struct RentedPaymentHistoryView: View {
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var errorHandler: ErrorHandler
    var paymentHistory: [RentedRoomPaymentHistory]
    var roomsData: RoomDM
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    var body: some View {
        VStack {
//            List(paymentHistory) { data in
//                HStack {
//                    Text(data.pastPaymentFee)
//                    Spacer()
//                    Text(data.paymentDate, format: Date.FormatStyle().year().month().day())
//                }
//            }
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(paymentHistory) { data in
                    CusListUnit(paymentH: data)
                }
            }
        }
        .frame(width: uiScreenWidth - 80, height: uiScreenHeight - 240)
        .padding()
//        .background(alignment: .center, content: {
//            RoundedRectangle(cornerRadius: 20)
//                .fill(.gray.opacity(0.4))
//        })
//        .onAppear(perform: {
//            UITableView.appearance().backgroundColor = .clear
//        })
        .task {
            do {
                guard !roomsData.renterUID.isEmpty else { return }
                try await firestoreToFetchUserinfo.fetchPaymentHistory(uidPath: roomsData.renterUID)
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
}

// struct RentedPaymentHistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        RentedPaymentHistoryView()
//    }
// }
