//
//  CoinService.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 30/12/22.
//

import Foundation
import Combine

class CoinService {
    
    @Published var allCoin: Result<[Coin], Error> = .success([])

    let pageSize = 50
    
    private func getUrl(for page: Int = 1) -> String {
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=\(pageSize)&page=\(page)&sparkline=true&price_change_percentage=24h"
    }
    
    private let decoder = JSONDecoder()
    
    init(){
        getCoins()
    }
    
    func getCoins(){
        guard let url = URL(string: getUrl()) else { return }
        
        fetchCoins(for: url)
            .map(Result.success)
            .catch ({ error in Just(.failure(error)) })
            .assign(to: &$allCoin)
    }
    
    func getCoins(for page: Int) {
        guard let url = URL(string: getUrl(for: page)) else { return }

        fetchCoins(for: url)
            .combineLatest(allCoin.publisher)
            .map{ (newCoins, currentResult) in currentResult + newCoins }
            .map(Result.success)
            .catch ({ error in Just(.failure(error)) })
            .assign(to: &$allCoin)
        
    }
    
    private func fetchCoins(for url: URL) -> AnyPublisher<[Coin], any Error>{
        NetworkManager.download(for: url)
            .print("GET COINS: [\(url.relativeString)]")
            .decode(type: [Coin].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

extension Result where Success == [Coin] {
    var data: [Coin] {
        switch self {
        case .success(let coins):
            return coins
        case .failure(_):
            return []
        }
    }
    
    var message: String {
        switch self {
        case .success(_):
            return ""
        case .failure(let error):
            return error.localizedDescription
        }
    }
}
