//
//  ColorUtils.swift
//  nook-components
//
//  Created by Maciek Bagiński on 03/11/2025.
//

import SwiftUI

enum ColorBrightness {
    case dark
    case light
}

extension Color {
    func brightness() -> ColorBrightness {
        guard let components = NSColor(self).cgColor.components else { return .dark }
        
        let r = gammaCorrect(components[0])
        let g = gammaCorrect(components[1])
        let b = gammaCorrect(components[2])
        
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        
        return luminance < 0.5 ? .dark : .light
    }
    
    private func gammaCorrect(_ channel: CGFloat) -> Double {
        let c = Double(channel)
        return c <= 0.03928 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4)
    }
}
