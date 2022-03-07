//
//  RenterMainView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct RenterMainView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    
    var gridItemLayout = [
        GridItem(.fixed(170)),
        GridItem(.fixed(170))
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(Color("backgroundBrown"))
                    .ignoresSafeArea(.all)
                VStack(alignment: .leading) {
                    ScrollView(.vertical, showsIndicators: false) {
                        //: Announcement Group
                        Group {
                            TitleAndDivider(title: "Announcement")
                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sem magna in donec amet duis pretium aliquam egestas aliquam.")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .regular))
                                .padding(.leading)
                                .padding(.bottom, 5)
                        }
                        //: New rooms Group
                        Group {
                            TitleAndDivider(title: "What's new")
                            //: New publish scrill view
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: gridItemLayout, spacing: 50) {
                                    ForEach(firestoreToFetchRoomsData.fetchRoomInfo) { result in
                                        Button {
//                                            if localData.tempCart.isEmpty {
//                                                localData.tempCart.append(result)
//                                                //                                                localData.sumupPriceArray.append(result.roomPrice)
//                                                localData.addItem(itemName: result.roomName, itemPrice: result.roomPrice)
//                                            } else {
//                                                localData.tempCart.removeAll()
//                                                //                                                localData.sumupPriceArray.removeAll()
//                                                localData.summaryItemHolder.removeAll()
//                                                if localData.tempCart.isEmpty {
//                                                    localData.tempCart.append(result)
//                                                    //                                                    localData.sumupPriceArray.append(result.roomPrice)
//                                                    localData.addItem(itemName: result.roomName, itemPrice: result.roomPrice)
//                                                }
//                                            }
                                            if appViewModel.isPresent == false {
                                                appViewModel.isPresent = true
                                            }
                                            localData.sumPrice = localData.compute(source: localData.summaryItemHolder)
                                        } label: {
                                            
//                                            GridView(objectName: (result.city + result.town), objectPrice: result.rentalPrice, imgUID: result.id)
//                                            GridView(objectImage: result.roomImage, objectName: result.roomName, objectPrice: result.roomPrice)
//                                                .frame(height: 160)
//                                                .alert(isPresented: $appViewModel.isPresent) {
//                                                    Alert(title: Text("Congrate!"), message: Text("The room is adding in the chart, also check out the furnitures if needing. Please see Payment session."), dismissButton: .default(Text("Sure")))
//                                                }
                                        }
                                    }
                                }
                                .frame(height: 310)
                                .padding()
                            }
                        }
                        
                        //: Everybody's facorite
                        Group {
                            TitleAndDivider(title: "What's Everybody Favorite")
                            //: New publish scrill view
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: gridItemLayout, spacing: 50) {
//                                    ForEach(localData.roomDataSets) { result in
//                                        Button {
//                                            if localData.tempCart.isEmpty {
//                                                localData.tempCart.append(result)
//                                                //                                                localData.sumupPriceArray.append(result.roomPrice)
//                                                localData.addItem(itemName: result.roomName, itemPrice: result.roomPrice)
//                                            } else {
//                                                localData.tempCart.removeAll()
//                                                //                                                localData.sumupPriceArray.removeAll()
//                                                localData.summaryItemHolder.removeAll()
//                                                if localData.tempCart.isEmpty {
//                                                    localData.tempCart.append(result)
//                                                    //                                                    localData.sumupPriceArray.append(result.roomPrice)
//                                                    localData.addItem(itemName: result.roomName, itemPrice: result.roomPrice)
//                                                }
//                                            }
//                                            if appViewModel.isPresent == false {
//                                                appViewModel.isPresent = true
//                                            }
//                                            localData.sumPrice = localData.compute(source: localData.summaryItemHolder)
//                                        }  label: {
//                                            GridView(objectImage: result.roomImage, objectName: result.roomName, objectPrice: result.roomPrice)
//                                                .frame(height: 160)
//                                                .alert(isPresented: $appViewModel.isPresent) {
//                                                    Alert(title: Text("Congrate!"), message: Text("The room is adding in the chart, also check out the furnitures if needing. Please see Payment session."), dismissButton: .default(Text("Sure")))
//                                                }
//                                        }
//                                    }
                                }
                            }
                            .frame(height: 310)
                            .padding()
                        }
                        
                    }
                }
            }
            .onAppear(perform: {
//                fetchFirestore.fetchRoomsData.listeningRoomInfo(uidPath: fetchFirestore.getUID())
            })
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    struct RenterMainView_Previews: PreviewProvider {
        static var previews: some View {
            RenterMainView()
        }
    }
}
    
    
    


/*
 ForEach(localData.roomDataSets) { result in
     Button {
         if localData.tempCart.isEmpty {
             localData.tempCart.append(result)
             //                                                localData.sumupPriceArray.append(result.roomPrice)
             localData.addItem(itemName: result.roomName, itemPrice: result.roomPrice)
         } else {
             localData.tempCart.removeAll()
             //                                                localData.sumupPriceArray.removeAll()
             localData.summaryItemHolder.removeAll()
             if localData.tempCart.isEmpty {
                 localData.tempCart.append(result)
                 //                                                    localData.sumupPriceArray.append(result.roomPrice)
                 localData.addItem(itemName: result.roomName, itemPrice: result.roomPrice)
             }
         }
         if appViewModel.isPresent == false {
             appViewModel.isPresent = true
         }
         localData.sumPrice = localData.compute(source: localData.summaryItemHolder)
     } label: {
         GridView(objectImage: result.roomImage, objectName: result.roomName, objectPrice: result.roomPrice)
             .frame(height: 160)
             .alert(isPresented: $appViewModel.isPresent) {
                 Alert(title: Text("Congrate!"), message: Text("The room is adding in the chart, also check out the furnitures if needing. Please see Payment session."), dismissButton: .default(Text("Sure")))
             }
     }
 }
*/