//
//  MainTabView.swift
//  FitGit
//

import SwiftUI

public enum MainTab: String, CaseIterable, Identifiable {
    case today = "Today"
    case split = "Split"
    case routines = "Routines"
    case exercises = "Exercises"
    case settings = "Settings"

    public var id: String { rawValue }

    public var iconName: String {
        switch self {
        case .today: return "flame.fill"
        case .split: return "calendar.badge.clock"
        case .routines: return "square.stack.3d.up.fill"
        case .exercises: return "dumbbell.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

public struct MainTabView: View {
    @State private var selectedTab: MainTab = .today

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            // Screen Contents
            Group {
                switch selectedTab {
                case .today:
                    TodaySplitView()
                case .split:
                    WeeklySplitPlannerView()
                case .routines:
                    RoutinesView()
                case .exercises:
                    ExerciseLibraryView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom Neumorphic Bottom Tab Bar
            HStack(spacing: 0) {
                ForEach(MainTab.allCases) { tab in
                    let isSelected = (selectedTab == tab)

                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            selectedTab = tab
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.iconName)
                                .font(.system(size: isSelected ? 20 : 18, weight: .bold))
                                .foregroundStyle(isSelected ? NeumorphicTheme.primaryOrange : NeumorphicTheme.textMuted)

                            Text(tab.rawValue)
                                .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                                .foregroundStyle(isSelected ? NeumorphicTheme.primaryOrange : NeumorphicTheme.textMuted)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            isSelected ?
                            RoundedRectangle(cornerRadius: 12)
                                .fill(NeumorphicTheme.background)
                                .shadow(color: NeumorphicTheme.insetLight, radius: 2, x: 2, y: 2)
                                .shadow(color: NeumorphicTheme.insetDark, radius: 2, x: -2, y: -2)
                            : nil
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(NeumorphicTheme.background)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: NeumorphicTheme.lightShadow, radius: 6, x: -3, y: -4)
            .shadow(color: NeumorphicTheme.darkShadow, radius: 6, x: 3, y: 4)
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .background(NeumorphicTheme.background.ignoresSafeArea())
    }
}
