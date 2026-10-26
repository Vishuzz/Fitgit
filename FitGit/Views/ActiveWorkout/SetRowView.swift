//
//  SetRowView.swift
//  FitGit
//

import SwiftUI
import Combine

public struct SetRowView: View {
    @ObservedObject var setEntityObservable: SetEntityObservable
    let onToggleComplete: () -> Void
    let onDelete: () -> Void

    public init(set: ExerciseSet, onToggleComplete: @escaping () -> Void, onDelete: @escaping () -> Void) {
        self.setEntityObservable = SetEntityObservable(set: set)
        self.onToggleComplete = onToggleComplete
        self.onDelete = onDelete
    }

    public var body: some View {
        HStack(spacing: 12) {
            Text("\(setEntityObservable.set.setNumber)")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .frame(width: 24)

            // Weight Field
            HStack(spacing: 4) {
                TextField("0", value: $setEntityObservable.weight, format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 65)
                    .multilineTextAlignment(.center)
                Text("kg")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            // Reps Field
            HStack(spacing: 4) {
                TextField("0", value: $setEntityObservable.reps, format: .number)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 55)
                    .multilineTextAlignment(.center)
                Text("reps")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Complete Button
            Button(action: onToggleComplete) {
                Image(systemName: setEntityObservable.set.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(setEntityObservable.set.isCompleted ? Color.green : Color.secondary.opacity(0.6))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(setEntityObservable.set.isCompleted ? Color.green.opacity(0.08) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
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
