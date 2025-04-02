//
//  ScheduleItemData.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import Foundation

struct ScheduleItemData : Identifiable, Equatable{
    let id = UUID()
    var employeeName: String
    var startTimeHour: Int
    var startTimeMin: Int
    var endTimeHour: Int
    var endTimeMin: Int
    var location: String
    var message: String
    var soundName: String
    
    static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.id == rhs.id
        }
        
    func getStartTimeFormat() -> String {
        return "\(leadingZero(startTimeHour)):\(leadingZero(startTimeMin))"
    }
    func getEndTimeFormat() -> String {
        return "\(leadingZero(endTimeHour)):\(leadingZero(endTimeMin))"
    }
    
    private func leadingZero(_ num: Int) -> String {
        return String(format: "%02d", num)
    }
}

