//
//  UIApplication.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 04/01/23.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

extension View {
    func endEditing() {
        UIApplication.shared.endEditing()
    }
}
