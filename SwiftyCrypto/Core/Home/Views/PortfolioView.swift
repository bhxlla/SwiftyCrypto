//
//  PortfolioView.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 11/03/23.
//

import SwiftUI

struct PortfolioView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State var selectedCoin: Coin? = nil
    @State var quantity: String = ""
    @State var showCheckmark: Bool = false
    
    var isEdit: Bool {
        selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantity)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: .zero) {
                    
                    SearchBarView(text: $homeViewModel.searchText)
                    coinLogoList
                    
                    if let selectedCoin = selectedCoin {
                        PortfolioEdit(selectedCoin: selectedCoin)
                    }
                    
                }
            }
            .background(Color.theme.background)
            .navigationTitle("Edit Portfolio")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        XMark { dismiss() }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark").opacity(showCheckmark ? 1 : 0)
                            Button("SAVE") {
                                savePressed()
                            }.opacity(isEdit ? 1 : 0)
                        }
                        .font(.headline)
                    }
                }
                .onChange(of: homeViewModel.searchText) { newValue in
                    if newValue.isEmpty {
                        selectedCoin = nil
                    }
                }
        }
    }
    
    var totalValue: Double {
        guard let quantity = Double.init(quantity) else { return 0 }
        return quantity * (selectedCoin?.currentPrice ?? .zero)
    }
    
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVm)
            .preferredColorScheme(.dark)
    }
}

extension PortfolioView {
    
    var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            LazyHStack(spacing: 10) {
                ForEach(
                    homeViewModel.personalisedCoinsList
                ) { coin in
                    CoinLogoView(coin: coin)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                coinSelected(coin)
                            }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : .clear, lineWidth: 2)
                        }
                        .padding(.vertical, 2)
                }
            }.padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func PortfolioEdit(selectedCoin: Coin) -> some View {
        VStack(spacing: 12) {
            
            HStack {
                Text("Current price of \(selectedCoin.symbol.uppercased()): ")
                Spacer()
                Text("\(selectedCoin.currentPrice.asCurrencyWith6)")
            }
            
            Divider()
            
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.5", text: $quantity)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack {
                Text("Current Value: ")
                Spacer()
                Text("\(totalValue.asCurrencyWith2)")
            }
            
        }
            .animation(.none, value: selectedCoin.id)
            .padding().padding()
            .font(.headline)

    }
    
    private func coinSelected(_ coin: Coin){
        selectedCoin = coin
        if let folio = homeViewModel.portfolioCoins.first(where: { $0.id == coin.id }), folio.currentHoldings != nil {
            quantity = "\(folio.currentHoldings!)"
        } else {
            quantity = ""
        }
    }
    
    private func savePressed() {
        
        guard let coin = selectedCoin, let amount = Double(quantity) else { return }
        
        homeViewModel.updateFolio(coin: coin, amount: amount)
        
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelected()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: .init(block: {
            showCheckmark = false
        }))
        
        UIApplication.shared.endEditing()
    }
    
    private func removeSelected() {
        selectedCoin = nil
        homeViewModel.searchText = ""
    }
    
}
