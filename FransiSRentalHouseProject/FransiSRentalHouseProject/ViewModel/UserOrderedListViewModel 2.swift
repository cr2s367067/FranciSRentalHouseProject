//
//  UserOrderedListViewModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/26.
//

import Foundation


class UserOrderedListViewModel: ObservableObject {
    
    enum RatingStars: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3
        case four = 4
        case five = 5
    }
    
    @Published var rating = 0
    @Published var comment = ""
    
    func reset() {
        rating = 0
        comment = ""
    }
}
