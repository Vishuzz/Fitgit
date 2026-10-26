//
//  AddExerciseSheet.swift
//  FitGit
//

import SwiftUI

public struct AddExerciseSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onAdd: (String, String) -> Void

    @State private var exerciseName: String = ""
    @State private var selectedCategory: MuscleGroup = .chest

    let commonExercises: [String: [String]] = [
        "Chest": ["Barbell Bench Press", "Incline Dumbbell Press", "Dips", "Cable Flyes", "Push-ups"],
        "Back": ["Deadlift", "Pull-ups", "Barbell Row", "Lat Pulldown", "Seated Cable Row"],
        "Legs": ["Barbell Squat", "Romanian Deadlift", "Leg Press", "Bulgarian Split Squat", "Leg Curl"],
        "Shoulders": ["Overhead Barbell Press", "Dumbbell Lateral Raise", "Face Pulls", "Reverse Fly"],
        "Arms": ["Barbell Bicep Curl", "Tricep Rope Pushdown", "Hammer Curl", "Skull Crushers"],
        "Core": ["Hanging Leg Raise", "Plank", "Cable Woodchoppers", "Ab Wheel Rollout"]
    ]

    public init(onAdd: @escaping (String, String) -> Void) {
        self.onAdd = onAdd
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Custom Exercise") {
                    TextField("Exercise Name (e.g. Incline Bench)", text: $exerciseName)
                    Picker("Muscle Group", selection: $selectedCategory) {
                        ForEach(MuscleGroup.allCases) { group in
                            Label(group.rawValue, systemImage: group.iconName).tag(group)
                        }
                    }
                    Button("Add Custom Exercise") {
                        guard !exerciseName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        onAdd(exerciseName, selectedCategory.rawValue)
                        dismiss()
                    }
                    .disabled(exerciseName.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                Section("Quick Select") {
                    ForEach(MuscleGroup.allCases) { group in
                        if let list = commonExercises[group.rawValue] {
                            DisclosureGroup(group.rawValue) {
                                ForEach(list, id: \.self) { name in
                                    Button {
                                        onAdd(name, group.rawValue)
                                        dismiss()
                                    } label: {
                                        HStack {
                                            Text(name)
                                                .foregroundStyle(.primary)
                                            Spacer()
                                            Image(systemName: "plus.circle")
                                                .foregroundStyle(group.accentColor)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
