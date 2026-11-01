//
//  UserProfile.swift
//  FitGit
//

import SwiftUI

public enum FitnessGoal: String, CaseIterable, Identifiable, Codable {
    case hypertrophy = "Hypertrophy (Muscle Gain)"
    case strength = "Strength & Power"
    case recomp = "Body Recomposition"
    case fatLoss = "Fat Loss & Definition"
    case athletic = "Athletic Performance"

    public var id: String { rawValue }

    public var icon: String {
        switch self {
        case .hypertrophy: return "figure.strengthtraining.traditional"
        case .strength: return "scalemass.fill"
        case .recomp: return "arrow.triangle.2.circlepath"
        case .fatLoss: return "flame.fill"
        case .athletic: return "figure.run"
        }
    }

    public var shortTagline: String {
        switch self {
        case .hypertrophy: return "Size & Volume"
        case .strength: return "Max Compound PRs"
        case .recomp: return "Lean Mass & Definition"
        case .fatLoss: return "Caloric Deficit & Conditioning"
        case .athletic: return "Speed, Agility & Longevity"
        }
    }
}

public enum AthleteTier: String, CaseIterable, Codable {
    case novice = "Novice Athlete"
    case intermediate = "Intermediate Lifter"
    case advanced = "Advanced Lifter"
    case veteran = "Master / Veteran"

    public var badgeColor: Color {
        switch self {
        case .novice: return NeumorphicTheme.cyanPulse
        case .intermediate: return NeumorphicTheme.primaryOrange
        case .advanced: return NeumorphicTheme.purplePower
        case .veteran: return NeumorphicTheme.emeraldGreen
        }
    }

    public var icon: String {
        switch self {
        case .novice: return "leaf.fill"
        case .intermediate: return "bolt.shield.fill"
        case .advanced: return "trophy.fill"
        case .veteran: return "crown.fill"
        }
    }

    public var trainingGuidance: String {
        switch self {
        case .novice:
            return "Focus on fundamental compound mechanics, linear progressive overload, and rest between heavy sets."
        case .intermediate:
            return "Prioritize targeted muscle contractions, periodized volume (10-18 weekly sets per muscle), and 1-2 RIR."
        case .advanced:
            return "Implement specialized split rotation, weak-point focus, metabolic drop-sets, and deload weeks."
        case .veteran:
            return "Focus on longevity, peak joint preservation, RPE auto-regulation, and high-intensity mechanical tension."
        }
    }
}

public struct UserProfile: Codable, Equatable {
    public var name: String
    public var username: String
    public var age: Int
    public var weightKg: Double
    public var heightCm: Double
    public var yearsInGym: Double
    public var fitnessGoal: FitnessGoal
    public var isConfiguredWithAI: Bool
    public var lastUpdated: Date

    // AI Synthesized Attributes
    public var bmi: Double
    public var bmiCategory: String
    public var athleteTier: AthleteTier
    public var maintenanceCalories: Int
    public var targetCalories: Int
    public var dailyProteinGrams: Int
    public var recommendedSplit: String
    public var aiBioSummary: String
    public var weeklyVolumeGuideline: String

    public init(
        name: String = "Vishek Tyagi",
        username: String = "vishek",
        age: Int = 24,
        weightKg: Double = 78.5,
        heightCm: Double = 178.0,
        yearsInGym: Double = 2.5,
        fitnessGoal: FitnessGoal = .hypertrophy,
        isConfiguredWithAI: Bool = true,
        lastUpdated: Date = Date(),
        bmi: Double = 24.8,
        bmiCategory: String = "Athletic Build",
        athleteTier: AthleteTier = .intermediate,
        maintenanceCalories: Int = 2650,
        targetCalories: Int = 2950,
        dailyProteinGrams: Int = 118,
        recommendedSplit: String = "Push-Pull-Legs (PPL) - 6 Days",
        aiBioSummary: String = "24yo Intermediate Lifter • 78.5kg • 2.5 yrs gym experience • Focus on Hypertrophy & Progressive Strength",
        weeklyVolumeGuideline: String = "12-16 weekly sets per major muscle group"
    ) {
        self.name = name
        self.username = username
        self.age = age
        self.weightKg = weightKg
        self.heightCm = heightCm
        self.yearsInGym = yearsInGym
        self.fitnessGoal = fitnessGoal
        self.isConfiguredWithAI = isConfiguredWithAI
        self.lastUpdated = lastUpdated
        self.bmi = bmi
        self.bmiCategory = bmiCategory
        self.athleteTier = athleteTier
        self.maintenanceCalories = maintenanceCalories
        self.targetCalories = targetCalories
        self.dailyProteinGrams = dailyProteinGrams
        self.recommendedSplit = recommendedSplit
        self.aiBioSummary = aiBioSummary
        self.weeklyVolumeGuideline = weeklyVolumeGuideline
    }

    public var initials: String {
        let parts = name.split(separator: " ").filter { !$0.isEmpty }
        if parts.count >= 2 {
            let first = parts[0].prefix(1).uppercased()
            let second = parts[1].prefix(1).uppercased()
            return "\(first)\(second)"
        } else if let firstPart = parts.first, !firstPart.isEmpty {
            return String(firstPart.prefix(2)).uppercased()
        }
        return "FG"
    }

    public var heightFormatted: String {
        let totalInches = heightCm / 2.54
        let feet = Int(totalInches / 12)
        let inches = Int(totalInches.truncatingRemainder(dividingBy: 12))
        return "\(Int(heightCm)) cm (\(feet)'\(inches)\")"
    }

    public var weightFormatted: String {
        let lbs = weightKg * 2.20462
        return String(format: "%.1f kg (%.0f lbs)", weightKg, lbs)
    }

    public var experienceFormatted: String {
        if yearsInGym < 1.0 {
            let months = max(1, Int(yearsInGym * 12))
            return "\(months) \(months == 1 ? "month" : "months") in gym"
        } else if yearsInGym.truncatingRemainder(dividingBy: 1) == 0 {
            let yrs = Int(yearsInGym)
            return "\(yrs) \(yrs == 1 ? "year" : "years") in gym"
        } else {
            return String(format: "%.1f years in gym", yearsInGym)
        }
    }

    public var shortExperience: String {
        if yearsInGym < 1.0 {
            let months = max(1, Int(yearsInGym * 12))
            return "\(months)m gym"
        } else if yearsInGym.truncatingRemainder(dividingBy: 1) == 0 {
            let yrs = Int(yearsInGym)
            return "\(yrs)y exp"
        } else {
            return String(format: "%.1fy exp", yearsInGym)
        }
    }
}
