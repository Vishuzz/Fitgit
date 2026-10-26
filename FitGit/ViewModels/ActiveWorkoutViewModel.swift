//
//  ActiveWorkoutViewModel.swift
//  FitGit
//

import SwiftUI
import CoreData
import Observation

@Observable
public final class ActiveWorkoutViewModel {
    public var workout: Workout
    public var elapsedTime: TimeInterval = 0
    public var isTimerRunning: Bool = false
    public var showingAddExerciseSheet: Bool = false

    private var timer: Timer?
    private let repository: WorkoutRepositoryProtocol

    public init(workout: Workout, repository: WorkoutRepositoryProtocol = WorkoutRepository()) {
        self.workout = workout
        self.repository = repository
        updateElapsedTime()
        startTimer()
    }

    deinit {
        stopTimer()
    }

    public func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }

    public func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }

    public func updateElapsedTime() {
        if let start = workout.startDate {
            elapsedTime = Date().timeIntervalSince(start)
        }
    }

    public var formattedDuration: String {
        let totalSeconds = Int(elapsedTime)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    public func addExercise(name: String, category: String) {
        _ = repository.addExercise(to: workout, name: name, category: category)
    }

    public func addSet(to exercise: Exercise, weight: Double = 0.0, reps: Int16 = 0) {
        // Inherit last set's weight and reps if available
        let lastSet = exercise.setsArray.last
        let initialWeight = lastSet?.weight ?? weight
        let initialReps = lastSet?.reps ?? reps
        _ = repository.addSet(to: exercise, weight: initialWeight, reps: initialReps, rpe: nil)
    }

    public func toggleSetCompletion(_ set: ExerciseSet) {
        repository.toggleSetCompletion(set)
    }

    public func updateSet(_ set: ExerciseSet, weight: Double, reps: Int16, rpe: Double? = nil) {
        repository.updateSet(set, weight: weight, reps: reps, rpe: rpe)
    }

    public func deleteSet(_ set: ExerciseSet) {
        repository.deleteSet(set)
    }

    public func deleteExercise(_ exercise: Exercise) {
        repository.deleteExercise(exercise)
    }

    public func finishWorkout() {
        stopTimer()
        repository.finishWorkout(workout)
    }

    public func cancelWorkout() {
        stopTimer()
        repository.deleteWorkout(workout)
    }
}
