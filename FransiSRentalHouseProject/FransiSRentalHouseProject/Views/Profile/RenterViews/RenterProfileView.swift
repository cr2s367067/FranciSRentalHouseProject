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
    
    @Binding var show: Bool
    @State private var image = UIImage()
    @State private var showSheet = false
    
    init(show: Binding<Bool>) {
        self._show = show
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
                            .frame(height: UIScreen.main.bounds.height / 2 + 167)
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
                                    //                                            print("\(fetchFirestore.fetchMaintainInfo)")
                                    
                                } label: {
                                    if storageForUserProfile.isSummitImage == false {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(Color.gray.opacity(0.6))
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle())
                                            .scaledToFit()
                                    } else if storageForUserProfile.isSummitImage == true {
                                        if firebaseAuth.auth.currentUser != nil {
                                            WebImage(url: URL(string: storageForUserProfile.representedProfileImageURL))
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 120, height: 120)
                                                .clipShape(Circle())
                                                .scaledToFit()
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
                        VStack {
                            ScrollView(.vertical, showsIndicators: false) {
                                //: Room Status Session
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color("sessionBackground"))
                                        .cornerRadius(4)
                                        .frame(width: 378, height: 123)
                                    VStack {
                                        HStack {
                                            Text("Room Status: ")
                                                .font(.system(size: 20, weight: .heavy))
                                            Spacer()
                                                .frame(width: 218)
                                            NavigationLink {
                                                RoomStatusView()
                                            } label: {
                                                Image(systemName: "chevron.forward")
                                            }
                                        }
                                        //.padding(.leading, 5)
                                        HStack {
                                            Text("Expired Day")
                                                .font(.system(size: 20, weight: .heavy))
                                            Spacer()
                                                .frame(width: 100)
                                            Text("1/15/2023")
                                                .font(.system(size: 15, weight: .heavy))
                                        }
                                        .padding(.top, 5)
                                        Spacer()
                                            .frame(height: 40)
                                    }
                                    .foregroundColor(.white)
                                    .padding(.leading, 2)
                                    .padding(.top, 3)
                                }
                                //: Payment Session
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color("sessionBackground"))
                                        .cornerRadius(4)
                                        .frame(width: 378, height: 123)
                                    VStack {
                                        HStack {
                                            Text("Last Payment: ")
                                                .font(.system(size: 20, weight: .heavy))
                                            Spacer()
                                                .frame(width: 210)
                                            NavigationLink {
                                                PaymentDetailView()
                                            } label: {
                                                Image(systemName: "chevron.forward")
                                            }
                                        }
                                        //.padding(.leading, 5)
                                        HStack {
                                            Text("$9000 ")
                                                .font(.system(size: 20, weight: .heavy))
                                            Spacer()
                                                .frame(width: 100)
                                            Text("2/15/2023")
                                                .font(.system(size: 15, weight: .heavy))
                                        }
                                        .padding(.top, 5)
                                        Spacer()
                                            .frame(height: 40)
                                    }
                                    .foregroundColor(.white)
                                    .padding(.leading, 2)
                                    .padding(.top, 3)
                                }
                                .padding(.top, 10)
                                //: Maintain Session
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color("sessionBackground"))
                                        .cornerRadius(4)
                                        .frame(width: 378, height: localData.maintainTaskHolder.count > 3 ? 83 + CGFloat(localData.maintainTaskHolder.count * 60) : 263)
                                    VStack {
                                        HStack {
                                            Text("Maintain List: ")
                                                .font(.system(size: 20, weight: .heavy))
                                            Spacer()
                                                .frame(width: 225)
                                            //                                                    NavigationLink {
                                            //                                                        MaintainDetailView()
                                            //                                                    } label: {
                                            //                                                        Image(systemName: "chevron.forward")
                                            //                                                    }
                                        }
                                        VStack {
                                            ScrollView(.vertical, showsIndicators: false) {
                                                ForEach(firestoreToFetchMaintainTasks.fetchMaintainInfo) { task in
                                                    ProfileSessionUnit(mainTainTask: task.description)
                                                }
                                            }
                                        }
                                        Spacer()
                                            .frame(height: 40)
                                    }
                                    .foregroundColor(.white)
                                    .padding(.leading, 2)
                                    .padding(.top, 3)
                                }
                                .padding(.top, 10)
                            }
                        }
                    }
                }
            }
        }
        .background(alignment: .center, content: {
            Group {
                Image("backgroundImage")
                    .resizable()
                    .blur(radius: 10)
                    .clipped()
                Rectangle()
                    .fill(.white.opacity(0.5))
                    .blendMode(.multiply)
            }
            .edgesIgnoringSafeArea([.top, .bottom])
        })
        .sheet(isPresented: $showSheet, onDismiss: {
            Task {
                do {
                    if !image.isSymbolImage {
                        try await storageForUserProfile.uploadImageAsync(uidPath: firebaseAuth.getUID(), image: image)
                    }
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
        .task({
            do {
//                if firestoreToFetchMaintainTasks.fetchMaintainInfo.isEmpty {
//                    try await firestoreToFetchMaintainTasks.fetchMaintainInfoAsync(uidPath: firebaseAuth.getUID(), roomUID: "")
//                }
                try? await storageForUserProfile.representedProfileImageURL = storageForUserProfile.representStorageImageAsync(uidPath: firebaseAuth.getUID())
            } catch {
                self.errorHandler.handle(error: error)
            }
        })
    }
}
