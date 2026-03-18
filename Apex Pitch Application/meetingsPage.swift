//
//  meetingsPage.swift
//  Apex Pitch Application
//
//  Created by Pride Mafira  on 16/2/2026.
//

import SwiftUI
import WebKit

struct meetingsPage: View {
    @State public var showWebView: String
    private let urlString: String = "https://zoom.us/signin"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                WebView(url: URL(string: urlString)!).frame(height: .infinity)
                
                    .ignoresSafeArea()
                
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> some WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}



#Preview {
    meetingsPage(showWebView: "https://zoom.us/signin")
}
