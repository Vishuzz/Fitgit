//
//  WorkoutRepository.swift
//  FitGit
//

import Foundation
import CoreData

public protocol WorkoutRepositoryProtocol {
    func fetchWorkouts() throws -> [Workout]
    func fetchActiveWorkout() throws -> Workout?
    func createWorkout(name: String, notes: String?) -> Workout
    func addExercise(to workout: Workout, name: String, category: String) -> Exercise
    func addSet(to exercise: Exercise, weight: Double, reps: Int16, rpe: Double?) -> ExerciseSet
    func toggleSetCompletion(_ set: ExerciseSet)
    func updateSet(_ set: ExerciseSet, weight: Double, reps: Int16, rpe: Double?)
    func finishWorkout(_ workout: Workout)
    func deleteWorkout(_ workout: Workout)
    func deleteExercise(_ exercise: Exercise)
    func deleteSet(_ set: ExerciseSet)
    func save()
}

public final class WorkoutRepository: WorkoutRepositoryProtocol {
    private let context: NSManagedObjectContext

    public init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
    }

    public func fetchWorkouts() throws -> [Workout] {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Workout.startDate, ascending: false)]
        return try context.fetch(request)
    }

    public func fetchActiveWorkout() throws -> Workout? {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        request.predicate = NSPredicate(format: "isCompleted == NO")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Workout.startDate, ascending: false)]
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    public func createWorkout(name: String, notes: String? = nil) -> Workout {
        let workout = Workout(context: context)
        workout.id = UUID()
        workout.name = name.isEmpty ? "New Workout" : name
        workout.startDate = Date()
        workout.isCompleted = false
        workout.notes = notes
        workout.duration = 0
        workout.totalVolume = 0
        save()
        return workout
    }

    public func addExercise(to workout: Workout, name: String, category: String) -> Exercise {
        let exercise = Exercise(context: context)
        exercise.id = UUID()
        exercise.name = name
        exercise.category = category
        exercise.orderIndex = Int16(workout.exercisesArray.count)
        exercise.workout = workout
        save()
        return exercise
    }

    public func addSet(to exercise: Exercise, weight: Double, reps: Int16, rpe: Double? = nil) -> ExerciseSet {
        let set = ExerciseSet(context: context)
        set.id = UUID()
        set.setNumber = Int16(exercise.setsArray.count + 1)
        set.weight = weight
        set.reps = reps
        set.rpe = rpe ?? 0.0
        set.isCompleted = false
        set.restDuration = 60.0
        set.exercise = exercise
        save()
        return set
    }

    public func toggleSetCompletion(_ set: ExerciseSet) {
        set.isCompleted.toggle()
        if set.isCompleted {
            set.completedAt = Date()
        } else {
            set.completedAt = nil
        }
        set.exercise?.workout?.recalculateTotalVolume()
        save()
    }

    public func updateSet(_ set: ExerciseSet, weight: Double, reps: Int16, rpe: Double?) {
        set.weight = weight
        set.reps = reps
        if let rpe = rpe {
            set.rpe = rpe
        }
        set.exercise?.workout?.recalculateTotalVolume()
        save()
    }

    public func finishWorkout(_ workout: Workout) {
        workout.isCompleted = true
        workout.endDate = Date()
        if let start = workout.startDate {
            workout.duration = Date().timeIntervalSince(start)
        }
        workout.recalculateTotalVolume()
        save()
    }

    public func deleteWorkout(_ workout: Workout) {
        context.delete(workout)
        save()
    }

    public func deleteExercise(_ exercise: Exercise) {
        let workout = exercise.workout
        context.delete(exercise)
        workout?.recalculateTotalVolume()
        save()
    }

    public func deleteSet(_ set: ExerciseSet) {
        let exercise = set.exercise
        context.delete(set)
        // Renumber remaining sets
        if let remaining = exercise?.setsArray {
            for (idx, s) in remaining.enumerated() {
                s.setNumber = Int16(idx + 1)
            }
        }
        exercise?.workout?.recalculateTotalVolume()
        save()
    }

    public func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Failed to save WorkoutRepository context: \(nsError), \(nsError.userInfo)")
        }
    }
}
