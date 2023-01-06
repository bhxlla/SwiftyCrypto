//
//  HomeStatsView.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 06/01/23.
//

import SwiftUI

struct HomeStatsView: View {
    
    @Binding var showPortfolio: Bool
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        HStack {

            ForEach(homeViewModel.statistics) { stat in
                StatsView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }

        }.frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing :.leading)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(
            showPortfolio: .constant(false)
        ).environmentObject(dev.homeVm)
    }
}
