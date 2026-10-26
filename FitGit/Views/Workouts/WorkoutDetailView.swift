//
//  WorkoutDetailView.swift
//  FitGit
//

import SwiftUI

public struct WorkoutDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: WorkoutDetailViewModel
    @State private var showingDeleteAlert: Bool = false

    public init(workout: Workout) {
        _viewModel = State(initialValue: WorkoutDetailViewModel(workout: workout))
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Key Stats
                HStack(spacing: 12) {
                    MetricCard(
                        title: "Volume",
                        value: viewModel.formattedVolume,
                        icon: "scalemass.fill",
                        color: .orange
                    )
                    MetricCard(
                        title: "Duration",
                        value: viewModel.formattedDuration,
                        icon: "clock.fill",
                        color: .blue
                    )
                    MetricCard(
                        title: "Completed Sets",
                        value: "\(viewModel.workout.completedSetsCount)",
                        icon: "checkmark.circle.fill",
                        color: .green
                    )
                }
                .padding(.horizontal)

                if let notes = viewModel.workout.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Notes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(notes)
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }

                // Exercises Breakdown
                VStack(alignment: .leading, spacing: 14) {
                    Text("Exercises (\(viewModel.workout.exercisesArray.count))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    ForEach(viewModel.workout.exercisesArray) { exercise in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(exercise.unwrappedName)
                                    .font(.headline)
                                Spacer()
                                Text(exercise.unwrappedCategory)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.accentColor.opacity(0.12))
                                    .foregroundStyle(Color.accentColor)
                                    .clipShape(Capsule())
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
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "xmark.circle")
                                        .font(.caption)
                                        .foregroundStyle(set.isCompleted ? .green : .secondary)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
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
}
