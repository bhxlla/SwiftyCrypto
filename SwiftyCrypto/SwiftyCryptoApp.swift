//
//  SwiftyCryptoApp.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 24/12/22.
//

import SwiftUI

@main
struct SwiftyCryptoApp: App {
    
    @State var showLaunchView = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
    }
    
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }.environmentObject(homeViewModel)
                
                ZStack {
                    if showLaunchView {
                        LaunchView(show: $showLaunchView)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }.zIndex(2)
            }
        }
    }
}
