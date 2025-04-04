//
//  ScheduleDataController.swift
//  GOPQ
//
//  Created by Shawn Andrew on 26/03/25.
//

import SwiftUI

@Observable class ScheduleController {
    var data: [ScheduleItemData]
    
    init() {
        self.data = []
    }
    
    init(_ source: [ScheduleItemData]) {
        self.data = []
        self.set(source)
    }
    
    func set(_ source: [ScheduleItemData]) {
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
    
    
    func update(target: ScheduleItemData) {
        if let i = data.firstIndex(where: { $0.id == target.id }) {
            data[i] = target
            data.sort(by: { lhs, rhs in
                compare(lhs, rhs)
            })
        }
    }
    
    func remove(id: UUID) {
        data.removeAll(where: { $0.id == id})
    }
    
}

