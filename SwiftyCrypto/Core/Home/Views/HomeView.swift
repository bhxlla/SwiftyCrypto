//
//  HomeView.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 24/12/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State var showPortfolio = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                header

                if !showPortfolio {
                    allCoins
                        .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    portfolioCoins
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: .zero)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
                .environmentObject(dev.homeVm)
        }
        .preferredColorScheme(.dark)
    }
}

extension HomeView {
    
    private var header: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .background(CircleButtonAnimationView(animate: $showPortfolio))
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .animation(.none, value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(
                    .init(degrees: showPortfolio ? 180 : .zero)
                )
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortfolio.toggle()
                    }
                }
        }.padding(.horizontal)

    }
    
    private var allCoins: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldings: false)
                    .listRowInsets(.init(top: 12, leading: .zero, bottom: 12, trailing: 12))
            }
        }.listStyle(.plain)
    }
    
    private var portfolioCoins: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldings: true)
                    .listRowInsets(.init(top: 12, leading: .zero, bottom: 12, trailing: 12))
            }
        }.listStyle(.plain)
    }
}
