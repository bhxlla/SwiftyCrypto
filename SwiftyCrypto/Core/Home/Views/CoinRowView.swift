//
//  CoinRowView.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 24/12/22.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: Coin
    let showHoldings: Bool
    
    var body: some View {
        HStack(spacing: .zero) {

            leftRow
            
            Spacer()
            
            if showHoldings {
                centerColumn
            }
            
            rightColumn
                .frame(minWidth: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            
        }.font(.subheadline)
    }
    
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldings: true)
                .previewLayout(.sizeThatFits)
            
            CoinRowView(coin: dev.coin, showHoldings: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension CoinRowView {
    
    var leftRow: some View {
        HStack(spacing: .zero) {
            Text("\(coin.marketRank)")
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .frame(minWidth: 32)

            CoinImageView(coin: coin)
                .frame(width: 32, height: 32)

            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 8)
                .foregroundColor(.theme.accent)

        }
    }
    
    var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2)
                .bold()
            Text((coin.currentHoldings ?? .zero).asString)
        }.foregroundColor(.theme.accent)
    }
    
    var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6)
                .bold()
                .foregroundColor(.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercent ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? .zero) > 0 ? .theme.green : .theme.red
                )
        }
    }
    
}
