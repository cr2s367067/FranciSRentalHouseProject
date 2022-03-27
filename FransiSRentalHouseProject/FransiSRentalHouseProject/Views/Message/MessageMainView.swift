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
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
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
                    ForEach(firestoreForTextingMessage.contactMember) { message in
                        NavigationLink {
                            withAnimation(.easeInOut) {
                                MessageView(providerName: message.contacterPlayName, providerUID: message.contacterMailUidPath, chatDocID: message.id ?? "")
                            }
                        } label: {
                            MessageUserSession(userName: message.contacterPlayName)
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
        .task {
            do {
                _ = try await firestoreForTextingMessage.fetchStoredUserData(uidPath: firebaseAuth.getUID())
                try await firestoreForTextingMessage.fetchChatingMember(userDocID: firestoreForTextingMessage.senderUIDPath.chatDocId)
            } catch {
                self.errorHandler.handle(error: error)
            }
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
    
    let userName: String
    
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
                Text(userName)
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
