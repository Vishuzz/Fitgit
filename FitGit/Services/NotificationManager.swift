//
//  NotificationManager.swift
//  FitGit
//

import Foundation
import UserNotifications
import Combine

public struct ScheduledAlertInfo: Identifiable, Equatable {
    public var id: String
    public var title: String
    public var body: String
    public var weekday: String
    public var alertTime: String

    public init(id: String, title: String, body: String, weekday: String, alertTime: String) {
        self.id = id
        self.title = title
        self.body = body
        self.weekday = weekday
        self.alertTime = alertTime
    }
}

public final class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    public static let shared = NotificationManager()

    @Published public var isAuthorized: Bool = false
    @Published public var authorizationStatus: UNAuthorizationStatus = .notDetermined
    @Published public var lastScheduledCount: Int = 0
    @Published public var pendingAlertSummaries: [ScheduledAlertInfo] = []

    public override init() {
        super.init()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        checkAuthorization()
        refreshPendingAlerts()
    }

    // MARK: - UNUserNotificationCenterDelegate
    /// Allows notification banners and sound to display even while the app is in foreground
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound, .badge, .list])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // App opened from notification
        completionHandler()
    }

    public func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.authorizationStatus = settings.authorizationStatus
                self?.isAuthorized = (settings.authorizationStatus == .authorized)
                self?.refreshPendingAlerts()
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
                self?.checkAuthorization()
                completion(granted)
            }
        }
    }

    public func refreshPendingAlerts() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] requests in
            let summaries: [ScheduledAlertInfo] = requests.compactMap { req in
                if let calTrigger = req.trigger as? UNCalendarNotificationTrigger,
                   let date = calTrigger.nextTriggerDate() {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEE h:mm a"
                    return ScheduledAlertInfo(
                        id: req.identifier,
                        title: req.content.title,
                        body: req.content.body,
                        weekday: formatter.string(from: date),
                        alertTime: formatter.string(from: date)
                    )
                } else if let timeTrigger = req.trigger as? UNTimeIntervalNotificationTrigger {
                    return ScheduledAlertInfo(
                        id: req.identifier,
                        title: req.content.title,
                        body: req.content.body,
                        weekday: "Test Notification",
                        alertTime: "Fires in \(max(1, Int(timeTrigger.timeInterval)))s"
                    )
                }
                return ScheduledAlertInfo(
                    id: req.identifier,
                    title: req.content.title,
                    body: req.content.body,
                    weekday: "Scheduled",
                    alertTime: "Pending"
                )
            }

            DispatchQueue.main.async {
                self?.lastScheduledCount = requests.count
                self?.pendingAlertSummaries = summaries
            }
        }
    }

    /// Schedules weekly pre-workout reminder notifications for all active days in the weekly split plan
    public func scheduleAllReminders(for configs: [DayWorkoutConfig]) {
        let center = UNUserNotificationCenter.current()
        // Clear previous workout reminders first
        center.removeAllPendingNotificationRequests()

        var scheduledCount = 0

        for config in configs {
            guard !config.isRestDay else { continue }

            let calendar = Calendar.current
            let workoutHour = calendar.component(.hour, from: config.workoutTime)

            // Alert is scheduled (config.reminderMinutesBefore) minutes before the workout
            guard let alertDate = calendar.date(byAdding: .minute, value: -config.reminderMinutesBefore, to: config.workoutTime) else {
                continue
            }

            let alertHour = calendar.component(.hour, from: alertDate)
            let alertMinute = calendar.component(.minute, from: alertDate)

            var targetWeekday = config.day.calendarWeekday
            // If alert hour > workout hour, the reminder wrapped backward across midnight to the previous day
            if alertHour > workoutHour {
                targetWeekday = (targetWeekday == 1) ? 7 : (targetWeekday - 1)
            }

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
            triggerComponents.weekday = targetWeekday
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
            self.refreshPendingAlerts()
        }
    }

    /// Sends an immediate test notification 2 seconds from now so the user can verify alerts
    public func sendTestNotificationNow(todayConfig: DayWorkoutConfig) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        let title = todayConfig.isRestDay ? "Rest & Recovery Day" : (todayConfig.routineTitle.isEmpty ? todayConfig.summaryMuscles : todayConfig.routineTitle)
        content.title = "🔥 Workout Reminder (Test): \(title)"
        content.body = "Today's split targets \(todayConfig.summaryMuscles). Time to hydrate, get ready, and view your routine!"
        content.sound = .default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2.0, repeats: false)
        let request = UNNotificationRequest(identifier: "fitgit_test_notification_\(UUID().uuidString)", content: content, trigger: trigger)

        center.add(request) { [weak self] error in
            if let error = error {
                print("Failed to trigger test notification: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self?.refreshPendingAlerts()
            }
        }
    }
}
