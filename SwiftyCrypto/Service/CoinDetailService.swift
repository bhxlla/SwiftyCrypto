//
//  CoinDetailService.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 18/03/23.
//

import Foundation
import Combine

class CoinDetailService {
    
    @Published var detail: CoinDetail? = nil
    var cancellable: AnyCancellable?
    
    let coin: Coin
    
    private var urlString: String {
        "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
    }
    
    private let decoder = JSONDecoder()
    
    init(coin: Coin){
        self.coin = coin
        getCoins()
    }
    
    func getCoins(){
        guard let url = URL(string: urlString) else { return }
        
        cancellable = NetworkManager.download(for: url)
            .decode(type: CoinDetail.self, decoder: decoder)
            .sink { [weak self] result in
                if case let .failure(err) = result {
                    print(err.localizedDescription)
                }
                self?.cancellable?.cancel()
            } receiveValue: { [weak self] result in
                self?.detail = result
            }

    }
    
}
