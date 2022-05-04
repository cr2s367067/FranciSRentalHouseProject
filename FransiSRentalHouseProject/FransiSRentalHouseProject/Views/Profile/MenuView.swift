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
            VStack(spacing: 10) {
                HStack {
                    Text("Setting")
                        .font(.system(size: 25, weight: .semibold))
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.leading, 2)
                VStack(spacing: 30) {
                    identifyUserType(signUpType: SignUpType(rawValue: firestoreToFetchUserinfo.fetchedUserData.userType) ?? .isNormalCustomer, providerType: ProviderTypeStatus(rawValue: firestoreToFetchUserinfo.fetchedUserData.providerType) ?? .roomProvider)
                    NavigationLink {
                        withAnimation {
                            ContactView()
                        }
                    } label: {
                        SideBarButton(buttonName: "Contect Us", systemImageName: "questionmark.circle")
                    }
                    NavigationLink {
                        withAnimation {
                            BioAuthSettingView()
                        }
                    } label: {
                        SideBarButton(buttonName: "Security", systemImageName: "lock.iphone")
                    }
                }
                .foregroundColor(.white)
                Spacer()
                    .frame(height: UIScreen.main.bounds.height / 3)
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
            .padding()
        }
    }
}

extension MenuView {
    @ViewBuilder
    func identifyUserType(signUpType: SignUpType, providerType: ProviderTypeStatus) -> some View {
        if signUpType == .isNormalCustomer {
            NavigationLink {
                withAnimation {
                    UserDetailInfoView()
                }
            } label: {
                SideBarButton(buttonName: "User Profile", systemImageName: "person.crop.circle")
            }
            NavigationLink {
                withAnimation {
                    UserOrderedListView()
                }
            } label: {
                SideBarButton(buttonName: "Ordered", systemImageName: "filemenu.and.selection")
            }
            NavigationLink {
                withAnimation {
                    FocusProductsView()
                }
            } label: {
                SideBarButton(buttonName: "Focusing\rProducts", systemImageName: "face.dashed.fill")
            }
        }
        if signUpType == .isProvider {
            if providerType == .roomProvider {
                NavigationLink {
                    withAnimation {
                        ContractCollectionView()
                    }
                } label: {
                    SideBarButton(buttonName: "Contracts", systemImageName: "folder")
                }
            }
            if providerType == .productProvider {
                NavigationLink {
                    withAnimation {
                        StoreProfileView()
                    }
                } label: {
                    SideBarButton(buttonName: "My Store", systemImageName: "briefcase")
                }
                NavigationLink {
                    withAnimation {
                        ProductCollectionView()
                    }
                } label: {
                    SideBarButton(buttonName: "Products", systemImageName: "square.stack.fill")
                }
            }
            NavigationLink {
                withAnimation {
                    UserDetailInfoView()
                }
            } label: {
                SideBarButton(buttonName: "User Profile", systemImageName: "person.crop.circle")
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
                .foregroundColor(.white)
                .font(.system(size: 24))
            Text(buttonName)
                .foregroundColor(.white)
                .font(.system(size: 18))
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
