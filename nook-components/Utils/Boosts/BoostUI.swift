//
//  BoostUI.swift
//  nook-components
//
//  Created by Maciek Bagiński on 12/11/2025.
//

import SwiftUI

struct BoostUI: View {

    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 0) {
                BoostHeader()
                Rectangle()
                    .fill(.black.opacity(0.07))
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
            }
            VStack(spacing: 15) {
                BoostColorPicker()
                BoostOptions()
                BoostFonts()
                BoostFontOptions()
                BoostZapButton(isActive: false)
                BoostCodeButton(isActive: false)
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 36)

        }
        .frame(width: 185)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    BoostUI()
}
