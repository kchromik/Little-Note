//
//  SFSafariView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 27.08.24.
//

import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {

    var url:String

    func makeUIView(context: Context) -> some UIView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        let webview = WKWebView()
        webview.load(URLRequest(url: url))
        return webview
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}
