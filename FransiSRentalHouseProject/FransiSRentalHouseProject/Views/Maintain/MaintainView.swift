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
    
    //:temp
        @EnvironmentObject var firebaseAuth: FirebaseAuth
    
//    let firebaseAuth = FirebaseAuth()
    
    @State var describtion = "Please describe what stuff needs to fix."
    @State var appointment = Date()
    @State var showAlert = false
    
    //    let persistenceDM = PersistenceController()
    
    private func reset() {
        describtion = "Please describe what stuff needs to fix."
        appointment = Date()
    }
    
    private func checkRoomStatus() async throws {
        do {
            try firestoreToFetchUserinfo.checkRoosStatus(roomUID: firestoreToFetchUserinfo.getRoomUID())
            if describtion != "Please describe what stuff needs to fix." && !describtion.isEmpty {
                try await firestoreToFetchMaintainTasks.uploadMaintainInfoAsync(uidPath: firebaseAuth.getUID(), taskName: describtion, appointmentDate: appointment, roomUID: firestoreToFetchUserinfo.getRoomUID())
                showAlert.toggle()
            }
        } catch {
            self.errorHandler.handle(error: error)
        }
    }
    
    private func checkFillOut(completion: (()->Void)? = nil) {
        if describtion != "Please describe what stuff needs to fix." && !describtion.isEmpty {
            completion?()
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("backgroundBrown"))
                .ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                Spacer()
                    .frame(height: 2)
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
                                try await checkRoomStatus()
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
            .onAppear {
                firestoreToFetchUserinfo.appendFetchedDataInLocalRentedRoomInfo()
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct MaintainView_Previews: PreviewProvider {
    static var previews: some View {
        MaintainView()
    }
}
