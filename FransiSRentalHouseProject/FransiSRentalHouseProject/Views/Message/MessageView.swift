//
//  MessageView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/13/22.
//

import Combine
import SDWebImageSwiftUI
import SwiftUI
import WaterfallGrid

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

    @State private var selectLimit = 10

    var body: some View {
        VStack(alignment: .center) {
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { item in
                    VStack {
                        ForEach(firestoreForTextingMessage.messagesContainer) { textMessage in
                            if textMessage.senderDocID == firestoreForTextingMessage.senderUIDPath.chatDocId {
                                // MARK: Right side

                                TextingViewForSender(message: textMessage)
                                    .id(textMessage.id)
                            } else {
                                // MARK: Left side

                                TextingViewForReceiver(receiveProfileImage: contactMember.contacterProfileImage, message: textMessage)
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
                    ZStack {
                        HStack {
                            // Photo card
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack {
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
                                                        textingViewModel.image.removeAll(where: { $0.id == image.id })
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
                                }
                            }
                            Spacer()
                        }
                        isUploadImage(isUploading: storageForMessageImage.isUploading)
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
                                    try await storageForMessageImage.sendingImageAndMessage(images: textingViewModel.image, chatRoomUID: contactMember.chatRoomUID, senderDocID: firestoreForTextingMessage.senderUIDPath.chatDocId, contactWith: getContactPerson(sender: firestoreForTextingMessage.senderUIDPath.chatDocId), text: textingViewModel.text, senderProfileImage: "")
                                    textingViewModel.image.removeAll()
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
                    .frame(width: uiScreenWidth - 70, height: 45, alignment: .center)
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
                    ShowImage(imageArray: textingViewModel.imageArray, showImageDetail: $textingViewModel.showImageDetail)
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
        .sheet(isPresented: $textingViewModel.showPhpicker, onDismiss: {}, content: {
            PHPickerRepresentable(selectLimit: $selectLimit, images: $textingViewModel.image, video: Binding.constant(nil))
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

    let receiveProfileImage: String

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    var message: MessageContainDataModel

    var body: some View {
        HStack(spacing: 5) {
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
            VStack(spacing: 15) {
                HStack {
                    if !message.text.isEmpty {
                        Text(message.text)
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
                HStack {
                    if let imageArray = message.sendingImage {
                        idenImageArray(imageArray: imageArray)
                            .padding(.leading, 1)
                    }
                    Spacer()
                }
            }
            Spacer()
        }
    }
}

extension TextingViewForReceiver {
    @ViewBuilder
    func idenImageArray(imageArray: [String]) -> some View {
        if imageArray.count > 1 {
            moreThenFour(imageArray: imageArray)
        } else {
            ForEach(imageArray, id: \.self) { image in
                WebImage(url: URL(string: image))
                    .resizable()
                    .scaledToFill()
                    .frame(width: uiScreenWidth / 4 + 50, height: uiScreenHeight / 6 + 20)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .onTapGesture {
                        textingViewModel.showImageDetail = true
                        print(textingViewModel.showImageDetail)
                        textingViewModel.imageArray = imageArray
                    }
            }
        }
    }

    @ViewBuilder
    func moreThenFour(imageArray: [String]) -> some View {
        if imageArray.count >= 5 {
            let arraySlice = imageArray.prefix(4)
            VStack {
                HStack {
                    WaterfallGrid(arraySlice, id: \.self) { image in
                        WebImage(url: URL(string: image))
                            .resizable()
                            .scaledToFill()
                            .frame(width: uiScreenWidth / 5, height: uiScreenHeight / 7 - 50)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .onTapGesture {
                                textingViewModel.showImageDetail = true
                                print(textingViewModel.showImageDetail)
                                textingViewModel.imageArray = imageArray
                            }
                    }
                    .gridStyle(spacing: 5, animation: .easeInOut)
                }
                HStack {
                    Text("+\(adjustArray(imageArray: imageArray).count)")
                        .foregroundColor(.white)
                        .font(.body)
                        .fontWeight(.bold)
                    Spacer()
                }
            }
            .frame(width: uiScreenWidth / 3 + 40, height: uiScreenHeight / 5, alignment: .center)

        } else {
            HStack {
                WaterfallGrid(imageArray, id: \.self) { image in
                    WebImage(url: URL(string: image))
                        .resizable()
                        .scaledToFill()
                        .frame(width: uiScreenWidth / 5, height: uiScreenHeight / 7 - 50)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .onTapGesture {
                            textingViewModel.showImageDetail = true
                            print(textingViewModel.showImageDetail)
                            textingViewModel.imageArray = imageArray
                        }
                }
                .gridStyle(spacing: 5, animation: .easeInOut)
            }
            .frame(width: uiScreenWidth / 3 + 40, height: uiScreenHeight / 5, alignment: .center)
        }
    }

    private func adjustArray(imageArray: [String]) -> [String] {
        var origin = imageArray
        let range = 0 ... 3
        origin.removeSubrange(range)
        print(origin)
        return origin
    }
}

struct TextingViewForSender: View {
    @EnvironmentObject var imgPresenterM: ImagePresentingManager
    @EnvironmentObject var textingViewModel: TextingViewModel
    @Environment(\.colorScheme) var colorScheme

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

    var message: MessageContainDataModel

    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 15) {
                HStack {
                    Spacer()
                    if !message.text.isEmpty {
                        Text(message.text)
                            .foregroundColor(.white)
                            .padding()
                            .background(alignment: .center, content: {
                                Color.black.opacity(0.2)
                                    .cornerRadius(30)
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.green.opacity(colorScheme == .dark ? 0.5 : 0.2), lineWidth: 2)
                            })
                    }
                }
                HStack {
                    Spacer()
                    if let imageArray = message.sendingImage {
                        idenImageArray(imageArray: imageArray)
                            .padding()
                    }
                }
            }
        }
        .padding(.horizontal, 1)
    }
}

extension TextingViewForSender {
    @ViewBuilder
    func idenImageArray(imageArray: [String]) -> some View {
        if imageArray.count > 1 {
            moreThenFour(imageArray: imageArray)
        } else {
            ForEach(imageArray, id: \.self) { image in
                WebImage(url: URL(string: image))
                    .resizable()
                    .scaledToFill()
                    .frame(width: uiScreenWidth / 4 + 50, height: uiScreenHeight / 6 + 20)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .onTapGesture {
                        textingViewModel.showImageDetail = true
                        print(textingViewModel.showImageDetail)
                        textingViewModel.imageArray = imageArray
                    }
            }
        }
    }

    @ViewBuilder
    func moreThenFour(imageArray: [String]) -> some View {
        if imageArray.count >= 5 {
            let arraySlice = imageArray.prefix(4)
            VStack {
                HStack {
                    WaterfallGrid(arraySlice, id: \.self) { image in
                        WebImage(url: URL(string: image))
                            .resizable()
                            .scaledToFill()
                            .frame(width: uiScreenWidth / 5, height: uiScreenHeight / 7 - 50)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .onTapGesture {
                                textingViewModel.showImageDetail = true
                                print(textingViewModel.showImageDetail)
                                textingViewModel.imageArray = imageArray
                            }
                    }
                    .gridStyle(spacing: 5, animation: .easeInOut)
                }
                HStack {
                    Spacer()
                    Text("+\(adjustArray(imageArray: imageArray).count)")
                        .foregroundColor(.white)
                        .font(.body)
                        .fontWeight(.bold)
                }
            }
            .frame(width: uiScreenWidth / 3 + 40, height: uiScreenHeight / 5, alignment: .center)

        } else {
            HStack {
                WaterfallGrid(imageArray, id: \.self) { image in
                    WebImage(url: URL(string: image))
                        .resizable()
                        .scaledToFill()
                        .frame(width: uiScreenWidth / 5, height: uiScreenHeight / 7 - 50)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .onTapGesture {
                            textingViewModel.showImageDetail = true
                            print(textingViewModel.showImageDetail)
                            textingViewModel.imageArray = imageArray
                        }
                }
                .gridStyle(spacing: 5, animation: .easeInOut)
            }
            .frame(width: uiScreenWidth / 3 + 40, height: uiScreenHeight / 5, alignment: .center)
        }
    }

    private func adjustArray(imageArray: [String]) -> [String] {
        var origin = imageArray
        let range = 0 ... 3
        origin.removeSubrange(range)
        print(origin)
        return origin
    }
}

struct ShowImage: View {
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    var imageArray: [String]
    @Binding var showImageDetail: Bool
    var body: some View {
        VStack(alignment: .center, spacing: 22) {
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
            sigleGroupSwitch(imageArray: imageArray)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(alignment: .center) {
            Color.black.opacity(0.85)
                .edgesIgnoringSafeArea([.top, .bottom])
        }
    }
}

extension ShowImage {
    @ViewBuilder
    func sigleGroupSwitch(imageArray: [String]) -> some View {
        if imageArray.count >= 1 {
            TabView {
                ForEach(imageArray, id: \.self) { image in
                    WebImage(url: URL(string: image))
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .frame(width: uiScreenWidth, height: uiScreenHeight / 2 + 240, alignment: .center)
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}

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

    @ViewBuilder
    func isUploadImage(isUploading: Bool) -> some View {
        if isUploading {
            HStack {
                Spacer()
                UploadProgressView()
            }
        }
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification).map { $0.keyboardHeight }
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification).map { _ in CGFloat(0) }
        return MergeMany(willShow, willHide).eraseToAnyPublisher()
    }
}

extension UIResponder {
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    private weak static var _currentFirstResponder: UIResponder?

    @objc private func findFirstResponder(_: Any) {
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
