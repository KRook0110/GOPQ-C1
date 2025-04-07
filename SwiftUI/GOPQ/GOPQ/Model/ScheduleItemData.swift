//
//  ScheduleItemData.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import Foundation

struct ScheduleItemData : Identifiable{
    let id = UUID()
    var employeeName: String
    var startTime: Date
    var endTime: Date
    var location: String
    var message: String
    var soundName: String
    
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

