//
//  XMarkView.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 11/03/23.
//

import SwiftUI

struct XMark: View {
    
    let action: () -> ()
    
    var body: some View {
        
        Button {
            action()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

struct XMarkView_Previews: PreviewProvider {
    static var previews: some View {
        XMark.init{ }
    }
}
