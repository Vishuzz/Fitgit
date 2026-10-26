//
//  ExerciseCardView.swift
//  FitGit
//

import SwiftUI
import Combine

public struct ExerciseCardView: View {
    @ObservedObject var exerciseObservable: ExerciseObservable
    let onAddSet: () -> Void
    let onToggleSet: (ExerciseSet) -> Void
    let onOpenCalculator: (Double) -> Void
    let onDeleteSet: (ExerciseSet) -> Void
    let onDeleteExercise: () -> Void

    public init(
        exercise: Exercise,
        onAddSet: @escaping () -> Void,
        onToggleSet: @escaping (ExerciseSet) -> Void,
        onOpenCalculator: @escaping (Double) -> Void,
        onDeleteSet: @escaping (ExerciseSet) -> Void,
        onDeleteExercise: @escaping () -> Void
    ) {
        self.exerciseObservable = ExerciseObservable(exercise: exercise)
        self.onAddSet = onAddSet
        self.onToggleSet = onToggleSet
        self.onOpenCalculator = onOpenCalculator
        self.onDeleteSet = onDeleteSet
        self.onDeleteExercise = onDeleteExercise
    }

    private var muscleCategory: MuscleGroup? {
        MuscleGroup(rawValue: exerciseObservable.exercise.unwrappedCategory)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Exercise Header
            HStack {
                Circle()
                    .fill((muscleCategory?.accentColor ?? AppTheme.primaryAccent).opacity(0.15))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: muscleCategory?.iconName ?? "dumbbell.fill")
                            .font(.caption)
                            .foregroundStyle(muscleCategory?.accentColor ?? AppTheme.primaryAccent)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(exerciseObservable.exercise.unwrappedName)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    HStack(spacing: 6) {
                        Text(exerciseObservable.exercise.unwrappedCategory)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        if exerciseObservable.exercise.bestWeight > 0 {
                            Text("• Best: \(String(format: "%.0f", exerciseObservable.exercise.bestWeight)) kg")
                                .font(.caption2)
                                .foregroundStyle(AppTheme.emeraldPower)
                                .fontWeight(.semibold)
                        }
                    }
                }
                Spacer()

                Menu {
                    Button(role: .destructive, action: onDeleteExercise) {
                        Label("Remove Exercise", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(8)
                }
            }

            // Table Header
            HStack(spacing: 10) {
                Text("SET")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .frame(width: 28)

                Text("WEIGHT")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .frame(width: 70)

                Text("REPS")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .frame(width: 58)

                Spacer()

                Image(systemName: "checkmark")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .frame(width: 38)
            }
            .padding(.horizontal, 8)

            Divider()

            // Sets List
            ForEach(exerciseObservable.exercise.setsArray) { set in
                SetRowView(
                    set: set,
                    previousPerformance: nil,
                    onToggleComplete: { onToggleSet(set) },
                    onOpenCalculator: { weight in onOpenCalculator(weight) },
                    onDelete: { onDeleteSet(set) }
                )
            }

            // Add Set Button
            Button(action: onAddSet) {
                HStack(spacing: 6) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Set")
                }
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.primaryAccent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(AppTheme.primaryAccent.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}

public final class ExerciseObservable: ObservableObject {
    public let exercise: Exercise

    public init(exercise: Exercise) {
        self.exercise = exercise
    }
}
