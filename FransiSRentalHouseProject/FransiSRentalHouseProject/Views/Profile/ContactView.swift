//
//  ContactView.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import SwiftUI

struct ContactView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var firestoreForContactInfo: FirestoreForContactInfo
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @Environment(\.colorScheme) var colorScheme
    
    @State var contactDes = ""
    @State private var isSent = false
    @FocusState private var isFocused: Bool
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    TitleAndDivider(title: "Have any question?")
                    HStack {
                        Text("Tell Us 🤓")
                            .foregroundColor(.white)
                            .font(.title3)
                        Spacer()
                    }
                    VStack {
                        TextEditor(text: $contactDes)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: uiScreenWidth - 50, height: uiScreenHeight / 2 + 100)
                        
                    }
                    .padding()
                    .frame(width: uiScreenWidth - 30, height: uiScreenHeight / 2 + 120)
                    .background(alignment: .center) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(colorScheme == .dark ? .gray.opacity(0.5) : .black.opacity(0.5))
                    }
                    HStack {
                        Spacer()
                        if isSent {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                                .font(.system(size: 20))
                        }
                        Button {
                            Task {
                                do {
                                    if !contactDes.isEmpty {
                                        isSent = true
                                        try await firestoreForContactInfo.summitContactInfoAsync(question: contactDes, uidPath: firebaseAuth.getUID())
                                        reset()
                                    }
                                } catch {
                                    self.errorHandler.handle(error: error)
                                }
                            }
                        } label: {
                            Text("Send it!")
                                .modifier(ButtonModifier())
                        }
                    }
                    
                }
            }
            .onTapGesture {
                isFocused = false
            }
        }
        .modifier(ViewBackgroundInitModifier())
    }
}

extension ContactView {
    
    private func reset() {
        contactDes = ""
        isSent = false
    }
    
}
