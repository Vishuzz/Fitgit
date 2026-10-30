//
//  SettingsView.swift
//  FitGit
//

import SwiftUI
import UserNotifications

public struct SettingsView: View {
    @ObservedObject var notificationManager: NotificationManager = NotificationManager.shared
    @ObservedObject var splitStore: SplitStore = SplitStore.shared

    @AppStorage("fitgit_haptics_enabled") private var hapticsEnabled: Bool = true
    @AppStorage("fitgit_sounds_enabled") private var soundsEnabled: Bool = true

    @State private var showingTestAlertToast: Bool = false
    @State private var showingFirebaseGuideModal: Bool = false
    @State private var showingMonthlyActivityModal: Bool = false
    @State private var showingTimeSpentModal: Bool = false

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("SETTINGS & ACTIVITY")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.primaryOrange)
                                .tracking(1.5)

                            Text("Settings")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // MARK: - Athlete Profile Card
                    athleteProfileCard

                    // MARK: - Section 1: HOW YOU USE FITGIT (Activity & Insights)
                    VStack(alignment: .leading, spacing: 12) {
                        sectionHeader("HOW YOU USE FITGIT")

                        VStack(spacing: 0) {
                            // 1. Your Active Days This Month
                            SettingActionRow(
                                icon: "flame.fill",
                                iconColor: NeumorphicTheme.primaryOrange,
                                title: "Your Active Days in this Month",
                                subtitle: "18 days logged in October • 82% consistency",
                                badgeText: "18 Days"
                            ) {
                                showingMonthlyActivityModal = true
                            }

                            Divider().padding(.leading, 56)

                            // 2. Time Spent in Gym
                            SettingActionRow(
                                icon: "clock.arrow.circlepath",
                                iconColor: NeumorphicTheme.purplePower,
                                title: "Time Spent Working Out",
                                subtitle: "58m daily average • 22.4 hours this month",
                                badgeText: "58m avg"
                            ) {
                                showingTimeSpentModal = true
                            }
                        }
                        .neumorphicCard(cornerRadius: 20, padding: 6)
                    }
                    .padding(.horizontal)

                    // MARK: - Section 2: PREFERENCES & ALERTS
                    VStack(alignment: .leading, spacing: 12) {
                        sectionHeader("PREFERENCES & ALERTS")

                            VStack(spacing: 16) {
                                // Workout Reminders Card
                                workoutRemindersSubsection

                                Divider()

                                // Sounds & Haptic Feedback Toggle
                                HStack(spacing: 14) {
                                    settingIconBox("speaker.wave.2.fill", color: NeumorphicTheme.cyanPulse)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Sounds & Haptic Feedback")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(NeumorphicTheme.textPrimary)
                                        Text("Vibrate on set completion & timer alarms")
                                            .font(.caption2)
                                            .foregroundStyle(NeumorphicTheme.textSecondary)
                                    }

                                    Spacer()

                                    Toggle("", isOn: $hapticsEnabled)
                                        .labelsHidden()
                                        .tint(NeumorphicTheme.primaryOrange)
                                }
                                .padding(.horizontal, 10)
                            }
                            .neumorphicCard(cornerRadius: 20, padding: 14)
                        }
                        .padding(.horizontal)

                    // MARK: - Section 3: PRIVACY & SYSTEM INFO
                    VStack(alignment: .leading, spacing: 12) {
                        sectionHeader("PRIVACY & SYSTEM INFO")

                        VStack(spacing: 14) {

                            // Privacy & Storage
                            HStack(spacing: 14) {
                                settingIconBox("lock.shield.fill", color: NeumorphicTheme.emeraldGreen)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Privacy & Storage")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(NeumorphicTheme.textPrimary)
                                    Text("100% On-Device Core Data • Zero Tracking")
                                        .font(.caption2)
                                        .foregroundStyle(NeumorphicTheme.textSecondary)
                                }

                                Spacer()
                            }
                            .padding(.horizontal, 10)

                            Divider()

                            // About FitGit
                            HStack(spacing: 14) {
                                settingIconBox("info.circle.fill", color: NeumorphicTheme.textMuted)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("About FitGit")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(NeumorphicTheme.textPrimary)
                                    Text("Version 1.2.0 • Build 2026.10")
                                        .font(.caption2)
                                        .foregroundStyle(NeumorphicTheme.textSecondary)
                                }

                                Spacer()
                            }
                            .padding(.horizontal, 10)
                        }
                        .neumorphicCard(cornerRadius: 20, padding: 14)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 110)
            }
            .background(NeumorphicTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
            .alert("Test Notification Triggered", isPresented: $showingTestAlertToast) {
                Button("Got it", role: .cancel) {}
            } message: {
                Text("A pre-workout notification has been triggered! It will pop up in 2 seconds with sound, showing today's targeted split.")
            }
            .sheet(isPresented: $showingMonthlyActivityModal) {
                MonthlyActivityModalView()
            }
            .sheet(isPresented: $showingTimeSpentModal) {
                TimeSpentModalView()
            }
        }
    }

    // MARK: - Athlete Profile Card (Instagram Account Center Style)
    private var athleteProfileCard: some View {
        HStack(spacing: 16) {
            // Avatar with Gradient Ring
            ZStack {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [NeumorphicTheme.primaryOrange, NeumorphicTheme.emeraldGreen],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2.5
                    )
                    .frame(width: 58, height: 58)

                Circle()
                    .fill(NeumorphicTheme.darkSurface)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text("VT")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(NeumorphicTheme.primaryOrange)
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Vishek Tyagi")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.textPrimary)

                Text("@vishek • PPL Hypertrophy Split")
                    .font(.caption)
                    .foregroundStyle(NeumorphicTheme.textSecondary)

                HStack(spacing: 8) {
                    statPill("🔥 18 Active Days", color: NeumorphicTheme.primaryOrange)
                    statPill("82% Consistency", color: NeumorphicTheme.emeraldGreen)
                }
                .padding(.top, 2)
            }

            Spacer()

            Button {
                showingMonthlyActivityModal = true
            } label: {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.textMuted)
                    .padding(8)
                    .background(NeumorphicTheme.darkSurface)
                    .clipShape(Circle())
            }
        }
        .padding(16)
        .neumorphicCard(cornerRadius: 22)
        .padding(.horizontal)
    }

    // MARK: - Workout Reminders Subsection
    private var workoutRemindersSubsection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                settingIconBox("bell.badge.fill", color: notificationManager.isAuthorized ? NeumorphicTheme.primaryOrange : Color.red)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Workout Reminders")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(NeumorphicTheme.textPrimary)

                    Text(notificationManager.isAuthorized ? "Active & Scheduled locally" : "Permission not granted")
                        .font(.caption2)
                        .foregroundStyle(notificationManager.isAuthorized ? NeumorphicTheme.emeraldGreen : Color.red)
                }

                Spacer()

                if !notificationManager.isAuthorized {
                    Button("Enable") {
                        if notificationManager.authorizationStatus == .denied {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        } else {
                            notificationManager.requestAuthorization { granted in
                                if granted {
                                    notificationManager.scheduleAllReminders(for: splitStore.weeklySchedule)
                                }
                            }
                        }
                    }
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .neumorphicButton(cornerRadius: 10, accent: NeumorphicTheme.primaryOrange)
                }
            }

            // Queue & Resync
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("SYSTEM QUEUE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(NeumorphicTheme.textMuted)

                    Text(notificationManager.isAuthorized ? "\(notificationManager.lastScheduledCount) alerts registered in iOS" : "Pending permission")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(NeumorphicTheme.textPrimary)
                }

                Spacer()

                Button {
                    notificationManager.scheduleAllReminders(for: splitStore.weeklySchedule)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        Text("Resync")
                    }
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.primaryOrange)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                }
                .neumorphicButton(cornerRadius: 10)
            }
            .padding(10)
            .background(NeumorphicTheme.darkSurface.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Test Pre-Workout Notification Button
            Button {
                if !notificationManager.isAuthorized {
                    notificationManager.requestAuthorization { granted in
                        if granted {
                            notificationManager.scheduleAllReminders(for: splitStore.weeklySchedule)
                            notificationManager.sendTestNotificationNow(todayConfig: splitStore.todayConfig)
                            showingTestAlertToast = true
                        }
                    }
                } else {
                    notificationManager.sendTestNotificationNow(todayConfig: splitStore.todayConfig)
                    showingTestAlertToast = true
                }
            } label: {
                HStack {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(NeumorphicTheme.primaryOrange)
                    Text("Send Test Pre-Workout Notification (2s)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(NeumorphicTheme.textPrimary)
                    Spacer()
                }
                .padding(12)
            }
            .neumorphicButton(cornerRadius: 12)
        }
    }

    // MARK: - Helpers & Components
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundStyle(NeumorphicTheme.textMuted)
            .tracking(1.2)
            .padding(.leading, 4)
    }

    private func settingIconBox(_ systemName: String, color: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.15))
                .frame(width: 36, height: 36)

            Image(systemName: systemName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(color)
        }
    }

    private func statPill(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }
}

// MARK: - Instagram-Style Action Row
private struct SettingActionRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let badgeText: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 36, height: 36)

                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(iconColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(NeumorphicTheme.textPrimary)

                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(NeumorphicTheme.textSecondary)
                }

                Spacer()

                if let badge = badgeText {
                    Text(badge)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(iconColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(iconColor.opacity(0.12))
                        .clipShape(Capsule())
                }

                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.textMuted)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Monthly Activity & Consistency Modal (Instagram "Your Activity" Style)
private struct MonthlyActivityModalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var splitStore: SplitStore = SplitStore.shared

    // Current month day simulation & attendance mapping (31 days in current month)
    private let totalDaysInMonth = 31
    private let activeDaysCount = 18

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    // Header Month Pill
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("MONTHLY INSIGHTS")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.primaryOrange)
                                .tracking(1.5)

                            Text("October 2026")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                        }

                        Spacer()

                        Text("82% Consistency")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(NeumorphicTheme.emeraldGreen)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(NeumorphicTheme.emeraldGreen.opacity(0.12))
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // 3 Metric Cards
                    HStack(spacing: 12) {
                        metricTile(title: "Active Days", value: "18", subtitle: "of 31 days", color: NeumorphicTheme.primaryOrange)
                        metricTile(title: "Gym Hours", value: "22.4h", subtitle: "this month", color: NeumorphicTheme.cyanPulse)
                        metricTile(title: "Current Streak", value: "5 🔥", subtitle: "days in a row", color: NeumorphicTheme.emeraldGreen)
                    }
                    .padding(.horizontal)

                    // Monthly Heatmap / Calendar Grid Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("MONTHLY ATTENDANCE GRID")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.textMuted)
                                .tracking(1.2)
                            Spacer()
                            Text("October")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundStyle(NeumorphicTheme.primaryOrange)
                        }

                        // Day of week headers
                        HStack {
                            ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                                Text(day)
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(NeumorphicTheme.textMuted)
                                    .frame(maxWidth: .infinity)
                            }
                        }

                        // 31-day grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                            ForEach(1...totalDaysInMonth, id: \.self) { dayNum in
                                let isGymHit = isDayHit(dayNum)
                                let isRest = isDayRest(dayNum)

                                VStack(spacing: 2) {
                                    Text("\(dayNum)")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(isGymHit ? .white : (isRest ? Color.blue : NeumorphicTheme.textSecondary))

                                    if isGymHit {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 7, weight: .black))
                                            .foregroundStyle(.white)
                                    } else if isRest {
                                        Circle()
                                            .fill(Color.blue.opacity(0.5))
                                            .frame(width: 4, height: 4)
                                    } else {
                                        Circle()
                                            .fill(Color.clear)
                                            .frame(width: 4, height: 4)
                                    }
                                }
                                .frame(height: 38)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(isGymHit ? NeumorphicTheme.emeraldGreen : (isRest ? Color.blue.opacity(0.12) : NeumorphicTheme.darkSurface))
                                )
                            }
                        }

                        // Legend
                        HStack(spacing: 16) {
                            legendPill(color: NeumorphicTheme.emeraldGreen, label: "Gym Hit (18)")
                            legendPill(color: Color.blue.opacity(0.6), label: "Rest Day (5)")
                            legendPill(color: NeumorphicTheme.textMuted.opacity(0.4), label: "Scheduled (8)")
                            Spacer()
                        }
                        .padding(.top, 4)
                    }
                    .padding(16)
                    .neumorphicCard(cornerRadius: 22)
                    .padding(.horizontal)

                    // Consistency Quote Card
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CONSISTENCY SPOTLIGHT")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(NeumorphicTheme.textMuted)

                        Text("“You have trained 18 days this month. Consistency is the true foundation of progressive overload and muscle growth.”")
                            .font(.subheadline)
                            .foregroundStyle(NeumorphicTheme.textPrimary)
                            .italic()
                            .lineSpacing(3)
                    }
                    .padding(16)
                    .neumorphicCard(cornerRadius: 18)
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
            .background(NeumorphicTheme.background.ignoresSafeArea())
            .navigationTitle("Your Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func metricTile(title: String, value: String, subtitle: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(color)

            Text(title)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(NeumorphicTheme.textPrimary)

            Text(subtitle)
                .font(.system(size: 9))
                .foregroundStyle(NeumorphicTheme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .neumorphicCard(cornerRadius: 16)
    }

    private func legendPill(color: Color, label: String) -> some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(NeumorphicTheme.textSecondary)
        }
    }

    private func isDayHit(_ day: Int) -> Bool {
        // Realistic distribution across the month (18 active days)
        let activeDates: Set<Int> = [1, 2, 3, 5, 6, 8, 9, 10, 12, 13, 15, 16, 17, 19, 20, 22, 23, 24]
        return activeDates.contains(day)
    }

    private func isDayRest(_ day: Int) -> Bool {
        let restDates: Set<Int> = [4, 7, 11, 14, 18, 21]
        return restDates.contains(day)
    }
}

// MARK: - Time Spent Modal View
private struct TimeSpentModalView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("TRAINING DURATION")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.purplePower)
                                .tracking(1.5)

                            Text("Time Spent in Gym")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // Hero Stat
                    VStack(spacing: 6) {
                        Text("22h 24m")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(NeumorphicTheme.purplePower)
                        Text("Total time trained in October")
                            .font(.caption)
                            .foregroundStyle(NeumorphicTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(22)
                    .neumorphicCard(cornerRadius: 22)
                    .padding(.horizontal)

                    // Breakdown
                    VStack(alignment: .leading, spacing: 14) {
                        Text("SESSION TIMING BREAKDOWN")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(NeumorphicTheme.textMuted)

                        HStack {
                            Text("Average Session Length")
                                .font(.caption)
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                            Spacer()
                            Text("58 minutes")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.primaryOrange)
                        }

                        Divider()

                        HStack {
                            Text("Longest Session")
                                .font(.caption)
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                            Spacer()
                            Text("1h 18m (Legs & Calves)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.cyanPulse)
                        }

                        Divider()

                        HStack {
                            Text("Average Rest Between Sets")
                                .font(.caption)
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                            Spacer()
                            Text("90 seconds")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.emeraldGreen)
                        }
                    }
                    .padding(16)
                    .neumorphicCard(cornerRadius: 20)
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
            .background(NeumorphicTheme.background.ignoresSafeArea())
            .navigationTitle("Time Spent")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

private struct StepRow: View {
    let number: String
    let title: String
    let desc: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(NeumorphicTheme.primaryOrange.opacity(0.15))
                    .frame(width: 28, height: 28)
                Text(number)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.primaryOrange)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.textPrimary)
                Text(desc)
                    .font(.caption)
                    .foregroundStyle(NeumorphicTheme.textSecondary)
                    .lineSpacing(2)
            }
        }
        .padding(.vertical, 4)
    }
}
