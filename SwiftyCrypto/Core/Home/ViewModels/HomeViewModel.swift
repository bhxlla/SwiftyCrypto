//
//  HomeViewModel.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 24/12/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    enum SortType {
        case rank, rankReversed, holding, holdingReversed, price, priceReversed
        
        func sortCoins() -> ((Coin, Coin) -> Bool)   {
            switch self {
            case .holding, .rank:
                return { $0.marketRank < $1.marketRank }
            case .holdingReversed, .rankReversed:
                return { $0.marketRank > $1.marketRank }
            case .price:
                return { $0.currentPrice > $1.currentPrice }
            case .priceReversed:
                return { $0.currentPrice < $1.currentPrice }
            }
        }
        
        var imageName: String {
            switch self {
                case .holding, .price, .rank:
                    return "chevron.up"
                case .holdingReversed, .priceReversed, .rankReversed:
                    return "chevron.down"
            }
        }
        
        var isRankSort: Bool { self == .rank || self == .rankReversed }
        var isPriceSort: Bool { self == .price || self == .priceReversed }
        var isHoldingsSort: Bool { self == .holding || self == .holdingReversed }        
    }
    
    @Published var allCoins: [Coin] = .init()
    @Published var portfolioCoins: [Coin] = .init()
    @Published var searchText = ""
    @Published var statistics: [Statistics] = .init()
    @Published var isReloading = false
    @Published var sortType: SortType = .holding
    @Published var errorMessage: String = ""
    
    private let service: CoinService = CoinService()
    private let marketService: MarketService = MarketService()
    private let dataService: PortfolioDataService = PortfolioDataService()
    
    @Published var pagination: (page: Int, loading: Bool) = (1, false)
    
    init() {
        subscribeToCoins()
    }
    
    func subscribeToCoins(){
        
        service.$allCoin
            .map(\.data)
            .compactMap { coins in coins.isEmpty ? nil : coins }
            .combineLatest($searchText, $sortType)
            .debounce(for: .seconds(0.6), scheduler: DispatchQueue.main)
            .map { (coins, text, sort) in
                var result = text.isEmpty ? coins : coins.filter { coin in
                    coin.name.lowercased().contains(text.lowercased().trimmingCharacters(in: .whitespaces)) ||
                    coin.symbol.lowercased().contains(text.lowercased().trimmingCharacters(in: .whitespaces)) ||
                    coin.id.lowercased().contains(text.lowercased().trimmingCharacters(in: .whitespaces))
                }
                result.sort(by: sort.sortCoins())
                return result
            }
            .assign(to: &$allCoins)

        service.$allCoin
            .map(\.message)
            .assign(to: &$errorMessage)
        
        $allCoins
            .combineLatest(dataService.$portfolio)
            .compactMap { (coins: [Coin], portfolios: [Portfolio]) -> [Coin] in
                coins.compactMap { coin in
                    guard let folio = portfolios.first(where: { $0.coinId == coin.id }) else { return nil }
                    return coin.updateHoldings(with: folio.amount)
                }
            }
//            .removeDuplicates(by: { coins1, coins2 in coins1.isEmpty && coins2.isEmpty })
            .assign(to: &$portfolioCoins)

        marketService.$marketData
            .combineLatest($portfolioCoins)
            .map { marketData, coins in
                var stats: [Statistics] = .init()
                guard let marketData else {return stats}
                
                let portfolioValue = coins.map { $0.currentHoldingsValue }.reduce(0, +)
                
                let previousValue = coins.map { coin in
                    let priceChange = coin.priceChangePercentage24H ?? 0.0
                    return coin.currentHoldingsValue / (1 + ( priceChange / 100))
                }.reduce(0.0, +)
                
                let percentDiff = ((portfolioValue - previousValue) / previousValue) * 100
                
                stats.append(contentsOf: [
                    .init(title: "Market Cap", value: marketData.marketCap, percentChange: marketData.marketCapChangePercentage24HUsd),
                    .init(title: "24h Volume", value: marketData.volume),
                    .init(title: "BTC Dominance", value: marketData.btcDominance),
                    .init(title: "Portfolio", value: portfolioValue.asCurrencyWith2, percentChange: percentDiff)
                ])
                
                return stats
            }.assign(to: &$statistics)
        
        $allCoins
            .combineLatest(marketService.$marketData)
            .map { coins, marketService in false }
            .assign(to: &$isReloading)
        
        $allCoins
            .dropFirst()
            .map { $0.isEmpty ? 0 : 1 }
            .map { [weak self] value in ((self?.pagination.page ?? 1) + value, false) }
            .assign(to: &$pagination)
    }
    
    func errorDisplayed() {
        Just("")
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .map{ _ in "" }
            .assign(to: &$errorMessage)
    }
    
    func loadMore() {
        if !errorMessage.isEmpty && pagination.loading { return }
        let page = pagination.page
        pagination.loading = true
        service.getCoins(for: page)
    }
    
    func updateFolio(coin: Coin, amount: Double) {
        dataService.update(coin: coin, with: amount)
    }
  
    var personalisedCoinsList: [Coin] {
        portfolioCoins + allCoins.filter{ coin in !portfolioCoins.contains { $0.id == coin.id } }
    }
    
    func reloadData() {
        isReloading = true
        pagination.page = 1 // Will start from page 1 again...
        service.getCoins()
        marketService.getData()
        HapticManager.notify(type: .success)
    }
    
}


extension Array {
    var isNotEmpty: Bool { !isEmpty }
}
