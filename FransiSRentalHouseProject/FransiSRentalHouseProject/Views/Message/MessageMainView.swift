//
//  MessageMainView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageMainView: View {
    
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var textingViewModel: TextingViewModel
    @EnvironmentObject var firestoreForTextingMessage: FirestoreForTextingMessage
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("backgroundBrown"))
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack(alignment: .leading) {
                HStack {
//                    WebImage(url: URL(string: ""))
                    Image(systemName: "person.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .frame(width: 45, height: 45)
                    Text("UsersName")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                }
                VStack(spacing: 10) {
                    NavigationLink {
//                        withAnimation(.easeInOut) {
//                            MessageView()
//                        }
                    } label: {
                        MessageUserSession()
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MessageMainView_Previews: PreviewProvider {
    static var previews: some View {
        MessageMainView()
    }
}

struct MessageUserSession: View {
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .resizable()
                .foregroundColor(.white)
                .clipShape(Circle())
                .frame(width: 35, height: 35)
            VStack(alignment: .leading, spacing: 3) {
                Text("Username")
                Text("some message")
            }
            .padding(.leading)
            .foregroundColor(.white)
            .font(.system(size: 15, weight: .regular))
            Spacer()
        }
        .padding()
        .frame(width: uiScreenWidth - 50, height: 80)
        .frame(maxWidth: .infinity)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("sessionBackground").opacity(0.9))
        }
    }
}
