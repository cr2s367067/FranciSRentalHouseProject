//
//import Foundation
//import SwiftUI
//
//struct Test1 {
//    var someString: String
//}
//
//struct TestArray: Identifiable {
//    var id = UUID()
//    var stringStruct: [Test1]
//}
//
//
//let testArray: [TestArray] = [
//    TestArray(stringStruct: [
//        Test1(someString: "a"),
//        Test1(someString: "b"),
//        Test1(someString: "c"),
//        Test1(someString: "d"),
//        Test1(someString: "e")
//    ])
//]
//
//var appendArray: [Test1] = []
//

import Foundation
////for i in testArray {
////    for o in i.stringStruct {
////        appendArray.append(Test1(someString: o.someString))
////    }
////}
//
//func nestConverting(input dataSet: [TestArray]) {
//    dataSet.map { data in
//        data.stringStruct.map { item in
//            appendArray.append(Test1(someString: item.someString))
//        }
//    }
//}
//
//nestConverting(input: testArray)
//
//appendArray.map { data in
//    print(data.someString)
//}
//
//

let currentCal = Calendar.current
let current = Date()
let components = Calendar.current.dateComponents([.year, .month, .day], from: current)
print(components)


let year1 = currentCal.dateComponents([.year], from: current)
let year2 = currentCal.dateComponents([.year], from: current.addingTimeInterval(-9999999))

