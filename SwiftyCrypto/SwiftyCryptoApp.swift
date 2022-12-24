//
//  SwiftyCryptoApp.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 24/12/22.
//

import SwiftUI

@main
struct SwiftyCryptoApp: App {
    
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }.environmentObject(homeViewModel)
        }
    }
}
