//
//  HomeViewModel.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 24/12/22.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [Coin] = .init()
    @Published var portfolioCoins: [Coin] = .init()
    
    init() {
        
        
    }
    
}
