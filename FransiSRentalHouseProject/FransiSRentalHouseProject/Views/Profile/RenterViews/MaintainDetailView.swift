//
//  MaintainDetailView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//


import SwiftUI

struct MaintainDetailView: View {
    
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchMaintainTasks: FirestoreToFetchMaintainTasks
    
    var maintainTask = "Lorem ipsum dolor sit amet1."
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("backgroundBrown"))
                .ignoresSafeArea(.all)
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color("sessionBackground"))
                        .cornerRadius(4)
                        .frame(width: 378, height: 700)
                    VStack(spacing: 10) {
                        HStack {
                            Text("Maintain History: ")
                                .font(.system(size: 20, weight: .heavy))
                            Spacer()
                                .frame(width: 180)
                        }
                        VStack {
                            ScrollView(.vertical, showsIndicators: false) {
                                ForEach(firestoreToFetchMaintainTasks.fetchMaintainInfo) { task in
                                    ProfileSessionUnit(mainTainTask: task.taskName)
                                }
                            }
                        }
                        .frame(width: 370, height: 650)
//                        Spacer()
//                            .frame(height: 40)
                    }
                    .foregroundColor(.white)
                    .padding(.leading, 2)
                }
//                Spacer()
//                    .frame(height: 470)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MaintainDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MaintainDetailView()
    }
}
