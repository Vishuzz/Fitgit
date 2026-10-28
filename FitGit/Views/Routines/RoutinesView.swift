//
//  RoutinesView.swift
//  FitGit
//

import SwiftUI

public struct RoutinesView: View {
    @ObservedObject var splitStore: SplitStore = SplitStore.shared
    @State private var showingCreateRoutineSheet: Bool = false
    @State private var routineToAssign: CustomRoutine?
    @State private var showingAssignSheet: Bool = false

    @State private var selectedPresetForDetail: SplitStore.PresetSplitType? = nil

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("TEMPLATES")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.primaryOrange)
                                .tracking(1.5)

                            Text("Routines Library")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                        }

                        Spacer()

                        Button {
                            showingCreateRoutineSheet = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "plus")
                                    .fontWeight(.bold)
                                Text("New Routine")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                        }
                        .neumorphicButton(cornerRadius: 12, accent: NeumorphicTheme.primaryOrange)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // Custom Routines Section
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("My Custom Routines (\(splitStore.customRoutines.count))")
                                .font(.headline)
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                            Spacer()
                        }
                        .padding(.horizontal)

                        if splitStore.customRoutines.isEmpty {
                            VStack(spacing: 8) {
                                Text("No custom routines yet.")
                                    .font(.caption)
                                    .foregroundStyle(NeumorphicTheme.textMuted)
                                Text("Tap '+ New Routine' above to build a custom session from our exercise library.")
                                    .font(.caption2)
                                    .foregroundStyle(NeumorphicTheme.textSecondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .neumorphicCard(cornerRadius: 16)
                            .padding(.horizontal)
                        } else {
                            ForEach(splitStore.customRoutines) { routine in
                                RoutineCardView(routine: routine) {
                                    routineToAssign = routine
                                    showingAssignSheet = true
                                } onDelete: {
                                    splitStore.deleteCustomRoutine(routine)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    // Built-in Split Routine Templates from PDF
                    VStack(alignment: .leading, spacing: 14) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Complete Gym Splits (PDF Guide)")
                                .font(.headline)
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                            Text("Day-by-day programs with exercises, working sets & rep ranges")
                                .font(.caption2)
                                .foregroundStyle(NeumorphicTheme.textMuted)
                        }
                        .padding(.horizontal)

                        ForEach(SplitStore.PresetSplitType.allCases) { preset in
                            Button {
                                selectedPresetForDetail = preset
                            } label: {
                                HStack(spacing: 14) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(preset.rawValue)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(NeumorphicTheme.textPrimary)
                                        Text(preset.subtitle)
                                            .font(.caption2)
                                            .foregroundStyle(NeumorphicTheme.textSecondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(NeumorphicTheme.primaryOrange)
                                }
                                .padding(16)
                            }
                            .neumorphicButton(cornerRadius: 16)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 32)
            }
            .background(NeumorphicTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(isPresented: $showingCreateRoutineSheet) {
                CreateRoutineSheet { newRoutine in
                    splitStore.saveCustomRoutine(newRoutine)
                }
            }
            .sheet(isPresented: $showingAssignSheet) {
                if let routine = routineToAssign {
                    AssignRoutineToDaySheet(routine: routine) { targetDay in
                        splitStore.updateConfig(for: targetDay) { cfg in
                            cfg.isRestDay = false
                            cfg.routineTitle = routine.title
                            cfg.targetMuscles = routine.targetMuscles
                            cfg.customExercises = routine.exercises
                        }
                        showingAssignSheet = false
                    }
                }
            }
            .sheet(item: $selectedPresetForDetail) { preset in
                SplitProgramDetailSheet(preset: preset) {
                    splitStore.applyPresetSplit(preset)
                }
            }
        }
    }
}

// MARK: - Routine Card View
private struct RoutineCardView: View {
    let routine: CustomRoutine
    let onAssign: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(routine.title)
                        .font(.headline)
                        .foregroundStyle(NeumorphicTheme.textPrimary)
                    Text(routine.subtitle)
                        .font(.caption)
                        .foregroundStyle(NeumorphicTheme.textSecondary)
                }
                Spacer()

                Menu {
                    Button("Assign to a Day", action: onAssign)
                    Button("Delete Routine", role: .destructive, action: onDelete)
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.subheadline)
                        .foregroundStyle(NeumorphicTheme.textMuted)
                        .padding(8)
                }
            }

            // Target Muscles Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(routine.targetMuscles) { muscle in
                        HStack(spacing: 4) {
                            Circle().fill(muscle.accentColor).frame(width: 6, height: 6)
                            Text(muscle.rawValue).font(.caption2).fontWeight(.semibold)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(NeumorphicTheme.darkSurface)
                        .clipShape(Capsule())
                    }
                }
            }

            Divider()

            HStack {
                Text("\(routine.exercises.count) Exercises")
                    .font(.caption)
                    .foregroundStyle(NeumorphicTheme.textMuted)

                Spacer()

                Button(action: onAssign) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar.badge.plus")
                        Text("Assign Day")
                    }
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.primaryOrange)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                }
                .neumorphicButton(cornerRadius: 10)
            }
        }
        .neumorphicCard(cornerRadius: 18, padding: 16)
    }
}

// MARK: - Assign Routine To Day Modal
private struct AssignRoutineToDaySheet: View {
    @Environment(\.dismiss) private var dismiss
    let routine: CustomRoutine
    let onSelectDay: (DayOfWeek) -> Void

    var body: some View {
        NavigationStack {
            List(DayOfWeek.allCases) { day in
                Button {
                    onSelectDay(day)
                    dismiss()
                } label: {
                    HStack {
                        Text(day.rawValue)
                            .font(.headline)
                            .foregroundStyle(NeumorphicTheme.textPrimary)
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(NeumorphicTheme.primaryOrange)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Assign to Day")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Create Custom Routine Sheet
private struct CreateRoutineSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (CustomRoutine) -> Void

    @State private var title: String = ""
    @State private var subtitle: String = ""
    @State private var selectedMuscles: Set<MuscleGroupCategory> = []
    @State private var selectedExercises: [ExerciseItem] = []
    @State private var showingExerciseSelector: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Routine Overview") {
                    TextField("Routine Name (e.g. Chest & Tricep Power)", text: $title)
                    TextField("Focus / Notes (e.g. Heavy compounds)", text: $subtitle)
                }

                Section("Target Muscle Groups") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(MuscleGroupCategory.allCases) { muscle in
                                let isSelected = selectedMuscles.contains(muscle)
                                Button {
                                    if isSelected {
                                        selectedMuscles.remove(muscle)
                                    } else {
                                        selectedMuscles.insert(muscle)
                                    }
                                } label: {
                                    Text(muscle.rawValue)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(isSelected ? muscle.accentColor : Color(.systemGray5))
                                        .foregroundStyle(isSelected ? .white : .primary)
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Exercises (\(selectedExercises.count))") {
                    ForEach(selectedExercises) { ex in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(ex.name).font(.subheadline).fontWeight(.semibold)
                                Text(ex.primaryMuscle.rawValue).font(.caption2).foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                    }
                    .onDelete { indices in
                        selectedExercises.remove(atOffsets: indices)
                    }

                    Button {
                        showingExerciseSelector = true
                    } label: {
                        Label("Add Exercises From Library", systemImage: "plus.circle.fill")
                    }
                }
            }
            .navigationTitle("Create Routine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let routine = CustomRoutine(
                            title: title.isEmpty ? "Custom Routine" : title,
                            subtitle: subtitle,
                            targetMuscles: Array(selectedMuscles),
                            exercises: selectedExercises
                        )
                        onSave(routine)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .sheet(isPresented: $showingExerciseSelector) {
                MultiExercisePickerSheet(selectedList: $selectedExercises)
            }
        }
    }
}

// MARK: - Multi-Exercise Picker Sheet
private struct MultiExercisePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedList: [ExerciseItem]
    @State private var selectedCategory: MuscleGroupCategory? = nil
    @State private var searchText: String = ""

    private var filteredList: [ExerciseItem] {
        var items = ExerciseLibrary.shared.allExercises
        if let cat = selectedCategory {
            items = items.filter { $0.primaryMuscle == cat }
        }
        if !searchText.isEmpty {
            items = items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        return items
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Search
                TextField("Search exercises...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                // Category Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Button("All") { selectedCategory = nil }
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(selectedCategory == nil ? Color.accentColor : Color(.systemGray5))
                            .foregroundStyle(selectedCategory == nil ? .white : .primary)
                            .clipShape(Capsule())

                        ForEach(MuscleGroupCategory.allCases) { cat in
                            Button(cat.rawValue) { selectedCategory = cat }
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(selectedCategory == cat ? cat.accentColor : Color(.systemGray5))
                                .foregroundStyle(selectedCategory == cat ? .white : .primary)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal)
                }

                List(filteredList) { exercise in
                    let isAdded = selectedList.contains(where: { $0.id == exercise.id })

                    Button {
                        if isAdded {
                            selectedList.removeAll(where: { $0.id == exercise.id })
                        } else {
                            selectedList.append(exercise)
                        }
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(exercise.name).font(.subheadline).fontWeight(.semibold)
                                Text("\(exercise.primaryMuscle.rawValue) • \(exercise.equipment)").font(.caption2).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: isAdded ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(isAdded ? Color.green : Color.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Select Exercises")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
