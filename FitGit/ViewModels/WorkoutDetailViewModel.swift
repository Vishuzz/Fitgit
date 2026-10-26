//
//  WorkoutDetailViewModel.swift
//  FitGit
//

import SwiftUI
import CoreData
import Observation

@Observable
public final class WorkoutDetailViewModel {
    public var workout: Workout
    private let repository: WorkoutRepositoryProtocol

    public init(workout: Workout, repository: WorkoutRepositoryProtocol = WorkoutRepository()) {
        self.workout = workout
        self.repository = repository
    }

    public var formattedDuration: String {
        let totalSeconds = Int(workout.duration)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes) min"
        }
    }

    public var formattedVolume: String {
        let vol = workout.totalVolume
        if vol >= 1000 {
            return String(format: "%.1f k kg", vol / 1000.0)
        } else {
            return String(format: "%.0f kg", vol)
        }
    }

    public func deleteWorkout() {
        repository.deleteWorkout(workout)
    }
}
