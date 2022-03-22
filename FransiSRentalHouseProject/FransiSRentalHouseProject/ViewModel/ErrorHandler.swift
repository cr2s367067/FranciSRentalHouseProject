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
    case providerTypeError
    case licenseEnterError
    case licenseNumberLengthError
    
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
        case .providerTypeError:
            return NSLocalizedString("Please select house owner/Rental Manager", comment: "")
        case .licenseEnterError:
            return NSLocalizedString("Please fill out the license number", comment: "")
        case .licenseNumberLengthError:
            return NSLocalizedString("Please recheck license number", comment: "")
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
    case userRentalError
    case purchaseError

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
        case .userRentalError:
            return NSLocalizedString("You haven't rent any room.", comment: "")
        case .purchaseError:
            return NSLocalizedString("Hi, You haven't select any product.", comment: "")
        }
    }
}

enum ProviderSummitError: LocalizedError {
    case holderNameError
    case holderMobileNumberFormateError
    case roomAddressError
    case roomTownError
    case roomCityError
    case roomZipCodeError
    case roomRentalPriceError
    case roomAreaError
    case blankError
    case tosAgreementError
    case roomImageError
    
    var errorDescription: String? {
        switch self {
        case .holderNameError:
            return NSLocalizedString("Holder Name shouldn't be empty.", comment: "")
        case .holderMobileNumberFormateError:
            return NSLocalizedString("Mobile Number's formate is not correct.", comment: "")
        case .roomAddressError:
            return NSLocalizedString("Room address shouldn't be empty.", comment: "")
        case .roomTownError:
            return NSLocalizedString("Town Name shouldn't be empty.", comment: "")
        case .roomZipCodeError:
            return NSLocalizedString("Zip Code shouldn't be empty.", comment: "")
        case .roomRentalPriceError:
            return NSLocalizedString("Rental fee shouldn't be empty.", comment: "")
        case .blankError:
            return NSLocalizedString("Please fill out the blank.", comment: "")
        case .roomCityError:
            return NSLocalizedString("Town Name shouldn't be empty.", comment: "")
        case .roomAreaError:
            return NSLocalizedString("Please fill in room area.", comment: "")
        case .tosAgreementError:
            return NSLocalizedString("Please read term of service.", comment: "")
        case .roomImageError:
            return NSLocalizedString("Please provide the room image.", comment: "")
        }
    }
}

enum ContractError: LocalizedError {
    case agreemnetError
    
    var errorDescription: String? {
        switch self {
        case .agreemnetError:
            return NSLocalizedString("Please, read and agree the contract.", comment: "")
        }
    }
}

enum StorageUploadError: LocalizedError {
    case imageURLfetchingError
    
    var errorDescription: String? {
        switch self {
        case .imageURLfetchingError:
            return NSLocalizedString("Cannot fetch the image path, please try again", comment: "")
        }
    }
}

enum MaintainError: LocalizedError {
    case maintianFillingError
    
    var errorDescription: String? {
        switch self {
        case .maintianFillingError:
            return NSLocalizedString("Please fill out the maintain infomation, thanks", comment: "")
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


