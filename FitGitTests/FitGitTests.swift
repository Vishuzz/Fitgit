//
//  FitGitTests.swift
//  FitGitTests
//

import Testing
import CoreData
import Foundation
@testable import FitGit

@Suite("FitGit Full Stack & Weekly Split Tests")
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

    @Test("Weekly Split Plan configuration and Day Schedule")
    func testWeeklySplitPlan() throws {
        let store = SplitStore()
        store.applyPresetSplit(.pushPullLegs)

        #expect(store.weeklySchedule.count == 7)

        let monday = store.weeklySchedule.first(where: { $0.day == .monday })
        #expect(monday != nil)
        #expect(monday?.isRestDay == false)
        #expect(monday?.targetMuscles.contains(.chest) == true)

        let sunday = store.weeklySchedule.first(where: { $0.day == .sunday })
        #expect(sunday != nil)
        #expect(sunday?.isRestDay == true)
    }

    @Test("Exercise Library covers all muscle groups")
    func testExerciseLibraryCoverage() throws {
        let library = ExerciseLibrary.shared
        #expect(library.allExercises.count > 50)

        for muscle in MuscleGroupCategory.allCases {
            let exercises = library.exercises(for: muscle)
            #expect(!exercises.isEmpty, "Muscle \(muscle.rawValue) must have exercises")
        }
    }

    @Test("Notification alert timing calculation and formatting")
    func testNotificationAlertTimeCalculations() throws {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current

        // 18:30 with 15-minute lead time -> 18:15 alert time
        var comps = DateComponents()
        comps.hour = 18
        comps.minute = 30
        let workoutDate = calendar.date(from: comps) ?? Date()

        let config = DayWorkoutConfig(
            day: .monday,
            isRestDay: false,
            workoutTime: workoutDate,
            reminderMinutesBefore: 15,
            targetMuscles: [.chest, .triceps],
            routineTitle: "Push Day"
        )

        let alertHour = calendar.component(.hour, from: config.alertTime)
        let alertMinute = calendar.component(.minute, from: config.alertTime)
        #expect(alertHour == 18)
        #expect(alertMinute == 15)

        // Midnight rollover edge case: 00:10 with 15-minute reminder -> 23:55
        var midnightComps = DateComponents()
        midnightComps.hour = 0
        midnightComps.minute = 10
        let midnightWorkout = calendar.date(from: midnightComps) ?? Date()

        let midnightConfig = DayWorkoutConfig(
            day: .tuesday,
            isRestDay: false,
            workoutTime: midnightWorkout,
            reminderMinutesBefore: 15
        )

        let rolloverHour = calendar.component(.hour, from: midnightConfig.alertTime)
        let rolloverMinute = calendar.component(.minute, from: midnightConfig.alertTime)
        #expect(rolloverHour == 23)
        #expect(rolloverMinute == 55)
    }

    @Test("Notification Manager schedules active workout days and filters rest days")
    func testNotificationSchedulingLogic() throws {
        let store = SplitStore()
        store.applyPresetSplit(.pushPullLegs)

        let activeDays = store.weeklySchedule.filter { !$0.isRestDay }
        let restDays = store.weeklySchedule.filter { $0.isRestDay }

        #expect(activeDays.count == 6)
        #expect(restDays.count == 1)

        for dayConfig in activeDays {
            #expect(!dayConfig.summaryMuscles.isEmpty)
            #expect(dayConfig.reminderMinutesBefore >= 15)
        }
    }
}
