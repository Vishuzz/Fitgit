//
//  ExerciseLibraryView.swift
//  FitGit
//

import SwiftUI

public struct ExerciseLibraryView: View {
    @State private var selectedCategory: MuscleGroupCategory? = nil
    @State private var searchText: String = ""
    @State private var customExercises: [ExerciseItem] = []
    @State private var showingCustomExerciseSheet: Bool = false
    @State private var selectedExerciseForDetail: ExerciseItem? = nil

    private var allExercisesCombined: [ExerciseItem] {
        customExercises + ExerciseLibrary.shared.allExercises
    }

    private var filteredExercises: [ExerciseItem] {
        var list = allExercisesCombined
        if let category = selectedCategory {
            list = list.filter { $0.primaryMuscle == category }
        }
        if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            list = list.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.equipment.localizedCaseInsensitiveContains(searchText) ||
                $0.primaryMuscle.rawValue.localizedCaseInsensitiveContains(searchText) ||
                $0.resolvedMusclePart.localizedCaseInsensitiveContains(searchText)
            }
        }
        return list
    }

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("CATALOG")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.primaryOrange)
                                .tracking(1.5)

                            Text("Exercise Library")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                        }

                        Spacer()

                        Button {
                            showingCustomExerciseSheet = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "plus")
                                    .fontWeight(.bold)
                                Text("Custom")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                        }
                        .neumorphicButton(cornerRadius: 12, accent: NeumorphicTheme.cyanPulse)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // Neumorphic Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(NeumorphicTheme.textMuted)
                        TextField("Search exercises by name, equipment, muscle...", text: $searchText)
                            .font(.subheadline)
                            .foregroundStyle(NeumorphicTheme.textPrimary)
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(NeumorphicTheme.textMuted)
                            }
                        }
                    }
                    .padding(12)
                    .neumorphicConcave(cornerRadius: 14)
                    .padding(.horizontal)

                    // Muscle Category Filter Chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            Button {
                                selectedCategory = nil
                            } label: {
                                Text("All (\(allExercisesCombined.count))")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 7)
                                    .background(selectedCategory == nil ? NeumorphicTheme.primaryOrange : NeumorphicTheme.background)
                                    .foregroundStyle(selectedCategory == nil ? .white : NeumorphicTheme.textSecondary)
                                    .clipShape(Capsule())
                                    .shadow(color: selectedCategory == nil ? Color.clear : NeumorphicTheme.lightShadow, radius: 2, x: -2, y: -2)
                                    .shadow(color: selectedCategory == nil ? Color.clear : NeumorphicTheme.darkShadow, radius: 2, x: 2, y: 2)
                            }
                            .buttonStyle(.plain)

                            ForEach(MuscleGroupCategory.allCases) { cat in
                                let isSelected = (selectedCategory == cat)
                                Button {
                                    selectedCategory = cat
                                } label: {
                                    HStack(spacing: 5) {
                                        Circle()
                                            .fill(cat.accentColor)
                                            .frame(width: 6, height: 6)
                                        Text(cat.rawValue)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 7)
                                    .background(isSelected ? cat.accentColor : NeumorphicTheme.background)
                                    .foregroundStyle(isSelected ? .white : NeumorphicTheme.textSecondary)
                                    .clipShape(Capsule())
                                    .shadow(color: isSelected ? Color.clear : NeumorphicTheme.lightShadow, radius: 2, x: -2, y: -2)
                                    .shadow(color: isSelected ? Color.clear : NeumorphicTheme.darkShadow, radius: 2, x: 2, y: 2)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }

                    // Exercise Cards List
                    VStack(spacing: 12) {
                        ForEach(filteredExercises) { exercise in
                            Button {
                                selectedExerciseForDetail = exercise
                            } label: {
                                HStack(spacing: 14) {
                                    Circle()
                                        .fill(exercise.primaryMuscle.accentColor.opacity(0.15))
                                        .frame(width: 44, height: 44)
                                        .overlay(
                                            Image(systemName: exercise.primaryMuscle.iconName)
                                                .font(.subheadline)
                                                .foregroundStyle(exercise.primaryMuscle.accentColor)
                                        )

                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(exercise.name)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(NeumorphicTheme.textPrimary)

                                        HStack(spacing: 6) {
                                            Text(exercise.primaryMuscle.rawValue)
                                                .font(.caption2)
                                                .foregroundStyle(exercise.primaryMuscle.accentColor)
                                                .fontWeight(.semibold)

                                            Text("• \(exercise.equipment)")
                                                .font(.caption2)
                                                .foregroundStyle(NeumorphicTheme.textMuted)
                                        }

                                        // Exact Targeted Muscle Part Pill
                                        HStack(spacing: 4) {
                                            Image(systemName: "scope")
                                                .font(.system(size: 9, weight: .bold))
                                                .foregroundStyle(exercise.primaryMuscle.accentColor)

                                            Text(exercise.resolvedMusclePart)
                                                .font(.system(size: 11, weight: .semibold))
                                                .foregroundStyle(NeumorphicTheme.textSecondary)
                                                .lineLimit(1)
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(NeumorphicTheme.darkSurface)
                                        .clipShape(Capsule())
                                    }

                                    Spacer()

                                    Image(systemName: "info.circle")
                                        .font(.subheadline)
                                        .foregroundStyle(NeumorphicTheme.textMuted)
                                }
                                .padding(12)
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
            .sheet(item: $selectedExerciseForDetail) { exercise in
                ExerciseDetailModal(exercise: exercise)
            }
            .sheet(isPresented: $showingCustomExerciseSheet) {
                AddCustomExerciseModal { newExercise in
                    customExercises.append(newExercise)
                }
            }
        }
    }
}

// MARK: - Exercise Detail Modal
private struct ExerciseDetailModal: View {
    @Environment(\.dismiss) private var dismiss
    let exercise: ExerciseItem

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Circle()
                            .fill(exercise.primaryMuscle.accentColor.opacity(0.15))
                            .frame(width: 56, height: 56)
                            .overlay(
                                Image(systemName: exercise.primaryMuscle.iconName)
                                    .font(.title2)
                                    .foregroundStyle(exercise.primaryMuscle.accentColor)
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(exercise.name)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.textPrimary)

                            Text(exercise.primaryMuscle.rawValue)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(exercise.primaryMuscle.accentColor)
                        }
                    }
                    .padding()
                    .neumorphicCard(cornerRadius: 18)

                    // Target Muscle Part Card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 6) {
                            Image(systemName: "scope")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.primaryOrange)

                            Text("TARGETED PART OF MUSCLE")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.primaryOrange)
                                .tracking(1.0)
                        }

                        Text(exercise.resolvedMusclePart)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(NeumorphicTheme.textPrimary)

                        Text("Isolates and places peak mechanical tension on this specific anatomical division.")
                            .font(.caption)
                            .foregroundStyle(NeumorphicTheme.textSecondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .neumorphicCard(cornerRadius: 18)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("DETAILS")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(NeumorphicTheme.textMuted)

                        HStack {
                            Text("Equipment Needed:")
                                .font(.subheadline)
                                .foregroundStyle(NeumorphicTheme.textSecondary)
                            Spacer()
                            Text(exercise.equipment)
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }

                        HStack {
                            Text("Target Working Sets:")
                                .font(.subheadline)
                                .foregroundStyle(NeumorphicTheme.textSecondary)
                            Spacer()
                            Text("\(exercise.targetSets) sets")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.primaryOrange)
                        }

                        HStack {
                            Text("Target Rep Range:")
                                .font(.subheadline)
                                .foregroundStyle(NeumorphicTheme.textSecondary)
                            Spacer()
                            Text(exercise.targetRepsRange)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.cyanPulse)
                        }

                        if !exercise.secondaryMuscles.isEmpty {
                            HStack {
                                Text("Secondary Muscles:")
                                .font(.subheadline)
                                .foregroundStyle(NeumorphicTheme.textSecondary)
                                Spacer()
                                Text(exercise.secondaryMuscles.joined(separator: ", "))
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    .padding()
                    .neumorphicCard(cornerRadius: 18)

                    if !exercise.instructions.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("FORM & TECHNIQUE")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.textMuted)

                            Text(exercise.instructions)
                                .font(.subheadline)
                                .foregroundStyle(NeumorphicTheme.textPrimary)
                                .lineSpacing(4)
                        }
                        .padding()
                        .neumorphicCard(cornerRadius: 18)
                    }
                }
                .padding()
            }
            .background(NeumorphicTheme.background.ignoresSafeArea())
            .navigationTitle("Exercise Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Add Custom Exercise Modal
private struct AddCustomExerciseModal: View {
    @Environment(\.dismiss) private var dismiss
    let onAdd: (ExerciseItem) -> Void

    @State private var name: String = ""
    @State private var selectedMuscle: MuscleGroupCategory = .chest
    @State private var targetMusclePart: String = ""
    @State private var equipment: String = "Dumbbells"
    @State private var instructions: String = ""

    let equipmentOptions = ["Barbell", "Dumbbells", "Cable", "Machine", "Bodyweight", "EZ Bar", "Kettlebell", "Cardio"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Exercise Info") {
                    TextField("Exercise Name (e.g. Incline Smith Press)", text: $name)
                    Picker("Primary Muscle", selection: $selectedMuscle) {
                        ForEach(MuscleGroupCategory.allCases) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                    TextField("Target Muscle Part (e.g. Upper Chest, Long Head)", text: $targetMusclePart)
                    Picker("Equipment", selection: $equipment) {
                        ForEach(equipmentOptions, id: \.self) { eq in
                            Text(eq).tag(eq)
                        }
                    }
                }

                Section("Instructions (Optional)") {
                    TextField("Form tips and cues...", text: $instructions, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let exercise = ExerciseItem(
                            name: name,
                            primaryMuscle: selectedMuscle,
                            targetMusclePart: targetMusclePart,
                            secondaryMuscles: [],
                            equipment: equipment,
                            instructions: instructions,
                            isCustom: true
                        )
                        onAdd(exercise)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
