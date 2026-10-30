//
//  WeeklySplitModels.swift
//  FitGit
//

import SwiftUI

public enum DayOfWeek: String, CaseIterable, Identifiable, Codable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"

    public var id: String { rawValue }

    public var shortName: String {
        switch self {
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        case .sunday: return "Sun"
        }
    }

    /// Monday = 1 ... Sunday = 7 for chronological week order in fitness splits
    public var weekIndex: Int {
        switch self {
        case .monday: return 1
        case .tuesday: return 2
        case .wednesday: return 3
        case .thursday: return 4
        case .friday: return 5
        case .saturday: return 6
        case .sunday: return 7
        }
    }

    /// Whether this day has already passed in the current week
    public var isPreviousDayThisWeek: Bool {
        return self.weekIndex < DayOfWeek.current().weekIndex
    }

    /// Whether this day is today
    public var isToday: Bool {
        return self == DayOfWeek.current()
    }

    /// Calendar weekday mapping (Sunday = 1, Monday = 2 ... Saturday = 7)
    public var calendarWeekday: Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }

    public static func current() -> DayOfWeek {
        let weekday = Calendar.current.component(.weekday, from: Date())
        switch weekday {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return .monday
        }
    }
}

public struct DayWorkoutConfig: Identifiable, Codable {
    public var id: String { day.rawValue }
    public var day: DayOfWeek
    public var isRestDay: Bool
    public var workoutTime: Date
    public var reminderMinutesBefore: Int // e.g. 15, 30, 45, 60 minutes
    public var targetMuscles: [MuscleGroupCategory]
    public var routineTitle: String
    public var customExercises: [ExerciseItem]
    public var isGymHit: Bool
    public var lastCompletedDate: Date?

    public init(
        day: DayOfWeek,
        isRestDay: Bool = false,
        workoutTime: Date = Calendar.current.date(bySettingHour: 18, minute: 30, second: 0, of: Date()) ?? Date(),
        reminderMinutesBefore: Int = 15,
        targetMuscles: [MuscleGroupCategory] = [],
        routineTitle: String = "",
        customExercises: [ExerciseItem] = [],
        isGymHit: Bool = false,
        lastCompletedDate: Date? = nil
    ) {
        self.day = day
        self.isRestDay = isRestDay
        self.workoutTime = workoutTime
        self.reminderMinutesBefore = reminderMinutesBefore
        self.targetMuscles = targetMuscles
        self.routineTitle = routineTitle
        self.customExercises = customExercises
        self.isGymHit = isGymHit
        self.lastCompletedDate = lastCompletedDate
    }

    enum CodingKeys: String, CodingKey {
        case day, isRestDay, workoutTime, reminderMinutesBefore, targetMuscles, routineTitle, customExercises, isGymHit, lastCompletedDate
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.day = try container.decode(DayOfWeek.self, forKey: .day)
        self.isRestDay = try container.decodeIfPresent(Bool.self, forKey: .isRestDay) ?? false
        self.workoutTime = try container.decodeIfPresent(Date.self, forKey: .workoutTime) ?? Date()
        self.reminderMinutesBefore = try container.decodeIfPresent(Int.self, forKey: .reminderMinutesBefore) ?? 15
        self.targetMuscles = try container.decodeIfPresent([MuscleGroupCategory].self, forKey: .targetMuscles) ?? []
        self.routineTitle = try container.decodeIfPresent(String.self, forKey: .routineTitle) ?? ""
        self.customExercises = try container.decodeIfPresent([ExerciseItem].self, forKey: .customExercises) ?? []
        self.isGymHit = try container.decodeIfPresent(Bool.self, forKey: .isGymHit) ?? false
        self.lastCompletedDate = try container.decodeIfPresent(Date.self, forKey: .lastCompletedDate)
    }

    public var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: workoutTime)
    }

    public var alertTime: Date {
        Calendar.current.date(byAdding: .minute, value: -reminderMinutesBefore, to: workoutTime) ?? workoutTime
    }

    public var formattedAlertTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: alertTime)
    }

    public var summaryMuscles: String {
        if isRestDay { return "Rest & Recovery" }
        if targetMuscles.isEmpty { return "General Workout" }
        return targetMuscles.map { $0.rawValue }.joined(separator: " • ")
    }
}

public struct CustomRoutine: Identifiable, Codable {
    public let id: UUID
    public var title: String
    public var subtitle: String
    public var targetMuscles: [MuscleGroupCategory]
    public var exercises: [ExerciseItem]

    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        targetMuscles: [MuscleGroupCategory],
        exercises: [ExerciseItem]
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.targetMuscles = targetMuscles
        self.exercises = exercises
    }
}
