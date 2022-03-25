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
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    let providerName: String
    let providerUID: String
    let chatDocID: String

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
//    init() {
//        if providerUID !=  {
//
//        }
//    }
    
    //Figure out init at where!!
    func initChatRoom(providerUID: String, providerName: String) async throws {
        let chatRoomUID = UUID().uuidString
        _ = try await firestoreForTextingMessage.fetchStoredUserData(uidPath: firebaseAuth.getUID())
        try await firestoreForTextingMessage.createChatRoom(contact1docID: firestoreForTextingMessage.senderUIDPath.chatDocId, contact2docID: chatDocID, chatRoomUID: chatRoomUID)
        
        if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Renter" {
            try await fromSide(chatRoomUID: chatRoomUID, providerUID: providerUID, providerName: providerName)
            try await toSide(chatRoomUID: chatRoomUID, providerUID: providerUID, providerName: providerName)
        }
    }
    
    private func fromSide(chatRoomUID: String, providerUID: String, providerName: String) async throws {
        try await firestoreForTextingMessage.storeSenderUserInfo(uidPath: firebaseAuth.getUID(), userDocID: firestoreForTextingMessage.senderUIDPath.chatDocId, displayName: firestoreToFetchUserinfo.fetchedUserData.displayName, displayProfileImage: "", chatRoomUID: chatRoomUID)
        try await firestoreForTextingMessage.storeContactUserInfo(contactPersonDocID: chatDocID, contactPersonUidPath: providerUID, senderUserDocID: firestoreForTextingMessage.senderUIDPath.chatDocId, contactWithdisplayName: providerName, contactPersondisplayProfileImage: "", chatRoomUID: chatRoomUID)
    }
    
    private func toSide(chatRoomUID: String, providerUID: String, providerName: String) async throws {
        try await firestoreForTextingMessage.storeSenderUserInfo(uidPath: providerUID, userDocID: chatDocID, displayName: providerName, displayProfileImage: "", chatRoomUID: chatRoomUID)
        try await firestoreForTextingMessage.storeContactUserInfo(contactPersonDocID:  firestoreForTextingMessage.senderUIDPath.chatDocId,
                                                                  contactPersonUidPath: firebaseAuth.getUID(),
                                                                  senderUserDocID: chatDocID,
                                                                  contactWithdisplayName: firestoreToFetchUserinfo.fetchedUserData.displayName,
                                                                  contactPersondisplayProfileImage: "", chatRoomUID: chatRoomUID)
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("backgroundBrown"))
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack(alignment: .center) {
                HStack {
                    Button {
                        print(firestoreForTextingMessage.chatManager)
                    } label: {
                        Text("test")
                    }
                    Button {
                        Task {
                            do {
                                _ = try await firestoreForTextingMessage.fetchChatCenter()
                            } catch {
                                self.errorHandler.handle(error: error)
                            }
                        }
//                        firestoreForTextingMessage.listenChatCenterMessageContain(chatRoomUID: firestoreForTextingMessage.chatUserData.chatRoomUID)
                    } label: {
                         Text("get")
                    }
                }
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollViewReader { item in
                        VStack {
                            ForEach(firestoreForTextingMessage.messagesContainer) { textMessage in
                                if textMessage.senderDocID == firestoreForTextingMessage.senderUIDPath.chatDocId {
                                    TextingViewForSender(text: textMessage.text)
                                        .id(textMessage.id)
                                } else {
                                    TextingViewForReceiver(text: textMessage.text)
                                        .id(textMessage.id)
                                }
                            }
                        }
                        .onAppear {
                            withAnimation(.spring()) {
                                item.scrollTo(firestoreForTextingMessage.messagesContainer.last?.id, anchor: .bottom)
                            }
                        }
                        .onChange(of: firestoreForTextingMessage.messagesContainer.count) { _ in
                            withAnimation(.spring()) {
                                item.scrollTo(firestoreForTextingMessage.messagesContainer.last?.id, anchor: .bottom)
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
                                try await firestoreForTextingMessage.sendingMessage(text: textingViewModel.text,
                                                                                    sendingImage: "",
                                                                                    senderProfileImage: "",
                                                                                    senderDocID: firestoreForTextingMessage.senderUIDPath.chatDocId,
                                                                                    chatRoomUID: firestoreForTextingMessage.chatUserData.chatRoomUID)
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
                try await firestoreForTextingMessage.fetchChatCenter()
                _ = try await firestoreForTextingMessage.fetchStoredUserData(uidPath: firebaseAuth.getUID())
                if firestoreForTextingMessage.chatManager.isEmpty {
                    try await initChatRoom(providerUID: providerUID, providerName: providerName)
                }
                _ = try await firestoreForTextingMessage.fetchChatUserInfo(userDocID: firestoreForTextingMessage.senderUIDPath.chatDocId)
                await firestoreForTextingMessage.listenChatCenterMessageContain(chatRoomUID: firestoreForTextingMessage.chatUserData.chatRoomUID)
                try await firestoreForTextingMessage.fetchChatingMember(userDocID: firestoreForTextingMessage.senderUIDPath.chatDocId)
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
