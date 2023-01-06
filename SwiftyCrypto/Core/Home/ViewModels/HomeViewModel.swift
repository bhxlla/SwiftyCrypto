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
    @Published var statistics: [Statistics] = [.init(title: "Title1", value: "Value1", percentChange: 23), .init(title: "Title2", value: "Value2"), .init(title: "Title3", value: "Value3", percentChange: -41), .init(title: "Title4", value: "Value4")]
    
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
