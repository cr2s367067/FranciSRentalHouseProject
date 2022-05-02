//
//  ContactView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ContactView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firestoreForContactInfo: FirestoreForContactInfo
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @Environment(\.colorScheme) var colorScheme
    
    @State var connectDes = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
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
                                .background(colorScheme == .dark ? .gray.opacity(0.8) : .white)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .frame(width: 360, height: 600)
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button {
                            Task {   
                                do {
                                    if !connectDes.isEmpty {
                                        try await firestoreForContactInfo.summitContactInfoAsync(question: connectDes, uidPath: firebaseAuth.getUID())
                                    }
                                } catch {
                                    self.errorHandler.handle(error: error)
                                }
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
