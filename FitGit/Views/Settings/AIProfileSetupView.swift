//
//  AIProfileSetupView.swift
//  FitGit
//

import SwiftUI

public struct AIProfileSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var profileStore = UserProfileStore.shared

    // Step state (0: Welcome/Name, 1: Age, 2: Weight & Height, 3: Years in Gym, 4: Goal, 5: AI Generating, 6: Result)
    @State private var currentStep: Int = 0

    // Form inputs initialized from current profile
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var age: Int = 24
    @State private var weightKg: Double = 78.5
    @State private var isWeightInLbs: Bool = false
    @State private var heightCm: Double = 178.0
    @State private var yearsInGym: Double = 2.5
    @State private var selectedGoal: FitnessGoal = .hypertrophy

    // Generated profile holder
    @State private var generatedProfile: UserProfile? = nil
    @State private var isAnalyzing: Bool = false
    @State private var aiAnalysisStatusText: String = "Analyzing biometric data..."

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                NeumorphicTheme.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top Progress Bar
                    if currentStep <= 4 {
                        stepProgressBar
                            .padding(.horizontal)
                            .padding(.top, 12)
                            .padding(.bottom, 8)
                    }

                    ScrollView {
                        VStack(spacing: 20) {
                            switch currentStep {
                            case 0:
                                nameStepView
                            case 1:
                                ageStepView
                            case 2:
                                bodyMetricsStepView
                            case 3:
                                gymExperienceStepView
                            case 4:
                                goalStepView
                            case 5:
                                aiAnalyzingStepView
                            case 6:
                                if let generated = generatedProfile {
                                    aiResultStepView(profile: generated)
                                }
                            default:
                                EmptyView()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                    }

                    // Bottom Navigation Buttons
                    if currentStep <= 4 {
                        bottomNavigationControls
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .background(NeumorphicTheme.background)
                    }
                }
            }
            .navigationTitle(currentStep == 6 ? "AI Profile Ready" : "AI Coach Assessment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if currentStep < 5 || currentStep == 6 {
                        Button("Close") {
                            dismiss()
                        }
                        .foregroundStyle(NeumorphicTheme.textSecondary)
                    }
                }
            }
            .onAppear {
                loadExistingData()
            }
        }
    }

    private func loadExistingData() {
        let p = profileStore.profile
        name = p.name
        username = p.username
        age = p.age
        weightKg = p.weightKg
        heightCm = p.heightCm
        yearsInGym = p.yearsInGym
        selectedGoal = p.fitnessGoal
    }

    // MARK: - Progress Bar
    private var stepProgressBar: some View {
        HStack(spacing: 6) {
            ForEach(0..<5) { index in
                Capsule()
                    .fill(index <= currentStep ? NeumorphicTheme.primaryOrange : NeumorphicTheme.darkSurface)
                    .frame(height: 5)
                    .animation(.easeInOut(duration: 0.25), value: currentStep)
            }
        }
    }

    // MARK: - Step 0: Name & Handle
    private var nameStepView: some View {
        VStack(spacing: 20) {
            aiCoachSpeechBubble(
                title: "Welcome Athlete!",
                message: "I am your FitGit AI Coach. I will analyze your biometrics and gym experience to engineer your custom training profile."
            )

            VStack(alignment: .leading, spacing: 14) {
                Text("WHAT SHOULD I CALL YOU?")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.textMuted)
                    .tracking(1.2)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Full Name")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(NeumorphicTheme.textSecondary)

                    TextField("e.g. Vishek Tyagi", text: $name)
                        .font(.body)
                        .foregroundStyle(NeumorphicTheme.textPrimary)
                        .padding(14)
                        .neumorphicConcave(cornerRadius: 14)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Athlete Handle (@)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(NeumorphicTheme.textSecondary)

                    HStack(spacing: 4) {
                        Text("@")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundStyle(NeumorphicTheme.primaryOrange)

                        TextField("vishek", text: $username)
                            .font(.body)
                            .foregroundStyle(NeumorphicTheme.textPrimary)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding(14)
                    .neumorphicConcave(cornerRadius: 14)
                }
            }
            .padding(18)
            .neumorphicCard(cornerRadius: 20)
        }
    }

    // MARK: - Step 1: Age
    private var ageStepView: some View {
        VStack(spacing: 20) {
            aiCoachSpeechBubble(
                title: "Age Calibration",
                message: "Your age helps me calibrate your metabolic recovery capacity, hormone profile, and heart rate training zones."
            )

            VStack(spacing: 16) {
                Text("HOW OLD ARE YOU?")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.textMuted)
                    .tracking(1.2)

                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(age)")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundStyle(NeumorphicTheme.primaryOrange)

                    Text("years old")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(NeumorphicTheme.textSecondary)
                }

                // Interactive Stepper
                HStack(spacing: 16) {
                    Button {
                        if age > 14 {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            age -= 1
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(NeumorphicTheme.textPrimary)
                            .frame(width: 48, height: 48)
                    }
                    .neumorphicButton(cornerRadius: 14)

                    Slider(value: Binding(
                        get: { Double(age) },
                        set: { age = Int($0) }
                    ), in: 14...80, step: 1)
                    .tint(NeumorphicTheme.primaryOrange)

                    Button {
                        if age < 80 {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            age += 1
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(NeumorphicTheme.textPrimary)
                            .frame(width: 48, height: 48)
                    }
                    .neumorphicButton(cornerRadius: 14)
                }
                .padding(.horizontal, 8)
            }
            .padding(22)
            .neumorphicCard(cornerRadius: 20)
        }
    }

    // MARK: - Step 2: Weight & Height
    private var bodyMetricsStepView: some View {
        VStack(spacing: 20) {
            aiCoachSpeechBubble(
                title: "Body Composition Baseline",
                message: "Accurate weight and height are essential for computing BMI, maintenance calorie expenditure, and exact daily protein intake."
            )

            // Weight Card
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("CURRENT BODY WEIGHT")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(NeumorphicTheme.textMuted)
                        .tracking(1.2)

                    Spacer()

                    Picker("Unit", selection: $isWeightInLbs) {
                        Text("kg").tag(false)
                        Text("lbs").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 100)
                }

                HStack(alignment: .lastTextBaseline, spacing: 6) {
                    let displayWeight = isWeightInLbs ? (weightKg * 2.20462) : weightKg
                    Text(String(format: "%.1f", displayWeight))
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(NeumorphicTheme.primaryOrange)

                    Text(isWeightInLbs ? "lbs" : "kg")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(NeumorphicTheme.textSecondary)

                    Spacer()

                    HStack(spacing: 12) {
                        Button {
                            if weightKg > 40 {
                                weightKg -= 0.5
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                        } label: {
                            Image(systemName: "minus")
                                .font(.headline)
                                .frame(width: 38, height: 38)
                        }
                        .neumorphicButton(cornerRadius: 12)

                        Button {
                            if weightKg < 180 {
                                weightKg += 0.5
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.headline)
                                .frame(width: 38, height: 38)
                        }
                        .neumorphicButton(cornerRadius: 12)
                    }
                }

                Slider(value: $weightKg, in: 40...160, step: 0.5)
                    .tint(NeumorphicTheme.primaryOrange)
            }
            .padding(18)
            .neumorphicCard(cornerRadius: 20)

            // Height Card
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("STATURE / HEIGHT")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(NeumorphicTheme.textMuted)
                        .tracking(1.2)

                    Spacer()

                    let totalInches = heightCm / 2.54
                    let feet = Int(totalInches / 12)
                    let inches = Int(totalInches.truncatingRemainder(dividingBy: 12))
                    Text("\(feet)'\(inches)\"")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(NeumorphicTheme.cyanPulse)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(NeumorphicTheme.darkSurface)
                        .clipShape(Capsule())
                }

                HStack(alignment: .lastTextBaseline, spacing: 6) {
                    Text("\(Int(heightCm))")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(NeumorphicTheme.cyanPulse)

                    Text("cm")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(NeumorphicTheme.textSecondary)

                    Spacer()

                    HStack(spacing: 12) {
                        Button {
                            if heightCm > 130 {
                                heightCm -= 1
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                        } label: {
                            Image(systemName: "minus")
                                .font(.headline)
                                .frame(width: 38, height: 38)
                        }
                        .neumorphicButton(cornerRadius: 12)

                        Button {
                            if heightCm < 220 {
                                heightCm += 1
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.headline)
                                .frame(width: 38, height: 38)
                        }
                        .neumorphicButton(cornerRadius: 12)
                    }
                }

                Slider(value: $heightCm, in: 130...220, step: 1)
                    .tint(NeumorphicTheme.cyanPulse)
            }
            .padding(18)
            .neumorphicCard(cornerRadius: 20)

            // Live BMI Calculation Pill
            let hM = heightCm / 100.0
            let bmiVal = weightKg / (hM * hM)
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .foregroundStyle(NeumorphicTheme.primaryOrange)
                Text("Current BMI:")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.textSecondary)
                Text(String(format: "%.1f", bmiVal))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.textPrimary)
                Spacer()
                Text(bmiVal >= 25.0 ? "Athletic Build" : "Standard")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.emeraldGreen)
            }
            .padding(12)
            .neumorphicConcave(cornerRadius: 14)
        }
    }

    // MARK: - Step 3: Years in Gym
    private var gymExperienceStepView: some View {
        VStack(spacing: 20) {
            aiCoachSpeechBubble(
                title: "Gym Experience Level",
                message: "How many years have you been consistently lifting? This dictates your systemic recovery capacity, optimal set volume, and split complexity."
            )

            VStack(spacing: 16) {
                Text("YEARS LIFTING IN THE GYM")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.textMuted)
                    .tracking(1.2)

                HStack(alignment: .lastTextBaseline, spacing: 6) {
                    if yearsInGym < 1.0 {
                        let months = max(1, Int(yearsInGym * 12))
                        Text("\(months)")
                            .font(.system(size: 52, weight: .bold, design: .rounded))
                            .foregroundStyle(NeumorphicTheme.purplePower)
                        Text(months == 1 ? "month" : "months")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(NeumorphicTheme.textSecondary)
                    } else {
                        Text(String(format: "%.1f", yearsInGym))
                            .font(.system(size: 52, weight: .bold, design: .rounded))
                            .foregroundStyle(NeumorphicTheme.purplePower)
                        Text(yearsInGym == 1.0 ? "year" : "years")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(NeumorphicTheme.textSecondary)
                    }
                }

                // Quick preset cards
                VStack(spacing: 10) {
                    experiencePresetRow(
                        title: "Beginner / Novice (< 1 year)",
                        subtitle: "Focus on linear compound progression & mechanics",
                        years: 0.5,
                        icon: "leaf.fill",
                        color: NeumorphicTheme.cyanPulse
                    )

                    experiencePresetRow(
                        title: "Dedicated Lifter (1 – 2 years)",
                        subtitle: "Solid base, mastering muscle isolation & consistency",
                        years: 1.5,
                        icon: "bolt.fill",
                        color: NeumorphicTheme.primaryOrange
                    )

                    experiencePresetRow(
                        title: "Intermediate Athlete (2 – 4 years)",
                        subtitle: "Hypertrophy periodization, progressive overload",
                        years: 3.0,
                        icon: "trophy.fill",
                        color: NeumorphicTheme.purplePower
                    )

                    experiencePresetRow(
                        title: "Advanced / Veteran (5+ years)",
                        subtitle: "High mechanical tension, RPE auto-regulation",
                        years: 5.0,
                        icon: "crown.fill",
                        color: NeumorphicTheme.emeraldGreen
                    )
                }

                // Fine-tuning slider
                VStack(alignment: .leading, spacing: 6) {
                    Text("Fine-tune exact years:")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(NeumorphicTheme.textMuted)

                    Slider(value: $yearsInGym, in: 0.1...12.0, step: 0.25)
                        .tint(NeumorphicTheme.purplePower)
                }
                .padding(.top, 8)
            }
            .padding(18)
            .neumorphicCard(cornerRadius: 20)
        }
    }

    private func experiencePresetRow(title: String, subtitle: String, years: Double, icon: String, color: Color) -> some View {
        let isSelected = abs(yearsInGym - years) <= 0.75

        return Button {
            yearsInGym = years
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundStyle(color)
                    .frame(width: 32, height: 32)
                    .background(color.opacity(0.15))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(isSelected ? NeumorphicTheme.primaryOrange : NeumorphicTheme.textPrimary)

                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(NeumorphicTheme.textSecondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(NeumorphicTheme.primaryOrange)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? NeumorphicTheme.darkSurface : NeumorphicTheme.background)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Step 4: Primary Goal
    private var goalStepView: some View {
        VStack(spacing: 20) {
            aiCoachSpeechBubble(
                title: "Primary Objective",
                message: "What is your main gym focus right now? I will tune your recommended training split and caloric surplus or deficit around this."
            )

            VStack(spacing: 12) {
                ForEach(FitnessGoal.allCases) { goal in
                    let isSelected = (selectedGoal == goal)

                    Button {
                        selectedGoal = goal
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: goal.icon)
                                .font(.title3)
                                .foregroundStyle(isSelected ? Color.white : NeumorphicTheme.primaryOrange)
                                .frame(width: 44, height: 44)
                                .background(isSelected ? NeumorphicTheme.primaryOrange : NeumorphicTheme.darkSurface)
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(goal.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(NeumorphicTheme.textPrimary)

                                Text(goal.shortTagline)
                                    .font(.caption2)
                                    .foregroundStyle(NeumorphicTheme.textSecondary)
                            }

                            Spacer()

                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(NeumorphicTheme.primaryOrange)
                            }
                        }
                        .padding(14)
                        .neumorphicCard(cornerRadius: 18)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Step 5: AI Analyzing
    private var aiAnalyzingStepView: some View {
        VStack(spacing: 28) {
            Spacer().frame(height: 40)

            ZStack {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [NeumorphicTheme.primaryOrange, NeumorphicTheme.cyanPulse],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 100, height: 100)

                Image(systemName: "brain.head.profile")
                    .font(.system(size: 44))
                    .foregroundStyle(NeumorphicTheme.primaryOrange)
            }

            VStack(spacing: 8) {
                Text("FitGit AI Computing...")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.textPrimary)

                Text(aiAnalysisStatusText)
                    .font(.subheadline)
                    .foregroundStyle(NeumorphicTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }

            ProgressView()
                .scaleEffect(1.2)
                .tint(NeumorphicTheme.primaryOrange)

            Spacer().frame(height: 40)
        }
        .padding(24)
        .neumorphicCard(cornerRadius: 24)
    }

    // MARK: - Step 6: AI Profile Result View
    private func aiResultStepView(profile: UserProfile) -> some View {
        VStack(spacing: 20) {
            // Header Badge
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundStyle(NeumorphicTheme.primaryOrange)
                Text("AI ATHLETE PROFILE GENERATED")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.primaryOrange)
                    .tracking(1.5)
            }

            // Athlete Hero Card
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [NeumorphicTheme.primaryOrange, NeumorphicTheme.emeraldGreen],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 64, height: 64)

                        Text(profile.initials)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(profile.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(NeumorphicTheme.textPrimary)

                        Text("@\(profile.username) • \(profile.athleteTier.rawValue)")
                            .font(.caption)
                            .foregroundStyle(NeumorphicTheme.textSecondary)

                        HStack(spacing: 6) {
                            Text(profile.experienceFormatted)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.primaryOrange)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(NeumorphicTheme.darkSurface)
                                .clipShape(Capsule())

                            Text(profile.fitnessGoal.shortTagline)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(NeumorphicTheme.cyanPulse)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(NeumorphicTheme.darkSurface)
                                .clipShape(Capsule())
                        }
                    }
                    Spacer()
                }
            }
            .padding(18)
            .neumorphicCard(cornerRadius: 22)

            // Synthesized Metrics Grid
            VStack(alignment: .leading, spacing: 12) {
                Text("OPTIMIZED BIOMETRICS & TARGETS")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.textMuted)
                    .tracking(1.2)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    metricStatCard(
                        title: "Daily Calories",
                        value: "\(profile.targetCalories) kcal",
                        subtitle: "\(profile.maintenanceCalories) maintenance",
                        icon: "flame.fill",
                        color: NeumorphicTheme.primaryOrange
                    )

                    metricStatCard(
                        title: "Daily Protein",
                        value: "\(profile.dailyProteinGrams) g",
                        subtitle: "1.5x body weight target",
                        icon: "fork.knife",
                        color: NeumorphicTheme.emeraldGreen
                    )

                    metricStatCard(
                        title: "Body Stature",
                        value: "\(profile.weightKg.formatted()) kg",
                        subtitle: "\(Int(profile.heightCm)) cm (BMI \(profile.bmi))",
                        icon: "scalemass.fill",
                        color: NeumorphicTheme.cyanPulse
                    )

                    metricStatCard(
                        title: "Athlete Tier",
                        value: profile.athleteTier.rawValue,
                        subtitle: profile.experienceFormatted,
                        icon: profile.athleteTier.icon,
                        color: profile.athleteTier.badgeColor
                    )
                }
            }

            // Recommended Training Split
            VStack(alignment: .leading, spacing: 10) {
                Text("AI RECOMMENDED SPLIT")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.textMuted)
                    .tracking(1.2)

                HStack(spacing: 12) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.title2)
                        .foregroundStyle(NeumorphicTheme.purplePower)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(profile.recommendedSplit)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(NeumorphicTheme.textPrimary)

                        Text(profile.weeklyVolumeGuideline)
                            .font(.caption2)
                            .foregroundStyle(NeumorphicTheme.textSecondary)
                    }
                    Spacer()
                }
                .padding(14)
                .neumorphicCard(cornerRadius: 18)
            }

            // Action Buttons
            VStack(spacing: 12) {
                Button {
                    applyGeneratedProfile()
                } label: {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                        Text("Apply to Profile in Settings")
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [NeumorphicTheme.primaryOrange, Color.orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: NeumorphicTheme.primaryOrange.opacity(0.4), radius: 8, y: 4)
                }

                Button {
                    currentStep = 0
                } label: {
                    Text("Adjust Inputs & Re-run")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(NeumorphicTheme.textSecondary)
                }
            }
            .padding(.top, 8)
        }
    }

    private func metricStatCard(title: String, value: String, subtitle: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(color)
                Spacer()
            }

            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(NeumorphicTheme.textPrimary)

            Text(title)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(NeumorphicTheme.textMuted)

            Text(subtitle)
                .font(.system(size: 9))
                .foregroundStyle(NeumorphicTheme.textSecondary)
                .lineLimit(1)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .neumorphicCard(cornerRadius: 16)
    }

    // MARK: - Bottom Navigation Controls
    private var bottomNavigationControls: some View {
        HStack(spacing: 14) {
            if currentStep > 0 {
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        currentStep -= 1
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.textPrimary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                }
                .neumorphicButton(cornerRadius: 14)
            }

            Button {
                handleNextStep()
            } label: {
                HStack(spacing: 6) {
                    Text(currentStep == 4 ? "Generate with AI" : "Continue")
                    Image(systemName: currentStep == 4 ? "sparkles" : "chevron.right")
                }
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [NeumorphicTheme.primaryOrange, Color.orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: NeumorphicTheme.primaryOrange.opacity(0.35), radius: 6, y: 3)
            }
        }
    }

    private func handleNextStep() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        if currentStep < 4 {
            withAnimation(.easeInOut(duration: 0.25)) {
                currentStep += 1
            }
        } else if currentStep == 4 {
            // Trigger AI Analysis
            withAnimation(.easeInOut(duration: 0.25)) {
                currentStep = 5
            }

            runAIAnalysisSimulation()
        }
    }

    private func runAIAnalysisSimulation() {
        isAnalyzing = true
        aiAnalysisStatusText = "Analyzing metabolic rate and TDEE..."

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            aiAnalysisStatusText = "Evaluating \(yearsInGym < 1.0 ? "novice" : "progressive") volume capacity..."
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            aiAnalysisStatusText = "Synthesizing optimal split and protein ratio..."
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            let synthesized = profileStore.generateProfileWithAI(
                name: name,
                username: username,
                age: age,
                weightKg: weightKg,
                heightCm: heightCm,
                yearsInGym: yearsInGym,
                goal: selectedGoal
            )
            self.generatedProfile = synthesized
            self.isAnalyzing = false

            UINotificationFeedbackGenerator().notificationOccurred(.success)
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep = 6
            }
        }
    }

    private func applyGeneratedProfile() {
        if let gen = generatedProfile {
            profileStore.saveProfile(gen)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            dismiss()
        }
    }

    // MARK: - Reusable AI Coach Speech Bubble
    private func aiCoachSpeechBubble(title: String, message: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(NeumorphicTheme.darkSurface)
                    .frame(width: 44, height: 44)

                Image(systemName: "sparkles")
                    .font(.headline)
                    .foregroundStyle(NeumorphicTheme.primaryOrange)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(NeumorphicTheme.textPrimary)

                Text(message)
                    .font(.footnote)
                    .foregroundStyle(NeumorphicTheme.textSecondary)
                    .lineSpacing(2)
            }
        }
        .padding(16)
        .neumorphicCard(cornerRadius: 18)
    }
}

