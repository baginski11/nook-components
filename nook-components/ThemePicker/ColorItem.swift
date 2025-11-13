import SwiftUI

struct ColorItem: View {
    var color: Color
    var strokeColor: Color
    var onClick: () -> Void
    
    @State private var isHovered = false
    @State private var isPressed = false
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Circle()
                .fill(color)
                .overlay(
                    Circle()
                        .stroke(strokeColor, lineWidth: 2)
                )
                .frame(width: 20, height: 20)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : (isHovered ? 1.08 : 1.0))
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isHovered)
        .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isPressed)
        .onHover { hovering in
            isHovered = hovering
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}

#Preview {
    HStack {
        ColorItem(
            color: Color(hex: "F3EAE4"),
            strokeColor: Color(hex: "DAD3CD"),
            onClick: {}
        )
    }
    .padding(24)
}
