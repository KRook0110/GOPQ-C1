//
//  AppShortcutProviders.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 30/04/25.
//

import AppIntents

struct AppShortcutProviders: AppShortcutsProvider {
    
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddShiftIntent(),
            phrases: [
                "Add New shift in \(.applicationName)",
                "Schedule a new shift in \(.applicationName)",
                "New shift in \(.applicationName)",
                "Create New shift in \(.applicationName)",
                "Create reminder in \(.applicationName)",
                "Tambah shift baru di \(.applicationName)",
                "Buat shift baru di \(.applicationName)"
            ],
            shortTitle: LocalizedStringResource("Add Shift", comment: "Short title for adding a shift"),
            systemImageName: "calendar.badge.plus"
        )
    }
}

