//
//  MaintainWaitingDetailView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/12.
//

import SwiftUI
import SDWebImageSwiftUI

struct MaintainWaitingDetailView: View {
    
    @EnvironmentObject var firestoreToFetchMaintainTasks: FirestoreToFetchMaintainTasks
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @Environment(\.colorScheme) var colorScheme
    
    let uiscreenWidth = UIScreen.main.bounds.width
    let uiscreedHeight = UIScreen.main.bounds.height
    
    var docID: String
    
    var amountTask: Int {
        firestoreToFetchMaintainTasks.fetchMaintainInfo.count
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack(spacing: 10) {
                    Text("Tasks: ")
                    Text("\(amountTask)")
                    Spacer()
                }
                .foregroundColor(.primary)
                .padding()
                .background(alignment: .center) {
                    Capsule()
                        .stroke(.gray, lineWidth: 1)
                }
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach(firestoreToFetchMaintainTasks.fetchMaintainInfo) { mTask in
                        MaintainTaskWaitingListUnit(maintainTask: mTask, docID: docID)
                    }
                }
                .padding()
            }
            .frame(width: uiscreenWidth - 30, height: uiscreedHeight - 180, alignment: .center)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 30)
                    .fill(colorScheme == .dark ? .gray.opacity(0.3) : .white)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(alignment: .center) {
            LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea([.top, .bottom])
        }
        .task {
            do {
                try await firestoreToFetchMaintainTasks.fetchMaintainInfoAsync(uidPath: firebaseAuth.getUID(), docID: docID)
            } catch {
                print("error")
            }
        }
    }
}



struct MaintainTaskWaitingListUnit: View {
    
    @EnvironmentObject var firestoreToFetchMaintainTasks: FirestoreToFetchMaintainTasks
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    
    var maintainTask: MaintainTaskHolder
    var docID: String
    
    let uiscreenWidth = UIScreen.main.bounds.width
    let uiscreedHeight = UIScreen.main.bounds.height
    var body: some View {
        placeHolder()
    }
}



extension MaintainTaskWaitingListUnit {
    
    @ViewBuilder
    func placeHolder() -> some View {
        if firestoreToFetchMaintainTasks.fetchMaintainInfo.isEmpty {
            VStack(alignment: .center) {
               Text("No item needs to fix🥸")
            }
            .padding()
            .frame(width: uiscreenWidth - 50, height: uiscreedHeight / 3, alignment: .center)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.5))
            }
        } else {
            VStack(alignment: .center) {
                WebImage(url: URL(string: maintainTask.itemImageURL))
                    .resizable()
                    .scaledToFill()
                    .frame(width: uiscreenWidth / 2 + 150, height: uiscreedHeight / 6 + 70, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                HStack {
                    VStack {
                        HStack {
                            Text(maintainTask.description)
                            Spacer()
                        }
                        HStack{
                            Text(maintainTask.appointmentDate, format: Date.FormatStyle().year().month().day())
                            Spacer()
                        }
                    }
                    Button {
                        Task {
                            do {
                                try await firestoreToFetchMaintainTasks.updateFixedInfo(uidPath: firebaseAuth.getUID(), docID: docID, maintainDocID: maintainTask.id ?? "")
                                try await firestoreToFetchMaintainTasks.deleteFixedItem(uidPath: firebaseAuth.getUID(), docID: docID, maintainDocID: maintainTask.id ?? "")
                                try await firestoreToFetchMaintainTasks.fetchMaintainInfoAsync(uidPath: firebaseAuth.getUID(), docID: docID)
                            } catch {
                                print("error")
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: maintainTask.isFixed ? "checkmark.circle.fill" : "x.circle.fill")
                                .foregroundColor(maintainTask.isFixed ? .green : .red)
                            Text("Fixed")
                        }
                    }
                }
            }
            .padding()
            .frame(width: uiscreenWidth - 50, height: uiscreedHeight / 3, alignment: .center)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.5))
            }
        }
    }

}
