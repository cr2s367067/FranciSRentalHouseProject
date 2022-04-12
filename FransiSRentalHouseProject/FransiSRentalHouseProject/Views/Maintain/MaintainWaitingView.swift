//
//  MaintainWaitingView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/9/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct MaintainWaitingView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreToFetchMaintainTasks: FirestoreToFetchMaintainTasks
    
    @State private var showDetail = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea(.all)
            //:~Main View
            VStack {
                TitleAndDivider(title: "Maintian List")
                Spacer()
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(firestoreToFetchRoomsData.fetchRoomInfoFormOwner) { data in
                        if data.isRented == true {
                            MaintainWaitingReusableUnit(showDetail: self.$showDetail, roomsData: data)
                                .padding(.top)
                        }
                    }
                }
            }
        }
        .overlay(content: {
            if firestoreToFetchUserinfo.presentUserId().isEmpty {
                UnregisterCoverView(isShowUserDetailView: $appViewModel.isShowUserDetailView)
            }
        })
    }
}

struct MaintainWaitingReusableUnit: View {
    
    @EnvironmentObject var firestoreToFetchMaintainTasks: FirestoreToFetchMaintainTasks
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    
    
    @Binding var showDetail: Bool
    
    var roomsData: RoomInfoDataModel
    
    var address: String {
        let zipCode = roomsData.zipCode
        let city = roomsData.city
        let town = roomsData.town
        let roomAddress = roomsData.roomAddress
        return zipCode + city + town + roomAddress
    }
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    private func increaseByElement(amount: Int) -> CGFloat {
        let result = amount * 90
        return CGFloat(630 - result)
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                VStack {
                    HStack {
                        ZStack {
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                                .frame(width: 130, height: 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.brown)
                                )
                            WebImage(url: URL(string: roomsData.roomImage ?? ""))
                                .resizable()
                                .frame(width: 130, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Spacer()
                            .frame(width: uiScreenWidth - 200)
                    }
                    VStack(spacing: 3) {
                        HStack {
                            Text("Address: ")
                            Text(address)
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.top, 3)
                        HStack {
                            Text("Tasks: ")
                            Text("\(firestoreToFetchMaintainTasks.fetchMaintainInfo.count)")
                            Spacer()
                        }
                        .padding(.leading)
                    }
                    HStack {
                        Spacer()
                            .frame(width: uiScreenWidth - 50)
                        Button {
                            withAnimation {
                                showDetail.toggle()
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .foregroundColor(Color("buttonBlue"))
                                .frame(width: 25, height: 25, alignment: .trailing)
                                .rotationEffect(showDetail ? .degrees(45) : .degrees(0))
                        }
                    }
                    .padding(.trailing)
                }
                Spacer()
                    .frame(height: 30)
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(firestoreToFetchMaintainTasks.fetchMaintainInfo) { task in
                            if showDetail {
                                MaintainTaskWaitingListUnit(maintainTask: task, roomUID: roomsData.roomUID)
                            }
                        }
                    }
                }
            }
            .padding()
            .frame(width: uiScreenWidth - 20, height: showDetail ? uiScreenHeight - increaseByElement(amount: firestoreToFetchMaintainTasks.fetchMaintainInfo.count) : uiScreenHeight / 4 - 50)
            .background(alignment: .center, content: {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("fieldGray"))
            })
        }
        .task {
            do {
                try await firestoreToFetchMaintainTasks.fetchMaintainInfoAsync(uidPath: firebaseAuth.getUID(), roomUID: roomsData.roomUID)
            } catch {
                print("error")
            }
        }
    }
}

struct MaintainTaskWaitingListUnit: View {
    
    @EnvironmentObject var firestoreToFetchMaintainTasks: FirestoreToFetchMaintainTasks
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    
    var maintainTask: MaintainTaskHolder
    var roomUID: String
    
    let uiscreenWidth = UIScreen.main.bounds.width
    let uiscreedHeight = UIScreen.main.bounds.height
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.5))
                .frame(width: uiscreenWidth - 50, height: 90, alignment: .center)
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        HStack {
                            Text(maintainTask.description)
                            Spacer()
                        }
                        HStack{
                            Text(maintainTask.appointmentDate, format: Date.FormatStyle().year().month().day())
                            Spacer()
                        }
                    }
                    Button {
                        Task {
                            do {
                                try await firestoreToFetchMaintainTasks.updateFixedInfo(uidPath: firebaseAuth.getUID(), roomUID: roomUID, maintainDocID: maintainTask.id ?? "")
                                try await firestoreToFetchMaintainTasks.fetchMaintainInfoAsync(uidPath: firebaseAuth.getUID(), roomUID: roomUID)
                            } catch {
                                print("error")
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: maintainTask.isFixed ? "checkmark.circle.fill" : "x.circle.fill")
                                .foregroundColor(maintainTask.isFixed ? .green : .red)
                            Text("Fixed")
                        }
                    }
                }
            }
            .padding()
        }
    }
}



