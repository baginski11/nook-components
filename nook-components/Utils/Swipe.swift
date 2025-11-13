import SwiftUI
import AppKit

struct EventView: NSViewRepresentable {
    @Binding var message: String
    @Binding var blueBoxOffset: CGFloat

    class Coordinator: NSObject {
        var parent: EventView
        var accumulatedScrollDeltaX: CGFloat = 0
        var isLocked: Bool = false
        var scrollEndTimer: Timer?
        
        init(parent: EventView) {
            self.parent = parent
        }

        @objc func handleEvent(_ event: NSEvent) {
            if event.type == .scrollWheel {
                scrollEndTimer?.invalidate()
                
                accumulatedScrollDeltaX += event.scrollingDeltaX
                
                if isLocked {
                    if accumulatedScrollDeltaX < -10 {
                        DispatchQueue.main.async {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                self.parent.blueBoxOffset = -300
                            }
                            self.parent.message = "Hidden!"
                        }
                        isLocked = false
                        accumulatedScrollDeltaX = 0
                    }
                } else {
                    if accumulatedScrollDeltaX > 45 {
                        DispatchQueue.main.async {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                self.parent.blueBoxOffset = 0
                            }
                            self.parent.message = "Swiped Right!"
                        }
                        isLocked = true
                        accumulatedScrollDeltaX = 0
                    } else if accumulatedScrollDeltaX < 0 {
                        DispatchQueue.main.async {
                            self.parent.blueBoxOffset = -300
                        }
                        accumulatedScrollDeltaX = 0
                    } else {
                        DispatchQueue.main.async {
                            let progress = self.accumulatedScrollDeltaX / 45.0
                            self.parent.blueBoxOffset = -300 + (300 * progress)
                        }
                        
                        scrollEndTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false) { [weak self] _ in
                            guard let self = self else { return }
                            if self.accumulatedScrollDeltaX < 45 && self.accumulatedScrollDeltaX > 0 {
                                DispatchQueue.main.async {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        self.parent.blueBoxOffset = -300
                                    }
                                }
                                self.accumulatedScrollDeltaX = 0
                            }
                        }
                    }
                }
                
                print("Scroll delta X: \(event.scrollingDeltaX), accumulated: \(accumulatedScrollDeltaX)")
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        
        NSEvent.addLocalMonitorForEvents(matching: [.scrollWheel]) { event in
            context.coordinator.handleEvent(event)
            return event
        }
        
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
