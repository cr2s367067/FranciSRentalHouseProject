//
//  ProfileSessionUnit.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ProfileSessionUnit: View {
    
    var mainTainTask: MaintainDM
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("fieldGray"))
                .cornerRadius(5)
                .frame(width: uiScreenWidth - 80, height: 50)
            HStack {
                Text(mainTainTask.maintainDescription)
                    .foregroundColor(Color("sessionBackground"))
                    .font(.system(size: 16, weight: .heavy))
                Spacer()
//                    .frame(width: 90)
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 15, weight: .heavy))
            }
            .padding()
            .frame(width: uiScreenWidth - 80, height: 50)
        }
    }
}
