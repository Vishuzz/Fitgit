//
//  SplitStore.swift
//  FitGit
//

import SwiftUI
import Combine

public final class SplitStore: ObservableObject {
    public static let shared = SplitStore()

    private let storageKey = "fitgit_saved_weekly_split_v5"
    private let customRoutinesKey = "fitgit_saved_custom_routines_v1"

    @Published public var weeklySchedule: [DayWorkoutConfig] = []
    @Published public var customRoutines: [CustomRoutine] = []

    public init() {
        loadSchedule()
        loadCustomRoutines()
    }

    public var todayConfig: DayWorkoutConfig {
        let currentDay = DayOfWeek.current()
        return weeklySchedule.first(where: { $0.day == currentDay }) ?? DayWorkoutConfig(day: currentDay)
    }

    public func toggleGymHit(for day: DayOfWeek) {
        updateConfig(for: day) { cfg in
            cfg.isGymHit.toggle()
            if cfg.isGymHit {
                cfg.lastCompletedDate = Date()
            }
        }
    }

    public func markGymHit(for day: DayOfWeek, isHit: Bool = true) {
        updateConfig(for: day) { cfg in
            cfg.isGymHit = isHit
            if isHit {
                cfg.lastCompletedDate = Date()
            }
        }
    }

    public func updateConfig(for day: DayOfWeek, update: (inout DayWorkoutConfig) -> Void) {
        if let index = weeklySchedule.firstIndex(where: { $0.day == day }) {
            update(&weeklySchedule[index])
            saveSchedule()
            NotificationManager.shared.scheduleAllReminders(for: weeklySchedule)
        }
    }

    public func saveSchedule() {
        if let encoded = try? JSONEncoder().encode(weeklySchedule) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    public func loadSchedule() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([DayWorkoutConfig].self, from: data),
           decoded.count == 7 {
            self.weeklySchedule = decoded
        } else {
            // Default to Push-Pull-Legs (PPL) program from the complete workout splits guide
            applyPresetSplit(.pushPullLegs)
        }
    }

    // MARK: - Custom Routines
    public func saveCustomRoutine(_ routine: CustomRoutine) {
        if let index = customRoutines.firstIndex(where: { $0.id == routine.id }) {
            customRoutines[index] = routine
        } else {
            customRoutines.append(routine)
        }
        if let encoded = try? JSONEncoder().encode(customRoutines) {
            UserDefaults.standard.set(encoded, forKey: customRoutinesKey)
        }
    }

    public func deleteCustomRoutine(_ routine: CustomRoutine) {
        customRoutines.removeAll(where: { $0.id == routine.id })
        if let encoded = try? JSONEncoder().encode(customRoutines) {
            UserDefaults.standard.set(encoded, forKey: customRoutinesKey)
        }
    }

    private func loadCustomRoutines() {
        if let data = UserDefaults.standard.data(forKey: customRoutinesKey),
           let decoded = try? JSONDecoder().decode([CustomRoutine].self, from: data) {
            self.customRoutines = decoded
        } else {
            self.customRoutines = [
                CustomRoutine(
                    title: "Chest & Triceps Hypertrophy",
                    subtitle: "Heavy press & cable burn",
                    targetMuscles: [.chest, .triceps],
                    exercises: [
                        PDFExerciseFactory.barbellBenchPress(sets: 3, reps: "6-8"),
                        PDFExerciseFactory.inclineDumbbellPress(sets: 3, reps: "8-12"),
                        PDFExerciseFactory.pecDeckCableFly(sets: 2, reps: "12-15"),
                        PDFExerciseFactory.tricepsRopePushdown(sets: 3, reps: "10-15"),
                        PDFExerciseFactory.overheadCableTricepsExtension(sets: 2, reps: "10-15")
                    ]
                ),
                CustomRoutine(
                    title: "Back & Biceps Pull",
                    subtitle: "Lats, rows & peak arm contractions",
                    targetMuscles: [.back, .biceps],
                    exercises: [
                        PDFExerciseFactory.pullUpsLatPulldown(sets: 3, reps: "8-12"),
                        PDFExerciseFactory.chestSupportedRow(sets: 3, reps: "8-12"),
                        PDFExerciseFactory.straightArmPulldown(sets: 2, reps: "12-15"),
                        PDFExerciseFactory.ezBarCurl(sets: 3, reps: "8-12"),
                        PDFExerciseFactory.inclineDumbbellCurl(sets: 2, reps: "10-15")
                    ]
                )
            ]
        }
    }

    // MARK: - Preset Split Templates
    public enum PresetSplitType: String, CaseIterable, Identifiable {
        case pushPullLegs = "Push-Pull-Legs (PPL) - 6 Days"
        case arnoldSplit = "Arnold Split - 6 Days"
        case upperLower = "Upper/Lower Split - 4 Days"
        case broSplit = "Classic Bro Split - 5 Days"
        case fullBody = "Full Body - 3 Days"

        public var id: String { rawValue }

        public var subtitle: String {
            switch self {
            case .pushPullLegs: return "3 or 6 days • Balanced strength and hypertrophy"
            case .arnoldSplit: return "6 days • Bodybuilding with extra arm/shoulder focus"
            case .upperLower: return "4 days • Balanced growth and recovery"
            case .broSplit: return "5 days • Focused single-muscle sessions"
            case .fullBody: return "3 days • Efficient training with frequent muscle stimulation"
            }
        }
    }

    public func applyPresetSplit(_ type: PresetSplitType) {
        weeklySchedule = PDFWorkoutSplits.schedule(for: type)
        saveSchedule()
        NotificationManager.shared.scheduleAllReminders(for: weeklySchedule)
    }
}
