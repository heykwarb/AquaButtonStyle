//
//  AquaButtonStyle.swift
//  Aqua Button
//
//  Created by Yohey Kuwa on 2024/08/22.
//

import SwiftUI

struct AquaButtonStyle: ButtonStyle {
    var aquaColor: Color
    var colorShadow: Bool
    var shape: ButtonShape
    
    var highlight: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding() // Button padding
            .overlay(
                GeometryReader { geo in
                    let edgePadding = geo.size.height / 30 // Edge padding based on the button's height
                    
                    ZStack {
                        // Base shape with optional color shadow
                        Group {
                            switch shape {
                            case .capsule:
                                Capsule() // Shape: Capsule
                            case .rectangle(let cornerRadius):
                                RoundedRectangle(cornerRadius: cornerRadius) // Shape: RoundedRectangle with specified cornerRadius
                            }
                        }
                        .foregroundStyle(aquaColor.opacity(0.9)) // Main button color
                        .shadow(radius: edgePadding / 2) // Subtle shadow for depth
                        .shadow(
                            color: colorShadow ? aquaColor.opacity(0.35) : .clear, // Shadow color based on colorShadow flag
                            radius: colorShadow ? geo.size.height / 20 : 0, // Shadow radius based on colorShadow flag
                            y: colorShadow ? geo.size.height / 10 : 0 // Shadow y-offset based on colorShadow flag
                        )
                        
                        configuration.label
                            .foregroundStyle(Color.black.opacity(0.7)) // Label color
                            .shadow(radius: edgePadding, y: edgePadding * 2) // Shadow for the label
                        
                        ZStack {
                            // Gradient overlay for highlight effect
                            Group {
                                switch shape {
                                case .capsule:
                                    Capsule() // Shape: Capsule
                                case .rectangle(let cornerRadius):
                                    RoundedRectangle(cornerRadius: cornerRadius - edgePadding) // Shape: RoundedRectangle with adjusted cornerRadius
                                }
                            }
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.white.opacity(0), .white.opacity(0.1), .white.opacity(0.3), .white.opacity(1)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .blur(radius: edgePadding / 2) // Soften the gradient edges
                            .blendMode(.overlay) // Blend mode for gradient overlay
                            
                            ZStack {
                                // Reflection effect
                                Group {
                                    switch shape {
                                    case .capsule:
                                        Capsule() // Shape: Capsule
                                    case .rectangle(let cornerRadius):
                                        RoundedRectangle(cornerRadius: cornerRadius - edgePadding) // Shape: RoundedRectangle with adjusted cornerRadius
                                    }
                                }
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.white.opacity(0.95), .white.opacity(0.2), .white.opacity(0)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .mask(
                                    Group {
                                        switch shape {
                                        case .capsule:
                                            Capsule()
                                                .offset(y: -geo.size.height / 2 + edgePadding * 8) // Position reflection for Capsule
                                                .padding(.vertical, edgePadding * 5)
                                                .padding(.horizontal, edgePadding * 3)
                                            
                                        case .rectangle:
                                            Ellipse()
                                                .scaleEffect(x: 1.5)
                                                .offset(y: -geo.size.height / 2 + edgePadding * 4) // Position reflection for Rectangle
                                        }
                                    }
                                )
                            
                                // Highlight effect (applied only if highlight is true)
                                if highlight {
                                    Group {
                                        switch shape {
                                        case .capsule:
                                            Capsule() // Base highlight shape: Capsule
                                                .foregroundStyle(.white.opacity(0.8))
                                                .mask(
                                                    ZStack {
                                                        Capsule() // Full-sized highlight shape
                                                        
                                                        Capsule()
                                                            .offset(y: edgePadding * 1.2) // Offset highlight shape to create cut-out effect
                                                            .blendMode(.destinationOut) // Blend mode for cut-out effect
                                                        
                                                    }
                                                    .compositingGroup() // Combine shapes to create final highlight effect
                                                    .mask(
                                                        Capsule()
                                                            .offset(y: -geo.size.height / 2 + edgePadding * 8) // Position reflection for Capsule
                                                            .padding(.vertical, edgePadding * 5)
                                                            .padding(.horizontal, edgePadding * 3)
                                                    )
                                                )
                                            
                                        case .rectangle(let cornerRadius):
                                            RoundedRectangle(cornerRadius: cornerRadius - edgePadding) // Base highlight shape: RoundedRectangle
                                                .foregroundStyle(.white.opacity(0.8))
                                                .mask(
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: cornerRadius - edgePadding) // Full-sized highlight shape
                                                        
                                                        RoundedRectangle(cornerRadius: cornerRadius - edgePadding)
                                                            .offset(y: edgePadding * 1.2) // Offset highlight shape to create cut-out effect
                                                            .blendMode(.destinationOut) // Blend mode for cut-out effect
                                                        
                                                    }
                                                    .compositingGroup() // Combine shapes to create final highlight effect
                                                    .mask(
                                                        Ellipse()
                                                            .scaleEffect(x: 1.5)
                                                            .offset(y: -geo.size.height / 2 + edgePadding * 4) // Align with reflection
                                                    )
                                                )
                                        }
                                    }
                                    .blur(radius: edgePadding / 4) // Blur effect for highlight
                                }
                            }
                        }
                        .padding(edgePadding) // Additional padding for inner ZStack
                    }
                }
            )
            .opacity(configuration.isPressed ? 0.7 : 1.0) // Dim the button when pressed
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0) // Slightly scale down the button when pressed
            .buttonStyle(PlainButtonStyle()) // Ensure the button behaves as a plain button without additional styles
    }
}

enum ButtonShape{
    case capsule
    case rectangle(cornerRadius: CGFloat)
}

extension View {
    func aquaButtonStyle(aquaColor: Color, colorShadow: Bool = true, shape: ButtonShape = .capsule) -> some View {
        self.buttonStyle(AquaButtonStyle(aquaColor: aquaColor, colorShadow: colorShadow, shape: shape))
    }
}
