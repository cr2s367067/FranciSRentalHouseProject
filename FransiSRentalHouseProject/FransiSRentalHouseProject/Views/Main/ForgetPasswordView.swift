//
//  ForgetPasswordView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/12.
//

import SwiftUI

struct ForgetPasswordView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var bioAuthViewModel: BioAuthViewModel
    @EnvironmentObject var errorHandler: ErrorHandler

    @State private var email = ""
    @FocusState private var isFocus: Bool

    var body: some View {
        VStack {
            TitleAndDivider(title: "Forgot Password?")
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    cusField(imageName: "rectangle.and.pencil.and.ellipsis", fieldName: "E-mail Address", text: $email, fieldBool: email.isEmpty)
                    HStack {
                        Spacer()
                        Button {
                            Task {
                                do {
                                    try await firebaseAuth.resetPasswordAsync(email: email)
                                    bioAuthViewModel.faceIDEnable = false
                                    bioAuthViewModel.userNameBioAuth = ""
                                    bioAuthViewModel.passwordBioAuth = ""
                                } catch {
                                    self.errorHandler.handle(error: error)
                                }
                            }
                        } label: {
                            Text("Reset")
                        }
                        .modifier(ButtonModifier())
                    }
                    Spacer()
                }
                .modifier(SubViewBackgroundInitModifier())
                Spacer()
            }
        }
        .modifier(ViewBackgroundInitModifier())
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isFocus = false
                }
            }
        }
    }
}

struct ForgetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordView()
    }
}

extension ForgetPasswordView {
    @ViewBuilder
    func cusField(imageName: String, fieldName: String, text: Binding<String>, fieldBool: Bool) -> some View {
        HStack {
            Image(systemName: imageName)
                .padding(.leading)
            TextField("", text: text)
                .foregroundColor(.white)
                .placeholer(when: fieldBool) {
                    Text(fieldName)
                        .foregroundColor(.white.opacity(0.8))
                }
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .focused($isFocus)
        }
        .modifier(customTextField())
    }
}
