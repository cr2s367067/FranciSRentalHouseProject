//
//  VideoView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/6/12.
//

import SwiftUI
import AVKit
import SDWebImageSwiftUI

struct VideoView: View {
    
    @EnvironmentObject var roomsDetailViewModel: RoomsDetailViewModel
    @EnvironmentObject var firestoreToFetchRoomsData: FirestoreToFetchRoomsData
    @EnvironmentObject var productDetailViewModel: ProductDetailViewModel
    @EnvironmentObject var roomCARVM: RoomCommentAndRattingViewModel
    @EnvironmentObject var firestoreForProducts: FirestoreForProducts
    @EnvironmentObject var firestoreToFetchUserinfo: FirestoreToFetchUserinfo
    
    
    enum SideImageName: String, CaseIterable {
        case docTextImage = "doc.text.image"
        case message = "message"
    }
    
    enum RattingID: String {
        case isRoom
        case isProduct
    }
    
    let sideImageName: [String] = SideImageName.allCases.map({$0.rawValue})
    
    @State var urlString: String
//    let uiScreenWidth = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.width
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
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
                                showRatting()
                                    .fontWeight(.bold)
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
            NavigationView {
                VStack {
                    Spacer()
                    HStack(alignment:.bottom) {
                        profileImage(provider: firestoreToFetchUserinfo.fetchedUserData.profileImageURL)
                        VStack(alignment: .leading) {
                            Text("Provider Name")
                            Text("Provider Des.")
                        }
                        Spacer()
                        VStack {
                            showRatting()
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
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(urlString: "")
    }
}


extension VideoView {
    
    //MARK: - Profile Image
    @ViewBuilder
    func profileImage(provider image: String) -> some View {
        if image.isEmpty {
            Image(systemName: "person.circle")
                .font(.system(size: 30))
        } else {
            WebImage(url: URL(string: image))
                .resizable()
                .frame(width: 30, height: 30)
        }
    }
    
    //MARK: - Video Player
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
    
    
    //MARK: - Side Button
    @ViewBuilder
    func cusButton(sideImageName: SideImageName) -> some View {
        Button {
            switch sideImageName {
            case .docTextImage:
                presentContainDetail()
            case .message:
                createMessage()
            }
        } label: {
            Image(systemName: sideImageName.rawValue)
                .foregroundColor(.black)
                .font(.system(size: 25))
        }
    }
    
    private func presentContainDetail() {
        print("Is doc text image")
    }
    
    private func createMessage() {
        print("Is message")
    }
    
    //MARK: - Ratting Score
    @ViewBuilder
    func showRatting() -> some View {
        Button {
            
        } label: {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                rattingPresenter(source: RattingID(rawValue: "") ?? .isRoom, product: firestoreForProducts.productCommentAndRatting, room: firestoreToFetchRoomsData.roomCARDataSet)
                    .foregroundColor(.white)
                //BUG, wait official fix.
//                    .fontWeight(.bold)
            }
            .frame(width: 60, height: 40)
            .font(.system(size: 18))
            .padding(.horizontal)
            .background {
                Capsule()
                    .fill(.gray)
            }
        }
    }
    
    @ViewBuilder
    private func rattingPresenter(source: RattingID, product inputP: [ProductCommentRattingDataModel], room inputR: [RoomCommentAndRattingDataModel]) -> some View {
        switch source {
        case .isProduct:
            productRatting(product: inputP)
        case .isRoom:
            roomRatting(room: inputR)
        }
    }
    
    @ViewBuilder
    private func productRatting(product input: [ProductCommentRattingDataModel]) -> some View {
        Text("\(productDetailViewModel.computeRattingAvg(commentAndRatting: input), specifier: "%.1f")")
    }
    
    @ViewBuilder
    private func roomRatting(room input: [RoomCommentAndRattingDataModel]) -> some View {
        Text("\(roomCARVM.rattingCompute(input: input), specifier: "%.1f")")
    }
    
    
   
}
