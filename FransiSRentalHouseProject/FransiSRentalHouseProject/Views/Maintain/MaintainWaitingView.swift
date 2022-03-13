//
//  MaintainWaitingView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 3/9/22.
//

import SwiftUI

struct MaintainWaitingView: View {
    
    
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    
    @State private var showDetail = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("backgroundBrown"))
                .ignoresSafeArea(.all)
            //:~Main View
            VStack {
                TitleAndDivider(title: "Maintian List")
                Spacer()
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(firestoreToFetchRoomsData.fetchRoomInfoFormOwner) { data in
                        MaintainWaitingReusableUnit(showDetail: self.$showDetail, roomAddress: data.roomAddress, roomTown: data.town, roomCity: data.city, roomZipCode: data.zipCode)
                            .padding(.top)
                    }
                }
            }
        }
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
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("fieldGray"))
                .frame(width: uiScreenWidth - 20, height: showDetail ? uiScreenHeight - 300 : uiScreenHeight - 785)
            VStack {
                VStack {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 50))
                            .frame(width: 130, height: 100)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.brown)
                            )
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
                            Text("5")
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
                
            }
            .frame(width: uiScreenWidth - 20, height: showDetail ? uiScreenHeight - 200 : uiScreenHeight - 670)
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
                .frame(width: uiscreenWidth - 50, height: 70, alignment: .center)
            VStack(alignment: .leading) {
                HStack {
                    Text(taskName)
                        .padding(.leading, 25)
                    Text("\(appointmentTime)")
                        .padding(.trailing)
                    Spacer()
                }
            }
        }
    }
}


struct MaitainWaitingView_Previews: PreviewProvider {
    static var previews: some View {
        MaintainWaitingView()
    }
}
