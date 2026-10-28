//
//  NeumorphicTheme.swift
//  FitGit
//

import SwiftUI
import UIKit

public enum NeumorphicTheme {
    // MARK: - Neumorphic Base Surfaces
    // Soft off-white / light slate surface that allows both light highlights and dark shadows to be sculpted
    public static let background = Color(red: 0.92, green: 0.94, blue: 0.96) // #EBF0F5
    public static let darkSurface = Color(red: 0.88, green: 0.90, blue: 0.93)
    
    // Light highlight (top-left)
    public static let lightShadow = Color.white.opacity(0.9)
    // Dark depth shadow (bottom-right)
    public static let darkShadow = Color(red: 0.65, green: 0.70, blue: 0.78).opacity(0.55)
    
    // Inset / concave dark shadow
    public static let insetDark = Color(red: 0.62, green: 0.67, blue: 0.75).opacity(0.4)
    public static let insetLight = Color.white.opacity(0.8)

    // MARK: - Vibrant Accents
    public static let primaryOrange = Color(red: 1.0, green: 0.38, blue: 0.18) // Electric Coral
    public static let cyanPulse = Color(red: 0.0, green: 0.72, blue: 0.96)    // Cyan Energy
    public static let emeraldGreen = Color(red: 0.12, green: 0.78, blue: 0.45) // Mint Emerald
    public static let purplePower = Color(red: 0.58, green: 0.35, blue: 0.95)  // Royal Violet

    // Text colors
    public static let textPrimary = Color(red: 0.18, green: 0.22, blue: 0.28)
    public static let textSecondary = Color(red: 0.45, green: 0.50, blue: 0.58)
    public static let textMuted = Color(red: 0.60, green: 0.65, blue: 0.72)
}

// MARK: - View Modifiers for Neumorphic Styling

public struct NeumorphicCardModifier: ViewModifier {
    var cornerRadius: CGFloat
    var isPressed: Bool
    var padding: CGFloat

    public func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(NeumorphicTheme.background)
                    .shadow(color: isPressed ? NeumorphicTheme.lightShadow : NeumorphicTheme.lightShadow,
                            radius: isPressed ? 2 : 6,
                            x: isPressed ? 2 : -5,
                            y: isPressed ? 2 : -5)
                    .shadow(color: isPressed ? NeumorphicTheme.insetDark : NeumorphicTheme.darkShadow,
                            radius: isPressed ? 2 : 6,
                            x: isPressed ? -2 : 5,
                            y: isPressed ? -2 : 5)
            )
    }
}

public struct NeumorphicConcaveModifier: ViewModifier {
    var cornerRadius: CGFloat

    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(NeumorphicTheme.darkSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.black.opacity(0.04), lineWidth: 1)
                    )
                    .shadow(color: NeumorphicTheme.insetDark, radius: 3, x: 2, y: 2)
                    .shadow(color: NeumorphicTheme.insetLight, radius: 3, x: -2, y: -2)
            )
    }
}

public struct NeumorphicButtonStyle: ButtonStyle {
    var cornerRadius: CGFloat = 16
    var accentColor: Color? = nil

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(accentColor ?? NeumorphicTheme.background)
                    .shadow(color: configuration.isPressed ? Color.clear : (accentColor != nil ? accentColor!.opacity(0.3) : NeumorphicTheme.lightShadow),
                            radius: configuration.isPressed ? 1 : 5,
                            x: configuration.isPressed ? 1 : -4,
                            y: configuration.isPressed ? 1 : -4)
                    .shadow(color: configuration.isPressed ? Color.clear : (accentColor != nil ? Color.black.opacity(0.18) : NeumorphicTheme.darkShadow),
                            radius: configuration.isPressed ? 1 : 5,
                            x: configuration.isPressed ? -1 : 4,
                            y: configuration.isPressed ? -1 : 4)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

extension View {
    public func neumorphicCard(cornerRadius: CGFloat = 18, isPressed: Bool = false, padding: CGFloat = 16) -> some View {
        self.modifier(NeumorphicCardModifier(cornerRadius: cornerRadius, isPressed: isPressed, padding: padding))
    }

    public func neumorphicConcave(cornerRadius: CGFloat = 14) -> some View {
        self.modifier(NeumorphicConcaveModifier(cornerRadius: cornerRadius))
    }

    public func neumorphicButton(cornerRadius: CGFloat = 16, accent: Color? = nil) -> some View {
        self.buttonStyle(NeumorphicButtonStyle(cornerRadius: cornerRadius, accentColor: accent))
    }
}
