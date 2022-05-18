//
//  CustomToggleView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/9.
//

import SwiftUI
import MetricKit

struct CustomToggleView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    
    enum ToggleLabel: String {
        case lodge = "Lodge"
        case goods = "Goods"
        
    }
    
    @Binding var isOn: Bool
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.gray)
                .frame(width: 68, height: 30, alignment: .center)
            Image(systemName: isOn ? "house" : "bag")
                .foregroundColor(.white)
                .background(alignment: .center) {
                    Circle()
                        .fill(Color("buttonBlue"))
                        .frame(width: 68, height: 30, alignment: .center)
                }
                .offset(x: isOn ? -19 : 19)
                .animation(.linear, value: 0.1)
            HStack {
                Text(LocalizedStringKey(ToggleLabel.lodge.rawValue))
                Spacer()
                Text(LocalizedStringKey(ToggleLabel.goods.rawValue))
            }
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .frame(width: uiScreenWidth / 2, height: 30, alignment: .center)
            .accessibilityIdentifier("presentTitle")
        }
    }
}

struct CustomToggleView_Previews: PreviewProvider {
    static var previews: some View {
        CustomToggleView(isOn: .constant(false))
        TestView2()
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            CustomToggleView(isOn: configuration.$isOn)
        }
    }
}

struct TestView2: View {
    @State var isOn = false
    var body: some View {
        VStack {
            Toggle("", isOn: $isOn)
                .toggleStyle(CustomToggleStyle())
        }
    }
}
