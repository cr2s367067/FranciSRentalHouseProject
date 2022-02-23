
import Foundation
import SwiftUI

func convertString(input: String) -> String {
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
func sumupCompute(adjustId: String, fixArray: [Int]) -> Int {
    var sumNum = 0
    let tempArray = zip(adjustId, fixArray).map {
        Int($0.description)! * $1
    }
    tempArray.forEach { data in
        sumNum += data
    }
    return sumNum
}

func idChecker(id: String) {
    let idenNum = id[id.index(id.startIndex, offsetBy: 9)]
    let fixIndex = [1, 9, 8, 7, 6, 5, 4, 3, 2, 1]
    var stringHolder = convertString(input: id)
    stringHolder.removeLast()
    let sumupResult = sumupCompute(adjustId: stringHolder, fixArray: fixIndex)
    let remider = sumupResult % 10
    let outputNum = 10 - remider
    if String(idenNum) == String(outputNum) {
        print("True")
    } else {
        print("Please check your id again.")
    }
}


idChecker(id: "A214501746")

