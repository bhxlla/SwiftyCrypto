//
//  DetailViewModel.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 18/03/23.
//

import Foundation

class DetailViewModel: ObservableObject {
    
    let coin: Coin
    
    @Published var detail: CoinDetail?
    
    private let detailService: CoinDetailService
    
    
    init(coin: Coin) {
        self.coin = coin
        detailService = CoinDetailService(coin: coin)
        
        bindService()
    }
    
    func bindService(){
        
        detailService.$detail
            .assign(to: &$detail)
            
        
    }
    
}
