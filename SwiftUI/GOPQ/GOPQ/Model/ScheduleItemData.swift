//
//  ScheduleItemData.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import Foundation

struct ScheduleItemData {
    var startTimeHour: Int
    var startTimeMin: Int
    var endTimeHour: Int
    var endTimeMin: Int
    var location: String
    var message: String
    var soundName: String
    
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

