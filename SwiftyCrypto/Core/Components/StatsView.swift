//
//  StatsView.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 06/01/23.
//

import SwiftUI

struct StatsView: View {
    
    let stat: Statistics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
            
            Text(stat.value)
                .font(.headline)
                .foregroundColor(.theme.accent)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (stat.percentChange ?? 0) >= 0 ? 0 : 180)
                    )
                
                Text(stat.percentChange?.asPercent ?? "")
                    .font(.caption).bold()
            }.foregroundColor(
                (stat.percentChange ?? 0) >= 0 ? .theme.green : .theme.red
            ).opacity(stat.percentChange == nil ? 0 : 1)
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            StatsView(stat: dev.statistic1)
                .previewLayout(.sizeThatFits)
            StatsView(stat: dev.statistic2)
                .previewLayout(.sizeThatFits)
            StatsView(stat: dev.statistic3)
                .previewLayout(.sizeThatFits)
        }
    }
}
