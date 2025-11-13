//
//  BoostOptions.swift
//  nook-components
//
//  Created by Maciek Bagiński on 12/11/2025.
//

import SwiftUI

struct BoostOptions: View {
    @State private var lightbulbIsOn: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            OptionButton(icon: "lightbulb", isActive: lightbulbIsOn) {
                // Invert lightness
            }
            OptionButton(icon: "slider.horizontal.3", isActive: false) {
                lightbulbIsOn.toggle()
                // Advanced color options

            }
            .popover(isPresented: $lightbulbIsOn) {
                VStack(alignment: .leading) {
                    Text("Lightness")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Slider(value: .constant(0.3))
                    Text("Contrast")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Slider(value: .constant(0.5))
                    Text("Tint strentgh")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Slider(value: .constant(1))
                }
                .padding(20)
                .frame(width: 300)
            }
            OptionButton(icon: "nosign", isActive: false) {
                print("ligtbulb pressed")
                // Reset to original colors
            }
        }
    }
}

#Preview {
    BoostOptions()
        .frame(width: 300, height: 300)
        .background(.white)
}

struct OptionButton: View {

    var icon: String
    var isActive: Bool
    var action: () -> Void
    @State private var isHovered: Bool = false

    var body: some View {
        Button {
            action()

        } label: {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(
                    isActive ? .white.opacity(0.8) : .black.opacity(0.75)
                )
                .frame(width: 16, height: 16)
                .padding(.horizontal, 13)
                .padding(.vertical, 11)
                .background(
                    isActive
                        ? .black.opacity(0.8)
                        : isHovered ? .black.opacity(0.1) : .black.opacity(0.07)
                )
                .animation(.linear(duration: 0.1), value: isActive)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(ScaleButtonStyle())

        .onHover { state in
            isHovered = state
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.9

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .animation(
                .easeInOut(duration: 0.2),
                value: configuration.isPressed
            )
    }
}
