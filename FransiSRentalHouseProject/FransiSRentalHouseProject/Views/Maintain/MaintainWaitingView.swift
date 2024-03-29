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
    
    var body: some View {
        NavigationView {
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
                                NavigationLink {
                                    MaintainWaitingDetailView(docID: data.id ?? "")
                                } label: {
                                    MaintainWaitingReusableUnit(roomsData: data)
                                        .padding(.top)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .overlay(content: {
                if firestoreToFetchUserinfo.presentUserId().isEmpty {
                    UnregisterCoverView(isShowUserDetailView: $appViewModel.isShowUserDetailView)
                }
            })
        }
    }
}

struct MaintainWaitingReusableUnit: View {
    
    @EnvironmentObject var firestoreToFetchMaintainTasks: FirestoreToFetchMaintainTasks
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    
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
    
    var taskAmount: Int {
        firestoreToFetchMaintainTasks.fetchMaintainInfo.count
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                VStack {
//                    Button {
//                        Task {
//                            do {
//                                try await firestoreToFetchMaintainTasks.fetchMaintainInfoAsync(uidPath: firebaseAuth.getUID(), docID: roomsData.id ?? "")
//                            } catch {
//                                print("error")
//                            }
//                        }
//                        print(firestoreToFetchMaintainTasks.fetchMaintainInfo)
//                    } label: {
//                        Text("test")
//                    }
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
                            Image(systemName: "chevron.forward")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                        }
                        .foregroundColor(.black)
                        .padding(.leading)
                        .padding(.top, 3)
//                        HStack {
//                            Text("Tasks: ")
//
//                            Text("\(firestoreToFetchMaintainTasks.fetchMaintainInfo.count)")
//                            Spacer()
//                        }
//                        .padding(.leading)
                    }
//                    HStack {
//                        Spacer()
//                            .frame(width: uiScreenWidth - 50)
//                        Button {
//                            withAnimation {
//                                showDetail.toggle()
//                            }
//                        } label: {
//                            Image(systemName: "plus.circle.fill")
//                                .resizable()
//                                .foregroundColor(Color("buttonBlue"))
//                                .frame(width: 25, height: 25, alignment: .trailing)
//                                .rotationEffect(showDetail ? .degrees(45) : .degrees(0))
//                        }
//                    }
//                    .padding(.trailing)
                }
                Spacer()
                    .frame(height: 30)
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(firestoreToFetchMaintainTasks.fetchMaintainInfo) { task in
                        }
                    }
                }
            }
            .padding()
            .frame(width: uiScreenWidth - 20, height: uiScreenHeight / 4 - 50)
            .background(alignment: .center, content: {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("fieldGray"))
            })
        }
        
    }
}



