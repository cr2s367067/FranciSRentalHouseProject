//
//  CustomProgressView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/7.
//

import SwiftUI

struct CustomProgressView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color("background2").opacity(0.7)
                .blur(radius: 1)
                .ignoresSafeArea(.all)
            VStack {
                ProgressView("Uploading please wait...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white)
                    .frame(width: uiScreenWidth / 2, height: uiScreenHeight / 6, alignment: .center)
                    .background(colorScheme == .dark ? .gray.opacity(0.5) : Color.black.opacity(0.6))
                    .cornerRadius(20)
                    .accessibilityIdentifier("process")
            }
        }
    }
}




struct UploadProgressView: View {
    var body: some View {
        VStack {
            ProgressView("Uploading...")
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .foregroundColor(.white)
                .font(.system(size: 15))
                .background(alignment: .center) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.black.opacity(0.4))
                }
        }
        .padding()
    }
}


struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        UploadProgressView()
            .preferredColorScheme(.dark)
    }
}
