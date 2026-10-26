//
//  PlateCalculatorSheet.swift
//  FitGit
//

import SwiftUI

public struct PlateCalculatorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var targetWeight: Double
    @State private var barWeight: Double = 20.0

    let standardPlates: [Double] = [25.0, 20.0, 15.0, 10.0, 5.0, 2.5, 1.25]

    public init(initialWeight: Double = 100.0) {
        _targetWeight = State(initialValue: max(initialWeight, 20.0))
    }

    private var weightPerSide: Double {
        max(0.0, (targetWeight - barWeight) / 2.0)
    }

    private var calculatedPlatesPerSide: [(plate: Double, count: Int)] {
        var remaining = weightPerSide
        var result: [(plate: Double, count: Int)] = []

        for plate in standardPlates {
            if remaining >= plate {
                let count = Int(remaining / plate)
                result.append((plate: plate, count: count))
                remaining = (remaining - (Double(count) * plate)).rounded(toPlaces: 2)
            }
        }
        return result
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Target Weight Stepper & Display
                VStack(spacing: 8) {
                    Text("Target Total Weight")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 20) {
                        Button {
                            if targetWeight >= 2.5 + barWeight {
                                targetWeight -= 2.5
                                HapticManager.light()
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(AppTheme.primaryAccent)
                        }

                        Text("\(targetWeight.cleanString) kg")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .frame(minWidth: 160)

                        Button {
                            targetWeight += 2.5
                            HapticManager.light()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(AppTheme.primaryAccent)
                        }
                    }

                    Text("Per side: \(weightPerSide.cleanString) kg (Bar: \(barWeight.cleanString) kg)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                // Visual Plate Stack on Barbell
                VStack(alignment: .leading, spacing: 14) {
                    Text("Plates Needed Per Side")
                        .font(.headline)
                        .padding(.horizontal)

                    if calculatedPlatesPerSide.isEmpty {
                        Text("No additional plates needed. Load empty bar.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding()
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                // Barbell Collar
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 8, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 3))

                                ForEach(calculatedPlatesPerSide, id: \.plate) { item in
                                    ForEach(0..<item.count, id: \.self) { _ in
                                        PlateVisual(weight: item.plate)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }

                        // Detailed Plate Breakdown List
                        VStack(spacing: 6) {
                            ForEach(calculatedPlatesPerSide, id: \.plate) { item in
                                HStack {
                                    Circle()
                                        .fill(plateColor(item.plate))
                                        .frame(width: 12, height: 12)
                                    Text("\(item.plate.cleanString) kg plate")
                                        .font(.subheadline)
                                    Spacer()
                                    Text("× \(item.count)")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                                .padding(.vertical, 4)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Plate Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func plateColor(_ weight: Double) -> Color {
        switch weight {
        case 25.0: return .red
        case 20.0: return .blue
        case 15.0: return .yellow
        case 10.0: return .green
        case 5.0: return .white
        case 2.5: return .black
        default: return .gray
        }
    }
}

private struct PlateVisual: View {
    let weight: Double

    private var height: CGFloat {
        switch weight {
        case 25.0: return 120
        case 20.0: return 110
        case 15.0: return 95
        case 10.0: return 80
        case 5.0: return 65
        case 2.5: return 50
        default: return 40
        }
    }

    private var color: Color {
        switch weight {
        case 25.0: return .red
        case 20.0: return .blue
        case 15.0: return .yellow
        case 10.0: return .green
        case 5.0: return Color(.systemGray3)
        case 2.5: return Color(.darkGray)
        default: return .secondary
        }
    }

    var body: some View {
        VStack {
            Text("\(weight.cleanString)")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(weight == 15.0 ? .black : .white)
                .rotationEffect(.degrees(-90))
        }
        .frame(width: 22, height: height)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.black.opacity(0.15), lineWidth: 1)
        )
    }
}

extension Double {
    fileprivate var cleanString: String {
        self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }

    fileprivate func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
