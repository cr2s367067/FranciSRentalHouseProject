//
//  WebView.swift
//  FransiSRentalHouseProject
//
//  Created by Kuan on 2022/5/21.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context _: Context) -> WKWebView {
        let webView = WKWebView()
        webView.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context _: Context) {
        uiView.loadHTMLString(text, baseURL: nil)
    }
}
