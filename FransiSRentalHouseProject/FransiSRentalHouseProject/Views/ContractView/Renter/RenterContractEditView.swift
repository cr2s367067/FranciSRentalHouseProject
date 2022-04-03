//
//  RenterContractEditView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/2.
//

import SwiftUI

struct RenterContractEditView: View {
    
//    @EnvironmentObject var rentEditVM: RenterContractEditViewModel
    
    @State var test = ""
    @State var testToggle = false
    var body: some View {
        VStack {
            Form {
                TextField("出租人簽章", text: $test)
                TextField("出租人 (公司名稱)", text: $test)
                Section("主建物面積") {
                    TextField("專有部分建號", text: $test)
                    TextField("權利範圍", text: $test)
                    TextField("面積共計幾平方公尺", text: $test)
                }
                Section("附屬建物") {
                    TextField("附屬建物用途", text: $test)
                    TextField("面積幾平方公尺", text: $test)
                    TextField("權利範圍", text: $test)
                    TextField("面積共計幾平方公尺", text: $test)
                }
                Section("共有部分") {
                    TextField("共有部分建號", text: $test)
                    TextField("權利範圍", text: $test)
                    TextField("持分面積共計幾平方公尺", text: $test)
                }
                Section("設定他項權利") {
                    Toggle("有無他項權利", isOn: $testToggle)
                    if testToggle == true {
                        withAnimation(.easeInOut) {
                            TextField("權利種類", text: $test)
                        }
                    }
                }
                Section("租賃範圍") {
                    Toggle("租賃住宅全部", isOn: $testToggle)
                    if testToggle == true {
                        withAnimation(.easeInOut) {
                            roomsInfoTextFields()
                        }
                        
                    }
                    Toggle("租賃住宅部分", isOn: $testToggle)
                    if testToggle == true {
                        withAnimation(.easeInOut) {
                            roomsInfoTextFields()
                        }
                    }
                }
            }
        }
        .background(alignment: .center) {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom))
                .edgesIgnoringSafeArea([.top, .bottom])
        }
        .navigationTitle("Contract Edit Mode")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RenterContractEditView_Previews: PreviewProvider {
    static var previews: some View {
        RenterContractEditView()
    }
}

extension RenterContractEditView {
    @ViewBuilder
    func roomsInfoTextFields() -> some View {
        TextField("房間數", text: $test)
        TextField("第幾室", text: $test)
        TextField("面積幾平方公尺", text: $test)
    }
}
//
//struct ContractDataList: View {
//    @Binding var consData: RentersContractDataModel
//    var body: some View {
//        VStack {
//            Text("test")
//        }
//    }
//}
