//
//  LoginVM.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/23.
//

import Foundation


class LoginVM: ObservableObject {
    @Published var emailAddress: String
    @Published var userPassword: String
    @Published var currentNonce: String?
    
    init(emailAddress: String, userPassword: String) {
        self.emailAddress = emailAddress
        self.userPassword = userPassword
    }
}
