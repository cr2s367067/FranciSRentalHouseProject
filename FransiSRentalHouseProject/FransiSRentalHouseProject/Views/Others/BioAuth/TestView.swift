//
//  TestView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/18.
//

import SwiftUI

struct TestView: View {
    
    @State private var test = ""
    
    var body: some View {
        TabView {        
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(0..<100) { data in
                        Text("\(data)")
                    }
                }
                Spacer()
                HStack {
                    Image(systemName: "paperplane")
                    TextField("test field", text: $test)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .padding()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
