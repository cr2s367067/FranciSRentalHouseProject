//
//  PwdManager.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/12.
//

import Foundation

class PwdManager: ObservableObject {
    
    func passwordChecker(password: String) throws {
        let convertInt = Int(password.count)
        print(convertInt)
        guard convertInt >= 8 else {
            throw SignUpError.passwordIstooShort
        }
        let symbols = "@!#$^%&*"
        let pwdCheck = password.contains { char in
            print("upperCheck: \(char)")
            if char.isUppercase {
                print("is uppercase")
                return true
            }
            return false
        }
        let symbol = password.contains { char in
            print("symbolCheck: \(char)")
            for sym in symbols {
                if sym == char {
                    print("has symbol")
                    return true
                }
            }
            return false
        }
        print(symbol)
        print(pwdCheck)
        guard symbol == true && pwdCheck == true else {
            throw SignUpError.passwordIsNotValid
        }
    }
    
    func lengthCheck(password: String) -> Bool {
        let convertInt = Int(password.count)
        print(convertInt)
        guard convertInt >= 8 else {
           return false
        }
        return true
    }
    
    func symbolCheck(password: String) -> Bool {
        let symbols = "@!#$^%&*"
        let symbol = password.contains { char in
            print("symbolCheck: \(char)")
            for sym in symbols {
                if sym == char {
                    print("has symbol")
                    return true
                }
            }
            return false
        }
        return symbol
    }
    
    func upperCheck(password: String) -> Bool {
        let pwdCheck = password.contains { char in
            print("upperCheck: \(char)")
            if char.isUppercase {
                print("is uppercase")
                return true
            }
            return false
        }
        return pwdCheck
    }
    
}
