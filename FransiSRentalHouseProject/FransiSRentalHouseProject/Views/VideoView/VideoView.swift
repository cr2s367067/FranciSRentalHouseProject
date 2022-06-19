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
    
    enum SideImageName: String, CaseIterable {
        case docTextImage = "doc.text.image"
        case message = "message"
    }
    
    let sideImageName: [String] = SideImageName.allCases.map({$0.rawValue})
    
    @State var urlString: String
//    let uiScreenWidth = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.width
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var body: some View {
//        VStack {
//            //MARK: data fail to catch bug
//            if let url = URL(string: urlString) {
//                VideoPlayer(player: AVPlayer(url: url))
//            }
//        }
        
        if #available(iOS 16.0, *) {
            NavigationView {
                Grid {
                    Spacer()
                    GridRow {
                        HStack(alignment:.bottom) {
                            Image(systemName: "person.circle")
                                .font(.system(size: 30))
                            VStack(alignment: .leading) {
                                Text("Provider Name")
                                Text("Provider Des.")
                            }
                            Spacer()
                            VStack {
                                Button {
                                    
                                } label: {
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                        Text("1.4")
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 40, height: 30)
                                    .font(.system(size: 12))
                                    .padding(.horizontal)
                                    .background {
                                        Capsule()
                                            .fill(.gray)
                                    }
                                }
                                ForEach(sideImageName, id: \.self) { imageName in
                                    GridRow {
                                        cusButton(sideImageName: SideImageName(rawValue: imageName) ?? .docTextImage)
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                }
                .padding()
                .navigationTitle("DSIntro")
                .navigationBarTitleDisplayMode(.inline)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    videoPlayer(url: urlString)
                }
            }
        } else {
            // Fallback on earlier versions
            VStack {
                Spacer()
                HStack(alignment:.bottom) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 30))
                    VStack(alignment: .leading) {
                        Text("Provider Name")
                        Text("Provider Des.")
                    }
                    Spacer()
                    VStack {
                        Button {
                            
                        } label: {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("1.4")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 40, height: 30)
                            .font(.system(size: 12))
                            .padding(.horizontal)
                            .background {
                                Capsule()
                                    .fill(.gray)
                            }
                        }
                        ForEach(sideImageName, id: \.self) { imageName in
                            HStack {
                                cusButton(sideImageName: SideImageName(rawValue: imageName) ?? .docTextImage)
                            }
                            .padding()
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("DSIntro")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                videoPlayer(url: urlString)
            }
        }
        
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(urlString: "")
    }
}


extension VideoView {
    @ViewBuilder
    func videoPlayer(url: String) -> some View {
        if let url = URL(string: url) {
            let avP = AVPlayer(url: url)
            VideoPlayer(player: avP)
                .onAppear {
                    avP.play()
                }
        }
    }
    
    @ViewBuilder
    func cusButton(sideImageName: SideImageName) -> some View {
        Button {
            switch sideImageName {
            case .docTextImage:
                return print("Is doc text image")
            case .message:
                return print("Is message")
            }
        } label: {
            Image(systemName: sideImageName.rawValue)
                .foregroundColor(.black)
                .font(.system(size: 25))
        }
    }
}
