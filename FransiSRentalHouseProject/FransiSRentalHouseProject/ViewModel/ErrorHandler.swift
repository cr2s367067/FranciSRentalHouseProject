//
//  ErrorHandler.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import Foundation
import SwiftUI

enum SignUpError: LocalizedError {
    case emailIsEmpty
    case passwordIsEmpty
    case confirmPasswordIsEmpty
    case passwordIstooShort
    case termofServiceIsNotAgree
    case missingUserType
    case passwordAndConfirmIsNotMatch
    case creationError
    
    var errorDescription: String?  {
        switch self {
        case .emailIsEmpty:
            return NSLocalizedString("Email address is missing", comment: "")
        case .passwordIsEmpty:
            return NSLocalizedString("Please fill in the paassword", comment: "")
        case .confirmPasswordIsEmpty:
            return NSLocalizedString("Please fill in the password", comment: "")
        case .passwordIstooShort:
            return NSLocalizedString("Password should be longer then 6 character", comment: "")
        case .termofServiceIsNotAgree:
            return NSLocalizedString("Please check the Term of Service", comment: "")
        case .missingUserType:
            return NSLocalizedString("Please select the Owner/Renter", comment: "")
        case .passwordAndConfirmIsNotMatch:
            return NSLocalizedString("Please check the confirm password", comment: "")
        case .creationError:
            return NSLocalizedString("The account could not create", comment: "")
        }
    }
}

enum UserInformationError: LocalizedError {
    case idFormateError
    case invalidID
    case genderIsNotSelected
    case mobileNumberFormateError
    case dobFormateError
    case blankError

    var errorDescription: String? {
        switch self {
        case .idFormateError:
            return NSLocalizedString("ID Formate is not correct, please check it again.", comment: "")
        case .invalidID:
            return NSLocalizedString("ID is invalid, please check it again.", comment: "")
        case .genderIsNotSelected:
            return NSLocalizedString("Please select the gender.", comment: "")
        case .mobileNumberFormateError:
            return NSLocalizedString("Mobile Number is too long or short, please check it again.", comment: "")
        case .dobFormateError:
            return NSLocalizedString("Please enter valid date of birth", comment: "")
        case .blankError:
            return NSLocalizedString("Please fill out the blank", comment: "")
        }
    }
}

struct ErrorAlert: Identifiable {
    var id = UUID()
    var message: String
    var dismissAction: (() -> Void)?
}

class ErrorHandler: ObservableObject {
    @Published var currentAlert: ErrorAlert? = nil
    
    func handle(error: Error) {
        currentAlert = ErrorAlert(message: error.localizedDescription)
    }
}

