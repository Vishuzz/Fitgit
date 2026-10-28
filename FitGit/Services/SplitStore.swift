//
//  SplitStore.swift
//  FitGit
//

import SwiftUI
import Combine

public final class SplitStore: ObservableObject {
    public static let shared = SplitStore()

    private let storageKey = "fitgit_saved_weekly_split_v3"
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
            // Default to Push Pull Legs (PPL) split with leg exercise pairings
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
                    title: "Chest & Tricep Hypertrophy",
                    subtitle: "Heavy press & cable burn",
                    targetMuscles: [.chest, .triceps],
                    exercises: Array(ExerciseLibrary.shared.exercises(for: .chest).prefix(3)) + Array(ExerciseLibrary.shared.exercises(for: .triceps).prefix(2))
                ),
                CustomRoutine(
                    title: "Back & Bicep Pull",
                    subtitle: "Lats, deadlifts & peak biceps",
                    targetMuscles: [.back, .biceps],
                    exercises: Array(ExerciseLibrary.shared.exercises(for: .back).prefix(3)) + Array(ExerciseLibrary.shared.exercises(for: .biceps).prefix(2))
                )
            ]
        }
    }

    // MARK: - Preset Split Templates
    public enum PresetSplitType: String, CaseIterable, Identifiable {
        case pushPullLegs = "Push Pull Legs (PPL)"
        case arnoldSplit = "Arnold Split (Chest/Back, Shoulders/Arms, Legs)"
        case upperLower = "Upper / Lower (4-Day)"
        case broSplit = "Classic Bro Split (5-Day)"
        case fullBody = "Full Body (3-Day)"

        public var id: String { rawValue }
    }

    public func applyPresetSplit(_ type: PresetSplitType) {
        let calendar = Calendar.current
        let defaultTime = calendar.date(bySettingHour: 18, minute: 30, second: 0, of: Date()) ?? Date()

        switch type {
        case .pushPullLegs:
            weeklySchedule = [
                DayWorkoutConfig(day: .monday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.chest, .shoulders, .triceps], routineTitle: "Push Day A"),
                DayWorkoutConfig(day: .tuesday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.back, .biceps, .forearms], routineTitle: "Pull Day A"),
                DayWorkoutConfig(day: .wednesday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.quads, .hamstrings, .glutes, .calves], routineTitle: "Leg Day A (Compounds)", customExercises: LegExercisePairing.day1Exercises),
                DayWorkoutConfig(day: .thursday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.chest, .shoulders, .triceps], routineTitle: "Push Day B"),
                DayWorkoutConfig(day: .friday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.back, .biceps], routineTitle: "Pull Day B"),
                DayWorkoutConfig(day: .saturday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.quads, .hamstrings, .glutes, .calves], routineTitle: "Leg Day B (Alternatives)", customExercises: LegExercisePairing.day2AlternativeExercises),
                DayWorkoutConfig(day: .sunday, isRestDay: true, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [], routineTitle: "Rest & Recovery")
            ]
        case .arnoldSplit:
            weeklySchedule = [
                DayWorkoutConfig(day: .monday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.chest, .back], routineTitle: "Chest & Back"),
                DayWorkoutConfig(day: .tuesday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.shoulders, .biceps, .triceps, .forearms], routineTitle: "Shoulders & Arms"),
                DayWorkoutConfig(day: .wednesday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.quads, .hamstrings, .glutes, .calves], routineTitle: "Leg Day 1", customExercises: LegExercisePairing.day1Exercises),
                DayWorkoutConfig(day: .thursday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.chest, .back], routineTitle: "Chest & Back"),
                DayWorkoutConfig(day: .friday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.shoulders, .biceps, .triceps], routineTitle: "Shoulders & Arms"),
                DayWorkoutConfig(day: .saturday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.quads, .hamstrings, .glutes, .calves], routineTitle: "Leg Day 2 (Alternative)", customExercises: LegExercisePairing.day2AlternativeExercises),
                DayWorkoutConfig(day: .sunday, isRestDay: true, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [], routineTitle: "Rest Day")
            ]
        case .upperLower:
            weeklySchedule = [
                DayWorkoutConfig(day: .monday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.chest, .back, .shoulders, .biceps, .triceps], routineTitle: "Upper Body Power"),
                DayWorkoutConfig(day: .tuesday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.quads, .hamstrings, .glutes, .calves], routineTitle: "Lower Body 1", customExercises: LegExercisePairing.day1Exercises),
                DayWorkoutConfig(day: .wednesday, isRestDay: true, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [], routineTitle: "Active Recovery"),
                DayWorkoutConfig(day: .thursday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.chest, .back, .shoulders, .biceps, .triceps], routineTitle: "Upper Body Hypertrophy"),
                DayWorkoutConfig(day: .friday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.quads, .hamstrings, .glutes, .calves], routineTitle: "Lower Body 2 (Alternative)", customExercises: LegExercisePairing.day2AlternativeExercises),
                DayWorkoutConfig(day: .saturday, isRestDay: true, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [], routineTitle: "Rest Day"),
                DayWorkoutConfig(day: .sunday, isRestDay: true, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [], routineTitle: "Rest Day")
            ]
        case .broSplit:
            weeklySchedule = [
                DayWorkoutConfig(day: .monday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.chest], routineTitle: "Chest Day"),
                DayWorkoutConfig(day: .tuesday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.back], routineTitle: "Back Day"),
                DayWorkoutConfig(day: .wednesday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.shoulders, .core], routineTitle: "Shoulders & Abs"),
                DayWorkoutConfig(day: .thursday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.quads, .hamstrings, .glutes, .calves], routineTitle: "Leg Day", customExercises: LegExercisePairing.day1Exercises),
                DayWorkoutConfig(day: .friday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.biceps, .triceps, .forearms], routineTitle: "Arm Farm"),
                DayWorkoutConfig(day: .saturday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.core, .cardio], routineTitle: "Cardio & Core"),
                DayWorkoutConfig(day: .sunday, isRestDay: true, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [], routineTitle: "Rest & Eat")
            ]
        case .fullBody:
            weeklySchedule = [
                DayWorkoutConfig(day: .monday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.chest, .back, .quads, .shoulders], routineTitle: "Full Body A"),
                DayWorkoutConfig(day: .tuesday, isRestDay: true, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [], routineTitle: "Rest Day"),
                DayWorkoutConfig(day: .wednesday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.back, .hamstrings, .chest, .biceps, .triceps], routineTitle: "Full Body B"),
                DayWorkoutConfig(day: .thursday, isRestDay: true, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [], routineTitle: "Rest Day"),
                DayWorkoutConfig(day: .friday, isRestDay: false, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [.quads, .chest, .back, .core], routineTitle: "Full Body C"),
                DayWorkoutConfig(day: .saturday, isRestDay: true, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [], routineTitle: "Rest Day"),
                DayWorkoutConfig(day: .sunday, isRestDay: true, workoutTime: defaultTime, reminderMinutesBefore: 15, targetMuscles: [], routineTitle: "Rest Day")
            ]
        }
        saveSchedule()
        NotificationManager.shared.scheduleAllReminders(for: weeklySchedule)
    }
}
