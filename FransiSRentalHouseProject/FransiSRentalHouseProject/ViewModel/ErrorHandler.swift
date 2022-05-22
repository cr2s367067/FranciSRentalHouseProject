//
//  ErrorHandler.swift
//  FransiSRentalHouseProject
//
//  Created by JerryHuang on 2/23/22.
//

import Foundation
import SwiftUI
import FirebaseCrashlytics

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
    case passwordIsNotValid
    
    var errorDescription: String?  {
        switch self {
        case .emailIsEmpty:
            return NSLocalizedString("Email address is missing", comment: "")
        case .passwordIsEmpty:
            return NSLocalizedString("Please fill in the paassword", comment: "")
        case .confirmPasswordIsEmpty:
            return NSLocalizedString("Please fill in the password", comment: "")
        case .passwordIstooShort:
            return NSLocalizedString("Password should be longer then 8 character", comment: "")
        case .termofServiceIsNotAgree:
            return NSLocalizedString("Please check the Term of Service", comment: "")
        case .missingUserType:
            return NSLocalizedString("Please select the Owner/Renter", comment: "")
        case .passwordAndConfirmIsNotMatch:
            return NSLocalizedString("Please check the confirm password", comment: "")
        case .creationError:
            return NSLocalizedString("The account could not create", comment: "")
        case .providerTypeError:
            return NSLocalizedString("Please select provider type", comment: "")
        case .licenseEnterError:
            return NSLocalizedString("Please fill out the license number", comment: "")
        case .licenseNumberLengthError:
            return NSLocalizedString("Please recheck license number", comment: "")
        case .passwordIsNotValid:
            return NSLocalizedString("Please recheck password.", comment: "")
        }
    }
}

//enum StarUpError: LocalizedError {
//    case userInfoError
//    
//    var errorDescription: String? {
//        switch self {
//        case .userInfoError:
//            return NSLocalizedString("Hi, please filling up necessary user info first thanks.", comment: "")
//        }
//    }
//}

enum UserInformationError: LocalizedError {
    case idFormateError
    case invalidID
    case genderIsNotSelected
    case mobileNumberFormateError
    case dobFormateError
    case blankError
    case userRentalError
    case roomSelectedError
    case chartError
    case registeError
    case guiFormatError

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
        case .roomSelectedError:
            return NSLocalizedString("Hi, You haven't select any product.", comment: "")
        case .chartError:
            return NSLocalizedString("Please select something🥸", comment: "")
        case .registeError:
            return NSLocalizedString("Hi, I know you love it, but you have to fill out the user infomation first.😉", comment: "")
        case .guiFormatError:
            return NSLocalizedString("Hi, GUI formate is not correct", comment: "")
        }
    }
}

enum RentalError: LocalizedError {
    case rentedError
    
    var errorDescription: String? {
        switch self {
        case .rentedError:
            return NSLocalizedString("Un, you havn rented one, do you need more? Contact us.", comment: "")
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
    case imageSelectedError
    case productAmountError
    case productPriceError
    case productTypeError
    
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
        case .imageSelectedError:
            return NSLocalizedString("Please provide the image for user to check out", comment: "")
        case .productAmountError:
            return NSLocalizedString("Could not be 0", comment: "")
        case .productPriceError:
            return NSLocalizedString("Could not be 0", comment: "")
        case .productTypeError:
            return NSLocalizedString("Please select types for this product.", comment: "")
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

enum BillError: LocalizedError {
    case shippedError
    case cancelError
    
    var errorDescription: String? {
        switch self {
        case .shippedError:
            return NSLocalizedString("Sorry, product is shipped out, please contact product provider, for canceling to refund.", comment: "")
        case .cancelError:
            return NSLocalizedString("Sorry, you have been cancel this order", comment: "")
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

enum PurchaseError: LocalizedError {
    case blankError
    
    var errorDescription: String? {
        switch self {
        case .blankError:
            return NSLocalizedString("Please fill out payment infomation, thanks.", comment: "")
        }
    }
}

enum SettlementError: LocalizedError {
    case settlementResultError
    case historyFetchingError
    case settlementDateError
    case closeAccountError
    
    var errorDescription: String? {
        switch self {
        case .settlementResultError:
            return NSLocalizedString("Please compute amount first.", comment: "")
        case .historyFetchingError:
            return NSLocalizedString("Hi you have already fetched data.", comment: "")
        case .settlementDateError:
            return NSLocalizedString("Hi, Today is not settlement date.", comment: "")
        case .closeAccountError:
            return NSLocalizedString("Hi, Account is closed, you couldn't change it.", comment: "")
        }
    }
}

enum BioAuthError: LocalizedError {
    case deviceError
    case evaluateError
    
    var errorDescription: String? {
        switch self {
        case .deviceError:
            return NSLocalizedString("Sorry, please check your device is supported bio authentication or not.", comment: "")
        case .evaluateError:
            return NSLocalizedString("Sorry, fail to access account. please type username and password try again.", comment: "")
        }
    }
}

enum EncryptError: LocalizedError {
    case encryptError
    case decryptError
    
    var errorDescription: String? {
        switch self {
        case .encryptError:
            return NSLocalizedString("Fail to encrypt", comment: "")
        case .decryptError:
            return NSLocalizedString("Fail to decrypt", comment: "")
        }
    }
}

enum ECpayAPIError: LocalizedError {
    case invalidServerResponse
    case invalidFetchingJsonData
    
    var errorDescription: String? {
        switch self {
        case .invalidServerResponse:
            return NSLocalizedString("Fail to connect to the target server", comment: "")
        case .invalidFetchingJsonData:
            return NSLocalizedString("Fail to fetch the json data from target server", comment: "")
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
    
    func handle(error: Error, dismissAction: (() -> Void)? = nil) {
        dismissAction?()
        Crashlytics.crashlytics().record(error: error)
        currentAlert = ErrorAlert(message: error.localizedDescription)
    }
}


