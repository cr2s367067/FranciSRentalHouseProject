//
//  RenterProfileView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct RenterProfileView: View {
    
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var appViewModel: AppViewModel
    
    let firebaseSg = FirebaseStorageManager()
    
    let fetchFirestore = FetchFirestore()
    
    @State private var show = false
    @State private var image = UIImage()
    @State private var showSheet = false
    @State private var isSummitImage = false
    
    var body: some View {
        NavigationView {
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
                                Image(systemName: "gear")
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
                                        } label: {
                                            if isSummitImage == false {
                                                Image(systemName: "person.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 120, height: 120)
                                                    .clipShape(Circle())
                                            } else if isSummitImage == true {
                                                Image(uiImage: self.image)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 120, height: 120)
                                                    .clipShape(Circle())
                                            }
                                        }
                                    }
                                    Text("Lorem")
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
                                                        .frame(width: 220)
                                                    NavigationLink {
                                                        MaintainDetailView()
                                                    } label: {
                                                        Image(systemName: "chevron.forward")
                                                    }
                                                }
                                                VStack {
                                                    ScrollView(.vertical, showsIndicators: false) {
                                                        ForEach(localData.maintainTaskHolder) { task in
                                                            ProfileSessionUnit(mainTainTask: task.taskName)
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
                .scaleEffect(self.show ? 0.5: 1)
                .offset(x: self.show ? UIScreen.main.bounds.width / 3 : 0
                        , y: self.show ? 15 : 0)
                .onTapGesture {
                    withAnimation {
                        self.show = false
                    }
                }
                .sheet(isPresented: $showSheet, onDismiss: {
                    firebaseSg.uploadImage(uidPath: fetchFirestore.getUID(), image: image)
                    if !image.isSymbolImage {
                        isSummitImage = true
                    }
                }) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct RenterProfileView_Previews: PreviewProvider {
    static var previews: some View {
        RenterProfileView()
    }
}
