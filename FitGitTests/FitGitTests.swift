//
//  FitGitTests.swift
//  FitGitTests
//

import Testing
import CoreData
@testable import FitGit

@Suite("Core Data Fitness Stack Tests")
struct FitGitTests {

    private func createTestContext() -> NSManagedObjectContext {
        let controller = PersistenceController(inMemory: true)
        return controller.viewContext
    }

    @Test("Workout, Exercise, and Set creation and volume calculation")
    func testWorkoutExerciseSetRelationships() throws {
        let context = createTestContext()
        let repository = WorkoutRepository(context: context)

        // 1. Create Workout
        let workout = repository.createWorkout(name: "Heavy Upper Power")
        #expect(workout.name == "Heavy Upper Power")
        #expect(workout.isCompleted == false)
        #expect(workout.exercisesArray.isEmpty)

        // 2. Add Exercise
        let bench = repository.addExercise(to: workout, name: "Barbell Bench Press", category: "Chest")
        #expect(workout.exercisesArray.count == 1)
        #expect(bench.unwrappedName == "Barbell Bench Press")
        #expect(bench.unwrappedCategory == "Chest")

        // 3. Add Sets
        let set1 = repository.addSet(to: bench, weight: 100.0, reps: 5, rpe: 8.0)
        let set2 = repository.addSet(to: bench, weight: 105.0, reps: 5, rpe: 9.0)
        #expect(bench.setsArray.count == 2)
        #expect(set1.setNumber == 1)
        #expect(set2.setNumber == 2)

        // 4. Complete sets and verify volume
        repository.toggleSetCompletion(set1)
        #expect(set1.isCompleted == true)
        #expect(workout.totalVolume == 500.0) // 100 * 5

        repository.toggleSetCompletion(set2)
        #expect(workout.totalVolume == 1025.0) // 500 + 525

        // 5. Complete Workout
        repository.finishWorkout(workout)
        #expect(workout.isCompleted == true)
        #expect(workout.endDate != nil)
    }

    @Test("Cascade deletion cleans up exercises and sets")
    func testCascadeDelete() throws {
        let context = createTestContext()
        let repository = WorkoutRepository(context: context)

        let workout = repository.createWorkout(name: "Leg Day")
        let squat = repository.addExercise(to: workout, name: "Squat", category: "Legs")
        _ = repository.addSet(to: squat, weight: 140.0, reps: 5)

        #expect(try repository.fetchWorkouts().count == 1)

        repository.deleteWorkout(workout)

        let remainingWorkouts = try repository.fetchWorkouts()
        #expect(remainingWorkouts.isEmpty)

        let exerciseFetch: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let remainingExercises = try context.fetch(exerciseFetch)
        #expect(remainingExercises.isEmpty)

        let setFetch: NSFetchRequest<ExerciseSet> = ExerciseSet.fetchRequest()
        let remainingSets = try context.fetch(setFetch)
        #expect(remainingSets.isEmpty)
    }

    @Test("On-device ML progressive overload recommendation")
    func testMLInferenceOverload() throws {
        let context = createTestContext()
        let repository = WorkoutRepository(context: context)

        let workout = repository.createWorkout(name: "Test ML")
        let curl = repository.addExercise(to: workout, name: "Bicep Curl", category: "Arms")
        let set = repository.addSet(to: curl, weight: 20.0, reps: 10)
        repository.toggleSetCompletion(set)

        let mlService = MLInferenceService()
        let recommendedWeight = mlService.predictOptimalWeight(exerciseName: curl.unwrappedName, historicalSets: curl.setsArray)

        #expect(recommendedWeight != nil)
        #expect(recommendedWeight! > 20.0)
    }
}
