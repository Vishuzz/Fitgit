//
//  ExerciseSet+CoreDataClass.swift
//  FitGit
//

import Foundation
import CoreData

@objc(ExerciseSet)
public class ExerciseSet: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(UUID(), forKey: "id")
        setPrimitiveValue(Int16(1), forKey: "setNumber")
        setPrimitiveValue(0.0, forKey: "weight")
        setPrimitiveValue(Int16(0), forKey: "reps")
        setPrimitiveValue(false, forKey: "isCompleted")
        setPrimitiveValue(60.0, forKey: "restDuration")
    }
}
