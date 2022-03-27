//
//  ProviderProfileView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ProviderProfileView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    @Binding var show: Bool
    
    init(show: Binding<Bool>) {
        self._show = show
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            self.show.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.leading)
                .padding(.top)
                TitleAndDivider(title: "My Profile")
                HStack(spacing: 20) {
                    Spacer()
                    Image(systemName: "chart.bar.xaxis")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
                    Image(systemName: "chart.xyaxis.line")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
                }
                .padding(.trailing)
                ProviderBarChartView()
//                Rectangle()
//                    .fill(Color("fieldGray"))
//                    .frame(width: 378, height: 304)
//                    .cornerRadius(10)
                
                TitleAndDivider(title: "Detail")
                VStack {
                    OwnerProfileDetailUnit()
                    OwnerProfileDetailUnit()
                    OwnerProfileDetailUnit()
                }
                AppDivider()
                HStack {
                    Text("Total Earning")
                    Spacer()
                    Text("$27,000")
                }
                .foregroundColor(.white)
                .frame(width: 350)
                .padding()
                Spacer()
            }
        }
        .background(alignment: .center, content: {
            Group {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
            }
            .edgesIgnoringSafeArea([.top, .bottom])
        })
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct OwnerProfileDetailUnit: View {
    var body: some View {
        HStack {
            Text("Rental Price")
            Spacer()
            Text("$9,000")
        }
        .foregroundColor(.white)
        .frame(width: 350)
        .padding()
    }
}

//struct ProviderProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProviderProfileView()
//    }
//}
