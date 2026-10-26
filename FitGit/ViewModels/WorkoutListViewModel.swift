//
//  WorkoutListViewModel.swift
//  FitGit
//

import SwiftUI
import CoreData
import Observation

public enum WorkoutFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case thisWeek = "This Week"
    case thisMonth = "This Month"

    public var id: String { rawValue }
}

@Observable
public final class WorkoutListViewModel {
    public var workouts: [Workout] = []
    public var activeWorkout: Workout?
    public var isLoading: Bool = false
    public var errorMessage: String?
    public var showingCreateSheet: Bool = false
    public var newWorkoutName: String = ""
    public var selectedFilter: WorkoutFilter = .all
    public var searchText: String = ""

    private let repository: WorkoutRepositoryProtocol

    public init(repository: WorkoutRepositoryProtocol = WorkoutRepository()) {
        self.repository = repository
        loadWorkouts()
    }

    public func loadWorkouts() {
        isLoading = true
        errorMessage = nil
        do {
            self.workouts = try repository.fetchWorkouts()
            self.activeWorkout = try repository.fetchActiveWorkout()
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    public var filteredWorkouts: [Workout] {
        var list = workouts

        // Text search filter
        if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            list = list.filter {
                $0.unwrappedName.localizedCaseInsensitiveContains(searchText) ||
                $0.exercisesArray.contains { $0.unwrappedName.localizedCaseInsensitiveContains(searchText) }
            }
        }

        // Time window filter
        let calendar = Calendar.current
        let now = Date()
        switch selectedFilter {
        case .all:
            return list
        case .thisWeek:
            guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start else { return list }
            return list.filter { ($0.startDate ?? Date.distantPast) >= startOfWeek }
        case .thisMonth:
            guard let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start else { return list }
            return list.filter { ($0.startDate ?? Date.distantPast) >= startOfMonth }
        }
    }

    public var weeklyCompletedCount: Int {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else { return 0 }
        return workouts.filter { $0.isCompleted && ($0.startDate ?? Date.distantPast) >= startOfWeek }.count
    }

    public var weeklyTotalVolume: Double {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else { return 0 }
        return workouts.filter { $0.isCompleted && ($0.startDate ?? Date.distantPast) >= startOfWeek }
            .reduce(0.0) { $0 + $1.totalVolume }
    }

    public func startNewWorkout(name: String) -> Workout {
        let workoutName = name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Workout on \(Date().formatted(date: .abbreviated, time: .shortened))" : name
        let created = repository.createWorkout(name: workoutName, notes: nil)
        loadWorkouts()
        return created
    }

    public func startWorkoutFromTemplate(_ template: WorkoutTemplate) -> Workout {
        let created = repository.createWorkoutFromTemplate(template)
        loadWorkouts()
        return created
    }

    public func deleteWorkout(at offsets: IndexSet) {
        for index in offsets {
            let workout = filteredWorkouts[index]
            repository.deleteWorkout(workout)
        }
        loadWorkouts()
    }

    public func deleteWorkout(_ workout: Workout) {
        repository.deleteWorkout(workout)
        loadWorkouts()
    }
}
