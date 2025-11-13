//
//  Wave.swift
//  nook-components
//
//  Created by Maciek Bagiński on 21/10/2025.
//

import SwiftUI

struct Wave: Shape {
    var strenght: Double
    var frequency: Double
    var phase: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(strenght, phase) }
        set {
            self.strenght = newValue.first
            self.phase = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2
        
        let waveLenght = width / frequency
        
        path.move(to: NSPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / waveLenght
            let sine = sin(relativeX + phase)
            let y = strenght * sine + midHeight
            path.addLine(to: NSPoint(x: x, y: y))
        }
        
        return Path(path.cgPath)
        
    }
}


struct WaveView: View {
    @State private var phase = 0.0
    @State private var strenght = 0.1
    
    
    var body: some View {
        ZStack {
            Wave(strenght: strenght, frequency: 50, phase: phase)
                .stroke(Color.white, lineWidth: 2)
        }
        .background(Color.blue)
        .frame(width: 300, height: 300)
        .onAppear {

            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.linear(duration: 0.3)) {
                    self.strenght = 6.0
                }
                withAnimation(.linear(duration: 0.4).repeatForever(autoreverses: false)) {
                    self.phase = .pi * 2
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation(.linear(duration: 0.3)) {
                    self.strenght = 0
                }
            }
            

            

        }
    }
}



#Preview {
    WaveView()
}
