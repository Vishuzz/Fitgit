//
//  NotificationManager.swift
//  FitGit
//

import Foundation
import UserNotifications
import Combine

public final class NotificationManager: ObservableObject {
    public static let shared = NotificationManager()

    @Published public var isAuthorized: Bool = false
    @Published public var lastScheduledCount: Int = 0

    public init() {
        checkAuthorization()
    }

    public func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.isAuthorized = (settings.authorizationStatus == .authorized)
            }
        }
    }

    public func requestAuthorization(completion: @escaping (Bool) -> Void = { _ in }) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
                if let error = error {
                    print("Notification permission error: \(error.localizedDescription)")
                }
                completion(granted)
            }
        }
    }

    /// Schedules weekly pre-workout reminder notifications for all active days in the weekly split plan
    public func scheduleAllReminders(for configs: [DayWorkoutConfig]) {
        // Clear previous workout reminders first
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        var scheduledCount = 0

        for config in configs {
            guard !config.isRestDay else { continue }

            // Calculate alert time: workoutTime minus reminderMinutesBefore
            let calendar = Calendar.current
            let workoutHour = calendar.component(.hour, from: config.workoutTime)
            let workoutMinute = calendar.component(.minute, from: config.workoutTime)

            var workoutDateComponents = DateComponents()
            workoutDateComponents.hour = workoutHour
            workoutDateComponents.minute = workoutMinute

            guard let workoutDate = calendar.date(from: workoutDateComponents),
                  let alertDate = calendar.date(byAdding: .minute, value: -config.reminderMinutesBefore, to: workoutDate) else {
                continue
            }

            let alertHour = calendar.component(.hour, from: alertDate)
            let alertMinute = calendar.component(.minute, from: alertDate)

            // Build Notification Content
            let content = UNMutableNotificationContent()
            let title = config.routineTitle.isEmpty ? config.summaryMuscles : config.routineTitle
            content.title = "🔥 Workout in \(config.reminderMinutesBefore)m: \(title)"
            
            let musclesText = config.targetMuscles.isEmpty ? "your scheduled routine" : config.targetMuscles.map { $0.rawValue }.joined(separator: ", ")
            content.body = "Today's split targets \(musclesText). Time to hydrate, get ready, and view your routine!"
            content.sound = .default
            content.badge = 1

            // Trigger matching exact weekday, hour, and minute
            var triggerComponents = DateComponents()
            triggerComponents.weekday = config.day.calendarWeekday
            triggerComponents.hour = alertHour
            triggerComponents.minute = alertMinute

            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
            let identifier = "fitgit_workout_reminder_\(config.day.rawValue.lowercased())"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            center.add(request) { error in
                if let error = error {
                    print("Failed to schedule notification for \(config.day.rawValue): \(error.localizedDescription)")
                }
            }
            scheduledCount += 1
        }

        DispatchQueue.main.async {
            self.lastScheduledCount = scheduledCount
        }
    }

    /// Sends an immediate test notification 5 seconds from now so the user can verify alerts
    public func sendTestNotificationNow(todayConfig: DayWorkoutConfig) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        let title = todayConfig.isRestDay ? "Rest & Recovery Day" : (todayConfig.routineTitle.isEmpty ? todayConfig.summaryMuscles : todayConfig.routineTitle)
        content.title = "🔥 Pre-Workout Reminder: \(title)"
        content.body = "Your workout is starting soon! Today's split targets: \(todayConfig.summaryMuscles). Tap to view your routine."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        let request = UNNotificationRequest(identifier: "fitgit_test_notification_\(UUID().uuidString)", content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Failed to trigger test notification: \(error.localizedDescription)")
            }
        }
    }
}
