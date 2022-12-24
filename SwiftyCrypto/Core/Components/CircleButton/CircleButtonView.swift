//
//  CircleButtonView.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 24/12/22.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 48, height: 48)
            .background(
                Circle.init()
                    .foregroundColor(.theme.background)
            ).shadow(color: .theme.accent.opacity(1/4), radius: 12, x: 0, y: 0)
            .padding()
        
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleButtonView(iconName: "info")
                .previewLayout(.sizeThatFits)
            CircleButtonView(iconName: "plus")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)

        }
    }
}
