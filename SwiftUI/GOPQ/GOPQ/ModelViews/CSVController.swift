//
//  CSVController.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 31/03/25.
//

import SwiftUI

class CSVController:ObservableObject{
    
    @Published var content: String = ""
    @Published var schedules: [ScheduleItemData] = []
    
    func handleFileImport (for result: Result<URL, Error>){
        switch result {
        case .success(let url):
            print("File loaded: \(url.lastPathComponent)")
            readFile(url)
           
        case .failure(let error):
            print("Error loading file \(error)")
        }
    }
    
    func readFile(_ url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            print("Failed acces resources")
            return
        }
        
        defer { url.stopAccessingSecurityScopedResource() }
        
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            self.schedules = parseCSV(content: content)
            self.content = content
            print("File import suceed:")
            print(content)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
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
