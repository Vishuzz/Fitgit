//
//  RoutineTemplateCarouselView.swift
//  FitGit
//

import SwiftUI

public struct RoutineTemplateCarouselView: View {
    let onSelectTemplate: (WorkoutTemplate) -> Void

    public init(onSelectTemplate: @escaping (WorkoutTemplate) -> Void) {
        self.onSelectTemplate = onSelectTemplate
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Routine Templates")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Text("Quick Start")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(WorkoutTemplate.sampleTemplates) { template in
                        Button {
                            HapticManager.medium()
                            onSelectTemplate(template)
                        } label: {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: template.iconName)
                                        .font(.title3)
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Text("\(template.estimatedMinutes) min")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.white.opacity(0.25))
                                        .foregroundStyle(.white)
                                        .clipShape(Capsule())
                                }

                                Spacer()

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(template.title)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                    Text(template.subtitle)
                                        .font(.caption2)
                                        .foregroundStyle(.white.opacity(0.85))
                                        .lineLimit(1)
                                }

                                HStack {
                                    Text("\(template.exercises.count) exercises")
                                        .font(.caption2)
                                        .foregroundStyle(.white.opacity(0.8))
                                    Spacer()
                                    Image(systemName: "play.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(14)
                            .frame(width: 200, height: 140)
                            .background(template.gradient)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
