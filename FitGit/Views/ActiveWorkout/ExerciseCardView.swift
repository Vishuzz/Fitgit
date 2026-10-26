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
    let onDeleteSet: (ExerciseSet) -> Void
    let onDeleteExercise: () -> Void

    public init(
        exercise: Exercise,
        onAddSet: @escaping () -> Void,
        onToggleSet: @escaping (ExerciseSet) -> Void,
        onDeleteSet: @escaping (ExerciseSet) -> Void,
        onDeleteExercise: @escaping () -> Void
    ) {
        self.exerciseObservable = ExerciseObservable(exercise: exercise)
        self.onAddSet = onAddSet
        self.onToggleSet = onToggleSet
        self.onDeleteSet = onDeleteSet
        self.onDeleteExercise = onDeleteExercise
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Exercise Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(exerciseObservable.exercise.unwrappedName)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(exerciseObservable.exercise.unwrappedCategory)
                        .font(.caption)
                        .foregroundStyle(.secondary)
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
                        .padding(6)
                }
            }

            // Table Header
            HStack(spacing: 12) {
                Text("SET")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .frame(width: 24)
                Text("WEIGHT")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .frame(width: 65)
                Text("REPS")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .frame(width: 55)
                Spacer()
                Image(systemName: "checkmark")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 8)

            Divider()

            // Sets List
            ForEach(exerciseObservable.exercise.setsArray) { set in
                SetRowView(
                    set: set,
                    onToggleComplete: { onToggleSet(set) },
                    onDelete: { onDeleteSet(set) }
                )
            }

            // Add Set Button
            Button(action: onAddSet) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Set")
                }
                .font(.footnote)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
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
