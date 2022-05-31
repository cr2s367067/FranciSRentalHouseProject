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
    @Published var image = [TextingImageDataModel]()
    
    @Published var showPhpicker = false
    
    @Published var imageArray = [String]()
    
    @Published var showImageDetail = false

}
