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
    @Published var searchText = ""
    
    private let service: CoinService = CoinService()
    
    init() {
        subscribeToCoins()
    }
    
    func subscribeToCoins(){
        service.$allCoins
            .combineLatest($searchText)
            .debounce(for: .seconds(0.6), scheduler: DispatchQueue.main)
            .map { (coins, text) in
                if text.isEmpty { return coins }
                return coins.filter { coin in
                    coin.name.lowercased().contains(text.lowercased().trimmingCharacters(in: .whitespaces)) ||
                    coin.symbol.lowercased().contains(text.lowercased().trimmingCharacters(in: .whitespaces)) ||
                    coin.id.lowercased().contains(text.lowercased().trimmingCharacters(in: .whitespaces))
                }
            }.assign(to: &$allCoins)
    }
    
}
