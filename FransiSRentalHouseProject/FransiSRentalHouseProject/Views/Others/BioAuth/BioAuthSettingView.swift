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
    @Environment(\.colorScheme) var colorScheme
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    @State private var showComfirmAlert = false
    @FocusState private var isFocus: Bool

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
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Section {
                        Toggle(isOn: $bioAuthViewModel.faceIDEnable) {
                            Text("Enable Face ID")
                                .foregroundColor(.primary)
                        }
                        if bioAuthViewModel.faceIDEnable {
                            TextField("UserName", text: $bioAuthViewModel.userNameBioAuth)
                                .foregroundColor(.primary)
                                .keyboardType(.emailAddress)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .focused($isFocus)
                            SecureField("Password", text: $bioAuthViewModel.passwordBioAuth)
                                .foregroundColor(.primary)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .focused($isFocus)
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
                                .foregroundColor(.primary)
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
                        .fill(colorScheme == .dark ? .gray.opacity(0.3) : .white)
                }
            }
            .onTapGesture {
                isFocus = false
            }
//            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            LinearGradient(gradient: Gradient(colors: [Color("background1"), Color("background2")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea([.top, .bottom])
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

//struct BioAuthSettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BioAuthSettingView()
//    }
//}
