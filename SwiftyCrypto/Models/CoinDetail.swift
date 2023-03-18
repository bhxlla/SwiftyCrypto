//
//  CoinDetail.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 18/03/23.
//

import Foundation

/*
 Api: https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false

 */


struct CoinDetail: Codable {
    let id, symbol, name: String?
    let block_time_in_minutes: Int?
    let hashing_algorithm: String?
    let categories: [String]?
    let description: Description?
    let links: Links?
}

struct Description: Codable {
    let en: String?
}

struct Links: Codable {
    let homepage: [String]?
    let subreddit_url: String?
}
