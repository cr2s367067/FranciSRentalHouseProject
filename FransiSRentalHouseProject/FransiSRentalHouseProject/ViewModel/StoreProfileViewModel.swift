//
//  StoreProfileViewModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/21.
//

import Foundation
import SwiftUI

class StoreProfileViewModel: ObservableObject {
    enum StoreProfileStatus: String {
        case isCreated, providerDisplayName, providerProfileImage, providerDescription, storeBackgroundImage, isUpdate
    }

    @Published var images = [UIImage]()

    @AppStorage(StoreProfileStatus.isUpdate.rawValue) var isUpdate = false
    @AppStorage(StoreProfileStatus.isCreated.rawValue) var isCreated = false
    @AppStorage(StoreProfileStatus.providerDisplayName.rawValue) var providerDisplayName = ""
    @AppStorage(StoreProfileStatus.providerDescription.rawValue) var providerDescription = ""

    @Published var store: ProviderStore = .empty
}
