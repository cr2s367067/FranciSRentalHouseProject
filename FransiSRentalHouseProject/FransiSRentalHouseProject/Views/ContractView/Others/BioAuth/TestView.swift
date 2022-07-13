//
//  TestView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/4/18.
//

import AVKit
import SwiftUI
import AVKit


struct TestView: View {
<<<<<<< HEAD
    
    private let source = AVPlayer(url: URL(string: "http://localhost:9199/v0/b/francisrentalhouseproject.appspot.com/o/roomVideo%2F06AB3CBD-BD0E-4FA1-94CE-9F5CF96F535B.mp4?alt=media&token=732581aa-d889-4d68-9aa0-98cff5d189c2") ?? URL(string: "")!)
    
    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height
    
=======
    private let source = AVPlayer(url: URL(string: "http://localhost:9199/v0/b/francisrentalhouseproject.appspot.com/o/roomVideo%2F06AB3CBD-BD0E-4FA1-94CE-9F5CF96F535B.mp4?alt=media&token=732581aa-d889-4d68-9aa0-98cff5d189c2") ?? URL(string: "")!)

    let uiScreenWidth = UIScreen.main.bounds.width
    let uiScreenHeight = UIScreen.main.bounds.height

>>>>>>> PodsAdding
    var body: some View {
//        if let url = url {
//            video(url: url)
//                .onAppear {
//                    print("video url: \(url.absoluteString)")
//                }
//        }
        VStack {
            VideoPlayer(player: source)
                .onAppear {
                    print("av player status: \(source.debugDescription)")
                }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

<<<<<<< HEAD

=======
>>>>>>> PodsAdding
extension TestView {
    @ViewBuilder
    func video(url: URL) -> some View {
        VStack {
            VideoPlayer(player: AVPlayer(url: url))
        }
    }
}
