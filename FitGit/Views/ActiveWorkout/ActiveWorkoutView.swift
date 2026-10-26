//
//  ActiveWorkoutView.swift
//  FitGit
//

import SwiftUI

public struct ActiveWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ActiveWorkoutViewModel
    @State private var showingFinishConfirmation: Bool = false
    @State private var showingCancelConfirmation: Bool = false

    public init(workout: Workout) {
        _viewModel = State(initialValue: ActiveWorkoutViewModel(workout: workout))
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Session Live Metrics
                    HStack(spacing: 12) {
                        MetricCard(
                            title: "Time",
                            value: viewModel.formattedDuration,
                            icon: "stopwatch.fill",
                            color: .blue
                        )
                        MetricCard(
                            title: "Volume",
                            value: String(format: "%.0f kg", viewModel.workout.totalVolume),
                            icon: "scalemass.fill",
                            color: .orange
                        )
                        MetricCard(
                            title: "Sets",
                            value: "\(viewModel.workout.completedSetsCount)/\(viewModel.workout.totalSetsCount)",
                            icon: "number.circle.fill",
                            color: .green
                        )
                    }
                    .padding(.horizontal)

                    // Exercises Cards
                    if viewModel.workout.exercisesArray.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "dumbbell.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.secondary.opacity(0.6))
                                .padding(.top, 40)
                            Text("No exercises added yet")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Text("Tap '+ Add Exercise' below to start logging your sets.")
                                .font(.subheadline)
                                .foregroundStyle(.tertiary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.workout.exercisesArray) { exercise in
                                ExerciseCardView(
                                    exercise: exercise,
                                    onAddSet: {
                                        viewModel.addSet(to: exercise)
                                    },
                                    onToggleSet: { set in
                                        viewModel.toggleSetCompletion(set)
                                    },
                                    onDeleteSet: { set in
                                        viewModel.deleteSet(set)
                                    },
                                    onDeleteExercise: {
                                        viewModel.deleteExercise(exercise)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Add Exercise Button
                    Button {
                        viewModel.showingAddExerciseSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Exercise")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: Color.accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(viewModel.workout.unwrappedName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Discard", role: .destructive) {
                        showingCancelConfirmation = true
                    }
                    .foregroundStyle(.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Finish") {
                        showingFinishConfirmation = true
                    }
                    .fontWeight(.bold)
                }
            }
            .sheet(isPresented: $viewModel.showingAddExerciseSheet) {
                AddExerciseSheet { name, category in
                    viewModel.addExercise(name: name, category: category)
                }
            }
            .confirmationDialog("Finish Workout?", isPresented: $showingFinishConfirmation) {
                Button("Save and Finish", role: .none) {
                    viewModel.finishWorkout()
                    dismiss()
                }
                Button("Keep Training", role: .cancel) {}
            } message: {
                Text("Great work! Ready to log this workout to your history?")
            }
            .confirmationDialog("Discard Workout?", isPresented: $showingCancelConfirmation) {
                Button("Discard Workout", role: .destructive) {
                    viewModel.cancelWorkout()
                    dismiss()
                }
                Button("Keep Training", role: .cancel) {}
            } message: {
                Text("Are you sure? All logged sets for this session will be removed.")
            }
        }
    }
}
