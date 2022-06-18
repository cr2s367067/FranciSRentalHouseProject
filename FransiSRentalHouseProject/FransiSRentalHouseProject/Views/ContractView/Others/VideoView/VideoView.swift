//
//  VideoView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/12.
//

import SwiftUI
import AVKit

struct VideoView: View {
    
//    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    
    @State var urlString: String
    
    var body: some View {
        VStack {
            //MARK: data fail to catch bug
            if let url = URL(string: urlString) {
                VideoPlayer(player: AVPlayer(url: url))
            }
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(urlString: "")
    }
}
