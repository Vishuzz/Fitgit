//
//  Exercise+CoreDataProperties.swift
//  FitGit
//

import Foundation
import CoreData

extension Exercise: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var category: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var orderIndex: Int16
    @NSManaged public var workout: Workout?
    @NSManaged public var sets: NSSet?

    // MARK: - Safe Convenience Properties

    public var unwrappedId: UUID {
        id ?? UUID()
    }

    public var unwrappedName: String {
        name ?? "Unnamed Exercise"
    }

    public var unwrappedCategory: String {
        category ?? "General"
    }

    public var setsArray: [ExerciseSet] {
        let set = sets as? Set<ExerciseSet> ?? []
        return set.sorted { $0.setNumber < $1.setNumber }
    }

    public var completedSets: [ExerciseSet] {
        setsArray.filter { $0.isCompleted }
    }

    public var bestWeight: Double {
        completedSets.map { $0.weight }.max() ?? 0.0
    }

    public var totalExerciseVolume: Double {
        completedSets.reduce(0.0) { $0 + ($1.weight * Double($1.reps)) }
    }
}

// MARK: Generated accessors for sets
extension Exercise {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: ExerciseSet)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: ExerciseSet)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}
