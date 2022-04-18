//
//  BioAuthSettingView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/18.
//

import SwiftUI

struct BioAuthSettingView: View {
    @EnvironmentObject var bioAuthViewModel: BioAuthViewModel
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var errorHandler: ErrorHandler
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    @State private var showComfirmAlert = false

    func cancel() {
        bioAuthViewModel.userNameBioAuth = ""
        bioAuthViewModel.passwordBioAuth = ""
        bioAuthViewModel.faceIDEnable = false
        showComfirmAlert = false
    }
    
    func comfirm() {
        showComfirmAlert = false
        do {
            try firebaseAuth.signOutAsync()
        } catch {
            self.errorHandler.handle(error: error)
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                Section {
                    Toggle(isOn: $bioAuthViewModel.faceIDEnable) {
                        Text("Enable Face ID")
                            .foregroundColor(.black)
                    }
                    if bioAuthViewModel.faceIDEnable {
                        TextField("UserName", text: $bioAuthViewModel.userNameBioAuth)
                            .foregroundColor(.black)
                        SecureField("Password", text: $bioAuthViewModel.passwordBioAuth)
                            .foregroundColor(.black)
                        Button {
                            showComfirmAlert.toggle()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Comfirm")
                                    .foregroundColor(.white)
                                    .frame(width: 90, height: 35)
                                    .background(Color("buttonBlue"))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .alert("Notice", isPresented: $showComfirmAlert) {
                            HStack {
                                Button {
                                    cancel()
                                } label: {
                                    Text("Cancel")
                                }
                                Button {
                                    comfirm()
                                } label: {
                                    Text("Comfirm")
                                }
                            }
                        } message: {
                            Text("When you comfirm, system will sign up and use bio authtication to sign in.")
                        }

                    }
                } header: {
                    HStack {
                        Text("Security Setting")
                            .foregroundColor(.black)
                            .font(.system(size: 22, weight: .bold))
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding()
            .frame(width: uiScreenWidth - 30, height: uiScreenHeight - 200 )
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea([.top, .bottom])
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct BioAuthSettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BioAuthSettingView()
//    }
//}
