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
                "Add my next shift in \(.applicationName)",
                "Add schedule using \(.applicationName)",
                "Schedule a new shift in \(.applicationName)",
                "New shift in \(.applicationName)",
                "Create work schedule in \(.applicationName)"
            ],
            shortTitle: LocalizedStringResource("Add Shift", comment: "Short title for adding a shift"),
            systemImageName: "calendar.badge.plus"
        )
        AppShortcut(
            intent: DeleteLastShiftIntent(),
            phrases: [
                "Delete last shift in \(.applicationName)",
                "Remove recent shift in \(.applicationName)",
                "Cancel my last schedule in \(.applicationName)",
                "Delete recent work schedule in \(.applicationName)"
            ],
            shortTitle: LocalizedStringResource("Delete Shift", comment: "Short title for deleting a shift"),
            systemImageName: "calendar.badge.minus"
        )
    }
}

