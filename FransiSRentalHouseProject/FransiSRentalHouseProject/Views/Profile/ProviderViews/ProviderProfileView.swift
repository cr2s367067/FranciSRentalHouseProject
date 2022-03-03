//
//  ProviderProfileView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ProviderProfileView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firebaseStorageDM: FirebaseStorageManager
    @EnvironmentObject var fetchFirestore: FetchFirestore
    
    @State private var show = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                MenuView()
                ZStack {
                    Group {
                        Rectangle()
                            .fill(Color("backgroundBrown"))
                    }
                    .edgesIgnoringSafeArea([.top, .bottom])
                    VStack {
                        //                        Spacer()
                        //                            .frame(height: 75)
                        HStack {
                            Button {
                                withAnimation {
                                    self.show.toggle()
                                }
                            } label: {
                                Image(systemName: "line.3.horizontal.circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding(.leading)
                        //                        .padding(.top)
                        TitleAndDivider(title: "My Profile")
                        HStack(spacing: 20) {
                            Spacer()
                            Image(systemName: "chart.bar.xaxis")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                            Image(systemName: "chart.xyaxis.line")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                        .padding(.trailing)
                        .frame(width: 378)
                        
                        Rectangle()
                            .fill(Color("fieldGray"))
                            .frame(width: 378, height: 304)
                            .cornerRadius(10)
                        
                        TitleAndDivider(title: "Detail")
                        VStack {
                            OwnerProfileDetailUnit()
                            OwnerProfileDetailUnit()
                            OwnerProfileDetailUnit()
                        }
                        AppDivider()
                        HStack {
                            Text("Total Earning")
                            Spacer()
                            Text("$27,000")
                        }
                        .foregroundColor(.white)
                        .frame(width: 350)
                        .padding()
                    }
                }
                .frame(height: UIScreen.main.bounds.height)
                .cornerRadius(self.show ? 30 : 0)
                .scaleEffect(self.show ? 0.5: 1)
                .offset(x: self.show ? UIScreen.main.bounds.width / 3 : 0
                        , y: self.show ? 15 : 0)
                .onTapGesture {
                    withAnimation {
                        self.show = false
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct OwnerProfileDetailUnit: View {
    var body: some View {
        HStack {
            Text("Rental Price")
            Spacer()
            Text("$9,000")
        }
        .foregroundColor(.white)
        .frame(width: 350)
        .padding()
    }
}

struct ProviderProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderProfileView()
    }
}
