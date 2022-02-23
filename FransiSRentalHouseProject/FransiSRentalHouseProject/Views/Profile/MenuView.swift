//
//  MenuView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct MenuView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var fetchFirestore: FetchFirestore
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                    .frame(height: 30)
                HStack {
                    Text("Setting")
                        .font(.system(size: 25, weight: .semibold))
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.top, appViewModel.getSafeAreaTop())
                Spacer()
                    .frame(height: 20)
                VStack(spacing: 30) {
                    NavigationLink {
                        withAnimation {
                            UserDetailInfoView()
                                
                        }
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("User Profile")
                        }
                    }
                    NavigationLink {
                        withAnimation {
                            ContectView()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "message")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Contect Us")
                        }
                    }
                }
                .foregroundColor(.white)
                
                .padding(.top)
                
                Spacer()
                Button {
                    appViewModel.signOut()
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.white)
                        .frame(width: 108, height: 35)
                        .background(Color("sessionBackground"))
                        .clipShape(RoundedCorner(radius: 5))
                        .offset(x: 30)
                        .padding(.leading)
                }
                Spacer()
                    .frame(height: 70)
            }
            .padding(.bottom, appViewModel.getSafeAreaBottom())
            .padding(.leading)
        }
        .background(Color("menuBackground"))
        .ignoresSafeArea(.all)
        .navigationTitle("")
        .navigationBarHidden(true)
        .onAppear(perform: {
            appViewModel.updateNavigationBarColor()
        })

    }
}



struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
