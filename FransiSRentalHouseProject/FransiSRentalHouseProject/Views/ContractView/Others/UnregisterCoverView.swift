//
//  UnregisterCoverView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/20.
//

import SwiftUI

struct UnregisterCoverView: View {
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    @Binding var isShowUserDetailView: Bool
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Text("Notice")
                    .font(.headline)
                    .foregroundColor(.black)
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    .resizable()
                    .foregroundColor(Color.gray)
                    .frame(width: 80, height: 50, alignment: .center)
                Text("Please fill out the user information, thanks")
                    .foregroundColor(.black)
                    .font(.body)
                    .fontWeight(.bold)
                Spacer()
                NavigationLink(isActive: $isShowUserDetailView) {
                    UserDetailInfoView()
                } label: {
                    Text("Let's do it.")
                        .foregroundColor(.white)
                        .frame(width: 108, height: 35)
                        .background(Color("buttonBlue"))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.trailing)
                }
            }
            .padding()
            .frame(width: uiScreenWidth / 2 + 30, height: uiScreenHeight / 4, alignment: .center)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(alignment: .center) {
            LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea([.top, .bottom])
        }
    }
}

// struct UnregisterCoverView_Previews: PreviewProvider {
//    static var previews: some View {
//        UnregisterCoverView(isShowUserDetailView: <#Binding<Bool>#>)
//    }
// }
