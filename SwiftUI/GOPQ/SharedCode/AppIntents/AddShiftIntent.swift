//
//  AddShiftIntent.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 30/04/25.
//

import AppIntents
import Foundation
#if os(iOS)
import SwiftData
#endif

#if os(watchOS)
import WatchConnectivity
#endif

struct AddShiftIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Shift"
    static var description = IntentDescription("Add a new shift to your schedule.")
    
    @Parameter(title: "Start Time")
    var startTime: Date
    
    @Parameter(title: "End Time")
    var endTime: Date
    
    @Parameter(title: "Location")
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
        
#if os(iOS)
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
            WatchConnector.shared.sendDataToWatch()
            
            // Kirim notifikasi untuk update UI
            NotificationCenter.default.post(name: Notification.Name("ScheduleDataUpdated"), object: nil)
        }
#elseif os(watchOS)
        print("Test intent")
        if WCSession.isSupported() {
            let session = WCSession.default
            session.activate()
            let payload: [String:Any] = [
                "type": "addCalendarEvent",
                "startDate": startTime.timeIntervalSince1970,
                "endDate":   endTime.timeIntervalSince1970,
                "location":  location,
                "employeeName": employeeName,
                "message":      message,
                "soundName":    soundName,
                "alertOffset":  alertOffset
            ]
            session.transferUserInfo(payload)
        }
#endif
        
        // Format tanggal untuk dialog
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let start = formatter.string(from: startTime)
        let end = formatter.string(from: endTime)
        
        // Return dialog (karena pakai ProvidesDialog)
        return .result(dialog: "Shift scheduled from \(start) to \(end) at \(location).")
    }
}

