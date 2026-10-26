//
//  Exercise+CoreDataClass.swift
//  FitGit
//

import Foundation
import CoreData

@objc(Exercise)
public class Exercise: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(UUID(), forKey: "id")
        setPrimitiveValue(Int16(0), forKey: "orderIndex")
    }
}
