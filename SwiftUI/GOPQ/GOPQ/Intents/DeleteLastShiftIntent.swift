//
//  DeleteLastShiftIntent.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 30/04/25.
//

import AppIntents
import Foundation
import SwiftData

struct DeleteLastShiftIntent: AppIntent {
    static var title: LocalizedStringResource = "Delete Last Shift"
    static var description = IntentDescription("Delete the most recently added shift from your schedule.")

    @MainActor
    func perform() async throws -> some IntentResult {
        let controller = ScheduleController()

        // Ambil data terurut dari SwiftData
        let context = ModelManager.shared.mainContext
        let results = (try? context.fetch(FetchDescriptor<ScheduleItemData>())) ?? []

        guard let lastShift = results.sorted(by: { $0.startTime < $1.startTime }).last else {
            return .result(dialog: "No shifts found to delete.")
        }

        // Hapus dari context
        context.delete(lastShift)

        do {
            try context.save()
            return .result(dialog: "Last shift has been deleted.")
        } catch {
            return .result(dialog: "Failed to delete last shift.")
        }
    }
}
