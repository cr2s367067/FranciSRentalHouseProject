//
//  RenterProfileView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/14/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct RenterProfileView: View {

    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var storageForUserProfile: StorageForUserProfile
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreToFetchMaintainTasks: FirestoreToFetchMaintainTasks
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var show: Bool
    @State private var image = UIImage()
    @State private var showSheet = false
    @State private var isLoading = false
    init(show: Binding<Bool>) {
        self._show = show
    }
    
    func lastPaymentDate(input: [PaymentHistoryDataModel]) -> Date {
        let lastDate = input.map({$0.paymentDate}).last
        return (lastDate ?? Date()) 
    }
    
    func lastPayment(input: [PaymentHistoryDataModel]) -> String {
        let payment = input.map({$0.pastPaymentFee}).last
        return (payment ?? "") 
    }
    
    var body: some View {
        ZStack {
            //: Tool bar
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            self.show.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.leading)
                .padding(.top)
                Spacer()
                ZStack {
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                            .frame(height: UIScreen.main.bounds.height / 2 + 195)
                            .cornerRadius(30, corners: [.topLeft, .topRight])
                    }
                    VStack {
                        HStack {
                            //: Profile Image
                            ZStack(alignment: .center) {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 130, height: 130)
                                    .clipped()
                                Button {
                                    showSheet.toggle()
                                } label: {
                                    ZStack {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(Color.gray.opacity(0.6))
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle())
                                            .scaledToFit()
                                        if firebaseAuth.auth.currentUser != nil {
                                            WebImage(url: URL(string: firestoreToFetchUserinfo.fetchedUserData.profileImageURL))
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 120, height: 120)
                                                .clipShape(Circle())
                                                .scaledToFit()
                                        }
                                        if isLoading == true {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                                .frame(width: 120, height: 120)
                                                .background(Color.black.opacity(0.4))
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                            }
                            Text("\(firestoreToFetchUserinfo.fetchedUserData.displayName)")
                                .foregroundColor(.white)
                                .font(.system(size: 30, weight: .heavy))
                                .padding(.leading, 20)
                        }
                        .padding()
                        VStack(spacing: 30) {
                            ScrollView(.vertical, showsIndicators: false) {
                                roomStatusSessionWithPlaceHolder()
//                                lastPaymentSessionWithPlaceholder()
                                maintainSessionWithPlaceHolder()
                            }
                        }
                    }
                }
            }
        }
        .background(alignment: .center, content: {
            VStack {
                Group {
                    Image("backgroundImage")
                        .resizable()
                        .blur(radius: 10)
                        .clipped()
                    Rectangle()
                        .fill(colorScheme == .dark ? .black : .white.opacity(0.5))
                        .blendMode(.multiply)
                }
                .edgesIgnoringSafeArea(.top)
                Color("background2")
                    .edgesIgnoringSafeArea(.bottom)
            }
        })
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
        }) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            firestoreToFetchUserinfo.userRentedRoomInfo()
        }
        .task({
            do {
                guard !(firestoreToFetchUserinfo.fetchedUserData.rentedRoomInfo?.roomUID?.isEmpty ?? false) else { return }
                _ = try await firestoreToFetchUserinfo.getSummittedContract(uidPath: firebaseAuth.getUID())
                //MARK: Fetch uploaded maintain tasks
                if !firestoreToFetchUserinfo.rentedContract.docID.isEmpty {
                    try await firestoreToFetchMaintainTasks.fetchMaintainInfoAsync(uidPath: firestoreToFetchUserinfo.rentingRoomInfo.providerUID ?? "", docID: firestoreToFetchUserinfo.rentedContract.docID)
                }
//                try await firestoreToFetchUserinfo.fetchPaymentHistory(uidPath: firebaseAuth.getUID())
            } catch {
                self.errorHandler.handle(error: error)
            }
        })
    }
}


extension RenterProfileView {
    
    @ViewBuilder
    private func roomStatusSession() -> some View {
        let uiScreenWidth = UIScreen.main.bounds.width
        let uiScreenHeight = UIScreen.main.bounds.height
            VStack {
                HStack {
                    Text("Room Status: ")
                        .font(.system(size: 20, weight: .heavy))
                        .unredacted()
                    Spacer()
                    NavigationLink {
                        RentalBillSettingView()
                    } label: {
                        Image(systemName: "chevron.forward")
                            .unredacted()
                    }
                }
                //.padding(.leading, 5)
                HStack {
                    Text("Expired Date")
                        .font(.system(size: 20, weight: .heavy))
                        .unredacted()
                    Spacer()
                        .frame(width: 100)
                    //MARK: Add the expired date in data model
                    Text(firestoreToFetchUserinfo.rentedContract.rentalEndDate, format: Date.FormatStyle().year().month().day())
                        .font(.system(size: 15, weight: .heavy))
                }
                .padding(.top, 5)
                Spacer()
                    .frame(height: 40)
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical)
            .frame(width: uiScreenWidth - 50, height: uiScreenHeight / 6, alignment: .center)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("sessionBackground"))
                    .cornerRadius(4)
            }
    }
    
    @ViewBuilder
    func roomStatusSessionWithPlaceHolder() -> some View {
        if !(firestoreToFetchUserinfo.fetchedUserData.rentedRoomInfo?.roomUID?.isEmpty ?? true) {
            roomStatusSession()
        } else {
            roomStatusSession()
                .disabled(true)
                .redacted(reason: .placeholder)
        }
    }
    
    @ViewBuilder
    private func lastPaymentSession() -> some View {
        let uiScreenWidth = UIScreen.main.bounds.width
        let uiScreenHeight = UIScreen.main.bounds.height
        //: Payment Session
        VStack {
            HStack {
                Text("Last Payment: ")
                    .font(.system(size: 20, weight: .heavy))
                    .unredacted()
                Spacer()
                NavigationLink {
                    PaymentDetailView()
                } label: {
                    Image(systemName: "chevron.forward")
                        .unredacted()
                }
            }
            //.padding(.leading, 5)
            HStack {
                Text("$\(lastPayment(input: firestoreToFetchUserinfo.paymentHistory)) ")
                    .font(.system(size: 20, weight: .heavy))
                Spacer()
                    .frame(width: 80)
                Text("\(lastPaymentDate(input: firestoreToFetchUserinfo.paymentHistory), format: Date.FormatStyle().year().month().day())")
                    .font(.system(size: 15, weight: .heavy))
            }
            .padding()
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.horizontal)
        .padding(.vertical)
        .frame(width: uiScreenWidth - 50, height: uiScreenHeight / 6)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("sessionBackground"))
                .cornerRadius(4)
        }
    }
    
    @ViewBuilder
    func lastPaymentSessionWithPlaceholder() -> some View {
        if !firestoreToFetchUserinfo.paymentHistory.isEmpty {
            lastPaymentSession()
        } else {
            lastPaymentSession()
                .disabled(true)
                .redacted(reason: .placeholder)
        }
    }
    
    @ViewBuilder
    private func maintainListSession() -> some View {
        let uiScreenWidth = UIScreen.main.bounds.width
        let uiScreenHeight = UIScreen.main.bounds.height
        VStack(alignment: .center) {
            HStack {
                Text("Maintain List: ")
                    .font(.system(size: 20, weight: .heavy))
                    .unredacted()
                Spacer()
            }
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(firestoreToFetchMaintainTasks.fetchMaintainInfo) { task in
                        ProfileSessionUnit(mainTainTask: task)
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical)
        .foregroundColor(.white)
        .frame(width: uiScreenWidth - 50, height: uiScreenHeight / 3)
        .background(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("sessionBackground"))
                .cornerRadius(4)
        }
    }
    
    @ViewBuilder
    func maintainSessionWithPlaceHolder() -> some View {
        if firestoreToFetchMaintainTasks.fetchMaintainInfo.isEmpty {
            maintainListSession()
                .redacted(reason: .placeholder)
        } else {
            maintainListSession()
                
        }
    }
    
}


class RenterProfileViewModel: ObservableObject {
    
    let firestoreToFetchUserinfo = FirestoreToFetchUserinfo()
    let firestoreToFetchRoomsData = FirestoreToFetchRoomsData()
    let firebaseAuth = FirebaseAuth()
    
    @Published var readyToRenew = false
    @Published var stopToShowThisMessage = false
    @Published var noticeAlert = false
    @Published var noticeMessage = ""
    
    func isRenewable(from fromDate: Date, to endDate: Date) {
        let calendar = Calendar.current
        let fromDateInDateCom = calendar.dateComponents([.year, .month, .day], from: fromDate)
        let endDateInDateCom = calendar.dateComponents([.year, .month, .day], from: endDate)
        let diff = calendar.dateComponents([.year, .month, .day], from: fromDateInDateCom, to: endDateInDateCom)
        let renewNoticePeriod = DateComponents(year: 0, month: 1, day: 0)
        
        if diff.year ?? 0 > renewNoticePeriod.year ?? 0 || diff.month ?? 0 > renewNoticePeriod.month ?? 0 || diff.day ?? 0 > renewNoticePeriod.day ?? 0 {
            noticeMessage = "Sorry, you have to wait until least one month."
        } else if diff.month ?? 0 <= renewNoticePeriod.month ?? 0 || diff.day ?? 0 <= renewNoticePeriod.day ?? 0 {
            noticeMessage = "Hi, just notice you, your room is expred soon."
        }
        
        
    }
    
    func eraseExpiredRoomInfo(from fromDate: Date, to endDate: Date, docID: String) async throws {
        let calendar = Calendar.current
        let fromDateInDateCom = calendar.dateComponents([.year, .month, .day], from: fromDate)
        let endDateInDateCom = calendar.dateComponents([.year, .month, .day], from: endDate)
        let diff = calendar.dateComponents([.month, .day], from: fromDateInDateCom, to: endDateInDateCom)
        let expiredDate = DateComponents(month: 0, day: 30)
        //Push notification for user to let them know the rental is expired
        //and delete the old version contract or renew new contract
        if diff == expiredDate {
            try? await firestoreToFetchRoomsData.expiredRoom(uidPath: firebaseAuth.getUID(), docID: docID)
            try? await firestoreToFetchUserinfo.clearExpiredContract(uidPath: firebaseAuth.getUID())
        }
    }
}
