//
//  Color.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 24/12/22.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent: Color = Color("AccentColor")
    let background: Color = Color("BackgroundColor")
    let green: Color = Color("GreenColor")
    let red: Color = Color("RedColor")
    let secondaryText: Color = Color("SecondaryTextColor")
    
    let launchAccent: Color = Color("LaunchAccentColor")
    let launchBg: Color = Color("LaunchBackgroundColor")
}
