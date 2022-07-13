//
//  TextingViewModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/3/23.
//

import Foundation
import UIKit

class TextingViewModel: ObservableObject {
    @Published var text = ""
    @Published var image = [UIImage]()

    @Published var showPhpicker = false

    @Published var showImageDetail = false
    @Published var imageURL = ""
}
