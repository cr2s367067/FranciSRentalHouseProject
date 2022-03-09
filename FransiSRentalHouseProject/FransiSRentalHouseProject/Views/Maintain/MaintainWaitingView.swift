//
//  MaitainWaitingView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/9/22.
//

import SwiftUI

struct MaitainWaitingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill()
            RoundedRectangle(cornerRadius: 20)
        }
    }
}

struct MaitainWaitingView_Previews: PreviewProvider {
    static var previews: some View {
        MaitainWaitingView()
    }
}
