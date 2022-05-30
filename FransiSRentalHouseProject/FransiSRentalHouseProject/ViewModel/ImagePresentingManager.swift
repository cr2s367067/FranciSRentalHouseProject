//
//  ImagePresentingManager.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/4.
//

import Foundation
import UIKit
import SDWebImageSwiftUI

class ImagePresentingManager: ObservableObject {
    
    enum ImgFrameStatus {
        case landscape
        case portrait
    }
    
    @Published var image = UIImage()
    @Published var imgFrameStatus: ImgFrameStatus = .landscape
    
    func plIdentify(image: UIImage) {
        if image.size.width > image.size.height {
            print("Is landscape image")
            imgFrameStatus = .landscape
        } else {
            print("Is portrait.")
            imgFrameStatus = .portrait
        }
    }
    
}

