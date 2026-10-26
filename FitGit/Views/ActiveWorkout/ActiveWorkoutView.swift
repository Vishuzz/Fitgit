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
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 16) {
                        // Live Session HUD Metrics
                        HStack(spacing: 12) {
                            MetricCard(
                                title: "Time",
                                value: viewModel.formattedDuration,
                                icon: "stopwatch.fill",
                                color: AppTheme.electricBlue
                            )
                            MetricCard(
                                title: "Volume",
                                value: String(format: "%.0f kg", viewModel.workout.totalVolume),
                                icon: "scalemass.fill",
                                color: AppTheme.primaryAccent
                            )
                            MetricCard(
                                title: "Sets",
                                value: "\(viewModel.workout.completedSetsCount)/\(viewModel.workout.totalSetsCount)",
                                icon: "checkmark.circle.fill",
                                color: AppTheme.emeraldPower
                            )
                        }
                        .padding(.horizontal)

                        // Exercises List
                        if viewModel.workout.exercisesArray.isEmpty {
                            VStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(AppTheme.primaryAccent.opacity(0.12))
                                        .frame(width: 80, height: 80)
                                    Image(systemName: "dumbbell.fill")
                                        .font(.system(size: 36))
                                        .foregroundStyle(AppTheme.primaryAccent)
                                }
                                .padding(.top, 40)

                                Text("Ready to train?")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)

                                Text("Add exercises to log weights, track reps, and let Core ML compute your progressive overload.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
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
                                        onOpenCalculator: { weight in
                                            viewModel.openPlateCalculator(for: weight)
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
                            HapticManager.light()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                Text("Add Exercise")
                            }
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AppTheme.blazeGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: AppTheme.primaryAccent.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        // Space at the bottom for floating Rest Timer
                        if viewModel.isRestTimerActive {
                            Spacer()
                                .frame(height: 70)
                        }
                    }
                    .padding(.vertical)
                }

                // Floating Rest Timer Bar
                if viewModel.isRestTimerActive {
                    RestTimerBar(
                        remainingSeconds: viewModel.restTimerRemainingSeconds,
                        totalSeconds: viewModel.restTimerTotalSeconds,
                        onAddSeconds: { seconds in
                            viewModel.adjustRestTimer(by: seconds)
                        },
                        onSkip: {
                            viewModel.cancelRestTimer()
                        }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 8)
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: viewModel.isRestTimerActive)
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
                    .foregroundStyle(AppTheme.emeraldPower)
                }
            }
            .sheet(isPresented: $viewModel.showingAddExerciseSheet) {
                AddExerciseSheet { name, category in
                    viewModel.addExercise(name: name, category: category)
                }
            }
            .sheet(isPresented: $viewModel.showingPlateCalculator) {
                PlateCalculatorSheet(initialWeight: viewModel.selectedPlateWeight)
            }
            .confirmationDialog("Finish Workout?", isPresented: $showingFinishConfirmation) {
                Button("Save and Finish", role: .none) {
                    viewModel.finishWorkout()
                    dismiss()
                }
                Button("Keep Training", role: .cancel) {}
            } message: {
                Text("Great session! Total volume: \(String(format: "%.0f kg", viewModel.workout.totalVolume)) across \(viewModel.workout.completedSetsCount) sets.")
            }
            .confirmationDialog("Discard Workout?", isPresented: $showingCancelConfirmation) {
                Button("Discard Session", role: .destructive) {
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
