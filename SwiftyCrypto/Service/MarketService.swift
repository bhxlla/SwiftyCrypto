//
//  MarketService.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 08/02/23.
//

import Foundation
import Combine

class MarketService {
    
    @Published var marketData: MarketData? = nil
    var cancellable: AnyCancellable?
    private let urlString = "https://api.coingecko.com/api/v3/global"
    
    private let decoder = JSONDecoder()
    
    init(){
        getData()
    }
    
    private func getData(){
        guard let url = URL(string: urlString) else { return }
        
        cancellable = NetworkManager.download(for: url)
            .decode(type: GlobalData.self, decoder: decoder)
            .sink { [weak self] result in
                if case let .failure(err) = result {
                    print(err.localizedDescription)
                }
                self?.cancellable?.cancel()
            } receiveValue: { [weak self] globalData in
                self?.marketData = globalData.data
            }

    }
    
}
