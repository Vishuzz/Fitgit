//
//  SettingsView.swift
//  FitGit
//

import SwiftUI
import UserNotifications

public struct SettingsView: View {
    @ObservedObject var notificationManager: NotificationManager = NotificationManager.shared
    @ObservedObject var splitStore: SplitStore = SplitStore.shared
    @State private var showingTestAlertToast: Bool = false
    @State private var showingFirebaseGuideModal: Bool = false

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("PREFERENCES")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.primaryOrange)
                                .tracking(1.5)

                            Text("Settings & Alerts")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // Notification Status Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(notificationManager.isAuthorized ? NeumorphicTheme.emeraldGreen.opacity(0.15) : Color.red.opacity(0.15))
                                    .frame(width: 44, height: 44)
                                Image(systemName: notificationManager.isAuthorized ? "bell.badge.fill" : "bell.slash.fill")
                                    .font(.subheadline)
                                    .foregroundStyle(notificationManager.isAuthorized ? NeumorphicTheme.emeraldGreen : Color.red)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Workout Reminders")
                                    .font(.headline)
                                    .foregroundStyle(NeumorphicTheme.textPrimary)
                                Text(notificationManager.isAuthorized ? "Active & Scheduled locally" : "Permission not granted")
                                    .font(.caption)
                                    .foregroundStyle(notificationManager.isAuthorized ? NeumorphicTheme.emeraldGreen : Color.red)
                            }

                            Spacer()

                            if !notificationManager.isAuthorized {
                                Button("Enable") {
                                    notificationManager.requestAuthorization { _ in
                                        notificationManager.scheduleAllReminders(for: splitStore.weeklySchedule)
                                    }
                                }
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .neumorphicButton(cornerRadius: 12, accent: NeumorphicTheme.primaryOrange)
                            }
                        }

                        Divider()

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
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

                        Text("Scheduled Alerts: FitGit automatically schedules local notifications for all your active workout days according to your preferred time and lead time (15–60 mins before).")
                            .font(.caption)
                            .foregroundStyle(NeumorphicTheme.textSecondary)
                            .lineSpacing(3)

                        // Test Notification Trigger
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
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(NeumorphicTheme.textPrimary)
                                Spacer()
                            }
                            .padding(14)
                        }
                        .neumorphicButton(cornerRadius: 14)
                    }
                    .neumorphicCard(cornerRadius: 22, padding: 18)
                    .padding(.horizontal)

                    // Firebase Guide Card
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color.orange.opacity(0.15))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "flame.fill")
                                    .font(.headline)
                                    .foregroundStyle(Color.orange)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Do You Need Firebase?")
                                    .font(.headline)
                                    .foregroundStyle(NeumorphicTheme.textPrimary)
                                Text("Native Local Alerts vs Remote Push")
                                    .font(.caption)
                                    .foregroundStyle(NeumorphicTheme.textSecondary)
                            }

                            Spacer()

                            Button("Details") {
                                showingFirebaseGuideModal = true
                            }
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(NeumorphicTheme.primaryOrange)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .neumorphicButton(cornerRadius: 10)
                        }

                        Divider()

                        Text("• No Firebase is required for your scheduled split reminders! iOS handles recurring alarms locally and 100% offline.\n• Tap 'Details' to view the full step-by-step setup guide if you ever decide to connect Firebase Cloud Messaging (FCM).")
                            .font(.caption)
                            .foregroundStyle(NeumorphicTheme.textSecondary)
                            .lineSpacing(4)
                    }
                    .neumorphicCard(cornerRadius: 22, padding: 18)
                    .padding(.horizontal)

                    // Neumorphism Theme Info
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundStyle(NeumorphicTheme.cyanPulse)
                            Text("Neumorphism Soft UI")
                                .font(.headline)
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                        }

                        Text("FitGit uses dual-shadow soft surface rendering modeled from physical materials, providing tactile button depressions and smooth concave inputs.")
                            .font(.caption)
                            .foregroundStyle(NeumorphicTheme.textSecondary)
                            .lineSpacing(3)
                    }
                    .neumorphicCard(cornerRadius: 20, padding: 16)
                    .padding(.horizontal)
                }
                .padding(.bottom, 110)
            }
            .background(NeumorphicTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
            .alert("Test Notification Triggered", isPresented: $showingTestAlertToast) {
                Button("Got it", role: .cancel) {}
            } message: {
                Text("Lock your phone or exit to the Home screen. A native pre-workout reminder notification will pop up in 5 seconds!")
            }
            .sheet(isPresented: $showingFirebaseGuideModal) {
                FirebaseGuideModal()
            }
        }
    }
}

// MARK: - Firebase Setup Guide Modal
private struct FirebaseGuideModal: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Summary Banner
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(NeumorphicTheme.emeraldGreen)
                            Text("Current Status: Fully Operational Without Firebase")
                                .font(.headline)
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                        }

                        Text("Your pre-workout reminders currently use Apple's native UserNotifications framework. This is the optimal architecture because:")
                            .font(.caption)
                            .foregroundStyle(NeumorphicTheme.textSecondary)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("1. 100% Offline: Triggers even with zero internet or airplane mode.")
                            Text("2. Zero Cost: No server hosting or Firebase fees.")
                            Text("3. Ultra Precise: iOS background scheduler fires at the exact minute.")
                            Text("4. Zero Setup: Works out of the box without Google certificates.")
                        }
                        .font(.caption2)
                        .foregroundStyle(NeumorphicTheme.textSecondary)
                        .padding(10)
                        .background(NeumorphicTheme.darkSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding()
                    .neumorphicCard(cornerRadius: 18)

                    // Step by step Firebase FCM Guide
                    VStack(alignment: .leading, spacing: 14) {
                        Text("STEPS IF YOU WANT FIREBASE CLOUD MESSAGING (FCM):")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(NeumorphicTheme.textMuted)

                        StepRow(number: "1", title: "Apple Developer Account", desc: "Enroll in the Apple Developer Program ($99/yr) so you can generate an APNs (Apple Push Notification service) Auth Key (.p8 file).")
                        StepRow(number: "2", title: "Create Firebase Project", desc: "Go to console.firebase.google.com and create a project named 'FitGit'.")
                        StepRow(number: "3", title: "Register iOS App", desc: "Enter your Bundle ID: name.Vishek.FitGit, download GoogleService-Info.plist and place it in the FitGit project folder.")
                        StepRow(number: "4", title: "Upload APNs Key to Firebase", desc: "In Firebase Console → Project Settings → Cloud Messaging, upload your .p8 key, Key ID, and Apple Team ID.")
                        StepRow(number: "5", title: "Add Firebase SPM Package", desc: "In Xcode: File → Add Package Dependencies → URL: https://github.com/firebase/firebase-ios-sdk → Select FirebaseMessaging.")
                        StepRow(number: "6", title: "Initialize in App Scene", desc: "Import FirebaseCore and call FirebaseApp.configure() inside FitGitApp.swift.")
                    }
                    .padding()
                    .neumorphicCard(cornerRadius: 18)
                }
                .padding()
            }
            .background(NeumorphicTheme.background.ignoresSafeArea())
            .navigationTitle("Firebase Notification Guide")
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
