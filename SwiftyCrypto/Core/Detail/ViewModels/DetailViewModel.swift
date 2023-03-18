//
//  DetailViewModel.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 18/03/23.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    let coin: Coin
    
    @Published var detail: (overview: [Statistics], additionalDetails: [Statistics]) = ([], [])
    
    private let detailService: CoinDetailService
    
    
    init(coin: Coin) {
        self.coin = coin
        detailService = CoinDetailService(coin: coin)
        
        bindService()
    }
    
    func bindService(){
        
        detailService.$detail
            .combineLatest(Just(coin))
            .map(createStats)
            .assign(to: &$detail)
    }
    
    func createStats(detail: CoinDetail?, coin: Coin) -> (overview: [Statistics], additionalDetails: [Statistics]) {
        (createOverviewStats(coin: coin), createAdditionalStats(detail: detail, coin: coin))
    }
    
    func createOverviewStats(coin: Coin) -> [Statistics] {
        let priceStat = Statistics(title: "Current Price", value: coin.currentPrice.asCurrencyWith6, percentChange: coin.priceChangePercentage24H)
        let marketCapStat = Statistics(title: "Market Capitalization", value: "$\(coin.marketCap?.formattedWithAbbreviations() ?? "")", percentChange: coin.marketCapChangePercentage24H)
        let rankStat = Statistics(title: "Rank", value: "\(coin.marketRank)")
        let volStat = Statistics(title: "Volume", value: "$\(coin.totalVolume?.formattedWithAbbreviations() ?? "")")
        
        return [priceStat, marketCapStat, rankStat, volStat]
    }
    
    func createAdditionalStats(detail: CoinDetail?, coin: Coin) -> [Statistics] {
        let high = coin.high24H?.asCurrencyWith6 ?? "n/a"
        let highStat = Statistics(title: "24h High", value: high)
        
        let low = coin.low24H?.asCurrencyWith6 ?? "n/a"
        let lowStat = Statistics(title: "24h Low", value: low)
        
        let priceDiff = coin.priceChange24H?.asCurrencyWith6 ?? "n/a"
        let priceDiffPercent = coin.priceChangePercentage24H
        let priceDiffStat = Statistics(title: "24h Price Change", value: priceDiff, percentChange: priceDiffPercent)
        
        let marketCapChange = "$\(coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")"
        let marketCapPerc = coin.marketCapChangePercentage24H
        let marketStat = Statistics(title: "24h Market Cap Change", value: marketCapChange, percentChange: marketCapPerc)
        
        let blockStat = Statistics(title: "Block Time", value: "\(detail?.block_time_in_minutes ?? 0)")
        
        let hashingStat = Statistics(title: "Hashing Algorithm", value: detail?.hashing_algorithm ?? "n/a")
        
        return [highStat, lowStat, priceDiffStat, marketStat, blockStat, hashingStat]
    }
    
}
