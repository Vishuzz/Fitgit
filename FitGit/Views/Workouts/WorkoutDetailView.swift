//
//  WorkoutDetailView.swift
//  FitGit
//

import SwiftUI

public struct WorkoutDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: WorkoutDetailViewModel
    @State private var showingDeleteAlert: Bool = false
    @State private var showingShareSheet: Bool = false

    public init(workout: Workout) {
        _viewModel = State(initialValue: WorkoutDetailViewModel(workout: workout))
    }

    private var workoutShareText: String {
        var text = "💪 Finished Workout: \(viewModel.workout.unwrappedName)\n"
        text += "⏱️ Duration: \(viewModel.formattedDuration) • 🏋️ Volume: \(viewModel.formattedVolume)\n\n"
        for ex in viewModel.workout.exercisesArray {
            text += "• \(ex.unwrappedName) (\(ex.completedSets.count) sets, top: \(String(format: "%.0f", ex.bestWeight)) kg)\n"
        }
        text += "\nTracked with FitGit"
        return text
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Key Stats Hero Cards
                HStack(spacing: 12) {
                    MetricCard(
                        title: "Volume",
                        value: viewModel.formattedVolume,
                        icon: "scalemass.fill",
                        color: AppTheme.primaryAccent
                    )
                    MetricCard(
                        title: "Duration",
                        value: viewModel.formattedDuration,
                        icon: "clock.fill",
                        color: AppTheme.electricBlue
                    )
                    MetricCard(
                        title: "Completed Sets",
                        value: "\(viewModel.workout.completedSetsCount)",
                        icon: "checkmark.circle.fill",
                        color: AppTheme.emeraldPower
                    )
                }
                .padding(.horizontal)

                if let notes = viewModel.workout.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("NOTES")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                        Text(notes)
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal)
                }

                // Exercises Breakdown with 1RM Estimates
                VStack(alignment: .leading, spacing: 14) {
                    Text("Exercises (\(viewModel.workout.exercisesArray.count))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    ForEach(viewModel.workout.exercisesArray) { exercise in
                        let estimated1RM = calculateEstimated1RM(for: exercise)

                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(exercise.unwrappedName)
                                        .font(.headline)
                                    Text(exercise.unwrappedCategory)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()

                                if estimated1RM > 0 {
                                    VStack(alignment: .trailing, spacing: 1) {
                                        Text("Est. 1RM")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                        Text("\(String(format: "%.1f", estimated1RM)) kg")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundStyle(AppTheme.primaryAccent)
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(AppTheme.primaryAccent.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }

                            Divider()

                            ForEach(exercise.setsArray) { set in
                                HStack {
                                    Text("Set \(set.setNumber)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .frame(width: 50, alignment: .leading)

                                    Spacer()

                                    Text("\(set.formattedWeight) kg × \(set.reps) reps")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)

                                    if set.rpe > 0 {
                                        Text("@ RPE \(String(format: "%.1f", set.rpe))")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }

                                    Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "xmark.circle")
                                        .font(.caption)
                                        .foregroundStyle(set.isCompleted ? AppTheme.emeraldPower : .secondary)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.workout.unwrappedName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                ShareLink(item: workoutShareText) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            ToolbarItem(placement: .destructiveAction) {
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .alert("Delete Workout?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteWorkout()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently remove this workout and its logged sets.")
        }
    }

    /// Epley formula for estimating 1 Rep Max: weight * (1 + reps / 30)
    private func calculateEstimated1RM(for exercise: Exercise) -> Double {
        let maxEstimates = exercise.completedSets.map { set in
            if set.reps <= 1 {
                return set.weight
            } else {
                return set.weight * (1.0 + Double(set.reps) / 30.0)
            }
        }
        return maxEstimates.max() ?? 0.0
    }
}
