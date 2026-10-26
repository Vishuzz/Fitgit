//
//  WorkoutTemplate.swift
//  FitGit
//

import SwiftUI

public struct TemplateExercise: Identifiable {
    public let id = UUID()
    public let name: String
    public let category: String
    public let defaultSetsCount: Int
    public let targetReps: Int16
    public let targetWeight: Double

    public init(name: String, category: String, defaultSetsCount: Int = 3, targetReps: Int16 = 10, targetWeight: Double = 60.0) {
        self.name = name
        self.category = category
        self.defaultSetsCount = defaultSetsCount
        self.targetReps = targetReps
        self.targetWeight = targetWeight
    }
}

public struct WorkoutTemplate: Identifiable {
    public let id = UUID()
    public let title: String
    public let subtitle: String
    public let iconName: String
    public let gradient: LinearGradient
    public let estimatedMinutes: Int
    public let exercises: [TemplateExercise]

    public static let sampleTemplates: [WorkoutTemplate] = [
        WorkoutTemplate(
            title: "Push Power",
            subtitle: "Chest, Shoulders & Triceps",
            iconName: "flame.fill",
            gradient: AppTheme.blazeGradient,
            estimatedMinutes: 55,
            exercises: [
                TemplateExercise(name: "Barbell Bench Press", category: "Chest", defaultSetsCount: 3, targetReps: 8, targetWeight: 80.0),
                TemplateExercise(name: "Overhead Dumbbell Press", category: "Shoulders", defaultSetsCount: 3, targetReps: 10, targetWeight: 24.0),
                TemplateExercise(name: "Incline Dumbbell Fly", category: "Chest", defaultSetsCount: 3, targetReps: 12, targetWeight: 18.0),
                TemplateExercise(name: "Tricep Rope Pushdown", category: "Arms", defaultSetsCount: 3, targetReps: 12, targetWeight: 25.0)
            ]
        ),
        WorkoutTemplate(
            title: "Pull Hypertrophy",
            subtitle: "Back, Rear Delts & Biceps",
            iconName: "figure.rower",
            gradient: AppTheme.powerGradient,
            estimatedMinutes: 60,
            exercises: [
                TemplateExercise(name: "Barbell Deadlift", category: "Back", defaultSetsCount: 3, targetReps: 6, targetWeight: 120.0),
                TemplateExercise(name: "Lat Pulldown", category: "Back", defaultSetsCount: 3, targetReps: 10, targetWeight: 65.0),
                TemplateExercise(name: "Seated Cable Row", category: "Back", defaultSetsCount: 3, targetReps: 10, targetWeight: 60.0),
                TemplateExercise(name: "Barbell Bicep Curl", category: "Arms", defaultSetsCount: 3, targetReps: 12, targetWeight: 30.0)
            ]
        ),
        WorkoutTemplate(
            title: "Leg Destruction",
            subtitle: "Quads, Hamstrings & Calves",
            iconName: "bolt.fill",
            gradient: AppTheme.successGradient,
            estimatedMinutes: 50,
            exercises: [
                TemplateExercise(name: "Barbell Back Squat", category: "Legs", defaultSetsCount: 4, targetReps: 8, targetWeight: 100.0),
                TemplateExercise(name: "Romanian Deadlift", category: "Legs", defaultSetsCount: 3, targetReps: 10, targetWeight: 80.0),
                TemplateExercise(name: "Bulgarian Split Squat", category: "Legs", defaultSetsCount: 3, targetReps: 10, targetWeight: 20.0),
                TemplateExercise(name: "Standing Calf Raise", category: "Legs", defaultSetsCount: 4, targetReps: 15, targetWeight: 50.0)
            ]
        ),
        WorkoutTemplate(
            title: "Full Body Blast",
            subtitle: "High Density Conditioning",
            iconName: "figure.cross.training",
            gradient: LinearGradient(colors: [Color.indigo, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing),
            estimatedMinutes: 45,
            exercises: [
                TemplateExercise(name: "Barbell Squat", category: "Legs", defaultSetsCount: 3, targetReps: 10, targetWeight: 75.0),
                TemplateExercise(name: "Pull-ups", category: "Back", defaultSetsCount: 3, targetReps: 8, targetWeight: 0.0),
                TemplateExercise(name: "Dips", category: "Chest", defaultSetsCount: 3, targetReps: 10, targetWeight: 0.0),
                TemplateExercise(name: "Hanging Leg Raise", category: "Core", defaultSetsCount: 3, targetReps: 12, targetWeight: 0.0)
            ]
        )
    ]
}
