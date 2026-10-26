//
//  ExerciseSet+CoreDataProperties.swift
//  FitGit
//

import Foundation
import CoreData

extension ExerciseSet: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseSet> {
        return NSFetchRequest<ExerciseSet>(entityName: "ExerciseSet")
    }

    @NSManaged public var completedAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var reps: Int16
    @NSManaged public var restDuration: Double
    @NSManaged public var rpe: Double
    @NSManaged public var setNumber: Int16
    @NSManaged public var weight: Double
    @NSManaged public var exercise: Exercise?

    // MARK: - Safe Convenience Properties

    public var unwrappedId: UUID {
        id ?? UUID()
    }

    public var volume: Double {
        isCompleted ? (weight * Double(reps)) : 0.0
    }

    public var formattedWeight: String {
        weight.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", weight) : String(format: "%.1f", weight)
    }
}
