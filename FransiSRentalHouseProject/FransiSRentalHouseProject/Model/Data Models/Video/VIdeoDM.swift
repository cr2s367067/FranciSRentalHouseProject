//
//  VideoDM.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct VideoDM: Codable {
    @DocumentID var id: String?
    
    //MARK: Could fetch provider data by providerUID
    var providerUID: String
    var providerIntroVideo: String
    
    //MARK: Navigate to target object
    var destinationUID: String
    
    @ServerTimestamp var postDate: Timestamp?
}
