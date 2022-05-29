//
//  MessageView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/13/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

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
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .center) {
//            WebImage(url: URL(string: "http://localhost:9199/v0/b/francisrentalhouseproject.appspot.com/o/messageImage%2FA0BC15D9-1FF8-481D-90DB-3B8E766562FB%2F49A70815-DC6E-4022-AF0B-3836332E6CB8%2FFCBDD200-4892-4E85-9842-D47D69867A6E.jpg?alt=media&token=994e3cfb-68d3-42d8-8129-e9723864bd6b"))
//                .resizable()
//                .frame(width: 100, height: 100, alignment: .center)
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { item in
                    VStack {
                        ForEach(firestoreForTextingMessage.messagesContainer) { textMessage in
                            if textMessage.senderDocID == firestoreForTextingMessage.senderUIDPath.chatDocId {
                                //MARK: Right side
                                TextingViewForSender(text: textMessage.text, imageURL: textMessage.sendingImage ?? "")
                                    .id(textMessage.id)
                            } else {
                                //MARK: Left side
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
                    .onChange(of: isFocused) { _ in
                        if isFocused == true {
                            withAnimation(.spring()) {
                                item.scrollTo(firestoreForTextingMessage.messagesContainer.last?.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            VStack(spacing: 10) {
                if !textingViewModel.image.isEmpty {
                    HStack {
                        //Photo card
                        ForEach(textingViewModel.image) { image in
                            ZStack {
                                Image(uiImage: image.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: uiScreenWidth / 5 - 20, height: uiScreenHeight / 8 - 20, alignment: .center)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button {
                                            textingViewModel.image.removeAll(where: {$0.id == image.id})
                                            debugPrint(image.image)
                                        } label: {
                                            ZStack {
                                                Image(systemName: "circle.fill")
                                                    .foregroundColor(.black)
                                                Image(systemName: "multiply.circle.fill")
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                    .padding(.top, 4)
                                    .padding(.trailing, 4)
                                    Spacer()
                                }
                                .frame(width: uiScreenWidth / 5 - 20, height: uiScreenHeight / 8 - 20, alignment: .center)
                            }
                        }
                        Spacer()
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
                    HStack {
                        TextField("", text: $textingViewModel.text)
                            .foregroundColor(.white)
                            .focused($isFocused)
                        Button {
                            Task {
                                do {
                                    
                                    //MARK: Adjust message sending method, this will create two new doc in once.
                                    if !textingViewModel.image.isEmpty {
                                        try await storageForMessageImage.sendingImage(images: textingViewModel.image, chatRoomUID: contactMember.chatRoomUID, senderDocID: firestoreForTextingMessage.senderUIDPath.chatDocId, contactWith: getContactPerson(sender: firestoreForTextingMessage.senderUIDPath.chatDocId))
                                        textingViewModel.image.removeAll()
                                    }
                                    if !textingViewModel.text.isEmpty {
                                        try await firestoreForTextingMessage.sendingMessage(text: textingViewModel.text,
                                                                                        sendingImage: "",
                                                                                        senderProfileImage: "",
                                                                                        senderDocID: firestoreForTextingMessage.senderUIDPath.chatDocId,
                                                                                        chatRoomUID: contactMember.chatRoomUID, contactWith: getContactPerson(sender: firestoreForTextingMessage.senderUIDPath.chatDocId))
                                    }
                                    guard let id = contactMember.id else { return }
                                    try await firestoreForTextingMessage.updateLastMessageTime(userDocID: firestoreForTextingMessage.senderUIDPath.chatDocId, contactPersonID: id)
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
                    .padding()
                    .frame(width: uiScreenWidth - 70 , height: 45, alignment: .center)
                    .background(alignment: .center) {
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.white, lineWidth: 2)
                            .foregroundColor(Color.clear)
                    }
                }
            }
            .padding()
            .frame(width: uiScreenWidth - 30)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .modifier(ViewBackgroundInitModifier())
        .keyboardAdaptive()
        .overlay {
            if textingViewModel.showImageDetail == true {
                withAnimation {
                    ShowImage(imageURL: textingViewModel.imageURL, showImageDetail: $textingViewModel.showImageDetail)
                }
            }
        }
        .task {
            do {
                _ = try await firestoreForTextingMessage.fetchChatCenter(chatRoomUID: contactMember.chatRoomUID)
                firestoreForTextingMessage.listenChatCenterMessageContain(chatRoomUID: contactMember.chatRoomUID)
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
        .sheet(isPresented: $textingViewModel.showPhpicker, onDismiss: {

        }, content: {
            PHPickerRepresentable(images: $textingViewModel.image)
        })
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
        .onTapGesture {
            if isFocused {
                isFocused = false
            }
        }
    }
}

struct TextingViewForReceiver: View {
    @EnvironmentObject var textingViewModel: TextingViewModel
    @Environment(\.colorScheme) var colorScheme
    let text: String
    let imageURL: String
    let receiveProfileImage: String
    var body: some View {
        HStack {
            if receiveProfileImage.isEmpty {
                Image(systemName: "person.crop.circle")
                    .foregroundColor(.white)
                    .font(.system(size: 40))
            } else {
                WebImage(url: URL(string: receiveProfileImage))
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
//            if !textingViewModel.image.isEmpty {
//
//            }
            if !imageURL.isEmpty {
                WebImage(url: URL(string: imageURL))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
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
                    .padding()
                    .background(alignment: .center, content: {
                        Color.black.opacity(0.2)
                            .cornerRadius(30)
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.blue.opacity(colorScheme == .dark ? 0.5 : 0.2), lineWidth: 2)
                    })
            }
            Spacer()
        }
        
        
    }
}


struct TextingViewForSender: View {
    @EnvironmentObject var imgPresenterM: ImagePresentingManager
    @EnvironmentObject var textingViewModel: TextingViewModel
    @Environment(\.colorScheme) var colorScheme
    let text: String
    let imageURL: String
    
    var body: some View {
        HStack {
            Spacer()
            if !text.isEmpty{
                Text(text)
                    .foregroundColor(.white)
                    .padding()
                    .background(alignment: .center, content: {
                        Color.black.opacity(0.2)
                            .cornerRadius(30)
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.green.opacity(colorScheme == .dark ? 0.5 : 0.2), lineWidth: 2)
                    })
            }
            if !imageURL.isEmpty {
                WebImage(url: URL(string: imageURL))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .onTapGesture {
                        textingViewModel.showImageDetail = true
                        print(textingViewModel.showImageDetail)
                        textingViewModel.imageURL = imageURL
                        print(textingViewModel.imageURL)
                    }
            }
        }
        .padding(.horizontal, 1)
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
                    .scaledToFill()
                    .frame(width: uiScreenWidth - 100, height: uiScreenHeight / 2)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
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


extension MessageView {
    
    func getContactPerson(sender: String) -> String {
        var holder = ""
        if firestoreForTextingMessage.chatManager.contact1docID == sender {
            holder = firestoreForTextingMessage.chatManager.contact2docID
        }
        if firestoreForTextingMessage.chatManager.contact2docID == sender {
            holder = firestoreForTextingMessage.chatManager.contact1docID
        }
        return holder
    }
    
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification).map {$0.keyboardHeight}
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification).map { _ in CGFloat(0)}
        return MergeMany(willShow, willHide).eraseToAnyPublisher()
    }
}

extension UIResponder {
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }
    
    private static weak var _currentFirstResponder: UIResponder?
    
    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
    
    var globalFram: CGRect? {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}

struct KeyboardAdaptive: ViewModifier {
    @State private var bottomPadding: CGFloat = 0
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.bottomPadding)
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    let focusedTextInputButtom = UIResponder.currentFirstResponder?.globalFram?.maxX ?? 0
                    self.bottomPadding = max(0, focusedTextInputButtom - keyboardTop - geometry.safeAreaInsets.bottom)
                }
        }
        .animation(.easeOut, value: 0.6)
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}


/*
 Task {
 do {
 try await storageForMessageImage.sendingImage(images: textingViewModel.image, chatRoomUID: contactMember.chatRoomUID, senderDocID: firestoreForTextingMessage.senderUIDPath.chatDocId)
 textingViewModel.image.removeAll()
 } catch {
 self.errorHandler.handle(error: error)
 }
 }
 
*/

//struct PhotoPreview: View {
//
//    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
//    @EnvironmentObject var errorHandler: ErrorHandler
//    @EnvironmentObject var firebaseAuth: FirebaseAuth
//    @EnvironmentObject var textingViewModel: TextingViewModel
//    @EnvironmentObject var firestoreForTextingMessage: FirestoreForTextingMessage
//    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
//    @EnvironmentObject var storageForMessageImage: StorageForMessageImage
//
//    var contactMember: ContactUserDataModel
//
//    let uiScreenWidth = UIScreen.main.bounds.width
//    let uiScreenHeight = UIScreen.main.bounds.height
//
//    @FocusState var isFocused: Bool
//
//    @Binding var showPicker: Bool
//    @Binding var text: String
//    @State var photoArray: [UIImage]
//
//
//    var body: some View {
//        VStack(spacing: 10) {
//            if !textingViewModel.image.isEmpty {
//                HStack {
//                    //Photo card
//                    ForEach(textingViewModel.image, id: \.self) { image in
//                        ZStack {
//                            Image(uiImage: image)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: uiScreenWidth / 5 - 20, height: uiScreenHeight / 8 - 20, alignment: .center)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                            VStack {
//                                HStack {
//                                    Spacer()
//                                    Button {
//
//                                    } label: {
//                                        Image(systemName: "multiply.circle.fill")
//                                            .foregroundColor(.gray)
//                                    }
//                                }
//                                .padding(.top, 4)
//                                .padding(.trailing, 4)
//                                Spacer()
//                            }
//                            .frame(width: uiScreenWidth / 5 - 20, height: uiScreenHeight / 8 - 20, alignment: .center)
//                        }
//                    }
//                    Spacer()
//                }
//            }
//            HStack {
//                Button {
//                    textingViewModel.showPhpicker.toggle()
//                } label: {
//                    Image(systemName: "photo")
//                        .foregroundColor(.white)
//                        .font(.system(size: 20))
//                }
//                HStack {
//                    TextField("", text: $text)
//                        .foregroundColor(.white)
//                        .focused($isFocused)
//                    Button {
//                        Task {
//                            do {
//                                try await firestoreForTextingMessage.sendingMessage(text: textingViewModel.text,
//                                                                                    sendingImage: "",
//                                                                                    senderProfileImage: "",
//                                                                                    senderDocID: firestoreForTextingMessage.senderUIDPath.chatDocId,
//                                                                                    chatRoomUID: contactMember.chatRoomUID, contactWith: getContactPerson(sender: firestoreForTextingMessage.senderUIDPath.chatDocId))
//                                guard let id = contactMember.id else { return }
//                                try await firestoreForTextingMessage.updateLastMessageTime(userDocID: firestoreForTextingMessage.senderUIDPath.chatDocId, contactPersonID: id)
//                                textingViewModel.text = ""
//                            } catch {
//                                self.errorHandler.handle(error: error)
//                            }
//                        }
//                    } label: {
//                        Image(systemName: "paperplane")
//                            .resizable()
//                            .foregroundColor(Color.white)
//                            .frame(width: 25, height: 25)
//                    }
//                }
//                .padding()
//                .frame(width: uiScreenWidth - 70 , height: 45, alignment: .center)
//                .background(alignment: .center) {
//                    RoundedRectangle(cornerRadius: 50)
//                        .stroke(Color.white, lineWidth: 2)
//                        .foregroundColor(Color.clear)
//                }
//            }
//        }
//        .padding()
//        .frame(width: uiScreenWidth - 30)
//    }
//}

//struct PhotoPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoPreview()
//            .preferredColorScheme(.dark)
//    }
//}



//HStack {
//                Button {
//                    textingViewModel.showPhpicker.toggle()
//                } label: {
//                    Image(systemName: "photo")
//                        .foregroundColor(.white)
//                        .font(.system(size: 20))
//                }
//                TextField("", text: $textingViewModel.text)
//                    .foregroundColor(.white)
//                    .focused($isFocused)
//                Button {
//                    Task {
//                        do {
//                            try await firestoreForTextingMessage.sendingMessage(text: textingViewModel.text,
//                                                                                sendingImage: "",
//                                                                                senderProfileImage: "",
//                                                                                senderDocID: firestoreForTextingMessage.senderUIDPath.chatDocId,
//                                                                                chatRoomUID: contactMember.chatRoomUID, contactWith: getContactPerson(sender: firestoreForTextingMessage.senderUIDPath.chatDocId))
//                            guard let id = contactMember.id else { return }
//                            try await firestoreForTextingMessage.updateLastMessageTime(userDocID: firestoreForTextingMessage.senderUIDPath.chatDocId, contactPersonID: id)
//                            textingViewModel.text = ""
//                        } catch {
//                            self.errorHandler.handle(error: error)
//                        }
//                    }
//                } label: {
//                    Image(systemName: "paperplane")
//                        .resizable()
//                        .foregroundColor(Color.white)
//                        .frame(width: 25, height: 25)
//                }
//            }
//            .padding(.horizontal)
//            .frame(width: uiScreenWidth - 30 , height: 45, alignment: .center)
//            .background(alignment: .center) {
//                RoundedRectangle(cornerRadius: 50)
//                    .stroke(Color.white, lineWidth: 2)
//                    .foregroundColor(Color.clear)
//            }
//            .ignoresSafeArea(.keyboard, edges: .bottom)
