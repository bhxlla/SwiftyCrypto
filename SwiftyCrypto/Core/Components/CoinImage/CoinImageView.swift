//
//  CoinImageView.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 31/12/22.
//

import SwiftUI
import Combine

struct CoinImageView: View {
    
    let coin: Coin
    @StateObject var vm: CoinImageViewModel
    
    init(coin: Coin) {
        self.coin = coin
        self._vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(.theme.secondaryText)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
