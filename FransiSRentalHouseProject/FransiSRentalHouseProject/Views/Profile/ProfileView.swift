//
//  ProfileView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var storageForUserProfile: StorageForUserProfile
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firestoreToFetchMaintainTasks: FirestoreToFetchMaintainTasks
    
    
    //    let firebaseStorageDM = FirebaseStorageManager()
    //    let persistenceDM = PersistenceController()
    
    @State private var show = false
    @State private var image = UIImage()
    @State private var showSheet = false
    //    @State var isSummitImage = false
    
    var body: some View {
        NavigationView {
            SideMenuBar(sidebarWidth: 180, showSidebar: $show) {
                /*
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color("menuBackground"))
                        .edgesIgnoringSafeArea([.top, .bottom])
                    VStack {
                        HStack {
                            Text("Setting")
                                .font(.system(size: 25, weight: .semibold))
                            Spacer()
                        }
                        .foregroundColor(.white)
                        VStack(spacing: 30) {
                            if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Renter" || appViewModel.userType == "Renter" {
                                NavigationLink {
                                    withAnimation {
                                        UserDetailInfoView()
                                    }
                                } label: {
                                    SideBarButton(buttonName: "User Profile", systemImageName: "person.crop.circle")
                                }
                            } else if firestoreToFetchUserinfo.getUserType(input: firestoreToFetchUserinfo.fetchedUserData) == "Provider" || appViewModel.userType == "Provider" {
                                NavigationLink {
                                    withAnimation {
                                        ContractCollectionView()
                                    }
                                } label: {
                                    SideBarButton(buttonName: "Contracts", systemImageName: "folder")
                                }
                            }
                            NavigationLink {
                                withAnimation {
                                    MessageView()
                                }
                            } label: {
                                SideBarButton(buttonName: "Messages", systemImageName: "message")
                            }
                            NavigationLink {
                                withAnimation {
                                    ContactView()
                                }
                            } label: {
                                SideBarButton(buttonName: "Contect Us", systemImageName: "questionmark.circle")
                            }
                        }
                        .foregroundColor(.white)
                        Spacer()
                            .frame(height: UIScreen.main.bounds.height / 2)
                        HStack {
                            Button {
                                firebaseAuth.signOut()
                            } label: {
                                Text("Sign Out")
                                    .foregroundColor(.white)
                                    .frame(width: 108, height: 35)
                                    .background(Color("sessionBackground"))
                                    .clipShape(RoundedCorner(radius: 5))
                                    .padding(.leading, 25)
                            }
                            Spacer()
                        }
                    }
                }
                */
                MenuView()
            } content: {
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
                                    .fill(Color("backgroundBrown"))
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
                                                //                                                else {
                                                //                                                    Image(uiImage: self.image)
                                                //                                                        .resizable()
                                                //                                                        .aspectRatio(contentMode: .fill)
                                                //                                                        .frame(width: 120, height: 120)
                                                //                                                        .clipShape(Circle())
                                                //                                                        .scaledToFit()
                                                //                                                }
                                            }
                                        }
                                    }
                                    Text("\(firestoreToFetchUserinfo.userLastName)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 30, weight: .heavy))
                                        .padding(.leading, 20)
                                }
                                .padding()
                                VStack {
                                    ScrollView(.vertical, showsIndicators: false) {
                                        //: Room Status Session
                                        ZStack {
                                            Rectangle()
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
                                            Rectangle()
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
                                            Rectangle()
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
                        Image("room")
                            .resizable()
                            .blur(radius: 10)
                            .clipped()
                        Rectangle()
                            .fill(.gray)
                            .blendMode(.multiply)
                    }
                    .edgesIgnoringSafeArea([.top, .bottom])
                })
                .sheet(isPresented: $showSheet, onDismiss: {
                    if !image.isSymbolImage {
                        storageForUserProfile.uploadImage(uidPath: firebaseAuth.getUID(), image: image)
                    }
                }) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                }
                .navigationTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    if firestoreToFetchMaintainTasks.fetchMaintainInfo.isEmpty {
                        firestoreToFetchMaintainTasks.fetchMaintainInfo(uidPath: firebaseAuth.getUID())
                    }
                    storageForUserProfile.representedProfileImageURL = storageForUserProfile.representStorageImage(uidPath: firebaseAuth.getUID())
                }
            }
        }
    }
}

struct RenterProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}



//, y: self.show ? 15 : 0   UIScreen.main.bounds.width / 2 + 200


/*
 ZStack {
 MenuView()
 ZStack {
 //: MainView
 Group {
 Image("room")
 .resizable()
 .blur(radius: 10)
 .aspectRatio(contentMode: .fill)
 .frame(width: 428, height: 945)
 .offset(x: -40)
 .clipped()
 Rectangle()
 .fill(.gray)
 .blendMode(.multiply)
 }
 .edgesIgnoringSafeArea([.top, .bottom])
 //: Tool bar
 VStack {
 Spacer()
 .frame(height: 75)
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
 .fill(Color("backgroundBrown"))
 .frame(height: UIScreen.main.bounds.height - 193)
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
 //                                                else {
 //                                                    Image(uiImage: self.image)
 //                                                        .resizable()
 //                                                        .aspectRatio(contentMode: .fill)
 //                                                        .frame(width: 120, height: 120)
 //                                                        .clipShape(Circle())
 //                                                        .scaledToFit()
 //                                                }
 }
 }
 }
 Text("\(firestoreToFetchUserinfo.userLastName)")
 .foregroundColor(.white)
 .font(.system(size: 30, weight: .heavy))
 .padding(.leading, 20)
 }
 .padding()
 VStack {
 ScrollView(.vertical, showsIndicators: false) {
 //: Room Status Session
 ZStack {
 Rectangle()
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
 Rectangle()
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
 Rectangle()
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
 .cornerRadius(self.show ? 30 : 0)
 .scaleEffect(self.show ? 0.5 : 1, anchor: .trailing)
 .offset(x: self.show ?  80 : 0, y: self.show ? 60 : 0)
 .ignoresSafeArea(.all)
 .onTapGesture {
 withAnimation {
 self.show = false
 }
 }
 .sheet(isPresented: $showSheet, onDismiss: {
 if !image.isSymbolImage {
 storageForUserProfile.uploadImage(uidPath: firebaseAuth.getUID(), image: image)
 }
 }) {
 ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
 }
 }
 .navigationTitle("")
 .navigationBarHidden(true)
 .navigationBarBackButtonHidden(true)
 .onAppear {
 if firestoreToFetchMaintainTasks.fetchMaintainInfo.isEmpty {
 firestoreToFetchMaintainTasks.fetchMaintainInfo(uidPath: firebaseAuth.getUID())
 }
 storageForUserProfile.representedProfileImageURL = storageForUserProfile.representStorageImage(uidPath: firebaseAuth.getUID())
 }
 */

/*
 Group {
     Image("room")
         .resizable()
         .blur(radius: 10)
         .aspectRatio(contentMode: .fit)
         .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
         .clipped()
     Rectangle()
         .fill(.gray)
         .blendMode(.multiply)
 }
 .edgesIgnoringSafeArea([.top, .bottom])
*/
