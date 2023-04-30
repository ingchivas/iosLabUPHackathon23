//
//  Waves.swift
//  NoWaste
//
//  Created by Carlos Alberto Lopez Figueroa on 29/04/23.

import SwiftUI
 
struct Wave: Shape {
    
    var waveHeight: CGFloat
    var phase: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.maxY)) // Bottom Left
        
        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX: CGFloat = x / 50 //wavelength
            let sine = CGFloat(sin(relativeX + CGFloat(phase.radians)))
            let y = waveHeight * sine //+ rect.midY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY)) // Top Right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // Bottom Right
        
        return path
    }
}




struct Waves: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                GeometryReader { geo in
                    ZStack {
                        Wave(waveHeight: 30, phase: Angle(degrees: (Double(geo.frame(in: .global).minY) + 45) * -1 * 0.7))
                            .foregroundColor(.orange)
                            .opacity(0.5)
                        Wave(waveHeight: 30, phase: Angle(degrees: Double(geo.frame(in: .global).minY) * 0.7))
                            .foregroundColor(.red)
                    }
                }.frame(height: 70, alignment: .center)
            }
        }
    }
}

    
    struct WavesPreview: PreviewProvider {
        static var previews: some View {
            Waves()
        }
    }
