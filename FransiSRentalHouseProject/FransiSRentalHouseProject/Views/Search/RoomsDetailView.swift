//
//  RoomsDetailView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/5.
//

import SwiftUI
import SDWebImageSwiftUI

struct RoomsDetailView: View {
    
    @EnvironmentObject var roomsDetailViewModel: RoomsDetailViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var roomsData: RoomInfoDataModel
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                HStack {
                    //Add image here
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.black)
                        .frame(width: 60, height: 60)
                }
                Spacer()
                    .frame(height: 15)
                VStack(alignment: .leading) {
                    HStack {
                        Text("Room Name") //If it has
                            .font(.system(size: 30))
                        Spacer()
                        Button {
                            roomsDetailViewModel.showMap.toggle()
                        } label: {
                            Image(systemName: "map")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .trailing)
                        }
                    }
                    RoomsInfoUnit(title: "Rooms Address")
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical)
                .frame(width: uiScreenWidth, height: uiScreenHeight / 3)
                .background {
                    Rectangle()
                        .fill(Color("background2"))
                        .cornerRadius(30, corners: [.topLeft, .topRight])
                }
                
            }
            .frame(height: uiScreenHeight / 2 - 60, alignment: .bottom)
            .background {
                Rectangle()
                    .fill(Color.brown)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
            }
        }
        .edgesIgnoringSafeArea(.top)
        .frame(maxWidth: .infinity)
        .background(alignment: .center) {
            VStack {
                mapSwitch(showMap: roomsDetailViewModel.showMap, address: getAddress())
//                Image("room")
//                    .resizable()
//                    .frame(height: uiScreenHeight / 2 + 190, alignment: .top)
//                    .edgesIgnoringSafeArea(.top)
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            UINavigationBar.appearance().barTintColor = UIColor(Color.clear)
            UINavigationBar.appearance().backgroundColor = UIColor(Color.clear)
        }
    }
}

//struct RoomsDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomsDetailView()
//    }
//}

struct RoomsInfoUnit: View {
    var title: String
    var body: some View {
        HStack {
            Text("\(title):")
            Spacer()
        }
    }
}

class RoomsDetailViewModel: ObservableObject {
    @Published var showMap = true
}


extension RoomsDetailView {
    @ViewBuilder
    func mapSwitch(showMap: Bool, address: String) -> some View {
        if showMap == true {
            RoomLocateMapView(address: address)
                .frame(height: uiScreenHeight / 2, alignment: .top)
                .edgesIgnoringSafeArea(.top)
        } else {
            Image("room")
                .resizable()
                .frame(height: uiScreenHeight / 2 + 190, alignment: .top)
                .edgesIgnoringSafeArea(.top)
        }
    }
    
    func getAddress() -> String {
        return address(input: roomsData)
    }
    
    func address(input: RoomInfoDataModel) -> String {
        let zipCode = input.zipCode
        let city = input.city
        let town = input.town
        let roomAddress = input.roomAddress
        return zipCode + city + town + roomAddress
    }
}
