//
//  MuscleGroup.swift
//  FitGit
//

import SwiftUI

public enum MuscleGroup: String, CaseIterable, Identifiable {
    case chest = "Chest"
    case back = "Back"
    case legs = "Legs"
    case shoulders = "Shoulders"
    case arms = "Arms"
    case core = "Core"
    case cardio = "Cardio"
    case fullBody = "Full Body"

    public var id: String { rawValue }

    public var iconName: String {
        switch self {
        case .chest: return "figure.strengthtraining.traditional"
        case .back: return "figure.rower"
        case .legs: return "figure.run"
        case .shoulders: return "figure.arms.open"
        case .arms: return "figure.boxing"
        case .core: return "figure.core.training"
        case .cardio: return "heart.fill"
        case .fullBody: return "figure.mixed.cardio"
        }
    }

    public var accentColor: Color {
        switch self {
        case .chest: return .blue
        case .back: return .indigo
        case .legs: return .orange
        case .shoulders: return .purple
        case .arms: return .pink
        case .core: return .green
        case .cardio: return .red
        case .fullBody: return .cyan
        }
    }
}
