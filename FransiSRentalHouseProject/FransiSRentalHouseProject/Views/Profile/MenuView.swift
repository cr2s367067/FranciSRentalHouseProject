//
//  MenuView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct MenuView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    
    var body: some View {
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
                .padding(.leading, 2)
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
                        NavigationLink {
                            withAnimation {
                                UserDetailInfoView()
                            }
                        } label: {
                            SideBarButton(buttonName: "User Profile", systemImageName: "person.crop.circle")
                        }
                    }
                    NavigationLink {
                        withAnimation {
                            MessageMainView()
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
                        do {
                            try firebaseAuth.signOutAsync()
                        } catch {
                            print("unknown error")
                        }
                        
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
    }
}

struct SideBarButton: View {
    var buttonName: String
    var systemImageName: String
    var body: some View {
        HStack {
            Image(systemName: systemImageName)
                .resizable()
                .frame(width: 24, height: 24)
            Text(buttonName)
            Spacer()
        }
        .padding(.leading, 5)
    }
}


struct SideMenuBar<SidebarContent: View, Content: View>: View {
    let sidebarContent: SidebarContent
    let mainContent: Content
    let sidebarWidth: CGFloat
    @Binding var showSidebar: Bool
    
    init(sidebarWidth: CGFloat, showSidebar: Binding<Bool>, @ViewBuilder sidebar: ()->SidebarContent, @ViewBuilder content: ()->Content) {
        self.sidebarWidth = sidebarWidth
        self._showSidebar = showSidebar
        sidebarContent = sidebar()
        mainContent = content()
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            sidebarContent
                .frame(width: sidebarWidth, alignment: .leading)
                .offset(x: showSidebar ? 0 : -1 * sidebarWidth, y: 0)
                .animation(.easeInOut, value: 2)
            mainContent
                .overlay(
                    Group {
                        if showSidebar {
                            Color.white
                                .opacity(showSidebar ? 0.01 : 0)
                                .onTapGesture {
                                    self.showSidebar = false
                                }
                        } else {
                            Color.clear
                                .opacity(showSidebar ? 0 : 0)
                                .onTapGesture {
                                    self.showSidebar = false
                                }
                        }
                    }
                )
                .offset(x: showSidebar ? sidebarWidth : 0, y: 0)
                .animation(.easeInOut, value: 2)
        }
    }
}



struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
