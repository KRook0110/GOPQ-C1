//
//  ScheduleItemData.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import Foundation
import SwiftData
import EventKit

@Model
class ScheduleItemData : Identifiable{
    var id: UUID
    var employeeName: String
    var startTime: Date
    var endTime: Date
    var location: String
    var message: String
    var soundName: String
    var eventID: String = ""
    
    init(employeeName: String, startTime: Date, endTime: Date, location: String, message: String, soundName: String) {
        self.id = UUID()
        self.employeeName = employeeName
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
        self.message = message
        self.soundName = soundName
        
    }
    
    func getStartTimeFormat() -> String {
        return formatDate(startTime)
    }
    func getEndTimeFormat() -> String {
        return formatDate(endTime)
    }
    
    private func formatDate(_ date: Date ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
}

func makeTime(hour: Int, min: Int ) -> Date {
    var componenents = Calendar.current.dateComponents([.year,.month,.day],from: Date())
    componenents.hour = hour
    componenents.minute = min
    if let finaldate = Calendar.current.date(from: componenents) {
        return finaldate
    }
    return Calendar.current.startOfDay(for: Date())
}

extension Date {
    static var notSet: Date {
        Calendar.current.date(from: DateComponents(year: 1970, month: 1, day: 1))!
    }
}

extension ScheduleItemData {
    static var empty: ScheduleItemData {
        ScheduleItemData(
            employeeName: "",
            startTime: .notSet,
            endTime: .notSet,
            location: "",
            message: "",
            soundName: ""
        )
    }
}


