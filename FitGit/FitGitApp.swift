//
//  FitGitApp.swift
//  FitGit
//

import SwiftUI
import CoreData

@main
struct FitGitApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        // Request or check local notification permissions on app launch
        NotificationManager.shared.checkAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
