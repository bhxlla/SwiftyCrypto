//
//  HapticManager.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 12/03/23.
//

import Foundation
import SwiftUI

class HapticManager {
    
    private static let generator = UINotificationFeedbackGenerator()
    
    static func notify(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
}
