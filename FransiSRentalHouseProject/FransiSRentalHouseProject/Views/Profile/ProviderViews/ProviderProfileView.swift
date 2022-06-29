//
//  ProviderProfileView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SDWebImageSwiftUI
import SwiftUI

struct ProviderProfileView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var paymentReceiveManager: PaymentReceiveManager
    @EnvironmentObject var providerProfileViewModel: ProviderProfileViewModel
    @EnvironmentObject var storageForUserProfile: StorageForUserProfile
    @EnvironmentObject var soldProductCollectionM: SoldProductCollectionManager
    @EnvironmentObject var providerStoreM: ProviderStoreM
    
    @Binding var show: Bool
    
    @State private var selectLimit = 1

    let uiScreenWidth = UIScreen.main.bounds.width
    @State private var isLoading = false
    @State private var image = [TextingImageDataModel]()
    @State private var showSheet = false
    @State private var isEditing = false

    init(show: Binding<Bool>) {
        _show = show
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            self.show.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .accessibilityIdentifier("menuButton")
                    Spacer()
                }
                .foregroundColor(.white)
                .padding()
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Button {
                            showSheet.toggle()
                        } label: {
                            ZStack {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color.white.opacity(0.6))
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .scaledToFit()
                                if firebaseAuth.auth.currentUser != nil {
                                    WebImage(url: URL(string: providerStoreM.storesData.companyProfileImage))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 45, height: 45)
                                        .clipShape(Circle())
                                        .scaledToFit()
                                }
                                if isEditing {
                                    Image(uiImage: backgroundImage(images: image))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 45, height: 45)
                                        .clipShape(Circle())
                                        .scaledToFit()
                                }
                                if isLoading == true {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .frame(width: 30, height: 30)
                                        .background(Color.black.opacity(0.4))
                                        .clipShape(Circle())
                                }
                            }
                        }
                        Text(firestoreToFetchUserinfo.fetchedUserData.nickName)
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(Color.white)
                        Spacer()
                        if isEditing {
                            Button {
                                profileImageUploading()
                            } label: {
                                 Text("Upload")
                                    .modifier(ButtonModifier())
                            }
                        }
                    }
                    HStack {
                        VStack {
                            Divider()
                                .background(Color.white)
                        }
                    }
                }
                .frame(width: uiScreenWidth - 25)
                HStack(spacing: 20) {
                    Spacer()
                    Image(systemName: "chart.bar.xaxis")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
//                    Image(systemName: "chart.xyaxis.line")
//                        .resizable()
//                        .foregroundColor(.white)
//                        .frame(width: 25, height: 25)
                }
                .padding(.trailing)
                isContainDataInBarChart()
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            providerProfileViewModel.editMode.toggle()
                        } label: {
                            Image(systemName: "gearshape.circle")
                                .foregroundColor(.white)
                                .font(.system(size: 30, weight: .semibold))
                        }
                    }
                    SettlementUnitView(date: $providerProfileViewModel.settlementDate, editMode: $providerProfileViewModel.editMode)
                    editModeSummitButton(editMode: providerProfileViewModel.editMode)
                }
                .padding()
                Spacer()
            }
        }
        .background(alignment: .center, content: {
            Group {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
            }
            .edgesIgnoringSafeArea([.top, .bottom])
        })
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showSheet, onDismiss: {
            print("test set: \(image)")
          isEditing = true
        }, content: {
//            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
            PHPickerRepresentable(selectLimit: $selectLimit, images: $image, video: Binding.constant(nil))
        })
        .task {
            do {
                if providerStoreM.storesData.isSetConfig {
                    try await paymentReceiveManager.fetchMonthlySettlement(uidPath: firebaseAuth.getUID())
                }
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
}

// struct OwnerProfileDetailUnit: View {
//    var body: some View {
//        HStack {
//            Text("Rental Price")
//            Spacer()
//            Text("$9,000")
//        }
//        .foregroundColor(.white)
//        .frame(width: 350)
//        .padding()
//    }
// }

extension ProviderProfileView {
    
    func backgroundImage(images: [TextingImageDataModel]) -> UIImage {
        var temp = UIImage()
        for image in images {
            temp = image.image
        }
        return temp
    }
    
    private func profileImageUploading() {
        Task {
            do {
                isLoading = true
                try await storageForUserProfile.providerStoreImage(
                    gui: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? "",
                    images: image
                )
                try await providerStoreM.fetchStore(provider: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? "")
                isLoading = false
                isEditing = false
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
    
    @ViewBuilder
    func isContainDataInBarChart() -> some View {
        if providerProfileViewModel.providerConfig.isCreatedMonthlySettlementData {
            ProviderBarChartView()
        } else {
            PlaceHolderView()
        }
    }

    @ViewBuilder
    func editModeSummitButton(editMode: Bool) -> some View {
        if editMode {
            Button {
                Task {
                    do {
                        try await providerProfileViewModel.updateConfig(
                            gui: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? "",
                            settlementDate: providerProfileViewModel.settlementDate
                        )
                        try await providerStoreM.fetchStore(provider: firestoreToFetchUserinfo.fetchedUserData.providerGUI ?? "")
                        providerProfileViewModel.editMode = false
                    } catch {
                        self.errorHandler.handle(error: error)
                    }
                }
            } label: {
                Text("Update")
                    .foregroundColor(.white)
                    .frame(width: 108, height: 35)
                    .background(Color("buttonBlue"))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }
}
