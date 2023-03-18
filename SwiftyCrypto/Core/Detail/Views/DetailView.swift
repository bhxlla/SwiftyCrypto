//
//  DetailView.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 12/03/23.
//

import SwiftUI

struct DetailScreen: View {
    @Binding var coin: Coin?
    
    init(coin: Binding<Coin?>) {
        self._coin = coin
    }
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

/*
 
 https://www.youtube.com/watch?v=yXSC6jTkLP4
 refetches everytime we visit this screen, can use NSCache.
 
 */

struct DetailView: View {
    
    let coin: Coin

    @StateObject var detailViewModel: DetailViewModel

    init(coin: Coin) {
        self.coin = coin
        self._detailViewModel = .init(wrappedValue: .init(coin: coin))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 18) {
                    
                    ChartView(coin: coin)
                        .frame(height: 160)
                    
                    overviewTitle
                    
                    Divider()
                    
                    overviewDetails
                        .padding(.horizontal)
                    
                    additionalTitle
                    
                    Divider()
                    
                    additionalDetails
                        .padding(.horizontal)
                    
                }.padding(.horizontal)
            }
        }.navigationTitle(coin.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Text("\(coin.symbol.uppercased())")
                            .font(.headline)
                            .foregroundColor(.theme.secondaryText)
                        CoinImageView(coin: coin)
                            .frame(width: 24, height: 24)
                    }
                }
            }
    }

    private var overviewTitle: some View {
        Text("Overview")
            .font(.title.bold())
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title.bold())
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalDetails: some View {
        LazyVGrid(
            columns: [GridItem.init(.flexible()), GridItem.init(.flexible())],
            alignment: .leading,
            spacing: 24,
            pinnedViews: []
        ) {
            ForEach(detailViewModel.detail.additionalDetails) { stat in
                StatsView(stat: stat)
            }
        }
    }
    
    private var overviewDetails: some View {
        LazyVGrid(
            columns: [GridItem.init(.flexible()), GridItem.init(.flexible())],
            alignment: .leading,
            spacing: 24,
            pinnedViews: []
        ) {
            ForEach(detailViewModel.detail.overview) { stat in
                StatsView(stat: stat)
            }            
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}
