//
//  PurchaseView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct PurchaseView: View {
    
    @EnvironmentObject var localData: LocalData
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    
    var brandArray = ["apple-pay", "google-pay", "mastercard", "visa"]
    
    @State var cardName = ""
    @State var cardNumber = ""
    @State var expDate = ""
    @State var secCode = ""
    
    var body: some View {
        ZStack {
//            Image("room")
//                .resizable()
//                .blur(radius: 10)
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 428, height: 926)
//                .offset(x: -40)
//                .clipped()
//            Rectangle()
//                .fill(.gray)
//                .blendMode(.multiply)
            Rectangle()
                .fill(Color("backgroundBrown"))
                .ignoresSafeArea(.all)
            VStack {
                Image("cardPic")
                    .resizable()
                    .frame(width: 300, height: 200)
                HStack(spacing: 10) {
                    ForEach(brandArray, id: \.self) { item in
                        Image(item)
                            .resizable()
                            .frame(width: 48, height: 32)
                    }
                    Spacer()
                        .frame(width: 60)
                }
                .padding(5)
                
                VStack(spacing: 15) {
                    //:Card Name
                    VStack(alignment: .leading, spacing: 1) {
                        HStack {
                            Text("Card Name*")
                                .foregroundColor(.white)
                            Spacer()
                                .frame(width: 40)
                        }
                        ZStack {
                            HStack {
                                TextField("", text: $cardName)
                                    .placeholer(when: cardName.isEmpty) {
                                        Text("Card Holder Name")
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                    .padding()
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .foregroundColor(.red)
                                    .frame(width: 24, height: 24)
                                    .padding(.trailing, 5)
                            }
                        }
                        .modifier(customTextField())
                        Text("Please fill out a card name.")
                            .foregroundColor(.red)
                            .font(.system(size: 12, weight: .heavy))
                            .padding(2)
                        
                    }
                    //: Card Number
                    VStack(alignment: .leading, spacing: 1) {
                        HStack {
                            Text("Card Number*")
                                .foregroundColor(.white)
                            Spacer()
                                .frame(width: 40)
                        }
                        ZStack {
                            HStack {
                                TextField("", text: $cardNumber)
                                    .placeholer(when: cardNumber.isEmpty) {
                                        Text("Card Number")
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                    .padding()
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .foregroundColor(.red)
                                    .frame(width: 24, height: 24)
                                    .padding(.trailing, 5)
                            }
                        }
                        .modifier(customTextField())
                        Text("This card number is not vaild")
                            .foregroundColor(.red)
                            .font(.system(size: 12, weight: .heavy))
                            .padding(2)
                    }
                    HStack(spacing: 60) {
                        //: Card exp.
                        VStack(alignment: .leading, spacing: 1) {
                            HStack {
                                Text("Exp.*")
                                    .foregroundColor(.white)
                                Spacer()
                                    .frame(width: 40)
                            }
                            ZStack {
                                HStack {
                                    TextField("", text: $expDate)
                                        .placeholer(when: expDate.isEmpty) {
                                            Text("x/xx")
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                        .padding()
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .foregroundColor(.red)
                                        .frame(width: 24, height: 24)
                                        .padding(.trailing, 5)
                                }
                            }
                            .frame(width: 150, height: 50)
                            .foregroundColor(.gray)
                            .background(Color("fieldGray").opacity(0.07))
                            .cornerRadius(10)
                            .padding(.top, 10)
                            Text("Please fill out an exp date.")
                                .foregroundColor(.red)
                                .font(.system(size: 12, weight: .heavy))
                                .padding(2)
                        }
                        //: Card security code
                        VStack(alignment: .leading, spacing: 1) {
                            HStack {
                                Text("Security Code*")
                                    .foregroundColor(.white)
                                Spacer()
                                    .frame(width: 40)
                            }
                            ZStack {
                                HStack {
                                    TextField("", text: $secCode)
                                        .placeholer(when: secCode.isEmpty) {
                                            Text("xxx")
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                        .padding()
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .foregroundColor(.red)
                                        .frame(width: 24, height: 24)
                                        .padding(.trailing, 5)
                                }
                            }
                            .frame(width: 150, height: 50)
                            .foregroundColor(.gray)
                            .background(Color("fieldGray").opacity(0.07))
                            .cornerRadius(10)
                            .padding(.top, 10)
                            Text("This security code is not valid")
                                .foregroundColor(.red)
                                .font(.system(size: 12, weight: .heavy))
                                .padding(2)
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    //: pass data to the next view
                    localData.summaryItemHolder.forEach { result in
                        Task {
                            try await firestoreToFetchUserinfo.updateUserInformationAsync(uidPath: firebaseAuth.getUID(), roomID: result.roomUID ?? "NA", roomImage: result.roomImage ?? "NA", roomAddress: result.roomAddress, roomTown: result.roomTown, roomCity: result.roomCity, roomPrice: String(result.itemPrice), roomZipCode: result.roomZipCode ?? "")
                        }
                    }
                    print("test")
                } label: {
                    Text("Pay")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .heavy))
                        .frame(width: 343, height: 50)
                        .background(Color("buttonBlue"))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                
                Spacer()
            }
            .padding()
        }
        //.navigationBarHidden(true)
        //.navigationBarBackButtonHidden(true)
    }
}

struct CardTextField: View {
    
    @State var dataHolder = ""
    //@State var holderName = ""
    
    var body: some View {
        ZStack {
            TextField("", text: $dataHolder)
                .placeholer(when: dataHolder.isEmpty) {
                    Text("Card Holder Name")
                        .foregroundColor(.white)
                }
                .padding()
        }
        .modifier(customTextField())
    }
}


struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView()
    }
}
