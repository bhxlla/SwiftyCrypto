//
//  CircleButtonAnimationView.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 24/12/22.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 4)
            .scale(animate ? 1 : 0)
            .opacity(animate ? 0 : 1)
            .animation(animate ? .spring() : .none, value: animate)
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
            .foregroundColor(.red)
            .frame(width: 72, height: 72)
    }
}
