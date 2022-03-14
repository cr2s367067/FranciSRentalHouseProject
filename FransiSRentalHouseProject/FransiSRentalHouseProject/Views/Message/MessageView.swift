//
//  MessageView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/13/22.
//

import SwiftUI

struct MessageView: View {
//    @EnvironmentObject var appViewModel: AppViewModel
//    @EnvironmentObject var firestoreForContactInfo: FirestoreForContactInfo
//    @EnvironmentObject var firebaseAuth: FirebaseAuth
    
    @State var connectDes = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("backgroundBrown"))
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack(alignment: .leading) {
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        Text("some texting message")
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.leading)
                    HStack {
                        Spacer()
                        Text("some texting message")
                    }
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.trailing)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
