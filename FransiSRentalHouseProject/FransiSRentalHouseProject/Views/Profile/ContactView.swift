//
//  ContactView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ContactView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firestoreForContactInfo: FirestoreForContactInfo
//    let firestoreForContactInfo = FirestoreForContactInfo()
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    
    @State var connectDes = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("backgroundBrown"))
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack(alignment: .leading) {
                ScrollView(.vertical, showsIndicators: false) {
                    //: Title Group
                    VStack(spacing: 1) {
                        HStack {
                            Text("Have any question?")
                                .font(.system(size: 24, weight: .heavy))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        HStack {
                            VStack {
                                Divider()
                                    .background(Color.white)
                                    .frame(width: 400, height: 10)
                            }
                        }
                    }
                    .padding(.leading)
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Contact Us")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .heavy))
                            TextEditor(text: $connectDes)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .frame(width: 360, height: 600)
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button {
                            if !connectDes.isEmpty {
                                firestoreForContactInfo.summitContactInfo(question: connectDes, uidPath: firebaseAuth.getUID())
                            }
                        } label: {
                            Text("Send it!")
                                .foregroundColor(.white)
                                .frame(width: 108, height: 35)
                                .background(Color("buttonBlue"))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    }
                    .padding(.trailing)
                    .padding(.top, 5)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContectView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView()
    }
}
