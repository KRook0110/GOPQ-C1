//
//  ScheduleDataController.swift
//  GOPQ
//
//  Created by Shawn Andrew on 26/03/25.
//

import SwiftUI

@Observable class ObservableScheduleList {
    var data: [ScheduleItemData]
    
    init() {
        self.data = []
    }
    
    init(_ source: [ScheduleItemData]) {
        self.data = source
        self.data.sort { (lhs, rhs) -> Bool in
            compare(lhs, rhs)
        }
    }
    
    func compare(_ lhs:ScheduleItemData, _ rhs:ScheduleItemData) -> Bool {
        if lhs.startTimeHour != rhs.startTimeHour{
            return lhs.startTimeHour < rhs.startTimeHour
        }
        return lhs.startTimeMin < rhs.startTimeMin
    }
    
    func insert(_ item:ScheduleItemData) { // fucking slow when adding many values, sorry guys
        for i in 0..<data.count {
            if !compare(data[i], item ) {
                data.insert(item, at: i)
                return
            }
        }
        data.append(item)
        return
    }
    
    
    func replace(with source:ScheduleItemData,  at index: Int) {
        data.remove(at: index)
        insert(source)
//        data.append(source)
//        data.sort(by: { lhs, rhs in
//            compare(lhs, rhs)
//        })
    }
    
}

