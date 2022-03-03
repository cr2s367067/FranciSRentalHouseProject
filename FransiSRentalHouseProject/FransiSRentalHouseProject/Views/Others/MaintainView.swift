//
//  MaintainView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct MaintainView: View {
    
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    
    let firebaseAuth = FirebaseAuth()
    
    @State var describtion = "Please describe what stuff needs to fix."
    @State var appointment = Date()
    @State var showAlert = false
    
    //    let persistenceDM = PersistenceController()
    
    private func reset() {
        describtion = "Please describe what stuff needs to fix."
        appointment = Date()
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
//                            if describtion != "Please describe what stuff needs to fix." && !describtion.isEmpty {
//                                fetchFirestore.uploadMaintainInfo(uidPath: fetchFirestore.getUID(), taskName: describtion, appointmentDate: appointment)
//                                showAlert.toggle()
//                            } else {
//                                showAlert.toggle()
//                                reset()
//                            }
//                            print("\(showAlert)")
//                            debugPrint(localData.maintainTaskHolder)
//                            debugPrint(fetchFirestore.fetchData)
//                            print("\(localData.localRoomsHolder)")
//                            firestoreToFetchRoomsData.summitRoomInfo(inputRoomData: localData.localRoomsHolder, uidPath: firebaseAuth.getUID())
                            print("\(firestoreToFetchUserinfo.fetchedUserData)")
                        } label: {
                            Text("Summit it!")
                                .foregroundColor(.white)
                                .frame(width: 108, height: 35)
                                .background(Color("buttonBlue"))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("Notice"),
                                          message: describtion != "Please describe what stuff needs to fix." && !describtion.isEmpty ? Text("It's added in our schedule, We will fix it as fast as possible.") : Text("Please fill the blank. Thanks"),
                                          dismissButton: .default(
                                            describtion != "Please describe what stuff needs to fix." && !describtion.isEmpty ? Text("Okay!") : Text("Got it.")
                                          ))
                                }
                                
                        }
                        
                    }
                    .padding(.trailing)
                    .padding(.top, 5)
                }
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
