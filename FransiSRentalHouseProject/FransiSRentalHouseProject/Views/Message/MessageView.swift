//
//  MessageView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/13/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageView: View {

    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var textingViewModel: TextingViewModel
    @EnvironmentObject var firestoreForTextingMessage: FirestoreForTextingMessage
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var storageForMessageImage: StorageForMessageImage

    
    var contactMember: ContactUserDataModel
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    

    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack(alignment: .center) {
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollViewReader { item in
                        VStack {
                            ForEach(firestoreForTextingMessage.messagesContainer) { textMessage in
                                if textMessage.senderDocID == firestoreForTextingMessage.senderUIDPath.chatDocId {
                                    TextingViewForSender(text: textMessage.text, imageURL: textMessage.sendingImage ?? "")
                                        .id(textMessage.id)
                                } else {
                                    TextingViewForReceiver(text: textMessage.text, imageURL: textMessage.sendingImage ?? "", receiveProfileImage: contactMember.contacterProfileImage)
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
                    Button {
                        textingViewModel.showPhpicker.toggle()
                    } label: {
                        Image(systemName: "photo")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
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
                                                                                    chatRoomUID: contactMember.chatRoomUID)
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
                        .stroke(Color.white, lineWidth: 2)
                        .foregroundColor(Color.clear)
                }
            }
            .padding(.vertical)
        }
        .overlay {
            if textingViewModel.showImageDetail == true {
                withAnimation {
                    ShowImage(imageURL: textingViewModel.imageURL, showImageDetail: $textingViewModel.showImageDetail)
                }
            }
        }
        .task {
//            do {
//                _ = try await firestoreForTextingMessage.fetchStoredUserData(uidPath: firebaseAuth.getUID())
//                _ = try await firestoreForTextingMessage.fetchChatUserInfo(userDocID: firestoreForTextingMessage.senderUIDPath.chatDocId)
                 firestoreForTextingMessage.listenChatCenterMessageContain(chatRoomUID: contactMember.chatRoomUID)
//                try await firestoreForTextingMessage.fetchChatingMember(userDocID: firestoreForTextingMessage.senderUIDPath.chatDocId)
//            } catch {
//                self.errorHandler.handle(error: error)
//            }
        }
        .sheet(isPresented: $textingViewModel.showPhpicker, onDismiss: {
            Task {
                do {
                    try await storageForMessageImage.sendingImage(images: textingViewModel.image, chatRoomUID: contactMember.chatRoomUID, senderDocID: firestoreForTextingMessage.senderUIDPath.chatDocId)
                    textingViewModel.image.removeAll()
                } catch {
                    self.errorHandler.handle(error: error)
                }
            }
        }, content: {
            PHPickerRepresentable(images: $textingViewModel.image)
        })
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

struct TextingViewForReceiver: View {
    @EnvironmentObject var textingViewModel: TextingViewModel
    let text: String
    let imageURL: String
    let receiveProfileImage: String
    var body: some View {
        HStack {
            WebImage(url: URL(string: receiveProfileImage))
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            if !imageURL.isEmpty {
                WebImage(url: URL(string: imageURL))
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .frame(width: 200, height: 250)
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .onTapGesture {
                        textingViewModel.showImageDetail = true
                        print(textingViewModel.showImageDetail)
                        textingViewModel.imageURL = imageURL
                        print(textingViewModel.imageURL)
                    }
            }
            if !text.isEmpty {
                Text(text)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical)
                    .background(alignment: .center, content: {
                        Color.black.opacity(0.2)
                            .cornerRadius(30)
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 2)
                    })
            }
            Spacer()
        }
        .padding(.leading)
        
        
    }
}

struct TextingViewForSender: View {
    @EnvironmentObject var textingViewModel: TextingViewModel
    let text: String
    let imageURL: String
    var body: some View {
        HStack {
            Spacer()
            if !text.isEmpty{
                Text(text)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical)
                    .background(alignment: .center, content: {
                        Color.black.opacity(0.2)
                            .cornerRadius(30)
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.green.opacity(0.2), lineWidth: 2)
                    })
            }
            if !imageURL.isEmpty {
                WebImage(url: URL(string: imageURL))
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(width: 200, height: 250)
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .onTapGesture {
                        textingViewModel.showImageDetail = true
                        print(textingViewModel.showImageDetail)
                        textingViewModel.imageURL = imageURL
                        print(textingViewModel.imageURL)
                    }
            }
        }
        .padding(.trailing)
        
        
    }
}

struct ShowImage: View {
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    var imageURL: String
    @Binding var showImageDetail: Bool
    var body: some View {
        VStack(spacing: 22) {
            HStack {
                Spacer()
                Button {
                    showImageDetail = false
                } label: {
                    Image(systemName: "x.square")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 25))
                }
            }
            VStack {
                WebImage(url: URL(string: imageURL))
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(width: uiScreenWidth - 100, height: uiScreenHeight / 2)
                    .padding()
                    .aspectRatio(contentMode: .fit)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(alignment: .center) {
            Color.black.opacity(0.85)
                .edgesIgnoringSafeArea([.top, .bottom])
        }
    }
}

//struct ShowImage_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowImage()
//    }
//}
