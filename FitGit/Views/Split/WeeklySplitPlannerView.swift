//
//  WeeklySplitPlannerView.swift
//  FitGit
//

import SwiftUI

public struct WeeklySplitPlannerView: View {
    @ObservedObject var splitStore: SplitStore = SplitStore.shared
    @ObservedObject var notificationManager: NotificationManager = NotificationManager.shared

    @State private var selectedDay: DayOfWeek = DayOfWeek.current()
    @State private var showingPresetSheet: Bool = false
    @State private var showingSavedToast: Bool = false

    private var activeConfig: DayWorkoutConfig {
        splitStore.weeklySchedule.first(where: { $0.day == selectedDay }) ?? DayWorkoutConfig(day: selectedDay)
    }

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    // MARK: - Header & Quick Preset Split Button
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("PLANNER")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.primaryOrange)
                                .tracking(1.5)

                            Text("Weekly Split")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                        }

                        Spacer()

                        Button {
                            showingPresetSheet = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "square.grid.2x2.fill")
                                    .foregroundStyle(NeumorphicTheme.primaryOrange)
                                Text("Preset Splits")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(NeumorphicTheme.textPrimary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                        }
                        .neumorphicButton(cornerRadius: 12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // MARK: - Days of Week Horizontal Selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(DayOfWeek.allCases) { day in
                                let isSelected = (day == selectedDay)
                                let config = splitStore.weeklySchedule.first(where: { $0.day == day })
                                let isRest = config?.isRestDay ?? false
                                let isGymHit = config?.isGymHit ?? false
                                let isPrevious = day.isPreviousDayThisWeek
                                let isToday = day.isToday

                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                        selectedDay = day
                                    }
                                } label: {
                                    VStack(spacing: 5) {
                                        Text(day.shortName)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundStyle(isSelected ? NeumorphicTheme.primaryOrange : (isGymHit ? NeumorphicTheme.emeraldGreen : NeumorphicTheme.textSecondary))

                                        // Status Indicator: Gym Hit, Rest Day, or Target Status
                                        if isGymHit {
                                            HStack(spacing: 2) {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 8, weight: .black))
                                                    .foregroundStyle(.white)
                                            }
                                            .frame(width: 14, height: 14)
                                            .background(NeumorphicTheme.emeraldGreen)
                                            .clipShape(Circle())
                                        } else if isRest {
                                            Image(systemName: "bed.double.fill")
                                                .font(.system(size: 9))
                                                .foregroundStyle(Color.blue.opacity(0.7))
                                                .frame(height: 14)
                                        } else if isPrevious {
                                            Circle()
                                                .strokeBorder(Color.red.opacity(0.35), lineWidth: 1.5)
                                                .frame(width: 8, height: 8)
                                                .frame(height: 14)
                                        } else if isToday {
                                            Circle()
                                                .fill(NeumorphicTheme.primaryOrange)
                                                .frame(width: 8, height: 8)
                                                .frame(height: 14)
                                        } else {
                                            Circle()
                                                .fill(isSelected ? NeumorphicTheme.primaryOrange : NeumorphicTheme.textMuted.opacity(0.3))
                                                .frame(width: 8, height: 8)
                                                .frame(height: 14)
                                        }
                                    }
                                    .frame(width: 52, height: 62)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(NeumorphicTheme.background)
                                            .overlay(
                                                isGymHit ?
                                                RoundedRectangle(cornerRadius: 14)
                                                    .stroke(NeumorphicTheme.emeraldGreen.opacity(0.3), lineWidth: 1)
                                                : nil
                                            )
                                            .shadow(color: isSelected ? NeumorphicTheme.insetLight : NeumorphicTheme.lightShadow,
                                                    radius: isSelected ? 2 : 4,
                                                    x: isSelected ? 2 : -3,
                                                    y: isSelected ? 2 : -3)
                                            .shadow(color: isSelected ? NeumorphicTheme.insetDark : NeumorphicTheme.darkShadow,
                                                    radius: isSelected ? 2 : 4,
                                                    x: isSelected ? -2 : 3,
                                                    y: isSelected ? -2 : 3)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                    }

                    // MARK: - Config Card for Selected Day
                    VStack(alignment: .leading, spacing: 18) {
                        // Title, Rest Day Toggle & Gym Hit Action
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 6) {
                                        Text(selectedDay.rawValue)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundStyle(NeumorphicTheme.textPrimary)

                                        if selectedDay.isToday {
                                            Text("TODAY")
                                                .font(.system(size: 9, weight: .heavy))
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(NeumorphicTheme.primaryOrange)
                                                .foregroundStyle(.white)
                                                .clipShape(Capsule())
                                        } else if selectedDay.isPreviousDayThisWeek {
                                            Text("PAST")
                                                .font(.system(size: 9, weight: .bold))
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color.secondary.opacity(0.2))
                                                .foregroundStyle(NeumorphicTheme.textSecondary)
                                                .clipShape(Capsule())
                                        }
                                    }

                                    Text(activeConfig.isRestDay ? "Designated Rest Day" : "Workout Day")
                                        .font(.caption)
                                        .foregroundStyle(activeConfig.isRestDay ? Color.blue : NeumorphicTheme.primaryOrange)
                                        .fontWeight(.semibold)
                                }

                                Spacer()

                                // Gym Hit Toggle Button
                                Button {
                                    splitStore.toggleGymHit(for: selectedDay)
                                } label: {
                                    HStack(spacing: 5) {
                                        Image(systemName: activeConfig.isGymHit ? "checkmark.seal.fill" : "circle")
                                            .font(.caption)
                                        Text(activeConfig.isGymHit ? "Gym Hit ✓" : "Hit Gym?")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 7)
                                    .foregroundStyle(activeConfig.isGymHit ? NeumorphicTheme.emeraldGreen : NeumorphicTheme.textSecondary)
                                }
                                .neumorphicButton(cornerRadius: 10)

                                // Rest Day Toggle Button
                                Button {
                                    splitStore.updateConfig(for: selectedDay) { cfg in
                                        cfg.isRestDay.toggle()
                                    }
                                } label: {
                                    Image(systemName: activeConfig.isRestDay ? "bed.double.fill" : "dumbbell.fill")
                                        .font(.caption)
                                        .padding(8)
                                        .foregroundStyle(activeConfig.isRestDay ? Color.blue : NeumorphicTheme.primaryOrange)
                                }
                                .neumorphicButton(cornerRadius: 10)
                            }

                            // Historical Gym Attendance Status Banner for Previous Days / Today
                            if activeConfig.isGymHit {
                                HStack(spacing: 8) {
                                    Image(systemName: "trophy.fill")
                                        .font(.caption)
                                        .foregroundStyle(NeumorphicTheme.emeraldGreen)

                                    Text(selectedDay.isToday ? "You hit the gym today! Great workout session." : "Marked: You hit the gym on this \(selectedDay.rawValue)! Consistency logged.")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(NeumorphicTheme.emeraldGreen)

                                    Spacer()
                                }
                                .padding(10)
                                .background(NeumorphicTheme.emeraldGreen.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            } else if selectedDay.isPreviousDayThisWeek && !activeConfig.isRestDay {
                                HStack(spacing: 8) {
                                    Image(systemName: "info.circle.fill")
                                        .font(.caption)
                                        .foregroundStyle(NeumorphicTheme.primaryOrange)

                                    Text("Did you hit the gym on \(selectedDay.rawValue)? Tap 'Hit Gym?' above to mark it.")
                                        .font(.caption2)
                                        .foregroundStyle(NeumorphicTheme.textSecondary)

                                    Spacer()
                                }
                                .padding(10)
                                .background(NeumorphicTheme.primaryOrange.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }

                        Divider()

                        if !activeConfig.isRestDay {
                            // Routine Title Field
                            VStack(alignment: .leading, spacing: 6) {
                                Text("ROUTINE NAME")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(NeumorphicTheme.textMuted)

                                TextField("e.g. Chest & Triceps Blast", text: Binding(
                                    get: { activeConfig.routineTitle },
                                    set: { newTitle in
                                        splitStore.updateConfig(for: selectedDay) { cfg in
                                            cfg.routineTitle = newTitle
                                        }
                                    }
                                ))
                                .font(.subheadline)
                                .padding(12)
                                .neumorphicConcave(cornerRadius: 12)
                            }

                            // Workout Timing & Notification Picker
                            VStack(alignment: .leading, spacing: 14) {
                                Text("TIMING & PRE-WORKOUT ALERT")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(NeumorphicTheme.textMuted)

                                HStack(spacing: 16) {
                                    // Time Picker
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Session Time")
                                            .font(.caption)
                                            .foregroundStyle(NeumorphicTheme.textSecondary)

                                        DatePicker("", selection: Binding(
                                            get: { activeConfig.workoutTime },
                                            set: { newTime in
                                                splitStore.updateConfig(for: selectedDay) { cfg in
                                                    cfg.workoutTime = newTime
                                                }
                                            }
                                        ), displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                        .datePickerStyle(.compact)
                                    }

                                    Spacer()

                                    // Reminder Lead Time Picker
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Alert Me Before")
                                            .font(.caption)
                                            .foregroundStyle(NeumorphicTheme.textSecondary)

                                        Picker("", selection: Binding(
                                            get: { activeConfig.reminderMinutesBefore },
                                            set: { newLead in
                                                splitStore.updateConfig(for: selectedDay) { cfg in
                                                    cfg.reminderMinutesBefore = newLead
                                                }
                                            }
                                        )) {
                                            Text("15 mins").tag(15)
                                            Text("30 mins").tag(30)
                                            Text("45 mins").tag(45)
                                            Text("1 hour").tag(60)
                                        }
                                        .pickerStyle(.menu)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(NeumorphicTheme.darkSurface)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                                .padding(12)
                                .neumorphicConcave(cornerRadius: 14)

                                HStack(spacing: 6) {
                                    Image(systemName: "bell.fill")
                                        .font(.caption2)
                                        .foregroundStyle(NeumorphicTheme.primaryOrange)
                                    Text("Alert fires at \(activeConfig.formattedAlertTime) on \(selectedDay.rawValue)s")
                                        .font(.caption2)
                                        .foregroundStyle(NeumorphicTheme.textSecondary)

                                    Spacer()

                                    if notificationManager.isAuthorized {
                                        Button {
                                            notificationManager.sendTestNotificationNow(todayConfig: activeConfig)
                                        } label: {
                                            Text("Test Alert")
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundStyle(NeumorphicTheme.primaryOrange)
                                        }
                                    }
                                }
                                .padding(.horizontal, 4)
                            }

                            // Muscle Groups Multi-Selector
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("TARGET MUSCLE GROUPS")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(NeumorphicTheme.textMuted)
                                    Spacer()
                                    Text("\(activeConfig.targetMuscles.count) selected")
                                        .font(.caption2)
                                        .foregroundStyle(NeumorphicTheme.primaryOrange)
                                }

                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                    ForEach(MuscleGroupCategory.allCases) { muscle in
                                        let isTargeted = activeConfig.targetMuscles.contains(muscle)

                                        Button {
                                            splitStore.updateConfig(for: selectedDay) { cfg in
                                                if isTargeted {
                                                    cfg.targetMuscles.removeAll(where: { $0 == muscle })
                                                } else {
                                                    cfg.targetMuscles.append(muscle)
                                                }
                                            }
                                        } label: {
                                            HStack(spacing: 8) {
                                                Circle()
                                                    .fill(muscle.accentColor)
                                                    .frame(width: 10, height: 10)

                                                Text(muscle.rawValue)
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(isTargeted ? NeumorphicTheme.textPrimary : NeumorphicTheme.textSecondary)

                                                Spacer()

                                                if isTargeted {
                                                    Image(systemName: "checkmark")
                                                        .font(.caption2)
                                                        .fontWeight(.bold)
                                                        .foregroundStyle(muscle.accentColor)
                                                }
                                            }
                                            .padding(10)
                                            .background(isTargeted ? muscle.accentColor.opacity(0.12) : NeumorphicTheme.background)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .shadow(color: isTargeted ? Color.clear : NeumorphicTheme.lightShadow, radius: 2, x: -2, y: -2)
                                            .shadow(color: isTargeted ? Color.clear : NeumorphicTheme.darkShadow, radius: 2, x: 2, y: 2)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "bed.double.fill")
                                    .font(.system(size: 36))
                                    .foregroundStyle(Color.blue.opacity(0.5))
                                Text("\(selectedDay.rawValue) is marked as a Rest Day")
                                    .font(.headline)
                                    .foregroundStyle(NeumorphicTheme.textPrimary)
                                Text("No workout timing or notifications will be scheduled for this day.")
                                    .font(.caption)
                                    .foregroundStyle(NeumorphicTheme.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                        }
                    }
                    .neumorphicCard(cornerRadius: 22, padding: 20)
                    .padding(.horizontal)
                }
                .padding(.bottom, 110)
            }
            .background(NeumorphicTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(isPresented: $showingPresetSheet) {
                PresetSplitsSheet { selectedPreset in
                    splitStore.applyPresetSplit(selectedPreset)
                    showingPresetSheet = false
                }
            }
        }
    }
}

// MARK: - Preset Splits Modal Sheet
private struct PresetSplitsSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onSelect: (SplitStore.PresetSplitType) -> Void

    @State private var selectedDetailPreset: SplitStore.PresetSplitType? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Select a split program from the Complete Gym Workout Splits Guide. Every split includes full day-wise exercise lists, sets, and rep ranges.")
                        .font(.caption)
                        .foregroundStyle(NeumorphicTheme.textSecondary)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    ForEach(SplitStore.PresetSplitType.allCases) { preset in
                        Button {
                            selectedDetailPreset = preset
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(preset.rawValue)
                                        .font(.headline)
                                        .foregroundStyle(NeumorphicTheme.textPrimary)
                                    Spacer()
                                    Image(systemName: "chevron.right.circle.fill")
                                        .foregroundStyle(NeumorphicTheme.primaryOrange)
                                }

                                Text(preset.subtitle)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(NeumorphicTheme.textSecondary)
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .neumorphicButton(cornerRadius: 16)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(NeumorphicTheme.background.ignoresSafeArea())
            .navigationTitle("Preset Splits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundStyle(NeumorphicTheme.textPrimary)
                }
            }
            .sheet(item: $selectedDetailPreset) { preset in
                SplitProgramDetailSheet(preset: preset) {
                    onSelect(preset)
                    selectedDetailPreset = nil
                    dismiss()
                }
            }
        }
    }
}
