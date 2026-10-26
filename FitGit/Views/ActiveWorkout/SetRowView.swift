//
//  SetRowView.swift
//  FitGit
//

import SwiftUI
import Combine

public struct SetRowView: View {
    @ObservedObject var setEntityObservable: SetEntityObservable
    let previousPerformance: String?
    let onToggleComplete: () -> Void
    let onOpenCalculator: (Double) -> Void
    let onDelete: () -> Void

    public init(
        set: ExerciseSet,
        previousPerformance: String? = nil,
        onToggleComplete: @escaping () -> Void,
        onOpenCalculator: @escaping (Double) -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.setEntityObservable = SetEntityObservable(set: set)
        self.previousPerformance = previousPerformance
        self.onToggleComplete = onToggleComplete
        self.onOpenCalculator = onOpenCalculator
        self.onDelete = onDelete
    }

    public var body: some View {
        HStack(spacing: 10) {
            // Set Number Badge
            ZStack {
                Circle()
                    .fill(setEntityObservable.set.isCompleted ? AppTheme.emeraldPower.opacity(0.15) : Color(.systemGray5))
                    .frame(width: 28, height: 28)
                Text("\(setEntityObservable.set.setNumber)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(setEntityObservable.set.isCompleted ? AppTheme.emeraldPower : .secondary)
            }

            // Previous Reference (Ghost text)
            if let prev = previousPerformance {
                Text(prev)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .frame(width: 55, alignment: .leading)
            }

            // Weight Field with Plate Calc Button
            HStack(spacing: 2) {
                TextField("0", value: $setEntityObservable.weight, format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.plain)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 4)
                    .frame(width: 58)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Button {
                    onOpenCalculator(setEntityObservable.weight)
                    HapticManager.light()
                } label: {
                    Image(systemName: "circle.circle")
                        .font(.caption2)
                        .foregroundStyle(AppTheme.primaryAccent)
                }
            }

            // Reps Field
            HStack(spacing: 2) {
                TextField("0", value: $setEntityObservable.reps, format: .number)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.plain)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 4)
                    .frame(width: 48)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Text("r")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Complete Checkbox Button
            Button(action: onToggleComplete) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(setEntityObservable.set.isCompleted ? AppTheme.emeraldPower : Color(.systemGray5))
                        .frame(width: 38, height: 32)

                    Image(systemName: setEntityObservable.set.isCompleted ? "checkmark" : "")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 3)
        .padding(.horizontal, 8)
        .background(setEntityObservable.set.isCompleted ? AppTheme.emeraldPower.opacity(0.08) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

/// Helper wrapper to observe and update Core Data set entity in real time
public final class SetEntityObservable: ObservableObject {
    public let set: ExerciseSet

    @Published public var weight: Double {
        didSet {
            set.weight = weight
            set.exercise?.workout?.recalculateTotalVolume()
        }
    }

    @Published public var reps: Int {
        didSet {
            set.reps = Int16(reps)
            set.exercise?.workout?.recalculateTotalVolume()
        }
    }

    public init(set: ExerciseSet) {
        self.set = set
        self.weight = set.weight
        self.reps = Int(set.reps)
    }
}
