//
//  CoinImageViewModel.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 01/01/23.
//

import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    let coin: Coin
    
    @Published var image: UIImage?
    @Published var isLoading: Bool = true
    var cancellables: Set<AnyCancellable> = .init()
    var coinService = CoinImageService()
    
    init(coin: Coin) {
        self.coin = coin
        coinService.getCoinImage(from: coin.image, with: coin.id)
        loadImage()
    }
    
    private func loadImage() {
        coinService.$image
            .sink { [weak self] completion in
                switch completion {
                    case .failure(_): self?.isLoading = false
                    case .finished: break
                }
            } receiveValue: { [weak self] image in
                self?.image = image
            }.store(in: &cancellables)
    }
    
}

