//
//  PaymentSummaryView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct PaymentSummaryView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var localData: LocalData
    
    
    @State var showErrorAlert = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
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
                                appViewModel.paymentSummaryTosAgree.toggle()
                            } label: {
                                Image(systemName: appViewModel.paymentSummaryTosAgree ? "checkmark.square.fill" : "checkmark.square")
                                    .foregroundColor(appViewModel.paymentSummaryTosAgree ? .green : .white)
                                    .padding(.trailing, 5)
                            }
                            Text("I have read and agree the terms of Service.")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .medium))
                        }
                        HStack {
                            Button {
                                appViewModel.paymentSummaryAutoPayAgree.toggle()
                            } label: {
                                Image(systemName: appViewModel.paymentSummaryAutoPayAgree ? "checkmark.square.fill" : "checkmark.square")
                                    .foregroundColor(appViewModel.paymentSummaryAutoPayAgree ? .green : .white)
                                    .padding(.trailing, 5)
                            }
                            Text("The rent payment will automatically pay\n monthly until the expired day.")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .medium))
                        }
                    }
                    if appViewModel.paymentSummaryTosAgree == true && appViewModel.paymentSummaryAutoPayAgree == true {
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
