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
                    // Weekly Streak & Volume Hero Banner
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("THIS WEEK")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(AppTheme.primaryAccent)
                            Text("\(viewModel.weeklyCompletedCount) Workouts Completed")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("\(String(format: "%.0f", viewModel.weeklyTotalVolume)) kg total volume lifted")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        ZStack {
                            Circle()
                                .stroke(Color(.systemGray5), lineWidth: 6)
                            Circle()
                                .trim(from: 0, to: min(1.0, Double(viewModel.weeklyCompletedCount) / 4.0))
                                .stroke(AppTheme.blazeGradient, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                            VStack(spacing: 0) {
                                Text("\(viewModel.weeklyCompletedCount)")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("/4")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(width: 54, height: 54)
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)

                    // Active Workout Sticky Resume Card (if in progress)
                    if let active = viewModel.activeWorkout {
                        Button {
                            HapticManager.medium()
                            activeWorkoutToPresent = active
                        } label: {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.orange.opacity(0.15))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "timer")
                                        .font(.headline)
                                        .foregroundStyle(.orange)
                                }

                                VStack(alignment: .leading, spacing: 3) {
                                    HStack {
                                        Text("CURRENT WORKOUT")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.orange)
                                        Spacer()
                                        Text("RESUME")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color.orange)
                                            .foregroundStyle(.white)
                                            .clipShape(Capsule())
                                    }
                                    Text(active.unwrappedName)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    Text("\(active.completedSetsCount) of \(active.totalSetsCount) sets completed")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(14)
                            .background(Color.orange.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.orange.opacity(0.35), lineWidth: 1.5)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        .padding(.horizontal)
                    }

                    // Start Empty Workout Hero Button
                    Button {
                        HapticManager.medium()
                        showingNamePrompt = true
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "plus")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Start Empty Workout")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Text("Build your session set-by-set")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.85))
                            }

                            Spacer()

                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.white)
                        }
                        .padding(14)
                        .background(AppTheme.blazeGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: AppTheme.primaryAccent.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)

                    // Routine Templates Carousel
                    RoutineTemplateCarouselView { template in
                        let created = viewModel.startWorkoutFromTemplate(template)
                        activeWorkoutToPresent = created
                    }

                    // Workouts Filter & Search Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("History")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()

                            // Filter Picker
                            Picker("Filter", selection: $viewModel.selectedFilter) {
                                ForEach(WorkoutFilter.allCases) { filter in
                                    Text(filter.rawValue).tag(filter)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(maxWidth: 220)
                        }
                        .padding(.horizontal)

                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            TextField("Search workouts or exercises...", text: $viewModel.searchText)
                            if !viewModel.searchText.isEmpty {
                                Button {
                                    viewModel.searchText = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(10)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)

                        // Workouts List
                        if viewModel.filteredWorkouts.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "figure.strengthtraining.traditional")
                                    .font(.system(size: 44))
                                    .foregroundStyle(.secondary.opacity(0.4))
                                    .padding(.top, 24)
                                Text("No workouts found")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                Text("Start a workout above to log your lifts and track your strength.")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.filteredWorkouts) { workout in
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
            .navigationTitle("FitGit")
            .refreshable {
                viewModel.loadWorkouts()
            }
            .alert("Start New Workout", isPresented: $showingNamePrompt) {
                TextField("Workout Name (e.g. Chest & Shoulders)", text: $newWorkoutTitle)
                Button("Start Training") {
                    let created = viewModel.startNewWorkout(name: newWorkoutTitle)
                    newWorkoutTitle = ""
                    activeWorkoutToPresent = created
                }
                Button("Cancel", role: .cancel) {
                    newWorkoutTitle = ""
                }
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
