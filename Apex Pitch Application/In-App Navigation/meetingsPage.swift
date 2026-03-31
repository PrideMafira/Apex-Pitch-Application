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

#Preview {
    meetingsPage(showWebView: "https://zoom.us/signin")
}
