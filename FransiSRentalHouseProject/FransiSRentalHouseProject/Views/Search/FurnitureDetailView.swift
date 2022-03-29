//
//  FurnitureDetailView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct FurnitureDetailView: View {
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    @State private var mark = false
    
    var productName: String
    var productPrice: String
    var productDescription: String
    var productImage: String
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    mark.toggle()
                } label: {
                     Image(systemName: "bookmark.circle")
                        .resizable()
                        .foregroundColor(mark ? .orange : .white)
                        .frame(width: 35, height: 35)
                        .padding(.trailing)
                }
            }
            Spacer()
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Text(productName)
                        .foregroundColor(.white)
                        .font(.system(size: 35, weight: .bold))
                    Spacer()
                    Group {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("4.7")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .padding()
                        .frame(width: 90, height: 30, alignment: .center)
                        .background(alignment: .trailing) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.4), radius: 5)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                HStack {
                    Text("Description")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
                VStack(alignment: .leading) {
                    ScrollView(.vertical, showsIndicators: true) {
                        HStack {
                            Text(productDescription)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
                Spacer()
                HStack {
                    Text("$ \(productPrice)")
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .bold))
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Add Cart")
                            .foregroundColor(.white)
                            .frame(width: 108, height: 35)
                            .background(Color("buttonBlue"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .frame(width: uiScreenWidth, height: uiScreenHeight / 2 + 40)
            .background(alignment: .center) {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(50, corners: [.topLeft, .topRight])
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(alignment: .center) {
            VStack {
                WebImage(url: URL(string: productImage))
                    .resizable()
                    .frame(width: uiScreenWidth, height: uiScreenHeight / 3 + 60, alignment: .top)
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

//struct FurnitureDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FurnitureDetailView()
//    }
//}



