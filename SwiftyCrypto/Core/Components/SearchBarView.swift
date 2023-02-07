//
//  SearchBarView.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 04/01/23.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor( text.isEmpty ? .theme.secondaryText : .theme.accent)
            
            TextField("Search by name", text: $text)
                .foregroundColor(.theme.accent)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 8)
                        .foregroundColor(.theme.accent)
                        .opacity(text.isEmpty ? .zero : 1)
                        .onTapGesture {
                            endEditing()
                            text = ""
                        }
                    ,
                    alignment: .trailing
                ).autocorrectionDisabled()
                .keyboardType(.alphabet)
            
        }.font(.headline).padding()
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.theme.background)
                    .shadow(color: .theme.accent.opacity(0.2), radius: 12, x: .zero, y: .zero)
            ).padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            SearchBarView(text: .constant(""))
                .previewLayout(.sizeThatFits)
            
            SearchBarView(text: .constant("Coin"))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
        
    }
}
