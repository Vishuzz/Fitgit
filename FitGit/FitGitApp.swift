//
//  FitGitApp.swift
//  FitGit
//

import SwiftUI
import CoreData

@main
struct FitGitApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
