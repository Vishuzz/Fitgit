//
//  Workout+CoreDataProperties.swift
//  FitGit
//

import Foundation
import CoreData

extension Workout: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var notes: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var totalVolume: Double
    @NSManaged public var duration: Double
    @NSManaged public var exercises: NSSet?

    // MARK: - Safe Convenience Properties

    public var unwrappedId: UUID {
        id ?? UUID()
    }

    public var unwrappedName: String {
        name ?? "Unnamed Workout"
    }

    public var unwrappedStartDate: Date {
        startDate ?? Date()
    }

    public var exercisesArray: [Exercise] {
        let set = exercises as? Set<Exercise> ?? []
        return set.sorted { $0.orderIndex < $1.orderIndex }
    }

    public var totalSetsCount: Int {
        exercisesArray.reduce(0) { $0 + $1.setsArray.count }
    }

    public var completedSetsCount: Int {
        exercisesArray.reduce(0) { sum, exercise in
            sum + exercise.setsArray.filter { $0.isCompleted }.count
        }
    }

    /// Recalculates total volume from all completed sets (weight * reps)
    public func recalculateTotalVolume() {
        var volume: Double = 0
        for exercise in exercisesArray {
            for set in exercise.setsArray where set.isCompleted {
                volume += (set.weight * Double(set.reps))
            }
        }
        self.totalVolume = volume
    }
}

// MARK: Generated accessors for exercises
extension Workout {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: Exercise)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: Exercise)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}
