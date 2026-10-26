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
    public var showingPlateCalculator: Bool = false
    public var selectedPlateWeight: Double = 60.0

    // MARK: - Rest Timer State
    public var isRestTimerActive: Bool = false
    public var restTimerRemainingSeconds: Int = 0
    public var restTimerTotalSeconds: Int = 60

    private var workoutTimer: Timer?
    private var restCountdownTimer: Timer?
    private let repository: WorkoutRepositoryProtocol

    public init(workout: Workout, repository: WorkoutRepositoryProtocol = WorkoutRepository()) {
        self.workout = workout
        self.repository = repository
        updateElapsedTime()
        startTimer()
    }

    deinit {
        stopTimer()
        cancelRestTimer()
    }

    public func startTimer() {
        isTimerRunning = true
        workoutTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }

    public func stopTimer() {
        workoutTimer?.invalidate()
        workoutTimer = nil
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

    // MARK: - Rest Timer Methods
    public func triggerRestTimer(seconds: Int = 60) {
        restCountdownTimer?.invalidate()
        restTimerTotalSeconds = seconds
        restTimerRemainingSeconds = seconds
        isRestTimerActive = true

        restCountdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.restTimerRemainingSeconds > 1 {
                self.restTimerRemainingSeconds -= 1
            } else {
                self.cancelRestTimer()
                HapticManager.success()
            }
        }
    }

    public func adjustRestTimer(by seconds: Int) {
        restTimerRemainingSeconds = max(5, restTimerRemainingSeconds + seconds)
        restTimerTotalSeconds = max(restTimerTotalSeconds, restTimerRemainingSeconds)
    }

    public func cancelRestTimer() {
        restCountdownTimer?.invalidate()
        restCountdownTimer = nil
        isRestTimerActive = false
        restTimerRemainingSeconds = 0
    }

    // MARK: - Workout Operations
    public func addExercise(name: String, category: String) {
        _ = repository.addExercise(to: workout, name: name, category: category)
        HapticManager.medium()
    }

    public func addSet(to exercise: Exercise, weight: Double = 0.0, reps: Int16 = 0) {
        let lastSet = exercise.setsArray.last
        let initialWeight = lastSet?.weight ?? weight
        let initialReps = lastSet?.reps ?? reps
        _ = repository.addSet(to: exercise, weight: initialWeight, reps: initialReps, rpe: nil)
        HapticManager.light()
    }

    public func toggleSetCompletion(_ set: ExerciseSet) {
        repository.toggleSetCompletion(set)
        if set.isCompleted {
            HapticManager.success()
            // Auto-trigger rest timer if configured
            let restDuration = set.restDuration > 0 ? Int(set.restDuration) : 60
            triggerRestTimer(seconds: restDuration)
        } else {
            HapticManager.light()
        }
    }

    public func updateSet(_ set: ExerciseSet, weight: Double, reps: Int16, rpe: Double? = nil) {
        repository.updateSet(set, weight: weight, reps: reps, rpe: rpe)
    }

    public func deleteSet(_ set: ExerciseSet) {
        repository.deleteSet(set)
        HapticManager.light()
    }

    public func deleteExercise(_ exercise: Exercise) {
        repository.deleteExercise(exercise)
        HapticManager.medium()
    }

    public func finishWorkout() {
        stopTimer()
        cancelRestTimer()
        repository.finishWorkout(workout)
        HapticManager.success()
    }

    public func cancelWorkout() {
        stopTimer()
        cancelRestTimer()
        repository.deleteWorkout(workout)
    }

    public func openPlateCalculator(for weight: Double) {
        selectedPlateWeight = max(20.0, weight)
        showingPlateCalculator = true
    }
}
