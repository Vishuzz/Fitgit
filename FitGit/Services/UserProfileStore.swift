//
//  UserProfileStore.swift
//  FitGit
//

import SwiftUI
import Combine

public final class UserProfileStore: ObservableObject {
    public static let shared = UserProfileStore()

    private let storageKey = "fitgit_user_profile_v2"

    @Published public var profile: UserProfile {
        didSet {
            saveToDisk()
        }
    }

    public init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.profile = decoded
        } else {
            self.profile = UserProfile()
        }
    }

    public func saveProfile(_ newProfile: UserProfile) {
        self.profile = newProfile
    }

    private func saveToDisk() {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    // MARK: - On-Device AI Assessment & Synthesis Engine
    public func generateProfileWithAI(
        name: String,
        username: String,
        age: Int,
        weightKg: Double,
        heightCm: Double,
        yearsInGym: Double,
        goal: FitnessGoal
    ) -> UserProfile {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Athlete" : name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanUsername = username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? cleanName.lowercased().replacingOccurrences(of: " ", with: "_") : username.replacingOccurrences(of: "@", with: "").trimmingCharacters(in: .whitespacesAndNewlines)

        // 1. Calculate BMI
        let heightM = max(heightCm / 100.0, 0.5)
        let rawBmi = weightKg / (heightM * heightM)
        let roundedBmi = (rawBmi * 10).rounded() / 10

        // Lifter-aware BMI Classification
        let bmiCategory: String
        if yearsInGym >= 1.5 && roundedBmi >= 25.0 {
            bmiCategory = "Athletic Muscular Build"
        } else if roundedBmi < 18.5 {
            bmiCategory = "Lean / Fast Metabolism"
        } else if roundedBmi < 25.0 {
            bmiCategory = "Athletic & Balanced"
        } else if roundedBmi < 30.0 {
            bmiCategory = "Solid Power Physique"
        } else {
            bmiCategory = "Heavyweight Mass"
        }

        // 2. Athlete Experience Tier
        let tier: AthleteTier
        if yearsInGym < 1.0 {
            tier = .novice
        } else if yearsInGym < 3.0 {
            tier = .intermediate
        } else if yearsInGym < 5.0 {
            tier = .advanced
        } else {
            tier = .veteran
        }

        // 3. Metabolic & Nutrition Calculations (Mifflin-St Jeor Formula + Activity Factor)
        let bmr = (10.0 * weightKg) + (6.25 * heightCm) - (5.0 * Double(age)) + 5.0
        let tdee = bmr * 1.55 // Standard resistance-training lifter activity factor (4-6 sessions/wk)
        let maintenance = Int(tdee.rounded())

        let targetCalories: Int
        switch goal {
        case .hypertrophy:
            targetCalories = maintenance + 300 // Clean surplus for lean muscle
        case .strength:
            targetCalories = maintenance + 200 // Energy support for heavy CNS lifts
        case .recomp:
            targetCalories = maintenance       // Isocaloric body recomposition
        case .fatLoss:
            targetCalories = max(maintenance - 450, 1500) // Moderate sustainable deficit
        case .athletic:
            targetCalories = maintenance + 150
        }

        // Protein calculation: 2.0g - 2.2g per kg bodyweight
        let proteinMultiplier: Double
        switch goal {
        case .fatLoss, .recomp:
            proteinMultiplier = 2.2 // Higher protein for muscle retention during deficit
        case .hypertrophy, .strength, .athletic:
            proteinMultiplier = 2.0
        }
        let dailyProtein = Int((weightKg * proteinMultiplier).rounded())

        // 4. Workout Split Recommendation
        let recommendedSplit: String
        switch tier {
        case .novice:
            recommendedSplit = "Full Body (3 Days) or Upper/Lower (4 Days)"
        case .intermediate:
            switch goal {
            case .hypertrophy:
                recommendedSplit = "Push-Pull-Legs (PPL) - 6 Days"
            case .strength:
                recommendedSplit = "Upper/Lower Split - 4 Days"
            default:
                recommendedSplit = "Push-Pull-Legs (PPL) - 6 Days"
            }
        case .advanced:
            switch goal {
            case .hypertrophy:
                recommendedSplit = "Arnold Split - 6 Days"
            default:
                recommendedSplit = "Push-Pull-Legs (PPL) - 6 Days"
            }
        case .veteran:
            recommendedSplit = "Push-Pull-Legs (PPL) or High-Intensity Split"
        }

        // 5. Volume Guideline
        let volumeGuideline: String
        switch tier {
        case .novice:
            volumeGuideline = "8-12 hard working sets per muscle group weekly"
        case .intermediate:
            volumeGuideline = "12-16 progressive sets per muscle group weekly (1-2 RIR)"
        case .advanced:
            volumeGuideline = "16-20 high-tension sets weekly with intensity techniques"
        case .veteran:
            volumeGuideline = "12-16 auto-regulated RPE sets with joint-friendly exercise selection"
        }

        // 6. Inspiring AI Bio
        let expText: String
        if yearsInGym < 1.0 {
            let months = max(1, Int(yearsInGym * 12))
            expText = "\(months)m gym exp"
        } else {
            expText = String(format: "%.1fy gym exp", yearsInGym)
        }

        let aiBio = "\(age)yo \(tier.rawValue) • \(String(format: "%.1f", weightKg))kg • \(expText) • Calibrated for \(goal.rawValue)"

        return UserProfile(
            name: cleanName,
            username: cleanUsername,
            age: age,
            weightKg: weightKg,
            heightCm: heightCm,
            yearsInGym: yearsInGym,
            fitnessGoal: goal,
            isConfiguredWithAI: true,
            lastUpdated: Date(),
            bmi: roundedBmi,
            bmiCategory: bmiCategory,
            athleteTier: tier,
            maintenanceCalories: maintenance,
            targetCalories: targetCalories,
            dailyProteinGrams: dailyProtein,
            recommendedSplit: recommendedSplit,
            aiBioSummary: aiBio,
            weeklyVolumeGuideline: volumeGuideline
        )
    }
}
