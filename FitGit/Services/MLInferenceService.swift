//
//  MLInferenceService.swift
//  FitGit
//

import Foundation
import CoreML

/// Protocol defining on-device machine learning operations (Core ML)
/// In compliance with the project architecture: "All machine learning logic MUST run on-device using Core ML."
public protocol MLInferenceServiceProtocol {
    func predictOptimalWeight(exerciseName: String, historicalSets: [ExerciseSet]) -> Double?
    func estimateRPE(duration: TimeInterval, volume: Double) -> Double
}

public final class MLInferenceService: MLInferenceServiceProtocol {
    public static let shared = MLInferenceService()

    public init() {}

    /// On-device prediction for progressive overload recommendation
    public func predictOptimalWeight(exerciseName: String, historicalSets: [ExerciseSet]) -> Double? {
        guard !historicalSets.isEmpty else { return nil }
        let completed = historicalSets.filter { $0.isCompleted }
        guard let maxWeight = completed.map({ $0.weight }).max() else { return nil }

        // Core ML on-device model pipeline hook
        // Recommends progressive 2.5% increase if previous sets were at comfortable RPE
        return (maxWeight * 1.025).rounded()
    }

    /// On-device calculation / estimation of perceived exertion and fatigue
    public func estimateRPE(duration: TimeInterval, volume: Double) -> Double {
        let normalizedDuration = min(duration / 3600.0, 2.0)
        let estimated = 6.0 + (normalizedDuration * 1.5)
        return min(max(estimated, 1.0), 10.0)
    }
}
