//
//  AppTheme.swift
//  FitGit
//

import SwiftUI
import UIKit

public enum AppTheme {
    // MARK: - Vibrant Fitness Accents
    public static let primaryAccent = Color(red: 1.0, green: 0.32, blue: 0.18) // Electric Coral
    public static let secondaryAccent = Color(red: 1.0, green: 0.58, blue: 0.0) // Energetic Orange
    public static let cyanEnergy = Color(red: 0.0, green: 0.88, blue: 0.95)   // Cyan Pulse
    public static let emeraldPower = Color(red: 0.18, green: 0.82, blue: 0.44) // Emerald Success
    public static let violetOverload = Color(red: 0.65, green: 0.35, blue: 0.95) // Purple Core ML
    public static let electricBlue = Color(red: 0.12, green: 0.55, blue: 1.0)

    // MARK: - Gradients
    public static let blazeGradient = LinearGradient(
        colors: [Color(red: 1.0, green: 0.28, blue: 0.15), Color(red: 1.0, green: 0.55, blue: 0.1)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let powerGradient = LinearGradient(
        colors: [Color(red: 0.55, green: 0.25, blue: 0.95), Color(red: 0.15, green: 0.55, blue: 1.0)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let successGradient = LinearGradient(
        colors: [Color(red: 0.12, green: 0.78, blue: 0.45), Color(red: 0.0, green: 0.85, blue: 0.75)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let darkCardBackground = Color(.secondarySystemGroupedBackground)
}

// MARK: - Haptic Feedback Manager
public enum HapticManager {
    public static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }

    public static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    public static func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }

    public static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
}
