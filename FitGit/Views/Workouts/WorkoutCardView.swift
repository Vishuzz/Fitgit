//
//  WorkoutCardView.swift
//  FitGit
//

import SwiftUI

public struct WorkoutCardView: View {
    let workout: Workout

    public init(workout: Workout) {
        self.workout = workout
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header: Name, Date & Status
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.unwrappedName)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(workout.unwrappedStartDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if !workout.isCompleted {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 6, height: 6)
                        Text("ACTIVE")
                            .font(.caption2)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.15))
                    .foregroundStyle(.orange)
                    .clipShape(Capsule())
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.emeraldPower)
                }
            }

            // Exercises Summary Pills
            if !workout.exercisesArray.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(workout.exercisesArray.prefix(4)) { exercise in
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(categoryColor(for: exercise.unwrappedCategory))
                                    .frame(width: 6, height: 6)
                                Text("\(exercise.setsArray.count)× \(exercise.unwrappedName)")
                                    .font(.caption2)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray5))
                            .foregroundStyle(.secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        if workout.exercisesArray.count > 4 {
                            Text("+\(workout.exercisesArray.count - 4) more")
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(.systemGray5))
                                .foregroundStyle(.tertiary)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
            }

            Divider()

            // Footer Metrics
            HStack(spacing: 16) {
                Label(String(format: "%.0f kg", workout.totalVolume), systemImage: "scalemass.fill")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.primaryAccent)

                Label("\(workout.completedSetsCount) sets", systemImage: "number")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if workout.duration > 0 {
                    Label(formatDuration(workout.duration), systemImage: "clock.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    private func categoryColor(for category: String) -> Color {
        MuscleGroup(rawValue: category)?.accentColor ?? .gray
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let mins = Int(duration) / 60
        let hours = mins / 60
        let remainingMins = mins % 60
        if hours > 0 {
            return "\(hours)h \(remainingMins)m"
        } else {
            return "\(mins) min"
        }
    }
}
