//
//  CSVController.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 31/03/25.
//

import SwiftData
import SwiftUI

enum CSVParsingError: Error {  // sry saya malas++
    case parsingError(String)
}

@Model
class HashedScheduleList {
    var value: Int
    init(value: Int) {
        self.value = value
    }
}

@Observable
class CSVController {

    @MainActor
    func reset() {
        let context = ModelManager.shared.mainContext
        let descriptor = FetchDescriptor<HashedScheduleList>()
        do {
            let items = try context.fetch(descriptor)
            for item in items {
                context.delete(item)
            }
            try context.save()
        }
        catch {
            print("Failed to reset items : \(error.localizedDescription)")
        }
    }

    func checkForDuplicateImports(
        _ source: [ScheduleItemData], completion: @escaping (Bool, Int) -> Void
    ) {
        var hasher = Hasher()
        for schedule in source {
            hasher.combine(schedule.hashValue)
        }
        let allHashed = hasher.finalize()
        DispatchQueue.main.async {
            let context = ModelManager.shared.mainContext
            let descriptor = FetchDescriptor<HashedScheduleList>(
                // predicate: #Predicate { item in
                //     return item.value == allHashed
                // },
                sortBy: [
                    .init(\.value)
                ]
            )
            // descriptor.fetchLimit = 1
            // descriptor.includePendingChanges = true

            do {
                let result = try context.fetch(descriptor)
                print("found: \(result)")
                completion(!result.isEmpty, allHashed)
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }

    func handleFileImport(for result: Result<URL, Error>) -> [ScheduleItemData] {
        switch result {
        case .success(let url):
            print("File loaded: \(url.lastPathComponent)")

            var scheduleItems = [ScheduleItemData]()
            do {
                scheduleItems = try readFile(url)
                return scheduleItems
            } catch CSVParsingError.parsingError(let errorMsg) {
                print("CSVParsingError \(errorMsg)")
            } catch {
                print("unknown error: \(error.localizedDescription)")
            }

        case .failure(let error):
            print("Error loading file \(error)")
        }
        return []
    }

    func readFile(_ url: URL) throws -> [ScheduleItemData] {
        guard url.startAccessingSecurityScopedResource() else {
            throw CSVParsingError.parsingError("Failed trying to access \(url)")
        }

        defer { url.stopAccessingSecurityScopedResource() }

        let content = try String(contentsOf: url, encoding: .utf8)
        return parseCSV(content: content)
    }

    private func parseCSV(content: String) -> [ScheduleItemData] {
        var result = [ScheduleItemData]()
        let rows = content.components(separatedBy: "\n")

        for i in 1..<rows.count {  // ignore the first row, first row is for the title etc
            let trimmedRow = rows[i].trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedRow.isEmpty else { continue }

            let columns = trimmedRow.components(separatedBy: ";")
            guard columns.count >= 7 else {
                print("Invalid row: \(trimmedRow)")
                continue
            }

            let schedule = ScheduleItemData(  // jujur gw males error handling etc, ntr aja lah ya
                employeeName: columns[0].trimmingCharacters(in: .whitespaces),
                startTime: makeTime(hour: Int(columns[1]) ?? 0, min: Int(columns[2]) ?? 0),
                endTime: makeTime(hour: Int(columns[3]) ?? 0, min: Int(columns[4]) ?? 0),
                location: columns[5].trimmingCharacters(in: .whitespaces),
                message: columns[6].trimmingCharacters(in: .whitespaces),
                soundName: "System Default"
            )
            result.append(schedule)
            print("Successfully parsed: \(schedule)")
        }
        return result
    }

}
