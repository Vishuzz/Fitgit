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

                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                        selectedDay = day
                                    }
                                } label: {
                                    VStack(spacing: 6) {
                                        Text(day.shortName)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundStyle(isSelected ? NeumorphicTheme.primaryOrange : NeumorphicTheme.textSecondary)

                                        Circle()
                                            .fill(isRest ? Color.blue.opacity(0.4) : (isSelected ? NeumorphicTheme.primaryOrange : NeumorphicTheme.textMuted.opacity(0.3)))
                                            .frame(width: 8, height: 8)
                                    }
                                    .frame(width: 48, height: 60)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(NeumorphicTheme.background)
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
                    VStack(alignment: .leading, spacing: 20) {
                        // Title & Rest Day Toggle
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(selectedDay.rawValue)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(NeumorphicTheme.textPrimary)

                                Text(activeConfig.isRestDay ? "Designated Rest Day" : "Workout Day")
                                    .font(.caption)
                                    .foregroundStyle(activeConfig.isRestDay ? Color.blue : NeumorphicTheme.primaryOrange)
                                    .fontWeight(.semibold)
                            }

                            Spacer()

                            // Rest Day Neumorphic Toggle Button
                            Button {
                                splitStore.updateConfig(for: selectedDay) { cfg in
                                    cfg.isRestDay.toggle()
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: activeConfig.isRestDay ? "bed.double.fill" : "dumbbell.fill")
                                    Text(activeConfig.isRestDay ? "Rest Day" : "Active Day")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .foregroundStyle(activeConfig.isRestDay ? Color.blue : NeumorphicTheme.primaryOrange)
                            }
                            .neumorphicButton(cornerRadius: 12)
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
                .padding(.bottom, 32)
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
