//
//  CSVController.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 31/03/25.
//

import SwiftUI
enum CSVParsingError:  Error { // sry saya malas++
    case parsingError(String)
}

@Observable
class CSVController{
    
    func handleFileImport (for result: Result<URL, Error>) -> [ScheduleItemData] {
        switch result {
        case .success(let url):
            print("File loaded: \(url.lastPathComponent)")
            do {
                return try readFile(url)
            } catch CSVParsingError.parsingError(let errorMsg) {
                print(errorMsg)
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
        
        for row in rows {
            let trimmedRow = row.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedRow.isEmpty else { continue }
            
            let columns = trimmedRow.components(separatedBy: ";")
            guard columns.count >= 7 else {
                print("Invalid row: \(trimmedRow)")
                continue
            }
            
            let schedule = ScheduleItemData(
                employeeName: columns[0].trimmingCharacters(in: .whitespaces),
                startTimeHour: Int(columns[1]) ?? 0,
                startTimeMin: Int(columns[2]) ?? 0,
                endTimeHour: Int(columns[3]) ?? 0,
                endTimeMin: Int(columns[4]) ?? 0,
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
