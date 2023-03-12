//
//  CoinService.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 30/12/22.
//

import Foundation
import Combine

class CoinService {
    
    @Published var allCoins: [Coin] = []
    var cancellable: AnyCancellable?
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    
    private let decoder = JSONDecoder()
    
    init(){
        getCoins()
    }
    
    func getCoins(){
        guard let url = URL(string: urlString) else { return }
        
        cancellable = NetworkManager.download(for: url)
            .decode(type: [Coin].self, decoder: decoder)
            .sink { [weak self] result in
                if case let .failure(err) = result {
                    print(err.localizedDescription)
                }
                self?.cancellable?.cancel()
            } receiveValue: { [weak self] coins in
                self?.allCoins = coins
            }

    }
    
}
