//
//  WorkoutListViewModel.swift
//  FitGit
//

import SwiftUI
import CoreData
import Observation

@Observable
public final class WorkoutListViewModel {
    public var workouts: [Workout] = []
    public var activeWorkout: Workout?
    public var isLoading: Bool = false
    public var errorMessage: String?
    public var showingCreateSheet: Bool = false
    public var newWorkoutName: String = ""

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

    public func startNewWorkout(name: String) -> Workout {
        let workoutName = name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Workout on \(Date().formatted(date: .abbreviated, time: .shortened))" : name
        let created = repository.createWorkout(name: workoutName, notes: nil)
        loadWorkouts()
        return created
    }

    public func deleteWorkout(at offsets: IndexSet) {
        for index in offsets {
            let workout = workouts[index]
            repository.deleteWorkout(workout)
        }
        loadWorkouts()
    }

    public func deleteWorkout(_ workout: Workout) {
        repository.deleteWorkout(workout)
        loadWorkouts()
    }
}
