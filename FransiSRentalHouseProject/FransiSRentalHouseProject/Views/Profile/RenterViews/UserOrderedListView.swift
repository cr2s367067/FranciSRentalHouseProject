//
//  UserOrderedListView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/30.
//

import SwiftUI

struct UserOrderedListView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack {
                UserOrderedListUnitView()
            }
        }
    }
}

struct UserOrderedListView_Previews: PreviewProvider {
    static var previews: some View {
        UserOrderedListView()
    }
}
