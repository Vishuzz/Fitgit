//
//  MainTabView.swift
//  FitGit
//

import SwiftUI

public struct MainTabView: View {
    public init() {}

    public var body: some View {
        TabView {
            WorkoutListView()
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell.fill")
                }

            AnalyticsDashboardView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.xaxis")
                }
        }
    }
}

#Preview {
    MainTabView()
        .environment(\.managedObjectContext, PersistenceController.preview.viewContext)
}
