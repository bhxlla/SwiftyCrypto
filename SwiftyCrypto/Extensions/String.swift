//
//  String.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 19/03/23.
//

import Foundation


extension String {
    
    var withRemovedHtml: String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
