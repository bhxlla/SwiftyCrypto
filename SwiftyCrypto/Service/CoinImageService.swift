//
//  CoinImageService.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 01/01/23.
//

import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil

    var cancellable: AnyCancellable?
    
    func getCoinImage(from url: String) {
        guard let url = URL(string: url) else { return }
        cancellable = NetworkManager.download(for: url)
            .tryMap(UIImage.init(data:))
            .sink { [weak self] result in
                if case let .failure(err) = result {
                    print(err.localizedDescription)
                }
                self?.cancellable?.cancel()
            } receiveValue: { [weak self] image in
                self?.image = image
            }

    }
}
