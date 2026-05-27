//
//  Colors.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

extension Color {
    // Background colors
    static let appBackground = Color(
        UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 0.10, green: 0.10, blue: 0.14, alpha: 1.0)
            } else {
                return UIColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 1.0)
            }
        }
    )
    
    static let cardBg = Color(
        UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 0.15, green: 0.15, blue: 0.21, alpha: 1.0)
            } else {
                return UIColor(red: 0.95, green: 0.94, blue: 1.0, alpha: 1.0)
            }
        }
    )
    
    // Accent colors
    static let purpleAccent = Color(red: 0.49, green: 0.24, blue: 0.93)
    static let correctGreen = Color(red: 0.08, green: 0.60, blue: 0.28)
    static let codeOrange = Color(red: 0.95, green: 0.60, blue: 0.25)
    static let codeTeal = Color(red: 0.24, green: 0.72, blue: 0.82)
    static let goldYellow = Color(red: 0.90, green: 0.72, blue: 0.20)
    
    // Text colors
    static let primaryText = Color(
        UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                return UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
            }
        }
    )
    
    static let secondaryText = Color(
        UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 0.7, green: 0.7, blue: 0.75, alpha: 1.0)
            } else {
                return UIColor(red: 0.55, green: 0.55, blue: 0.57, alpha: 1.0)
            }
        }
    )
    
    static let tertiaryText = Color(
        UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 0.5, green: 0.5, blue: 0.55, alpha: 1.0)
            } else {
                return UIColor(red: 0.75, green: 0.75, blue: 0.77, alpha: 1.0)
            }
        }
    )
    
    // Border colors
    static let borderColor = Color(
        UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 0.3, green: 0.3, blue: 0.35, alpha: 1.0)
            } else {
                return UIColor(red: 0.85, green: 0.85, blue: 0.88, alpha: 1.0)
            }
        }
    )
    
    static let transparent = Color(red: 0, green: 0, blue: 0, opacity: 0)
}
