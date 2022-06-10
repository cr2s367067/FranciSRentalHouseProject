//
//  ProviderProfileView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI
import SDWebImageSwiftUI


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
    
    @Binding var show: Bool

    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    @State private var isLoading = false
    @State private var image = UIImage()
    @State private var showSheet = false
    
    init(show: Binding<Bool>) {
        self._show = show
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
                                    WebImage(url: URL(string: firestoreToFetchUserinfo.fetchedUserData.profileImageURL))
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
                        Text(firestoreToFetchUserinfo.fetchedUserData.displayName)
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(Color.white)
                        Spacer()
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
                
                if #available(iOS 16, *) {
                    RentalPaymentChartView()
                        .frame(width: uiScreenWidth - 30, height: uiScreenHeight / 3)
                } else {
                    isContainDataInBarChart()
                }
                
                
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
            Task {
                do {
                    isLoading = true
                    try await storageForUserProfile.uploadImageAsync(uidPath: firebaseAuth.getUID(), image: image)
                    try await firestoreToFetchUserinfo.fetchUploadUserDataAsync()
                    isLoading = false
                } catch {
                    self.errorHandler.handle(error: error)
                }
            }
        }, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
        })
        .task {
            do {
                try await paymentReceiveManager.fetchMonthlySettlement(uidPath: firebaseAuth.getUID())
            } catch {
                self.errorHandler.handle(error: error)
            }
        }
    }
}

//struct OwnerProfileDetailUnit: View {
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
//}

extension ProviderProfileView {
    
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
        if editMode == true {
            Button {
                Task {
                    do {
                        try await providerProfileViewModel.updateConfig(uidPath: firebaseAuth.getUID(), settlementDate: providerProfileViewModel.settlementDate)
                        _ = try await providerProfileViewModel.fetchConfigData(uidPath: firebaseAuth.getUID())
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


