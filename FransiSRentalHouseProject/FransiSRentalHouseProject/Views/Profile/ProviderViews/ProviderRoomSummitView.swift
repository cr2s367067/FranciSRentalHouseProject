//
//  ProviderRoomSummitView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ProviderRoomSummitView: View {
    
    @State var holderName = ""
    @State var holderMobileNumber = ""
    @State var holderEmailAddress = ""
    @State var roomAddress = ""
    @State var roomArea = ""
    @State private var holderTosAgree = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("backgroundBrown"))
                .edgesIgnoringSafeArea([.top, .bottom])
            VStack(spacing: 5) {
                ScrollView(.vertical, showsIndicators: false){
                    TitleAndDivider(title: "Ready to Post your Room?")
                    StepsTitle(stepsName: "Step1: Upload the room pic.")
                    Rectangle()
                        .fill(Color("fieldGray"))
                        .frame(width: 378, height: 304)
                        .cornerRadius(10)
                    StepsTitle(stepsName: "Step2: Please provide the necessary information")
                    VStack(spacing: 10) {
                        InfoUnit(title: "Holder Name", bindingString: $holderName)
                        InfoUnit(title: "Mobile Number", bindingString: $holderMobileNumber)
                        InfoUnit(title: "Room Address", bindingString: $roomAddress)
                        InfoUnit(title: "Email Address", bindingString: $holderEmailAddress)
                        InfoUnit(title: "Room Area", bindingString: $roomArea)
                        
                    }
                    .frame(width: 350)
                    StepsTitle(stepsName: "Step3: Please check out the terms of service.")
                    VStack(alignment: .leading) {
                        Spacer()
                        HStack {
                            Button {
                                holderTosAgree.toggle()
                            } label: {
                                Image(systemName: holderTosAgree ? "checkmark.square.fill" : "checkmark.square")
                                    .foregroundColor(holderTosAgree ? .green : .white)
                                    .padding(.trailing, 5)
                            }
                            Text("I have read and agree the terms of Service.")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .medium))
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button {
                            
                        } label: {
                            Text("Next")
                                .foregroundColor(.white)
                                .frame(width: 108, height: 35)
                                .background(Color("buttonBlue"))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        
                    }
                    .padding(.trailing)
                    .frame(width: 400)
                }
            }
        }
    }
}

struct StepsTitle: View {
    var stepsName = ""
    var body: some View {
        HStack {
            Text(stepsName)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.leading)
    }
}

struct ProviderRoomSummitView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderRoomSummitView()
    }
}
