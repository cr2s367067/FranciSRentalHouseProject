//
//  RoomCommentAndRattingViewModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/1.
//

import Foundation

class RoomCommentAndRattingViewModel: ObservableObject {
    
//    @Published var trafficRate = 0
    @Published var convenienceRate = 0
    @Published var pricingRate = 0
    @Published var neighborRate = 0
    
    @Published var commentText = "Give some comment....."
    
    func rattingCompute(input: [RoomCommentRatting]) -> Double {
        var result: Double = 0.0
        if input.isEmpty {
            result = 0.0
        } else {
            var subResult: Double = 0
            guard input.count != 0 else { return 1 }
            for input in input {
//                let tra = input.trafficRate
                let con = input.convenienceRate
                let pri = input.pricingRate
                let nei = input.neighborRate
                let subtotal: Double = Double(con + pri + nei) / 3
                subResult += subtotal
            }
            result = subResult / Double(input.count)
        }
        return result
    }
}

