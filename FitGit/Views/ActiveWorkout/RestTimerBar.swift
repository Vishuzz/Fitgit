//
//  RestTimerBar.swift
//  FitGit
//

import SwiftUI

public struct RestTimerBar: View {
    let remainingSeconds: Int
    let totalSeconds: Int
    let onAddSeconds: (Int) -> Void
    let onSkip: () -> Void

    private var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return Double(remainingSeconds) / Double(totalSeconds)
    }

    private var formattedTime: String {
        let mins = remainingSeconds / 60
        let secs = remainingSeconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }

    public var body: some View {
        HStack(spacing: 16) {
            // Mini Countdown Ring
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 4)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1.0), value: progress)
                Image(systemName: "stopwatch.fill")
                    .font(.caption2)
                    .foregroundStyle(.white)
            }
            .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text("Rest Timer")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.8))
                Text(formattedTime)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }

            Spacer()

            // Quick add 30s
            Button {
                onAddSeconds(30)
                HapticManager.light()
            } label: {
                Text("+30s")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.2))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }

            // Skip Button
            Button {
                onSkip()
                HapticManager.light()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(AppTheme.blazeGradient)
                .shadow(color: AppTheme.primaryAccent.opacity(0.4), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}
