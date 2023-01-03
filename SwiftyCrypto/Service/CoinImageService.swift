//
//  CoinImageService.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 01/01/23.
//

import SwiftUI
import Combine

class CoinImageService {
    
    let folderName = "cached_imgs"
    
    @Published var image: UIImage? = nil
    var cancellable: AnyCancellable?
    
    private func downloadImage(from url: String, with name: String) {
        guard let url = URL(string: url) else { return }
        cancellable = NetworkManager.download(for: url)
            .tryMap(UIImage.init(data:))
            .sink { [weak self] result in
                if case let .failure(err) = result {
                    print(err.localizedDescription)
                }
                self?.cancellable?.cancel()
            } receiveValue: { [weak self] image in
                guard let image, let self else { return }
                self.image = image
                LocalFileManager.shared.saveImage(image: image, with: name, in: self.folderName)
            }
    }
    
    func getCoinImage(from urlString: String, with name: String) {
        if let image = LocalFileManager.shared.getImage(with: name, in: folderName) {
            self.image = image
        } else {
            downloadImage(from: urlString, with: name)
        }
    }
}
