//
//  BoostColorPicker.swift
//  nook-components
//
//  Created by Maciek Bagiński on 12/11/2025.
//

import SwiftUI

struct BoostColorPicker: View {

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(
                        colors: [.black, .white],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .frame(width: 133, height: 133)
        }
        .frame(width: 147, height: 147)
        .shadow(color: .black.opacity(0.4), radius: 5)

    }
}

#Preview {
    BoostColorPicker()
        .frame(width: 300, height: 300)
        .background(.white)
}
