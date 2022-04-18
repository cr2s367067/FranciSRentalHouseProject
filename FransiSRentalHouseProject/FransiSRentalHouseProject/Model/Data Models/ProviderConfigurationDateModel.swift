//
//  ProviderConfigurationDateModel.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/13.
//

import Foundation


struct ProviderConfigDM: Codable {
    var isSetConfig: Bool
    var settlementDate: Date
}

extension ProviderConfigDM {
    static let empty = ProviderConfigDM(isSetConfig: false, settlementDate: Date())
}