//
//  AddShiftIntent.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 30/04/25.
//

import AppIntents
import Foundation
import SwiftData

struct AddShiftIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Shift"
    static var description = IntentDescription("Add a new shift to your schedule.")
    
    @Parameter(title: "Waktu Mulai")
    var startTime: Date
    
    @Parameter(title: "Waktu Selesai")
    var endTime: Date
    
    @Parameter(title: "Lokasi")
    var location: String
    
    @Parameter(title: "Employee Name", default: "Self")
    var employeeName: String
    
    @Parameter(title: "Message", default: "GOPQ Alert")
    var message: String
    
    @Parameter(title: "Sound Name", default: "")
    var soundName: String
    
    @Parameter(title: "Alert Minutes Before", default: 5)
    var alertOffset: Int
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        
        let newShift = ScheduleItemData(
            employeeName: employeeName,
            startTime: startTime,
            endTime: endTime,
            location: location,
            message: message,
            soundName: soundName
        )
        if alertOffset > 0 {
            newShift.alertOffset = alertOffset
        }
        
        await MainActor.run {
            
            let context = ModelManager.shared.mainContext
            context.insert(newShift)
            try? context.save()
            
            // sync kalender
            ScheduleController.shared.ekmanager.syncEvent(newShift)
            
            // Kirim notifikasi untuk update UI
            NotificationCenter.default.post(name: Notification.Name("ScheduleDataUpdated"), object: nil)
        }
        
        // Format tanggal untuk dialog
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let start = formatter.string(from: startTime)
        let end = formatter.string(from: endTime)
        
        // Return dialog (karena pakai ProvidesDialog)
        return .result(dialog: "Shift scheduled from \(start) to \(end) at \(location).")
    }
}

