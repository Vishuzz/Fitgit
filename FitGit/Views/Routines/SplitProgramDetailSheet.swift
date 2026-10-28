//
//  SplitProgramDetailSheet.swift
//  FitGit
//
//  Day-by-day preview and apply sheet for the PDF Workout Splits.
//

import SwiftUI

public struct SplitProgramDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let preset: SplitStore.PresetSplitType
    let onApply: () -> Void

    @State private var showingAppliedNotice: Bool = false

    private var schedule: [DayWorkoutConfig] {
        PDFWorkoutSplits.schedule(for: preset)
    }

    public init(preset: SplitStore.PresetSplitType, onApply: @escaping () -> Void) {
        self.preset = preset
        self.onApply = onApply
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Overview
                    VStack(alignment: .leading, spacing: 8) {
                        Text(preset.rawValue)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(NeumorphicTheme.textPrimary)

                        Text(preset.subtitle)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(NeumorphicTheme.primaryOrange)

                        Text("Exact exercise lists, sets, and repetition ranges extracted from the official Complete Gym Workout Splits Guide.")
                            .font(.caption)
                            .foregroundStyle(NeumorphicTheme.textSecondary)
                            .padding(.top, 2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(18)
                    .neumorphicCard(cornerRadius: 18)
                    .padding(.horizontal)

                    // Day by Day Exercise Breakdown
                    VStack(spacing: 16) {
                        ForEach(schedule) { dayConfig in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(dayConfig.day.rawValue)
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundStyle(NeumorphicTheme.primaryOrange)
                                            .textCase(.uppercase)

                                        Text(dayConfig.routineTitle.isEmpty ? (dayConfig.isRestDay ? "Rest & Recovery" : "Workout") : dayConfig.routineTitle)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(NeumorphicTheme.textPrimary)
                                    }

                                    Spacer()

                                    if dayConfig.isRestDay {
                                        HStack(spacing: 4) {
                                            Image(systemName: "moon.fill")
                                                .font(.caption2)
                                            Text("Rest")
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                        }
                                        .foregroundStyle(Color.blue)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.12))
                                        .clipShape(Capsule())
                                    } else {
                                        Text("\(dayConfig.customExercises.count) Exercises")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundStyle(NeumorphicTheme.textSecondary)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(NeumorphicTheme.darkSurface)
                                            .clipShape(Capsule())
                                    }
                                }

                                if dayConfig.isRestDay {
                                    HStack(spacing: 8) {
                                        Image(systemName: "bed.double.fill")
                                            .foregroundStyle(Color.blue.opacity(0.6))
                                        Text("Recovery, light walking, mobility, and muscle protein synthesis.")
                                            .font(.caption)
                                            .foregroundStyle(NeumorphicTheme.textMuted)
                                    }
                                    .padding(.top, 4)
                                } else {
                                    VStack(spacing: 8) {
                                        ForEach(dayConfig.customExercises) { exercise in
                                            SplitDetailExerciseRow(exercise: exercise)
                                        }
                                    }
                                }
                            }
                            .padding(16)
                            .neumorphicCard(cornerRadius: 18)
                            .padding(.horizontal)
                        }
                    }

                    // Apply Button
                    Button {
                        onApply()
                        showingAppliedNotice = true
                        HapticManager.success()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            dismiss()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: showingAppliedNotice ? "checkmark.circle.fill" : "calendar.badge.plus")
                                .fontWeight(.bold)
                            Text(showingAppliedNotice ? "Program Applied!" : "Apply Program to Schedule")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundStyle(.white)
                    }
                    .neumorphicButton(cornerRadius: 16, accent: showingAppliedNotice ? NeumorphicTheme.emeraldGreen : NeumorphicTheme.primaryOrange)
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
                .padding(.top, 12)
            }
            .background(NeumorphicTheme.background.ignoresSafeArea())
            .navigationTitle("Split Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundStyle(NeumorphicTheme.textPrimary)
                }
            }
        }
    }
}

private struct SplitDetailExerciseRow: View {
    let exercise: ExerciseItem

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(exercise.primaryMuscle.accentColor)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(exercise.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(NeumorphicTheme.textPrimary)

                HStack(spacing: 6) {
                    Text(exercise.primaryMuscle.rawValue)
                        .font(.caption2)
                        .foregroundStyle(exercise.primaryMuscle.accentColor)

                    Text("• \(exercise.equipment)")
                        .font(.caption2)
                        .foregroundStyle(NeumorphicTheme.textMuted)
                }
            }

            Spacer()

            Text("\(exercise.targetSets) × \(exercise.targetRepsRange)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(NeumorphicTheme.primaryOrange)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(NeumorphicTheme.darkSurface)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding(10)
        .neumorphicConcave(cornerRadius: 12)
    }
}

