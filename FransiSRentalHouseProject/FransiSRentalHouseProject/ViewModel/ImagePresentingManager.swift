//
//  ImagePresentingManager.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/4.
//

import Foundation
import UIKit

class ImagePresentingManager: ObservableObject {
    
    @Published var image = UIImage()
    
    func plIdentify(image: UIImage) {
        if image.size.width > image.size.height {
            print("Is landscape image")
        } else {
            print("Is portrait.")
        }
    }
    
}

