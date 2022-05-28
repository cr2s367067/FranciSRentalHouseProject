//
//  ProfileSessionUnit.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ProfileSessionUnit: View {
    
    var mainTainTask: MaintainTaskHolder
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("fieldGray"))
                .cornerRadius(5)
                .frame(width: 354, height: 51)
            HStack {
                Text(mainTainTask.description)
                    .foregroundColor(Color("sessionBackground"))
                    .font(.system(size: 16, weight: .heavy))
                Spacer()
//                    .frame(width: 90)
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 15, weight: .heavy))
            }
            .frame(width: 350, height: 50)
            .padding(.leading, 20)
            .padding(.trailing, 20)
        }
    }
}
