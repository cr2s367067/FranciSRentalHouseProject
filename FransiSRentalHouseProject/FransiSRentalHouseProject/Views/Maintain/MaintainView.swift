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
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var storageForMaintainImage: StorageForMaintainImage
    
    @State var describtion = "Please describe what stuff needs to fix."
    @State var appointment = Date()
    @State var showAlert = false
    @FocusState private var isFocused: Bool
    @State var image = UIImage()
    @State var imagePickerSheet = false
    @State var isSelectedImage = false
    @State var showProgressView = false
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    private func reset() {
        describtion = "Please describe what stuff needs to fix."
        appointment = Date()
        isSelectedImage = false
    }
    
    private func checkRoomStatus(describtion: String, appointmentDate: Date) async throws {
        do {
            try firestoreToFetchUserinfo.checkRoosStatus(roomUID: firestoreToFetchUserinfo.getRoomUID())
            try firestoreToFetchUserinfo.checkMaintainFilled(description: describtion, appointmentDate: appointmentDate)
            showProgressView = true
            _ = try await firestoreToFetchUserinfo.getSummittedContract(uidPath: firebaseAuth.getUID())
            if describtion != "Please describe what stuff needs to fix." && !describtion.isEmpty {
                try await storageForMaintainImage.uploadFixItemImage(uidPath: firestoreToFetchUserinfo.rentingRoomInfo.providerUID ?? "", image: image, roomUID: firestoreToFetchUserinfo.fetchedUserData.rentedRoomInfo?.roomUID ?? "")
                try await firestoreToFetchMaintainTasks.uploadMaintainInfoAsync(uidPath: firestoreToFetchUserinfo.rentingRoomInfo.providerUID ?? "", taskName: describtion, appointmentDate: appointment, docID: firestoreToFetchUserinfo.rentedContract.docID, itemImageURL: storageForMaintainImage.itemImageURL)
                showProgressView = false
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
                VStack(alignment: .center) {
                    Spacer()
                    ScrollView(.vertical, showsIndicators: false) {
                        //: Title Group
                        TitleAndDivider(title: "Fix Something?")
                        VStack(alignment: .center) {
                            VStack(alignment: .center, spacing: 5) {
                                MaintainTitleUnit(title: "Please describe it.")
                                TextEditor(text: $describtion)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .frame(width: uiScreenWidth - 30, height: 200)
                                    .focused($isFocused)
                                    .onTapGesture {
                                        if describtion == "Please describe what stuff needs to fix." {
                                            describtion.removeAll()
                                        }
                                    }
                            }
                            .padding(.horizontal)
                            VStack(alignment: .center, spacing: 5) {
                                graphicalDatePicker()
                            }
                            VStack(spacing: 5) {
                                MaintainTitleUnit(title: "Upload Image")
                                Button {
                                    imagePickerSheet.toggle()
                                } label: {
                                    ZStack(alignment: .center) {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color("fieldGray"))
                                            .frame(width: uiScreenWidth / 2 + 100, height: uiScreenHeight / 4, alignment: .center)
                                        Image(systemName: "plus.square")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                        if isSelectedImage == true {
                                            Image(uiImage: image)
                                                .resizable()
                                                .frame(width: uiScreenWidth / 2 + 100, height: uiScreenHeight / 4, alignment: .center)
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
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
                        .padding()
                    }
                }
                .padding()
                .frame(width: uiScreenWidth - 30, alignment: .center)
                .onTapGesture(perform: {
                    isFocused = false
                })
            }
            .sheet(isPresented: $imagePickerSheet, onDismiss: {
                isSelectedImage = true
            }, content: {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
            })
            .overlay(content: {
                if firestoreToFetchUserinfo.presentUserId().isEmpty {
                    UnregisterCoverView(isShowUserDetailView: $appViewModel.isShowUserDetailView)
                }
                if showProgressView == true {
                    CustomProgressView()
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

extension MaintainView {
    @ViewBuilder
    func graphicalDatePicker() -> some View {
        HStack {
            DatePicker("Appointment", selection: $appointment, in: Date()...)
                .datePickerStyle(CompactDatePickerStyle())
                .font(.system(size: 18))
                .applyTextColor(.white)
            Spacer()
        }
        .frame(width: uiScreenWidth - 30, alignment: .center)
        .padding(.horizontal)
    }
    
    
}


struct MaintainTitleUnit: View {
    var title: String
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .heavy))
            Spacer()
        }
    }
}
