//
//  ScheduleItemData.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import Foundation

struct ScheduleItemData: Identifiable{
    var id = UUID();
    let startTimeHour: Int
    let startTimeMin: Int
    let endTimeHour: Int
    let endTimeMin: Int
    let location: String
    let message: String
    let soundName: String
    
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

