//
//  LaunchView.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 19/03/23.
//

import SwiftUI

struct LaunchView: View {
    
    @Binding var show: Bool
    
    var body: some View {
        
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: 128, height: 128)
                .aspectRatio(contentMode: .fill)
                .offset(y: -2)
            
            Text("Loading your Profile...")
                .font(.title.bold())
                .foregroundColor(.theme.accent)
                .offset(y: 90)
            
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: .init(block: {
                withAnimation {
                    show = false
                }
            }))
        }
        
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(show: .constant(true))
            .preferredColorScheme(.dark)
    }
}
