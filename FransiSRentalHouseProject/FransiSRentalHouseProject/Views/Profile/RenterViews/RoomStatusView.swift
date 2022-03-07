//
//  RoomStatusView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

import SwiftUI

struct RoomStatusView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("backgroundBrown"))
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                    .frame(height: 120)
                ZStack {
                    Rectangle()
                        .fill(Color("sessionBackground"))
                        .cornerRadius(4)
                        .frame(width: 378, height: 325)
                    HStack {
                        VStack {
                            HStack {
                                Image("room3")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                VStack {
                                    Spacer()
                                        .frame(height: 75)
                                    Text("Lorem")
                                        .foregroundColor(.white)
                                        .font(.system(size: 25, weight: .medium))
                                }
                                .padding(.leading, 10)
                            }
                            Spacer()
                                .frame(height: 300)
                        }
                        Spacer()
                            .frame(width: 140)
                    }
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 1) {
                            Text("Monthly Rental Price: ")
                                .foregroundColor(.white)
                            Spacer()
                                .frame(width: 90)
                            Text("$9000")
                                .foregroundColor(.white)
                                .padding(.leading, 1)
                        }
                        HStack(spacing: 1) {
                            Text("Expired Date: ")
                                .foregroundColor(.white)
                            Spacer()
                                .frame(width: 150)
                            Text("1/15/2023")
                                .foregroundColor(.white)
                                .padding(.leading, 1)
                            
                        }
                        HStack(spacing: 1) {
                            Text("Addition Furniture:  ")
                                .foregroundColor(.white)
                            Spacer()
                                .frame(width: 106)
                            Text("Yes")
                                .foregroundColor(.white)
                                .padding(.leading, 1)
                        }
                        HStack(spacing: 1) {
                            Text("Renew: ")
                                .foregroundColor(.white)
                            Spacer()
                                .frame(width: 175)
                            Button {
                                
                            } label: {
                                Text("Yes")
                                    .frame(width: 108, height: 35)
                                    .background(Color("fieldGray"))
                                    .cornerRadius(10)
                            }
                            .padding(.leading, 1)
                        }
                        HStack(spacing: 1) {
                            Text("Contract: ")
                                .foregroundColor(.white)
                            Spacer()
                                .frame(width: 150)
                            Button {
                                
                            } label: {
                                Text("show")
                                    .frame(width: 108, height: 35)
                                    .background(Color("fieldGray"))
                                    .cornerRadius(10)
                            }
                            .padding(.leading, 1)
                        }
                    }
                    .padding(.top, 30)
                }
                Spacer()
                    .frame(height: 450)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RoomStatusView_Previews: PreviewProvider {
    static var previews: some View {
        RoomStatusView()
    }
}
