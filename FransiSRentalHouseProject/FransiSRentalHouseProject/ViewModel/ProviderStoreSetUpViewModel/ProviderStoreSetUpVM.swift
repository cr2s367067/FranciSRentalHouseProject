//
//  ProviderStoreSetUpVM.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/29.
//

import Foundation


class ProviderStoreSetUpVM: ObservableObject {
    @Published var providerInfo: ProviderDM = .empty
    @Published var storeInfo: ProviderStore = .empty
}
