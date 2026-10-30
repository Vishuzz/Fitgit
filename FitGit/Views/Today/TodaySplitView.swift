//
//  TodaySplitView.swift
//  FitGit
//

import SwiftUI

public struct TodaySplitView: View {
    @ObservedObject var splitStore: SplitStore = SplitStore.shared
    @ObservedObject var notificationManager: NotificationManager = NotificationManager.shared

    @State private var checkedExerciseIds: Set<UUID> = []
    @State private var showingTestNotificationAlert: Bool = false
    @State private var overriddenExercises: [ExerciseItem]? = nil

    private var todayConfig: DayWorkoutConfig {
        splitStore.todayConfig
    }

    /// Determines other leg day in the weekly schedule (e.g., Saturday if today is Wednesday, or Wednesday if today is Saturday)
    private var otherLegDay: DayOfWeek? {
        let otherDays = splitStore.weeklySchedule.filter {
            $0.day != todayConfig.day && !$0.isRestDay && $0.targetMuscles.contains(.quads)
        }
        return otherDays.first?.day
    }

    private var isSecondLegDayOfWeek: Bool {
        todayConfig.day == .saturday || todayConfig.day == .friday
    }

    private var exercisesForToday: [ExerciseItem] {
        if let overridden = overriddenExercises {
            return overridden
        }

        if !todayConfig.customExercises.isEmpty {
            return todayConfig.customExercises
        }

        // Generate dynamically with strictly ONE exercise per leg muscle,
        // and alternative on the other leg day
        var list: [ExerciseItem] = []
        for muscle in todayConfig.targetMuscles {
            switch muscle {
            case .quads:
                list.append(isSecondLegDayOfWeek ? LegExercisePairing.legExtension : LegExercisePairing.squat)
            case .hamstrings:
                list.append(isSecondLegDayOfWeek ? LegExercisePairing.legCurl : LegExercisePairing.rdl)
            case .glutes:
                list.append(isSecondLegDayOfWeek ? LegExercisePairing.gluteKickback : LegExercisePairing.hipThrust)
            case .calves:
                list.append(isSecondLegDayOfWeek ? LegExercisePairing.seatedCalf : LegExercisePairing.standingCalf)
            default:
                if let ex = ExerciseLibrary.shared.exercises(for: muscle).first {
                    list.append(ex)
                }
            }
        }
        return list
    }

    private func swapExercise(_ current: ExerciseItem, with alternative: ExerciseItem) {
        var currentList = exercisesForToday
        if let index = currentList.firstIndex(where: { $0.id == current.id }) {
            currentList[index] = alternative
            overriddenExercises = currentList
            HapticManager.light()
        }
    }

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(todayConfig.day.rawValue.uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.primaryOrange)
                                .tracking(1.5)

                            Text("Today's Split")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                        }

                        Spacer()

                        // Test Notification Button
                        Button {
                            if !notificationManager.isAuthorized {
                                notificationManager.requestAuthorization { granted in
                                    if granted {
                                        notificationManager.scheduleAllReminders(for: splitStore.weeklySchedule)
                                        notificationManager.sendTestNotificationNow(todayConfig: todayConfig)
                                        showingTestNotificationAlert = true
                                    }
                                }
                            } else {
                                notificationManager.sendTestNotificationNow(todayConfig: todayConfig)
                                showingTestNotificationAlert = true
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "bell.badge.fill")
                                    .foregroundStyle(NeumorphicTheme.primaryOrange)
                                Text("Test Alert")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(NeumorphicTheme.textPrimary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                        }
                        .neumorphicButton(cornerRadius: 12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // MARK: - Hero Split Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(todayConfig.isRestDay ? "Rest & Recovery" : (todayConfig.routineTitle.isEmpty ? todayConfig.summaryMuscles : todayConfig.routineTitle))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(NeumorphicTheme.textPrimary)

                                Text(todayConfig.isRestDay ? "Sleep, hydrate and rebuild muscle tissue" : todayConfig.summaryMuscles)
                                    .font(.subheadline)
                                    .foregroundStyle(NeumorphicTheme.textSecondary)
                            }

                            Spacer()

                            ZStack {
                                Circle()
                                    .fill(todayConfig.isRestDay ? Color.blue.opacity(0.15) : NeumorphicTheme.primaryOrange.opacity(0.15))
                                    .frame(width: 50, height: 50)

                                Image(systemName: todayConfig.isRestDay ? "bed.double.fill" : "flame.fill")
                                    .font(.title3)
                                    .foregroundStyle(todayConfig.isRestDay ? Color.blue : NeumorphicTheme.primaryOrange)
                            }
                        }

                        Divider()

                        // Timing and Pre-Workout Alert Info
                        if !todayConfig.isRestDay {
                            HStack(spacing: 20) {
                                HStack(spacing: 8) {
                                    Image(systemName: "clock.fill")
                                        .font(.subheadline)
                                        .foregroundStyle(NeumorphicTheme.cyanPulse)
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text("Workout Time")
                                            .font(.caption2)
                                            .foregroundStyle(NeumorphicTheme.textMuted)
                                        Text(todayConfig.formattedTime)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(NeumorphicTheme.textPrimary)
                                    }
                                }

                                HStack(spacing: 8) {
                                    Image(systemName: "bell.fill")
                                        .font(.subheadline)
                                        .foregroundStyle(NeumorphicTheme.primaryOrange)
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text("Notification Lead")
                                            .font(.caption2)
                                            .foregroundStyle(NeumorphicTheme.textMuted)
                                        Text("\(todayConfig.reminderMinutesBefore)m before")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(NeumorphicTheme.textPrimary)
                                    }
                                }
                            }
                        }

                        // Target Muscle Chips
                        if !todayConfig.targetMuscles.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(todayConfig.targetMuscles) { muscle in
                                        HStack(spacing: 6) {
                                            Circle()
                                                .fill(muscle.accentColor)
                                                .frame(width: 8, height: 8)
                                            Text(muscle.rawValue)
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(NeumorphicTheme.textPrimary)
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(NeumorphicTheme.darkSurface)
                                        .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }
                    .neumorphicCard(cornerRadius: 22, padding: 20)
                    .padding(.horizontal)

                    // MARK: - Today's Workout Exercises / Checklist
                    if todayConfig.isRestDay {
                        VStack(spacing: 12) {
                            Image(systemName: "moon.stars.fill")
                                .font(.system(size: 42))
                                .foregroundStyle(Color.indigo.opacity(0.6))
                                .padding(.top, 16)
                            Text("Take it easy today!")
                                .font(.headline)
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                            Text("Rest is when muscle protein synthesis occurs. Stretch, foam roll, and hit your protein target.")
                                .font(.caption)
                                .foregroundStyle(NeumorphicTheme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        .padding()
                        .neumorphicCard(cornerRadius: 20)
                        .padding(.horizontal)
                    } else {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Session Exercises (\(exercisesForToday.count))")
                                    .font(.headline)
                                    .foregroundStyle(NeumorphicTheme.textPrimary)
                                Spacer()
                                Text("\(checkedExerciseIds.count)/\(exercisesForToday.count) done")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(NeumorphicTheme.primaryOrange)
                            }

                            if exercisesForToday.isEmpty {
                                Text("No exercises configured for this split. Head to Weekly Split or Routines to add some.")
                                    .font(.caption)
                                    .foregroundStyle(NeumorphicTheme.textMuted)
                                    .padding(.vertical, 12)
                            } else {
                                VStack(spacing: 14) {
                                    ForEach(exercisesForToday) { exercise in
                                        let isChecked = checkedExerciseIds.contains(exercise.id)
                                        let alternative = LegExercisePairing.alternative(for: exercise)

                                        VStack(alignment: .leading, spacing: 10) {
                                            HStack(spacing: 14) {
                                                // Neumorphic Checkbox
                                                Button {
                                                    if isChecked {
                                                        checkedExerciseIds.remove(exercise.id)
                                                    } else {
                                                        checkedExerciseIds.insert(exercise.id)
                                                    }
                                                } label: {
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(isChecked ? NeumorphicTheme.emeraldGreen : NeumorphicTheme.darkSurface)
                                                            .frame(width: 32, height: 32)
                                                            .shadow(color: isChecked ? Color.clear : NeumorphicTheme.insetDark, radius: 2, x: 2, y: 2)
                                                            .shadow(color: isChecked ? Color.clear : NeumorphicTheme.insetLight, radius: 2, x: -2, y: -2)

                                                        if isChecked {
                                                            Image(systemName: "checkmark")
                                                                .font(.caption)
                                                                .fontWeight(.bold)
                                                                .foregroundStyle(.white)
                                                        }
                                                    }
                                                }
                                                .buttonStyle(.plain)

                                                VStack(alignment: .leading, spacing: 3) {
                                                    Text(exercise.name)
                                                        .font(.subheadline)
                                                        .fontWeight(.bold)
                                                        .foregroundStyle(isChecked ? NeumorphicTheme.textMuted : NeumorphicTheme.textPrimary)
                                                        .strikethrough(isChecked, color: NeumorphicTheme.textMuted)

                                                    HStack(spacing: 6) {
                                                        Text(exercise.primaryMuscle.rawValue)
                                                            .font(.caption2)
                                                            .foregroundStyle(exercise.primaryMuscle.accentColor)
                                                            .fontWeight(.semibold)

                                                        Text("• \(exercise.equipment)")
                                                            .font(.caption2)
                                                            .foregroundStyle(NeumorphicTheme.textMuted)
                                                    }

                                                    HStack(spacing: 4) {
                                                        Image(systemName: "scope")
                                                            .font(.system(size: 8, weight: .bold))
                                                            .foregroundStyle(exercise.primaryMuscle.accentColor)

                                                        Text(exercise.resolvedMusclePart)
                                                            .font(.system(size: 10, weight: .medium))
                                                            .foregroundStyle(NeumorphicTheme.textSecondary)
                                                            .lineLimit(1)
                                                    }
                                                }

                                                Spacer()

                                                Text("\(exercise.targetSets) × \(exercise.targetRepsRange)")
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    .foregroundStyle(NeumorphicTheme.primaryOrange)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(NeumorphicTheme.darkSurface)
                                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                            }

                                            // MARK: - Alternative Leg Exercise Pill / Swap Action
                                            if let alt = alternative {
                                                Divider()

                                                HStack(spacing: 8) {
                                                    Image(systemName: "arrow.triangle.2.circlepath")
                                                        .font(.caption2)
                                                        .foregroundStyle(NeumorphicTheme.cyanPulse)

                                                    Text(otherLegDay != nil ? "Alternative on \(otherLegDay!.rawValue): \(alt.name)" : "Alternative: \(alt.name)")
                                                        .font(.caption2)
                                                        .foregroundStyle(NeumorphicTheme.textSecondary)
                                                        .lineLimit(1)

                                                    Spacer()

                                                    Button {
                                                        swapExercise(exercise, with: alt)
                                                    } label: {
                                                        Text("Swap")
                                                            .font(.caption2)
                                                            .fontWeight(.bold)
                                                            .foregroundStyle(NeumorphicTheme.primaryOrange)
                                                            .padding(.horizontal, 8)
                                                            .padding(.vertical, 3)
                                                            .background(NeumorphicTheme.darkSurface)
                                                            .clipShape(Capsule())
                                                    }
                                                    .buttonStyle(.plain)
                                                }
                                                .padding(.top, 2)
                                            }
                                        }
                                        .padding(14)
                                        .background(NeumorphicTheme.background)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .shadow(color: NeumorphicTheme.lightShadow, radius: 3, x: -2, y: -2)
                                        .shadow(color: NeumorphicTheme.darkShadow, radius: 3, x: 2, y: 2)
                                    }
                                }
                            }
                        }
                        .neumorphicCard(cornerRadius: 22, padding: 18)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 32)
            }
            .background(NeumorphicTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
            .alert("Test Notification Triggered", isPresented: $showingTestNotificationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("A pre-workout notification has been triggered! It will pop up in 2 seconds with sound, showing today's targeted split.")
            }
        }
    }
}
