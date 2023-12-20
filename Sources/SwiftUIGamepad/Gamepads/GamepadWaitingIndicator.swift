//
//  GamepadWaitingIndicator.swift
//  ReedWriteCycle (iOS)
//
//  Created by Kevin Mullins on 11/16/22.
//

import SwiftUI

/// A View that displays an animated waiting indicator for the `GamepadRequiredOverlay`.
public struct GamepadWaitingIndicator: View {
    
    // MARK: - Properties
    /// The `StrokeStyle` of the control.
    public var style = StrokeStyle (lineWidth: 6, lineCap: .round)
    
    /// The color of the control.
    public var color = Color.white
    
    /// If `true` the control is animated.
    @State public var animate = false
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameters:
    ///   - style: The `StrokeStyle` of the control.
    ///   - color: The color of the control.
    public init(style: StrokeStyle = StrokeStyle (lineWidth: 6, lineCap: .round), color: SwiftUI.Color = Color.white) {
        self.style = style
        self.color = color
    }
    
    // MARK: - Control Body
    /// The body of the control.
    public var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke (AngularGradient(gradient: .init(colors: [color]), center: .center),
                         style: style)
                .rotationEffect(Angle(degrees: animate ? 360 : 8))
                .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false), value: animate)
            Circle()
                .trim(from: 0.5, to: 0.7)
                .stroke (AngularGradient(gradient: .init(colors: [color]), center: .center),
                         style: style)
                . rotationEffect (Angle (degrees: animate ? 368: 0))
                .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false), value: animate)
        }.onAppear () {
            self.animate.toggle()
        }
    }
    
}

#Preview {
    GamepadWaitingIndicator()
        .background(Color.black)
}
