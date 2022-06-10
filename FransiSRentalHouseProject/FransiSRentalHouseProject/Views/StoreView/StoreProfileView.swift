//
//  StoreProfileView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct StoreProfileView: View {
    
    @EnvironmentObject var providerProfileViewModel: ProviderProfileViewModel
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var storeProfileVM: StoreProfileViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var storageForProductImage: StorageForProductImage
    @EnvironmentObject var firestoreForTextingMessage: FirestoreForTextingMessage
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    @State private var showPhPicker = false
    @State private var images = [TextingImageDataModel]()
    @State private var showImage = false
    @State private var showProgress = false
    
    @State private var selectLimit = 1
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                storeHeaderView(isCreate: storeProfileVM.isCreated)
            }
            .onTapGesture {
                isFocused = false
            }
        }
        .modifier(ViewBackgroundInitModifier())
        .onAppear {
            storeProfileVM.providerDescription = firestoreForProducts.storeLocalData.providerDescription
        }
        .sheet(isPresented: $showPhPicker) {
            Task {
                do {
                    showProgress = true
                    try await storageForProductImage.uploadAndUpdateStoreImage(uidPath: firebaseAuth.getUID(), images: images, imageID: storageForProductImage.imagUUIDGenerator())
                    _ = try await firestoreForProducts.fetchStoreInLocal(uidPath: firebaseAuth.getUID())
                    showProgress = false
                } catch {
                    self.errorHandler.handle(error: error)
                }
            }
        } content: {
            PHPickerRepresentable(selectLimit: $selectLimit, images: $images, video: Binding.constant(nil))
        }
        .task {
            do {
                storeProfileVM.isCreated = providerProfileViewModel.providerConfig.isCreated
//                _ = try await firestoreForTextingMessage.fetchStoredUserData(uidPath: firebaseAuth.getUID())
                if storeProfileVM.isCreated {
                    _ = try await firestoreForProducts.fetchStoreInLocal(uidPath: firebaseAuth.getUID())
                }
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
}


extension StoreProfileView {
    @ViewBuilder
    func storeHeaderView(isCreate: Bool) -> some View {
        if isCreate {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showPhPicker.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                }
                HStack {
                    ZStack {
                        Image(systemName: "person")
                            .modifier(StoreProfileImageModifier())
                        WebImage(url: URL(string: firestoreForProducts.storeLocalData.providerProfileImage))
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    Spacer()
                }
                HStack {
                    Text(firestoreForProducts.storeLocalData.providerDisplayName)
                        .modifier(StoreTextModifier())
                        .font(.headline)
                    Spacer()
                }
                HStack {
                    Text("Description")
                        .modifier(StoreTextModifier())
                        .font(.headline)
                    Spacer()
                }
                HStack {
                    Text(firestoreForProducts.storeLocalData.providerDescription)
                        .modifier(StoreTextModifier())
                        .font(.body)
                    Spacer()
                }
            }
            .padding(.horizontal)
            .frame(width: uiScreenWidth - 20, height: uiScreenHeight / 5 + 60)
            .background(alignment: .center) {
                WebImage(url: URL(string: firestoreForProducts.storeLocalData.storeBackgroundImage))
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                RoundedRectangle(cornerRadius: 20)
                    .fill(.black.opacity(0.4))
                if showProgress {
                    CustomProgressView()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            
            InfoUnit(title: "Store Description", bindingString: $storeProfileVM.providerDescription)
                .focused($isFocused)
            
            HStack {
                Spacer()
                if storeProfileVM.isUpdate {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                }
                Button {
                    Task {
                        do {
                            try await firestoreForProducts.updateStoreInfo(uidPath: firebaseAuth.getUID(),
                                                                           providerDescription: storeProfileVM.providerDescription)
                            try await firestoreForProducts.updateProfilePic(uidPath: firebaseAuth.getUID(), profileImage: firestoreToFetchUserinfo.fetchedUserData.profileImageURL)
                            _ = try await firestoreForProducts.fetchStoreInLocal(uidPath: firebaseAuth.getUID())
                            storeProfileVM.providerDescription = firestoreForProducts.storeLocalData.providerDescription
                            storeProfileVM.isUpdate = true
                        } catch {
                            self.errorHandler.handle(error: error)
                        }
                    }
                } label: {
                    Text("Summit")
                        .modifier(ButtonModifier())
                }
            }
        } else {
            VStack {
                Text("Let's get start")
                    .modifier(StoreTextModifier())
                Button {
                    Task {
                        do {
                            try await firestoreForProducts.createStore(uidPath: firebaseAuth.getUID(),
                                                                       provideBy: firebaseAuth.getUID(),
                                                                       providerDisplayName: firestoreToFetchUserinfo.fetchedUserData.displayName,
                                                                       providerProfileImage: firestoreToFetchUserinfo.fetchedUserData.profileImageURL,
                                                                       providerDescription: storeProfileVM.providerDescription, storeChatDocID: firestoreForTextingMessage.senderUIDPath.chatDocId)
                            try await providerProfileViewModel.updateCreated(uidPath: firebaseAuth.getUID(), isCreated: true)
                            storeProfileVM.isCreated = true
                        } catch {
                            self.errorHandler.handle(error: error)
                        }
                    }
                } label: {
                    Text("Create")
                        .modifier(ButtonModifier())
                }
            }
        }
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .frame(width: 108, height: 35)
            .background(Color("buttonBlue"))
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}
