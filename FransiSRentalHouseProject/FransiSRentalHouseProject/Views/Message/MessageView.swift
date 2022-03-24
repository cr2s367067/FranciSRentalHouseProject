//
//  MessageView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/13/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageView: View {
//    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var textingViewModel: TextingViewModel
    @EnvironmentObject var firestoreForTextingMessage: FirestoreForTextingMessage
    
    let providerName: String
    let providerUID: String
    let roomUID: String
    let chatID: String
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
//    private func getChatID() async -> String {
//        var chatID = ""
//        chatID = firestoreForTextingMessage.textGroup.map({$0.chatID}).description
//        return chatID
//    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("backgroundBrown"))
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack(alignment: .center) {
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollViewReader { item in
                        VStack {
                            ForEach(firestoreForTextingMessage.textContainer) { textMessage in
                                if textMessage.senderUID == firebaseAuth.getUID() {
                                    TextingViewForSender(text: textMessage.textContain)
                                        .id(textMessage.id)
                                } else {
                                    TextingViewForReceiver(text: textMessage.textContain)
                                        .id(textMessage.id)
                                }
                            }
                        }
                        .onAppear {
                            withAnimation(.spring()) {
                                item.scrollTo(firestoreForTextingMessage.textContainer.last?.id, anchor: .bottom)
                            }
                        }
                        .onChange(of: firestoreForTextingMessage.textContainer.count) { _ in
                            withAnimation(.spring()) {
                                item.scrollTo(firestoreForTextingMessage.textContainer.last?.id, anchor: .bottom)
                            }

                        }
                    }
                }
                HStack {
                    TextField("", text: $textingViewModel.text)
                        .foregroundColor(.white)
                        .frame(height: 40, alignment: .center)
                    Button {
                        Task {
                            do {
                                try await firestoreForTextingMessage.creatAndSendTextingSessionS(senderUID: firebaseAuth.getUID(), receiveUID: providerUID, receiveDisplayName: providerName, senderDisplayName: firestoreToFetchUserinfo.fetchedUserData.displayName, textContain: textingViewModel.text)
//                                try await firestoreForTextingMessage.sendingTextMessageRenter(senderUID: firebaseAuth.getUID(), receiveUID: providerUID, receiveDisplayName: providerName, senderDisplayName: firestoreToFetchUserinfo.fetchedUserData.displayName, textContain: textingViewModel.text)
                                textingViewModel.text = ""
                            } catch {
                                self.errorHandler.handle(error: error)
                            }
                        }
                    } label: {
                        Image(systemName: "paperplane")
                            .resizable()
                            .foregroundColor(Color.white)
                            .frame(width: 25, height: 25)
                    }
                }
                .padding(.horizontal)
                .frame(width: uiScreenWidth / 2 + 185, height: 45, alignment: .center)
                .background(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.gray.opacity(0.8), lineWidth: 3)
                        .foregroundColor(Color.clear)
                }
            }
            .padding(.vertical)
        }
        .task {
            do {
                _ = try await firestoreForTextingMessage.listeningTexingMessage(uidPath: firebaseAuth.getUID())
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: "house.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20, alignment: .leading)
                    Text("Provider")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .regular))
                        .padding(.leading)
                    Spacer()
                }
            }
        }
    }
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView(providerUID: "", roomUID: "")
//    }
//}

struct TextingViewForReceiver: View {
    let text: String
    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical)
                .background(alignment: .center, content: {
                    Color.black.opacity(0.2)
                        .cornerRadius(40)
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 2)
                })
            Spacer()
        }
        .padding(.leading)
        
        
    }
}

struct TextingViewForSender: View {
    let text: String
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical)
                .background(alignment: .center, content: {
                    Color.black.opacity(0.2)
                        .cornerRadius(40)
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.green.opacity(0.2), lineWidth: 2)
                })
        }
        .padding(.trailing)
        
        
    }
}
