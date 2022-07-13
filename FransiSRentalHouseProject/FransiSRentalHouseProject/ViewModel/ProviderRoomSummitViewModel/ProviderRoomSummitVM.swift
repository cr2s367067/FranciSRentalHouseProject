//
//  ProviderRoomSummitVM.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/27.
//

import Foundation
import SwiftUI

class ProviderRoomSummitViewModel: ObservableObject {
    // MARK: - Room basic data

    @Published var holderName = ""
    @Published var holderMobileNumber = ""
    @Published var roomAddress = ""
    @Published var roomTown = ""
    @Published var roomCity = ""
    @Published var roomZipCode = ""
    @Published var roomArea = ""
    @Published var roomRentalPrice = ""
    @Published var doesSomeDeadinRoomYes = false
    @Published var doesSomeDeadinRoomNo = false
    @Published var someoneDeadinRoom = false
    @Published var hasWaterLeakingYes = false
    @Published var hasWaterLeakingNo = false
    @Published var waterLeakingProblem = false
    @Published var roomDescription = ""

    // MARK: - Submit config

    @Published var holderTosAgree = false
    @Published var image = UIImage()
    @Published var imageSet = [TextingImageDataModel]()
    @Published var showSheet = false
    @Published var showPHPicker = false
    @Published var tosSheetShow = false
    @Published var isSummitRoomPic = false
    @Published var isSelectedRoomSet = false
    @Published var showSummitAlert = false
    @Published var showProgressView = false
    @Published var roomIntroVideoURL: URL?

//    @Published var roomData: RoomDM = .empty

    func presentImage(input: [TextingImageDataModel]) -> UIImage {
        var image = UIImage()
        if let firstImage = input.first {
            image = firstImage.image
        }
        return image
    }
}
