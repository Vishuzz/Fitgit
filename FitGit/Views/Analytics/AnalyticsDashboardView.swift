//
//  AnalyticsDashboardView.swift
//  FitGit
//

import SwiftUI
import CoreData
import Charts

public struct WeeklyVolumeData: Identifiable {
    public let id = UUID()
    public let weekLabel: String
    public let volume: Double
}

public struct PersonalRecordItem: Identifiable {
    public let id = UUID()
    public let exerciseName: String
    public let weight: Double
    public let reps: Int16
    public let date: Date
}

public struct AnalyticsDashboardView: View {
    @FetchRequest(
        entity: Workout.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.startDate, ascending: false)]
    ) var workouts: FetchedResults<Workout>

    private let mlService: MLInferenceServiceProtocol = MLInferenceService.shared

    public init() {}

    private var completedWorkouts: [Workout] {
        workouts.filter { $0.isCompleted }
    }

    private var totalVolume: Double {
        completedWorkouts.reduce(0.0) { $0 + $1.totalVolume }
    }

    private var totalSets: Int {
        completedWorkouts.reduce(0) { $0 + $1.completedSetsCount }
    }

    private var totalDurationSeconds: Double {
        completedWorkouts.reduce(0.0) { $0 + $1.duration }
    }

    // Weekly Volume Calculation for Chart
    private var weeklyVolumePoints: [WeeklyVolumeData] {
        let calendar = Calendar.current
        var points: [WeeklyVolumeData] = []

        for weekOffset in (0..<5).reversed() {
            guard let date = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: Date()),
                  let interval = calendar.dateInterval(of: .weekOfYear, for: date) else { continue }

            let volumeForWeek = completedWorkouts.filter { workout in
                guard let start = workout.startDate else { return false }
                return start >= interval.start && start < interval.end
            }.reduce(0.0) { $0 + $1.totalVolume }

            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            let label = formatter.string(from: interval.start)
            points.append(WeeklyVolumeData(weekLabel: label, volume: volumeForWeek))
        }
        return points
    }

    // PR Hall of Fame computed from Core Data
    private var personalRecords: [PersonalRecordItem] {
        let keyExercises = ["Bench Press", "Squat", "Deadlift", "Overhead Press", "Barbell Row"]
        var prs: [PersonalRecordItem] = []

        for name in keyExercises {
            var highestWeight: Double = 0.0
            var highestReps: Int16 = 0
            var bestDate: Date = Date()

            for workout in completedWorkouts {
                for exercise in workout.exercisesArray where exercise.unwrappedName.localizedCaseInsensitiveContains(name) {
                    for set in exercise.completedSets where set.weight > highestWeight {
                        highestWeight = set.weight
                        highestReps = set.reps
                        bestDate = workout.unwrappedStartDate
                    }
                }
            }

            if highestWeight > 0 {
                prs.append(PersonalRecordItem(exerciseName: name, weight: highestWeight, reps: highestReps, date: bestDate))
            }
        }
        return prs
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // High-level Metric Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        MetricCard(
                            title: "Total Workouts",
                            value: "\(completedWorkouts.count)",
                            icon: "flame.fill",
                            color: .red
                        )
                        MetricCard(
                            title: "Total Volume",
                            value: totalVolume >= 1000 ? String(format: "%.1f k kg", totalVolume / 1000.0) : String(format: "%.0f kg", totalVolume),
                            icon: "scalemass.fill",
                            color: AppTheme.primaryAccent
                        )
                        MetricCard(
                            title: "Completed Sets",
                            value: "\(totalSets)",
                            icon: "checkmark.circle.fill",
                            color: AppTheme.emeraldPower
                        )
                        MetricCard(
                            title: "Hours Trained",
                            value: String(format: "%.1f hrs", totalDurationSeconds / 3600.0),
                            icon: "clock.fill",
                            color: AppTheme.electricBlue
                        )
                    }
                    .padding(.horizontal)

                    // Weekly Volume Progression Chart
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Weekly Volume Trend (kg)")
                            .font(.headline)

                        if weeklyVolumePoints.allSatisfy({ $0.volume == 0 }) {
                            Text("Complete workouts across weeks to visualize volume progression.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 24)
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            Chart(weeklyVolumePoints) { item in
                                BarMark(
                                    x: .value("Week", item.weekLabel),
                                    y: .value("Volume", item.volume)
                                )
                                .foregroundStyle(AppTheme.blazeGradient)
                                .cornerRadius(6)
                            }
                            .frame(height: 160)
                            .chartYAxis {
                                AxisMarks(position: .leading)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)

                    // Personal Records (PR) Hall of Fame
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "trophy.fill")
                                .foregroundStyle(.yellow)
                            Text("Personal Records (PRs)")
                                .font(.headline)
                        }

                        if personalRecords.isEmpty {
                            Text("Log exercises like Bench Press, Squat, or Deadlift to record all-time personal bests.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 8)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(personalRecords) { pr in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(pr.exerciseName)
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                            Text(pr.date.formatted(date: .abbreviated, time: .omitted))
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }

                                        Spacer()

                                        Text("\(String(format: "%.0f", pr.weight)) kg × \(pr.reps)")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color.yellow.opacity(0.15))
                                            .foregroundStyle(.orange)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)

                    // On-Device Intelligence / Machine Learning Insights Card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "cpu")
                                .foregroundStyle(AppTheme.violetOverload)
                            Text("On-Device ML Insights (Core ML)")
                                .font(.headline)
                        }

                        Text("All analytics and progressive overload recommendations run 100% locally on your device with zero cloud latency.")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Divider()

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Estimated Training Strain")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("Calculated from session density, volume, and rest intervals.")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(String(format: "RPE %.1f", mlService.estimateRPE(duration: totalDurationSeconds, volume: totalVolume)))
                                .font(.headline)
                                .foregroundStyle(AppTheme.violetOverload)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(AppTheme.violetOverload.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)

                    // Muscle Group Distribution
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Muscle Group Focus")
                            .font(.headline)
                            .padding(.horizontal)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(MuscleGroup.allCases) { group in
                                HStack {
                                    Circle()
                                        .fill(group.accentColor.opacity(0.15))
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Image(systemName: group.iconName)
                                                .font(.caption)
                                                .foregroundStyle(group.accentColor)
                                        )

                                    Text(group.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Spacer()
                                }
                                .padding(10)
                                .background(Color(.secondarySystemGroupedBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Analytics")
        }
    }
}
