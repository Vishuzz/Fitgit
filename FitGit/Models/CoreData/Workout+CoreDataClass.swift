//
//  Workout+CoreDataClass.swift
//  FitGit
//

import Foundation
import CoreData

@objc(Workout)
public class Workout: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(UUID(), forKey: "id")
        setPrimitiveValue(Date(), forKey: "startDate")
        setPrimitiveValue(false, forKey: "isCompleted")
    }
}
