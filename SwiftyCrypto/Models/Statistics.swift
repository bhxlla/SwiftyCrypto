//
//  Statistics.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 06/01/23.
//

import Foundation

struct Statistics: Identifiable {
    let title: String
    let value: String
    let percentChange: Double?
    
    let id = UUID().uuidString
    
    init(title: String, value: String, percentChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentChange = percentChange
    }
    
}
