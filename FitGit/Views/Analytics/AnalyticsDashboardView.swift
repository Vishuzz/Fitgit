//
//  AnalyticsDashboardView.swift
//  FitGit
//

import SwiftUI
import CoreData

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

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // High-level Metric Cards
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
                            color: .orange
                        )
                        MetricCard(
                            title: "Completed Sets",
                            value: "\(totalSets)",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        MetricCard(
                            title: "Hours Trained",
                            value: String(format: "%.1f hrs", totalDurationSeconds / 3600.0),
                            icon: "clock.fill",
                            color: .blue
                        )
                    }
                    .padding(.horizontal)

                    // On-Device Intelligence / Machine Learning Insights Card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "cpu")
                                .foregroundStyle(.purple)
                            Text("On-Device ML Insights (Core ML)")
                                .font(.headline)
                        }

                        Text("All analytics and progression calculations run 100% locally on your device with zero cloud latency.")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Divider()

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Estimated Training Strain")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("Calculated from local session volume and duration.")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(String(format: "RPE %.1f", mlService.estimateRPE(duration: totalDurationSeconds, volume: totalVolume)))
                                .font(.headline)
                                .foregroundStyle(.purple)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.purple.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)

                    // Muscle Group Distribution
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Muscle Group Coverage")
                            .font(.headline)
                            .padding(.horizontal)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(MuscleGroup.allCases) { group in
                                HStack {
                                    Image(systemName: group.iconName)
                                        .foregroundStyle(group.accentColor)
                                        .frame(width: 24)
                                    Text(group.rawValue)
                                        .font(.subheadline)
                                    Spacer()
                                }
                                .padding(10)
                                .background(Color(.secondarySystemGroupedBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
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
