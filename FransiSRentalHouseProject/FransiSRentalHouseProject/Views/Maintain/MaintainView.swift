//
//  MaintainView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct MaintainView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchMaintainTasks: FirestoreToFetchMaintainTasks
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var appViewModel: AppViewModel
    
    //:temp
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    
    //    let firebaseAuth = FirebaseAuth()
    
    @State var describtion = "Please describe what stuff needs to fix."
    @State var appointment = Date()
    @State var showAlert = false
    @FocusState private var isFocused: Bool
    
    private func reset() {
        describtion = "Please describe what stuff needs to fix."
        appointment = Date()
    }
    
    private func checkRoomStatus(describtion: String, appointmentDate: Date) async throws {
        do {
            try firestoreToFetchUserinfo.checkRoosStatus(roomUID: firestoreToFetchUserinfo.getRoomUID())
            try firestoreToFetchUserinfo.checkMaintainFilled(description: describtion, appointmentDate: appointmentDate)
            if describtion != "Please describe what stuff needs to fix." && !describtion.isEmpty {
                try await firestoreToFetchMaintainTasks.uploadMaintainInfoAsync(uidPath: firebaseAuth.getUID(), taskName: describtion, appointmentDate: appointment, roomUID: firestoreToFetchUserinfo.getRoomUID())
                showAlert.toggle()
            }
        } catch {
            self.errorHandler.handle(error: error)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea([.top, .bottom])
                VStack {
                    Spacer()
                    ScrollView(.vertical, showsIndicators: false) {
                        //: Title Group
                        VStack(spacing: 1) {
                            HStack {
                                Text("Fix Something?")
                                    .font(.system(size: 24, weight: .heavy))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            HStack {
                                VStack {
                                    Divider()
                                        .background(Color.white)
                                        .frame(width: 400, height: 10)
                                }
                            }
                        }
                        .padding(.leading)
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Please describe it.")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .heavy))
                                TextEditor(text: $describtion)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .frame(width: 360, height: 200)
                                    .focused($isFocused)
                                    .onTapGesture {
                                        if describtion == "Please describe what stuff needs to fix." {
                                            describtion.removeAll()
                                        }
                                    }
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Make an appointment")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .heavy))
                                DatePicker("Appointment Date", selection: $appointment, in: Date()...)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .background(Color.white)
                                    .frame(width: 360)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        }
                        
                        HStack {
                            Spacer()
                            Button {
                                Task {
                                    try await checkRoomStatus(describtion: describtion, appointmentDate: appointment)
                                }
                            } label: {
                                Text("Summit it!")
                                    .foregroundColor(.white)
                                    .frame(width: 108, height: 35)
                                    .background(Color("buttonBlue"))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .alert("Notice", isPresented: $showAlert, actions: {
                                        Button {
                                            reset()
                                        } label: {
                                            Text(describtion != "Please describe what stuff needs to fix." && !describtion.isEmpty ? "Okay!" : "Got it.")
                                        }
                                    }, message: {
                                        describtion != "Please describe what stuff needs to fix." && !describtion.isEmpty ? Text("It's added in our schedule, We will fix it as fast as possible.") : Text("Please fill the blank. Thanks")
                                    })
                            }
                            
                        }
                        .padding(.trailing)
                        .padding(.top, 5)
                    }
                }
                .onTapGesture(perform: {
                    isFocused = false
                })
                //            .background(alignment: .center) {
                //                LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom)
                //                    .edgesIgnoringSafeArea([.top, .bottom])
                //            }
            }
            .overlay(content: {
                if firestoreToFetchUserinfo.presentUserId().isEmpty {
                    UnregisterCoverView(isShowUserDetailView: $appViewModel.isShowUserDetailView)
                }
            })
            .onAppear {
                firestoreToFetchUserinfo.userRentedRoomInfo()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct MaintainView_Previews: PreviewProvider {
    static var previews: some View {
        MaintainView()
    }
}
