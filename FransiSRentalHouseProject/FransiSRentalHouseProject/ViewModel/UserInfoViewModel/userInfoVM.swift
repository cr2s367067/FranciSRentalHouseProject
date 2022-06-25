//
//  userInfoVM.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/23.
//

import Foundation
import SwiftUI

class UserInfoVM: ObservableObject {
    
    enum UserInfoStatus: String {
        case id ,firstName ,lastName ,displayName ,mobileNumber ,zipCode ,country, address, town, city, gender, isMale, isFemale, dob
    }
    
    @Published var isEdit = false
    @Published var isShowUserDetailView = false
    @Published var userInfo: UserDM = .empty
    
//    @AppStorage(UserInfoStatus.id.rawValue) var id = ""
//    @AppStorage(UserInfoStatus.firstName.rawValue) var firstName = ""
//    @AppStorage(UserInfoStatus.lastName.rawValue) var lastName = ""
//    @AppStorage(UserInfoStatus.displayName.rawValue) var nickName = ""
//    @AppStorage(UserInfoStatus.mobileNumber.rawValue) var mobileNumber = ""
//    @AppStorage(UserInfoStatus.dob.rawValue) var dob = Date()
    @AppStorage(UserInfoStatus.isMale.rawValue) var isMale = false
    @AppStorage(UserInfoStatus.isFemale.rawValue) var isFemale = false
//    @AppStorage(UserInfoStatus.address.rawValue) var address = ""
//    @AppStorage(UserInfoStatus.town.rawValue) var town = ""
//    @AppStorage(UserInfoStatus.city.rawValue) var city = ""
//    @AppStorage(UserInfoStatus.zipCode.rawValue) var zipCode = ""
//    @AppStorage(UserInfoStatus.country.rawValue) var country = "Taiwan"
//    @AppStorage(UserInfoStatus.gender.rawValue) var gender = ""
    
    func userInfoFormatterCheckerAsync(id: String, firstName: String, lastName: String, gender: String, mobileNumber: String, uType: SignUpType) throws {
        if uType == .isNormalCustomer {
            guard id.count == 10 else {
                throw UserInformationError.idFormateError
            }
            guard mobileNumber.count == 10 else {
                throw UserInformationError.mobileNumberFormateError
            }
            guard !gender.isEmpty else {
                throw UserInformationError.genderIsNotSelected
            }
            guard formatterChecker(id: id) == true else {
                throw UserInformationError.idFormateError
            }
            guard id.count == 10 && idChecker(id: id) == true else {
                throw UserInformationError.invalidID
            }
        }
        if uType == .isProvider {
            guard id.count == 8 else {
                throw UserInformationError.idFormateError
            }
            guard mobileNumber.count == 10 else {
                throw UserInformationError.mobileNumberFormateError
            }
        }
    }
    
    func formatterChecker(id: String) -> Bool {
        var isCorrect = false
        if id[id.startIndex] == "A" || id[id.startIndex] == "B" || id[id.startIndex] == "C" || id[id.startIndex] == "D" || id[id.startIndex] == "E" || id[id.startIndex] == "F" || id[id.startIndex] == "G" || id[id.startIndex] == "H" || id[id.startIndex] == "I" || id[id.startIndex] == "J" || id[id.startIndex] == "K" || id[id.startIndex] == "L" || id[id.startIndex] == "M" || id[id.startIndex] == "N" || id[id.startIndex] == "O" || id[id.startIndex] == "P" || id[id.startIndex] == "Q" || id[id.startIndex] == "R" || id[id.startIndex] == "S" || id[id.startIndex] == "T" || id[id.startIndex] == "U" || id[id.startIndex] == "V" || id[id.startIndex] == "X" || id[id.startIndex] == "Y" {
            isCorrect = true
        }
        return isCorrect
    }
    
    func idChecker(id: String) -> Bool {
        lazy var idenNum = id[id.index(id.startIndex, offsetBy: 9)]
        let fixIndex = [1, 9, 8, 7, 6, 5, 4, 3, 2, 1]
        var stringHolder = convertString(input: id)
        stringHolder.removeLast()
        let sumupResult = sumupCompute(adjustId: stringHolder, fixArray: fixIndex)
        let remider = sumupResult % 10
        let outputNum = 10 - remider
        if String(idenNum) == String(outputNum) {
            return true
        } else {
            return false
        }
    }
    
    private func convertString(input: String) -> String {
        let tempHolder = input
        var replaceString = ""
        input.forEach { char in
            switch char {
            case "A":
                let _replaceString = tempHolder.replacingOccurrences(of: "A", with: "10")
                replaceString = _replaceString
            case "B":
                let _replaceString = tempHolder.replacingOccurrences(of: "B", with: "11")
                replaceString = _replaceString
            case "C":
                let _replaceString = tempHolder.replacingOccurrences(of: "C", with: "12")
                replaceString = _replaceString
            case "D":
                let _replaceString = tempHolder.replacingOccurrences(of: "D", with: "13")
                replaceString = _replaceString
            case "E":
                let _replaceString = tempHolder.replacingOccurrences(of: "E", with: "14")
                replaceString = _replaceString
            case "F":
                let _replaceString = tempHolder.replacingOccurrences(of: "F", with: "15")
                replaceString = _replaceString
            case "G":
                let _replaceString = tempHolder.replacingOccurrences(of: "G", with: "16")
                replaceString = _replaceString
            case "H":
                let _replaceString = tempHolder.replacingOccurrences(of: "H", with: "17")
                replaceString = _replaceString
            case "I":
                let _replaceString = tempHolder.replacingOccurrences(of: "I", with: "34")
                replaceString = _replaceString
            case "J":
                let _replaceString = tempHolder.replacingOccurrences(of: "J", with: "18")
                replaceString = _replaceString
            case "K":
                let _replaceString = tempHolder.replacingOccurrences(of: "K", with: "19")
                replaceString = _replaceString
            case "L":
                let _replaceString = tempHolder.replacingOccurrences(of: "L", with: "20")
                replaceString = _replaceString
            case "M":
                let _replaceString = tempHolder.replacingOccurrences(of: "M", with: "21")
                replaceString = _replaceString
            case "N":
                let _replaceString = tempHolder.replacingOccurrences(of: "N", with: "22")
                replaceString = _replaceString
            case "O":
                let _replaceString = tempHolder.replacingOccurrences(of: "O", with: "35")
                replaceString = _replaceString
            case "P":
                let _replaceString = tempHolder.replacingOccurrences(of: "P", with: "23")
                replaceString = _replaceString
            case "Q":
                let _replaceString = tempHolder.replacingOccurrences(of: "Q", with: "24")
                replaceString = _replaceString
            case "R":
                let _replaceString = tempHolder.replacingOccurrences(of: "R", with: "25")
                replaceString = _replaceString
            case "S":
                let _replaceString = tempHolder.replacingOccurrences(of: "S", with: "26")
                replaceString = _replaceString
            case "T":
                let _replaceString = tempHolder.replacingOccurrences(of: "T", with: "27")
                replaceString = _replaceString
            case "U":
                let _replaceString = tempHolder.replacingOccurrences(of: "U", with: "28")
                replaceString = _replaceString
            case "V":
                let _replaceString = tempHolder.replacingOccurrences(of: "V", with: "29")
                replaceString = _replaceString
            case "X":
                let _replaceString = tempHolder.replacingOccurrences(of: "X", with: "30")
                replaceString = _replaceString
            case "Y":
                let _replaceString = tempHolder.replacingOccurrences(of: "Y", with: "31")
                replaceString = _replaceString
            default:
                break
            }
        }
        return replaceString
    }
    private func sumupCompute(adjustId: String, fixArray: [Int]) -> Int {
        var sumNum = 0
        let tempArray = zip(adjustId, fixArray).map {
            Int($0.description)! * $1
        }
        tempArray.forEach { data in
            sumNum += data
        }
        return sumNum
    }
    
}
