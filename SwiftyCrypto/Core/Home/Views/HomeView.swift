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
    @State var showPortfolioView = false
    
    @State var selectedNavCoin: Coin? = nil
    @State var showDetail: Bool = false
    
    @State var infoSelected: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            
            VStack {
                header
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(text: $vm.searchText)
                columnTitles
                
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
            .sheet(isPresented: $infoSelected) {
                SettingsView()
            }
            
        }.background {
            NavigationLink(destination: DetailScreen(coin: $selectedNavCoin), isActive: $showDetail) {
                EmptyView()
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
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        infoSelected.toggle()
                    }
                }
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
                    .contentShape(Rectangle())
                    .onTapGesture {
                        goToDetail(coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }.listStyle(.plain)
    }
    
    private var portfolioCoins: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldings: true)
                    .listRowInsets(.init(top: 12, leading: .zero, bottom: 12, trailing: 12))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        goToDetail(coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }.listStyle(.plain)
    }
    
    private var columnTitles: some View {
        HStack {
            Button {
                vm.sortType = vm.sortType == .rank ? .rankReversed : .rank
            } label: {
                HStack(spacing: 4){
                    Text("Coin")
                    Image(systemName: vm.sortType.imageName)
                        .opacity(vm.sortType.isRankSort ? 1 : 0)
                }
            }

            Spacer()
            if showPortfolio {
                Button {
                    vm.sortType = vm.sortType == .holding ? .holdingReversed : .holding
                } label: {
                    HStack(spacing: 4){
                        Text("Holdings")
                        Image(systemName: vm.sortType.imageName)
                            .opacity(vm.sortType.isHoldingsSort ? 1 : 0)
                    }
                }
            }
            
            Button {
                vm.sortType = vm.sortType == .price ? .priceReversed : .price
            } label: {
                HStack(spacing: 4){
                    Text("Price")
                    Image(systemName: vm.sortType.imageName)
                        .opacity(vm.sortType.isPriceSort ? 1 : 0)
                }
            }
            .frame(minWidth: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            
            Button {
                withAnimation(.linear(duration: 2)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }.rotationEffect(vm.isReloading ? .degrees(360) : .zero)

        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }
    
    func goToDetail(_ coin: Coin) {
        selectedNavCoin = coin
        showDetail.toggle()
    }
    
}
