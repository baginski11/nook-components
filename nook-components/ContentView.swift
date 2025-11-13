//
//  ContentView.swift
//  nook-components
//
//  Created by Maciek Bagiński on 08/10/2025.
//

import SwiftUI
import Reeeed

struct ContentView: View {
    @State private var boostWindow: NSWindow?
    
    var body: some View {
        HStack {
            Button("Open Boost") {
                openBoostWindow()
            }
            CodeView()
        }
 
    }
    
    private func openBoostWindow() {
        if boostWindow != nil {
            boostWindow?.makeKeyAndOrderFront(nil)
            return
        }
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 185, height: 600),
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = true
        window.level = .floating
        window.contentView = NSHostingView(rootView: BoostUI())
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        boostWindow = window
    }
}
#Preview {
    ContentView()
}
