//
//  PaymentSummaryView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct PaymentSummaryView: View {
    
    //    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    
    @State var tosAgree = false
    @State var autoPayAgree = false
    @State var showErrorAlert = false
    
    var body: some View {
        ZStack {
            //            Group {
            //                Image("room")
            //                    .resizable()
            //                    .blur(radius: 10)
            //                    .aspectRatio(contentMode: .fill)
            //                    .frame(width: 428, height: 926)
            //                    .offset(x: -40)
            //                    .clipped()
            //                Rectangle()
            //                    .fill(.gray)
            //                    .blendMode(.multiply)
            //            }
            //            .edgesIgnoringSafeArea([.top, .bottom])
            Rectangle()
                .fill(Color("backgroundBrown"))
                .ignoresSafeArea(.all)
            VStack {
                TitleAndDivider(title: "Summary")
                SummaryItems()
                AppDivider()
                HStack {
                    Text("Total Price")
                    Spacer()
                        .frame(width: 200)
                    Text("\(localData.sumPrice)")
                }
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .regular))
                .padding()
                
                Spacer()
                    .frame(height: 180)
                
                
                VStack(alignment: .center, spacing: 30) {
                    //: Term Agreemnet
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Button {
                                tosAgree.toggle()
                            } label: {
                                Image(systemName: tosAgree ? "checkmark.square.fill" : "checkmark.square")
                                    .foregroundColor(tosAgree ? .green : .white)
                                    .padding(.trailing, 5)
                            }
                            Text("I have read and agree the terms of Service.")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .medium))
                        }
                        HStack {
                            Button {
                                autoPayAgree.toggle()
                            } label: {
                                Image(systemName: autoPayAgree ? "checkmark.square.fill" : "checkmark.square")
                                    .foregroundColor(autoPayAgree ? .green : .white)
                                    .padding(.trailing, 5)
                            }
                            Text("The rent payment will automatically pay\n monthly until the expired day.")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .medium))
                        }
                    }
                    if tosAgree == true && autoPayAgree == true {
                        NavigationLink {
                            //: pass data to the next view
                            RenterContractView()
                        } label: {
                            Text("Confirm")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .heavy))
                                .frame(width: 343, height: 50)
                                .background(Color("buttonBlue"))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                    } else {
                        Button {
                            showErrorAlert.toggle()
                        } label: {
                            Text("Confirm")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .heavy))
                                .frame(width: 343, height: 50)
                                .background(Color.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .alert(isPresented: $showErrorAlert) {
                                    Alert(title: Text("Notice"), message: Text("Please check the terms of service and payment checkbox."), dismissButton: .default(Text("Sure")))
                                }
                        }
                    }
                }
            }
        }
    }
}



struct PaymentSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentSummaryView()
    }
}
