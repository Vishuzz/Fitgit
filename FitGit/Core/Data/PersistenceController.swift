//
//  PersistenceController.swift
//  FitGit
//

import CoreData

public struct PersistenceController {
    // MARK: - Shared Singleton
    public static let shared = PersistenceController()

    // MARK: - Preview In-Memory Container
    public static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        // Create sample workout
        let workout = Workout(context: viewContext)
        workout.id = UUID()
        workout.name = "Push Day A"
        workout.startDate = Calendar.current.date(byAdding: .hour, value: -1, to: Date())
        workout.endDate = Date()
        workout.isCompleted = true
        workout.duration = 3600
        workout.notes = "Great bench session, hit high intensity on top sets."

        // Exercise 1: Barbell Bench Press
        let bench = Exercise(context: viewContext)
        bench.id = UUID()
        bench.name = "Barbell Bench Press"
        bench.category = "Chest"
        bench.orderIndex = 0
        bench.workout = workout

        let bSet1 = ExerciseSet(context: viewContext)
        bSet1.id = UUID()
        bSet1.setNumber = 1
        bSet1.weight = 80.0
        bSet1.reps = 10
        bSet1.isCompleted = true
        bSet1.rpe = 7.5
        bSet1.exercise = bench

        let bSet2 = ExerciseSet(context: viewContext)
        bSet2.id = UUID()
        bSet2.setNumber = 2
        bSet2.weight = 90.0
        bSet2.reps = 8
        bSet2.isCompleted = true
        bSet2.rpe = 8.5
        bSet2.exercise = bench

        let bSet3 = ExerciseSet(context: viewContext)
        bSet3.id = UUID()
        bSet3.setNumber = 3
        bSet3.weight = 100.0
        bSet3.reps = 5
        bSet3.isCompleted = true
        bSet3.rpe = 9.5
        bSet3.exercise = bench

        // Exercise 2: Overhead Shoulder Press
        let ohp = Exercise(context: viewContext)
        ohp.id = UUID()
        ohp.name = "Overhead Dumbbell Press"
        ohp.category = "Shoulders"
        ohp.orderIndex = 1
        ohp.workout = workout

        let oSet1 = ExerciseSet(context: viewContext)
        oSet1.id = UUID()
        oSet1.setNumber = 1
        oSet1.weight = 24.0
        oSet1.reps = 12
        oSet1.isCompleted = true
        oSet1.rpe = 8.0
        oSet1.exercise = ohp

        workout.recalculateTotalVolume()

        // Create a second active workout for testing active state
        let activeWorkout = Workout(context: viewContext)
        activeWorkout.id = UUID()
        activeWorkout.name = "Leg Day Hypertrophy"
        activeWorkout.startDate = Date()
        activeWorkout.isCompleted = false
        activeWorkout.notes = "Focus on quad drive and tempo."

        let squat = Exercise(context: viewContext)
        squat.id = UUID()
        squat.name = "Barbell Back Squat"
        squat.category = "Legs"
        squat.orderIndex = 0
        squat.workout = activeWorkout

        let sSet1 = ExerciseSet(context: viewContext)
        sSet1.id = UUID()
        sSet1.setNumber = 1
        sSet1.weight = 100.0
        sSet1.reps = 10
        sSet1.isCompleted = true
        sSet1.exercise = squat

        let sSet2 = ExerciseSet(context: viewContext)
        sSet2.id = UUID()
        sSet2.setNumber = 2
        sSet2.weight = 110.0
        sSet2.reps = 8
        sSet2.isCompleted = false
        sSet2.exercise = squat

        controller.save()
        return controller
    }()

    // MARK: - Core Data Container
    public let container: NSPersistentContainer

    public var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    public init(inMemory: Bool = false) {
        // Attempt to find the managed object model in Bundle.main
        if let modelURL = Bundle.main.url(forResource: "FitGitModel", withExtension: "momd"),
           let model = NSManagedObjectModel(contentsOf: modelURL) {
            container = NSPersistentContainer(name: "FitGitModel", managedObjectModel: model)
        } else {
            container = NSPersistentContainer(name: "FitGitModel")
        }

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // In production, log and handle gracefully
                fatalError("Unresolved Core Data error: \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // MARK: - Context Operations
    public func save() {
        let context = container.viewContext
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Error saving Core Data context: \(nsError), \(nsError.userInfo)")
        }
    }

    public func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
}
