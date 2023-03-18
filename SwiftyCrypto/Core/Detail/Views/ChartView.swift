//
//  ChartView.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 18/03/23.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let color: Color
    
    private let endDate: Date
    private let startDate: Date
    
    private var max: Double = 0
    private var min: Double = 0
    
    @State var chartWidth: Double? = nil
    
    @State var trimmedPortion = 0.0
    
    @State var dragValue: CGFloat? = nil
    @State var dataIndex: Int? = nil
    
    init(coin: Coin) {
        self.data = coin.sparklineIn7D?.price ?? []
        color = (data.first ?? 0) > (data.last ?? 0) ? .theme.red : .theme.green
        endDate = Date.init(coinString: coin.lastUpdated ?? "")
        startDate = endDate.addingTimeInterval(-7 * 24 * 60 * 60)
        max = data.max() ?? 0
        min = data.min() ?? 0
    }
    
    var body: some View {
        
        VStack {
            liveChart
                .contentShape(Rectangle())
                .background(yBackground)
                .overlay(alignment: .leading) {
                    yLabels
                        .padding(.horizontal, 4)
                }
                .gesture(
                    DragGesture(minimumDistance: 2)
                        .onChanged({ value in
                            guard let chartWidth, trimmedPortion == 1 else { return }
                            dragValue = value.location.x
                            let widthFraction = dragValue! / chartWidth
                            dataIndex =  Int(CGFloat(data.count) * widthFraction) + 1
                        })
                        .onEnded({ value in
                            dragValue = nil
                            dataIndex = nil
                        })
                )
                .overlay {
                    HStack {
                        let offsetX = (dragValue != nil && chartWidth != nil) ? dragValue! - (chartWidth!/2) : 0
                        Divider()
                            .overlay(Color.theme.accent)
                            .offset(x: offsetX)
                            .opacity((dragValue == nil) && !canShowLiveValue ? 0 : 1)
                    }
                }
            
            xLabels
                .padding(.horizontal, 4)
            
        }
        .font(.caption2)
        .foregroundColor(.theme.secondaryText)
        .onAppear {
            withAnimation(.easeInOut(duration: 2).delay(1)) {
                trimmedPortion = 1
            }
        }
        
    }
    
    private var liveChart: some View {
        GeometryReader { geometry in

            let width = geometry.size.width
            let height = geometry.size.height
            
            Path { path in
                
                data.indices.forEach { i in
                    
                    let x = (width / CGFloat(data.count)) * CGFloat(i + 1)
                    let yDiff = max - min
                    let yCurrent = data[i] - min
                    let y = (1 - (yCurrent / yDiff)) * height
                    
                    if i == 0 {
                        path.move(to: .init(x: x, y: y))
                    }
                    
                    path.addLine(to: .init(x: x, y: y))
                    
                }
                
            }
            .trim(from: 0, to: trimmedPortion)
            .stroke(color, style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .shadow(color: color, radius: 16, y: 12)
                .shadow(color: color.opacity(3/8), radius: 16, y: 18)
                .shadow(color: color.opacity(2/8), radius: 16, y: 24)
                .shadow(color: color.opacity(1/8), radius: 16, y: 30)
            .onAppear{
                chartWidth = width
            }
                
            
        }
    }
    
    private var yBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var yLabels: some View {
        VStack {
            Text(max.formattedWithAbbreviations())
            Spacer()
            Text(((max + min)/2).formattedWithAbbreviations())
            Spacer()
            Text(min.formattedWithAbbreviations())
        }
    }
    
    private var xLabels: some View {
        HStack {
            Text(startDate.asShortDateString)
            Spacer()
            if let dataIndex, canShowLiveValue {
                Text(data[dataIndex].asCurrencyWith6)
                    .fontWeight(.bold)
                    .foregroundColor(.theme.accent)
                    .transition(.opacity.animation(.easeIn(duration: 1/4)))
            }
            Spacer()
            Text(endDate.asShortDateString)
        }
    }
    
    private var canShowLiveValue: Bool {
        (dataIndex != nil) && (dataIndex! >= 0) && (dataIndex! < data.count)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
            .frame(height: 240)
    }
}


private extension Date {
    
    
    init(coinString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        let fm = DateFormatter()
        fm.dateStyle = .short
        return fm
    }
    
    var asShortDateString: String {
        shortFormatter.string(from: self)
    }
    
}
