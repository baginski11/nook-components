//
//  KeyButton.swift
//  nook-components
//
//  Created by Maciek Bagiński on 10/11/2025.
//
import SwiftUI


struct KeyButton: View {
    
    var key: String = "shift"
    @State private var isPressed: Bool = false
    
    private let symbolToKeyMap: [String: String] = [
        "shift": "shift",
        "command": "command",
        "option": "option",
        "control": "control"
    ]
    
    private var isSymbol: Bool {
        symbolToKeyMap.keys.contains(key) || NSImage(systemSymbolName: key, accessibilityDescription: nil) != nil
    }
    
    var body: some View {
        ZStack {
            Group {
                if isSymbol {
                    Image(systemName: key)
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(Color(hex: "5B5A2E"))
                        .multilineTextAlignment(.center)
                        .frame(width: 12, height: 12)
                } else {
                    Text(key)
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(Color(hex: "5B5A2E"))
                        .multilineTextAlignment(.center)
                        .frame(width: 12, height: 12)
                }
            }
            .offset(x: 0, y: isPressed ? 0 : -1)
            .animation(.linear(duration: 0.05), value: isPressed)

            RoundedRectangle(cornerRadius: 4)
                .stroke(Color(hex: "A9A999"), lineWidth: 2)
                .offset(x: 0, y: isPressed ? 0 : -2)
                .animation(.linear(duration: 0.05), value: isPressed)
        }
        .frame(width: 20, height: 20)
        .background(Color(hex: "DEDED5"))
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay {
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color(hex: "A9A999"), lineWidth: 2)
        }
        .onAppear {
            NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .keyUp, .flagsChanged]) { event in
                handleKeyEvent(event)
                return event
            }
        }
    }
    
    private func handleKeyEvent(_ event: NSEvent) {
        let mappedKey = symbolToKeyMap[key]
        
        if event.type == .flagsChanged, let mappedKey = mappedKey {
            let isModifierPressed: Bool
            switch mappedKey {
            case "shift":
                isModifierPressed = event.modifierFlags.contains(.shift)
            case "command":
                isModifierPressed = event.modifierFlags.contains(.command)
            case "option":
                isModifierPressed = event.modifierFlags.contains(.option)
            case "control":
                isModifierPressed = event.modifierFlags.contains(.control)
            default:
                return
            }
            
            withAnimation(.easeOut(duration: 0.01)) {
                isPressed = isModifierPressed
            }
        } else if event.type == .keyDown {
            if event.characters?.lowercased() == key.lowercased() {
                withAnimation(.easeOut(duration: 0.01)) {
                    isPressed = true
                }
            }
        } else if event.type == .keyUp {
            if event.characters?.lowercased() == key.lowercased() {
                withAnimation(.easeOut(duration: 0.01)) {
                    isPressed = false
                }
            }
        }
    }
}




#Preview {
    ZStack {
        VStack {
            KeyButton(key: "shift")
            KeyButton(key: "command")
            KeyButton(key: "A")
            KeyButton(key: "1")
        }
        .padding(40)
    }
}
