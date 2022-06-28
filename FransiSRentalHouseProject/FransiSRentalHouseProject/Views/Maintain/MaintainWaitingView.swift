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
                    taskHolder(hasContain: isRented())
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .overlay(content: {
                if firestoreToFetchUserinfo.userIDisEmpty() {
                    UnregisterCoverView(isShowUserDetailView: $appViewModel.isShowUserDetailView)
                }
            })
        }
    }
}

extension MaintainWaitingView {
    
    private func isRented() -> Bool {
        var temp = false
        firestoreToFetchRoomsData.fetchRoomInfoFormOwner.forEach { data in
            if data.renterUID.isEmpty {
                temp = true
            } else {
                temp = false
            }
        }
        return temp
    }
    
    @ViewBuilder
    func taskHolder(hasContain: Bool) -> some View {
        if hasContain {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(firestoreToFetchRoomsData.fetchRoomInfoFormOwner) { data in
                    if !data.renterUID.isEmpty {
                        NavigationLink {
                            MaintainWaitingDetailView(docID: data.id ?? "")
                        } label: {
                            MaintainWaitingReusableUnit(roomsData: data)
                                .padding(.top)
                        }
                    }
                }
            }
        } else {
            Text("Sorry, room has not rented.😅")
                .foregroundColor(.white)
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
        }
    }
}

struct MaintainWaitingReusableUnit: View {
    
    @EnvironmentObject var firestoreToFetchMaintainTasks: FirestoreToFetchMaintainTasks
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    
    var roomsData: RoomDM
    
    var address: String {
        let city = roomsData.city
        let town = roomsData.town
        let roomAddress = roomsData.address
        return city + town + roomAddress
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
                VStack(alignment: .leading) {
                    HStack {
//                        ZStack {
//                            Image(systemName: "photo")
//                                .font(.system(size: 50))
//                                .frame(width: , height: 100)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .fill(Color.brown)
//                                )
                            WebImage(url: URL(string: roomsData.roomsCoverImageURL))
                                .resizable()
                                .frame(width: uiScreenWidth / 3 + 20, height: uiScreenHeight / 8 + 5)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                        }
                        Spacer()
                            .frame(width: uiScreenWidth - 200)
                    }
                    HStack {
                        Text("Address: ")
                        Text(address)
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                    }
                    .foregroundColor(.black)
                    
                }
//                Spacer()
//                    .frame(height: 5)
//                VStack {
//                    ScrollView(.vertical, showsIndicators: false) {
//                        ForEach(firestoreToFetchMaintainTasks.fetchMaintainInfo) { task in
//                        }
//                    }
//                }
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



