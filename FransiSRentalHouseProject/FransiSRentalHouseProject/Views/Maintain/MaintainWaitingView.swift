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
//                HStack {
//                    Button {
//                        print(firestoreToFetchMaintainTasks.fetchMaintainInfo)
//                    } label: {
//                        Text("result")
//                    }
//                    Button {
//                        firestoreToFetchRoomsData.fetchRoomInfoFormOwner.forEach({ room in
//                            print("rent by: \(room.rentedBy ?? "")")
//                            print("roomUID: \(room.roomUID)")
////                            Task {
////                                do {
////                                    try await firestoreToFetchMaintainTasks.fetchMaintainInfoAsync(uidPath: room.rentedBy ?? "", roomUID: room.roomUID ?? "")
////                                } catch {
////                                    self.errorHandler.handle(error: error)
////                                }
////                            }
//                        })
//                    } label: {
//                        Text("get")
//                    }
//                }
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(firestoreToFetchRoomsData.fetchRoomInfoFormOwner) { data in
                        if data.isRented == true {
                            MaintainWaitingReusableUnit(showDetail: self.$showDetail, roomAddress: data.roomAddress, roomTown: data.town, roomCity: data.city, roomZipCode: data.zipCode, roomUID: data.roomUID, roomImage: data.roomImage ?? "", uidPath: data.rentedBy ?? "")
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
    
    
    @Binding var showDetail: Bool
    
    var roomAddress: String = ""
    var roomTown: String = ""
    var roomCity: String = ""
    var roomZipCode: String = ""
    var renter: String = ""
    var roomUID: String
    var roomImage: String
    var uidPath: String
    
    func address() -> String {
        var tempAddressHolder = ""
        tempAddressHolder = address(roomAddress: roomAddress, roomTown: roomTown, roomCity: roomCity, roomZipCode: roomZipCode)
        return tempAddressHolder
    }
    
    private func address(roomAddress: String, roomTown: String, roomCity: String, roomZipCode: String) -> String {
        return roomZipCode + roomCity + roomTown + roomAddress
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
//                    Button {
//                        increaseByElement(amount: firestoreToFetchMaintainTasks.fetchMaintainInfo.count)
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
                            WebImage(url: URL(string: roomImage))
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
                            Text("\(address())")
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.top, 3)
                        HStack {
                            Text("Waiting Task: ")
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
                                MaintainTaskWaitingListUnit(taskName: task.description, appointmentTime: task.appointmentDate)
                            }
                        }
                    }
                }
//                ((uiScreenHeight / 2 - 190) + (firestoreToFetchMaintainTasks.fetchMaintainInfo.count * 70))
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
                try await firestoreToFetchMaintainTasks.fetchMaintainInfoAsync(uidPath: uidPath, roomUID: roomUID)
            } catch {
                print("error")
            }
        }
    }
}

struct MaintainTaskWaitingListUnit: View {
    
    var taskName: String
    var appointmentTime: Date
    
    let uiscreenWidth = UIScreen.main.bounds.width
    let uiscreedHeight = UIScreen.main.bounds.height
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.5))
                .frame(width: uiscreenWidth - 50, height: 90, alignment: .center)
            VStack(alignment: .leading) {
                VStack {
                    HStack {
                        Text(taskName)
                        Spacer()
                    }
                    HStack{
                        Text("\(appointmentTime)")
                        Spacer()
                    }
                }
            }
            .padding()
        }
    }
}


//struct MaitainWaitingView_Previews: PreviewProvider {
//    static var previews: some View {
//        MaintainWaitingView()
//    }
//}
