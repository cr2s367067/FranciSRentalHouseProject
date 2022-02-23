//
//  SearchView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    
    @State private var tagSelect = "TapSearchButton"
    @State private var searchName = ""
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color("backgroundBrown"))
                .edgesIgnoringSafeArea([.bottom, .top])
            VStack(spacing: 10) {
                Spacer()
//                    .frame(height: 5)
                //: Search TextField For Temp
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading)
                    TextField("", text: $searchName)
                        .placeholer(when: searchName.isEmpty) {
                            Text("Search")
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .textInputAutocapitalization(.never)
                }
                .frame(width: 400, height: 50)
                .foregroundColor(.gray)
                .background(Color("fieldGray").opacity(0.07))
                .cornerRadius(10)
                //.offset(y: 40)
                .fixedSize(horizontal: true, vertical: true)
                //.padding(.bottom, 10)
                
                //: Scroll View
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        //ForEach to catch the data from firebase
                        ForEach(localData.roomDataSets.filter({
                            searchName.isEmpty ? true : $0.roomName.contains(searchName)
                        })) { result in
                            Button {
                                if localData.tempCart.isEmpty {
                                    localData.tempCart.append(result)
                                    localData.addItem(itemName: result.roomName, itemPrice: result.roomPrice)
                                } else {
                                    localData.tempCart.removeAll()
                                    localData.summaryItemHolder.removeAll()
                                    if localData.tempCart.isEmpty {
                                        localData.tempCart.append(result)
                                        localData.addItem(itemName: result.roomName, itemPrice: result.roomPrice)
                                    }
                                }
                                if appViewModel.isPresent == false {
                                    appViewModel.isPresent = true
                                }
                                localData.sumPrice = localData.compute(source: localData.summaryItemHolder)
                            } label: {
                                SearchListItemView(
                                    roomImage: result.roomImage,
                                    roomName: result.roomName,
                                    roomPrice: result.roomPrice,
                                    roomDescribtion: result.roomDescribtion,
                                    ranking: result.ranking
                                )
                                    .alert(isPresented: $appViewModel.isPresent) {
                                        Alert(title: Text("Congrate!"), message: Text("The room is adding in the chart, also check out the furnitures if needing. Please see Payment session."), dismissButton: .default(Text("Sure")))
                                    }
                            }
                        }
                    }
                    //.frame(height: 600)
                }
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
