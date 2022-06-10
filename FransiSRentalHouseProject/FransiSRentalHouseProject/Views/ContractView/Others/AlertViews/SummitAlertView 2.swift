//
//  SummitAlertView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/8/22.
//

import SwiftUI

struct SummitAlertView: View {
    @Binding var showSummitAlert: Bool
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.8))
                .blur(radius: 10)
                .ignoresSafeArea(.all)
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(width: 200, height: 200, alignment: .center)
            VStack(alignment: .center, spacing: 30) {
                Text("Success")
                    .font(.system(size: 25, weight: .medium))
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
                HStack(alignment: .center) {
//                    Button {
//
//                    } label: {
//                        Text("Cancel")
//                            .foregroundColor(.white)
//                            .frame(width: 108, height: 35)
//                            .background(Color("buttonBlue"))
//                            .clipShape(RoundedRectangle(cornerRadius: 5))
//                    }
//                    Spacer()
//                        .frame(width: 10)
                    Button {
                        showSummitAlert = false
                    } label: {
                        Text("Okay")
                            .foregroundColor(.white)
                            .frame(width: 108, height: 35)
                            .background(Color("buttonBlue"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
                .padding()
            }
        }
    }
}

//struct SummitAlertView_Previews: PreviewProvider {
//    static var previews: some View {
//        SummitAlertView()
//    }
//}
