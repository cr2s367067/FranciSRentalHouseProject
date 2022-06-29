//
//  ProviderStoreSetUpView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/28.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProviderStoreSetUpView: View {
    @EnvironmentObject var firestoreUser: FirestoreToFetchUserinfo
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var providerStoreM: ProviderStoreM
    @EnvironmentObject var signUpVM: SignUpVM
    @EnvironmentObject var providerStoreSetupVM: ProviderStoreSetUpVM
    @EnvironmentObject var storageForProductImage: StorageForProductImage
    
    //MARK: - Store edit config
    @State private var showPhPicker = false
    @State private var selectLimit = 1
    @State private var images = [TextingImageDataModel]()
    @State private var showImage = false
    @State private var showProgress = false
    @FocusState private var isFocus: Bool
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var storeData: ProviderStore
    var providerConfig: ProviderDM
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
//                TitleSection(
//                    storeData: storeData,
//                    providerConfig: providerConfig
//                )
//                InfoUnit(title: "GUI", bindingString: $providerStoreSetupVM.storeInfo.gui)
                editStoreHeader()
                InfoUnit(title: "Company Name", bindingString: $providerStoreSetupVM.providerInfo.companyName)
                InfoUnit(title: "Charge Name", bindingString: $providerStoreSetupVM.providerInfo.chargeName)
                InfoUnit(title: "City", bindingString: $providerStoreSetupVM.providerInfo.city)
                InfoUnit(title: "Town", bindingString: $providerStoreSetupVM.providerInfo.town)
                InfoUnit(title: "Address", bindingString: $providerStoreSetupVM.providerInfo.address)
                InfoUnit(title: "Company E-mail", bindingString: $providerStoreSetupVM.providerInfo.email)
                doneButton()
                Spacer()
            }
        }
        .modifier(ViewBackgroundInitModifier())
        .onAppear {
            providerStoreSetupVM.providerInfo = firestoreUser.providerInfo
        }
        .sheet(isPresented: $showPhPicker) {
            print(images)
//            Task {
//                do {
//                    showProgress = true
//                    try await storageForProductImage.uploadAndUpdateStoreImage(
//                        gui: providerStoreSetupVM.providerInfo.gui,
//                        images: images,
//                        imageID: storageForProductImage.imagUUIDGenerator()
//                    )
//                    _ = try await providerStoreM.fetchStore(provider: firebaseAuth.getUID())
//                    showProgress = false
//                } catch {
//                    self.errorHandler.handle(error: error)
//                }
//            }
        } content: {
            PHPickerRepresentable(selectLimit: $selectLimit, images: $images, video: Binding.constant(nil))
        }
    }
}

//struct ProviderStoreSetUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProviderStoreSetUpView()
//    }
//}


extension ProviderStoreSetUpView {
    @ViewBuilder
    func doneButton() -> some View {
        HStack {
            Spacer()
            Button {
                Task {
                    do {
                        try await providerStoreM.updateStoreInfo(
                            gui: firestoreUser.providerInfo.gui,
                            store: .updateStore(
                                created: .createStore,
                                companyName: providerStoreSetupVM.providerInfo.companyName,
                                storeDes: providerStoreSetupVM.storeInfo.storeDescription
                            )
                        )
                        try await firestoreUser.updateProviderData(
                            user: firebaseAuth.getUID(),
                            provider: providerStoreSetupVM.providerInfo
                        )
                        try await storageForProductImage.uploadAndUpdateStoreImage(
                            gui: providerStoreSetupVM.providerInfo.gui,
                            images: images,
                            imageID: storageForProductImage.imagUUIDGenerator()
                        )
                        firebaseAuth.signUp = true
                    } catch {
                        self.errorHandler.handle(error: error)
                    }
                }
            } label: {
                Text("Done")
                    .modifier(ButtonModifier())
            }
        }
    }
    
    @ViewBuilder
    func editStoreHeader() -> some View {
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
                    WebImage(url: URL(string: providerStoreSetupVM.providerInfo.companyProfileImageURL))
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Spacer()
            }
            HStack {
                Text(providerStoreSetupVM.storeInfo.companyName)
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
                Text(providerStoreM.storesData.storeDescription)
                    .modifier(StoreTextModifier())
                    .font(.body)
                Spacer()
            }
        }
        .padding(.horizontal)
        .frame(width: uiScreenWidth - 20, height: uiScreenHeight / 5 + 60)
        .background(alignment: .center) {
//            WebImage(url: URL(string: providerStoreSetupVM.storeInfo.storeBackgroundImage))
            Image(uiImage: backgroundImage(images: images))
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 20))
            RoundedRectangle(cornerRadius: 20)
                .fill(.black.opacity(0.4))
            if showProgress {
                CustomProgressView()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }

        InfoUnit(title: "Store Description", bindingString: $providerStoreSetupVM.storeInfo.storeDescription)
            .focused($isFocus)

    }
    
    func backgroundImage(images: [TextingImageDataModel]) -> UIImage {
        var temp = UIImage()
        for image in images {
            temp = image.image
        }
        return temp
    }
    
}
