//
//  ProviderBarChartViewModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/14.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProviderBarChartViewModel: ObservableObject {
    
//    @Published var collectionDateSet = [ReceivePaymentDateModel]()
    
    @Published var tempDataCollection = [Int]()
    @Published var resultDataCollection = [Double]()
    
    let db = Firestore.firestore()
    
    //MARK: Loop raw data in each docID and store in one data set
    func convertAndStore(input: [ReceivePaymentDateModel]) {
        if tempDataCollection.isEmpty {
            _ = input.map { data in
                tempDataCollection.append(data.settlementAmount)
            }
        } else {
            tempDataCollection.removeAll()
            _ = input.map { data in
                tempDataCollection.append(data.settlementAmount)
            }
        }
    }
    
    
    //MARK: Convert raw data to Double for presenting in bar chart
    func getMax(input: [Int]) -> Int {
        return input.max() ?? 1
    }
//
//    func convertToDouble(input: [Int]) {
//        var result: Double = 0
//        if resultDataCollection.isEmpty {
//            input.forEach { data in
//                result = Double(data / getMax(input: input))
//                resultDataCollection.append(result)
//            }
//        } else {
//            resultDataCollection.removeAll()
//            input.forEach { data in
//                result = Double(data / getMax(input: input))
//                resultDataCollection.append(result)
//            }
//        }
//    }
}
