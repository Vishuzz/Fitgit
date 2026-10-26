//
//  WorkoutListView.swift
//  FitGit
//

import SwiftUI

public struct WorkoutListView: View {
    @State private var viewModel: WorkoutListViewModel
    @State private var activeWorkoutToPresent: Workout?
    @State private var showingNamePrompt: Bool = false
    @State private var newWorkoutTitle: String = ""

    public init(viewModel: WorkoutListViewModel = WorkoutListViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Quick Action: Start New Workout Banner
                    Button {
                        showingNamePrompt = true
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(Color.accentColor.opacity(0.15))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "plus")
                                    .font(.headline)
                                    .foregroundStyle(Color.accentColor)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Start Empty Workout")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text("Log exercises and sets on the fly")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                    }
                    .padding(.horizontal)

                    // Active Workout Sticky Resume Card (if one is ongoing)
                    if let active = viewModel.activeWorkout {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CURRENT SESSION")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.orange)
                                .padding(.horizontal)

                            Button {
                                activeWorkoutToPresent = active
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(active.unwrappedName)
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                        Text("Started \(active.unwrappedStartDate.formatted(date: .omitted, time: .shortened)) • \(active.completedSetsCount) sets completed")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text("Resume")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(Color.orange)
                                        .foregroundStyle(.white)
                                        .clipShape(Capsule())
                                }
                                .padding(14)
                                .background(Color.orange.opacity(0.08))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Workout History Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Workout History")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(viewModel.workouts.count) total")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal)

                        if viewModel.workouts.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "figure.run.circle")
                                    .font(.system(size: 48))
                                    .foregroundStyle(.secondary.opacity(0.5))
                                    .padding(.top, 30)
                                Text("No workouts logged yet")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                Text("Your completed workouts and training metrics will show up here.")
                                    .font(.subheadline)
                                    .foregroundStyle(.tertiary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.workouts) { workout in
                                    NavigationLink {
                                        WorkoutDetailView(workout: workout)
                                    } label: {
                                        WorkoutCardView(workout: workout)
                                    }
                                    .buttonStyle(.plain)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            viewModel.deleteWorkout(workout)
                                        } label: {
                                            Label("Delete Workout", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingNamePrompt = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .refreshable {
                viewModel.loadWorkouts()
            }
            .alert("New Workout", isPresented: $showingNamePrompt) {
                TextField("Workout Name (e.g. Chest & Triceps)", text: $newWorkoutTitle)
                Button("Start") {
                    let created = viewModel.startNewWorkout(name: newWorkoutTitle)
                    newWorkoutTitle = ""
                    activeWorkoutToPresent = created
                }
                Button("Cancel", role: .cancel) {
                    newWorkoutTitle = ""
                }
            } message: {
                Text("Give your workout a name or leave blank for a default timestamp.")
            }
            .fullScreenCover(item: $activeWorkoutToPresent) { workout in
                ActiveWorkoutView(workout: workout)
                    .onDisappear {
                        viewModel.loadWorkouts()
                    }
            }
            .onAppear {
                viewModel.loadWorkouts()
            }
        }
    }
}
