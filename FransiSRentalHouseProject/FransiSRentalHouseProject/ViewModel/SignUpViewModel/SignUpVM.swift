//
//  SignUpVM.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/24.
//

import Foundation

class SignUpVM: ObservableObject {
    @Published var emailAddress = ""
    @Published var userPassword = ""
    @Published var recheckPassword = ""
    @Published var userType = ""
    @Published var isProvider = false
    @Published var isProductProvider = false
    @Published var isRentalM = false
    @Published var isRenter = false
    
    //MARK: - Provider emp status
    @Published var isFounder = false
    @Published var isEmployee = false
    
    @Published var isAgree = false
    @Published var providerType = ""
    
    //MARK: - Provider GUI
    @Published var gui = ""
    
    //MARK: - Rental License
    @Published var rentalManagerLicenseNumber = ""

    func passwordCheckAndSignUpAsync(email: String, password: String, confirmPassword: String) async throws {
        guard !email.isEmpty else {
            throw SignUpError.emailIsEmpty
        }
        guard !password.isEmpty else {
            throw SignUpError.passwordIsEmpty
        }
        guard !confirmPassword.isEmpty else {
            throw SignUpError.confirmPasswordIsEmpty
        }
        guard password.count >= 6 else {
            throw SignUpError.passwordIstooShort
        }
        guard isProvider == true || isRenter == true else {
            throw SignUpError.missingUserType
        }
        guard password == confirmPassword else {
            throw SignUpError.passwordAndConfirmIsNotMatch
        }
        if isProvider == true {
            guard isProductProvider == true || isRentalM == true else {
                throw SignUpError.providerTypeError
            }
            if isRentalM == true {
                guard !rentalManagerLicenseNumber.isEmpty else {
                    throw SignUpError.licenseEnterError
                }
                guard rentalManagerLicenseNumber.count == 9 else {
                    throw SignUpError.licenseNumberLengthError
                }
            }
        }
        guard isAgree == true else {
            throw SignUpError.termofServiceIsNotAgree
        }
    }
}
