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
    @EnvironmentObject var roomsDetailViewModel: RoomsDetailViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack(alignment: .leading) {
                HStack {
                    ZStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .frame(width: 45, height: 45)
                        WebImage(url: URL(string: firestoreToFetchUserinfo.fetchedUserData.profileImageURL))
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 45, height: 45)
                    }
                    Text(firestoreToFetchUserinfo.fetchedUserData.displayName)
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                }
                VStack(spacing: 10) {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(firestoreForTextingMessage.contactMember) { message in
                            if roomsDetailViewModel.createNewChateRoom == true {
                                NavigationLink(isActive: $roomsDetailViewModel.createNewChateRoom) {
                                    MessageView(contactMember: message)
                                } label: {
                                    MessageUserSession(userName: message.contacterPlayName, profileImage: message.contacterProfileImage)
                                }
                                
                            } else {
                                NavigationLink {
                                    withAnimation(.easeInOut) {
                                        MessageView(contactMember: message)
                                    }
                                } label: {
                                    MessageUserSession(userName: message.contacterPlayName, profileImage: message.contacterProfileImage)
                                }
                            }
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
                if !firestoreToFetchUserinfo.presentUserId().isEmpty {
                    _ = try await firestoreForTextingMessage.fetchStoredUserData(uidPath: firebaseAuth.getUID())
                    try await firestoreForTextingMessage.fetchChatingMember(userDocID: firestoreForTextingMessage.senderUIDPath.chatDocId)
                    try await determinProviderCreated(listUser: firestoreForTextingMessage.contactMember, providerChatID: roomsDetailViewModel.providerChatDodID, createRoom: roomsDetailViewModel.createNewChateRoom)
                }
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
        .overlay {
            if firestoreToFetchUserinfo.presentUserId().isEmpty {
                UnregisterCoverView(isShowUserDetailView: $appViewModel.isShowUserDetailView)
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
    let profileImage: String
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    var body: some View {
        HStack {
            ZStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
                WebImage(url: URL(string: profileImage))
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(userName)
            }
            .padding(.leading)
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .semibold))
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


extension MessageMainView {
    
    func determinProviderCreated(listUser: [ContactUserDataModel], providerChatID: String, createRoom: Bool) async throws {
        print("Call this function 1")
        print("array contain: \(listUser)")
        if listUser.isEmpty {
            print("prepare creating user")
            Task {
                do {
                    try await createNewChateRoom(newChatRoom: createRoom)
                } catch {
                    self.errorHandler.handle(error: error)
                }
            }
        }
    
        listUser.forEach { person in
            if person.id != providerChatID {
                print("person ID \(person.id ?? "")")
                print("providerChate: ID \(providerChatID)")
                print("increase user")
                Task {
                    do {
                        try await createNewChateRoom(newChatRoom: createRoom)
                    } catch {
                        self.errorHandler.handle(error: error)
                    }
                }
            }
        }
    }
    
    func initChatRoom(providerUID: String, providerName: String, providerChatDocID: String, profileImage: String) async throws {
        let chatRoomUID = UUID().uuidString
        _ = try await firestoreForTextingMessage.fetchStoredUserData(uidPath: firebaseAuth.getUID())
        try await firestoreForTextingMessage.createChatRoom(contact1docID: firestoreForTextingMessage.senderUIDPath.chatDocId, contact2docID: providerChatDocID, chatRoomUID: chatRoomUID)
        
        if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Renter" {
            try await fromSide(chatRoomUID: chatRoomUID, providerUID: providerUID, providerName: providerName, providerChatDocID: providerChatDocID, profileImage: profileImage)
            try await toSide(chatRoomUID: chatRoomUID, providerUID: providerUID, providerName: providerName, providerChatDocID: providerChatDocID, profileImage: profileImage)
        }
    }
    
    
    //MARK: Store same info in both side
    private func fromSide(chatRoomUID: String, providerUID: String, providerName: String, providerChatDocID: String, profileImage: String) async throws {
        
        //MARK: user side
        try await firestoreForTextingMessage.storeSenderUserInfo(uidPath: firebaseAuth.getUID(), userDocID: firestoreForTextingMessage.senderUIDPath.chatDocId, displayName: firestoreToFetchUserinfo.fetchedUserData.displayName, displayProfileImage: profileImage)
        
        //MARK: User contacting side
        try await firestoreForTextingMessage.storeContactUserInfo(contactPersonDocID: providerChatDocID, contactPersonUidPath: providerUID, senderUserDocID: firestoreForTextingMessage.senderUIDPath.chatDocId, contactWithdisplayName: providerName, contactPersondisplayProfileImage: firestoreForTextingMessage.getProviderProfileImage(provideBy: providerUID), chatRoomUID: chatRoomUID)
    }
    
    private func toSide(chatRoomUID: String, providerUID: String, providerName: String, providerChatDocID: String, profileImage: String) async throws {
        
        //MARK: Contact side
        try await firestoreForTextingMessage.storeSenderUserInfo(uidPath: providerUID, userDocID: providerChatDocID, displayName: providerName, displayProfileImage: firestoreForTextingMessage.getProviderProfileImage(provideBy: providerUID))
        
        //MARK: Contacter contacting side
        try await firestoreForTextingMessage.storeContactUserInfo(contactPersonDocID:  firestoreForTextingMessage.senderUIDPath.chatDocId,
                                                                  contactPersonUidPath: firebaseAuth.getUID(),
                                                                  senderUserDocID: providerChatDocID,
                                                                  contactWithdisplayName: firestoreToFetchUserinfo.fetchedUserData.displayName,
                                                                  contactPersondisplayProfileImage: profileImage, chatRoomUID: chatRoomUID)
    }
    
    
    func createNewChateRoom(newChatRoom: Bool) async throws {
        if newChatRoom == true {
            Task {
                do {
                    try await initChatRoom(providerUID: roomsDetailViewModel.providerUID, providerName: roomsDetailViewModel.providerDisplayName, providerChatDocID: roomsDetailViewModel.providerChatDodID, profileImage: firestoreToFetchUserinfo.fetchedUserData.profileImageURL)
                    _ = try await firestoreForTextingMessage.fetchStoredUserData(uidPath: firebaseAuth.getUID())
                    try await firestoreForTextingMessage.fetchChatingMember(userDocID: firestoreForTextingMessage.senderUIDPath.chatDocId)
                } catch {
                    self.errorHandler.handle(error: error)
                }
            }
        }
    }
}

