//
//  ScheduleDataController.swift
//  GOPQ
//
//  Created by Shawn Andrew on 26/03/25.
//

import SwiftUI
import SwiftData

@MainActor
@Observable class ScheduleController {
    var data: [ScheduleItemData]
    var ekmanager = EKManager()
    
    init() {
        self.data = []
        let context = ModelManager.shared.mainContext
        let results = (try? context.fetch(FetchDescriptor<ScheduleItemData>())) ?? []
        self.set(results)
    }
    
    init(_ source: [ScheduleItemData]) {
        self.data = []
        self.set(source)
    }
    
    func set(_ source: [ScheduleItemData], name: String? = nil) {
        if let unwrappedName = name {
            self.data = source.filter {
                $0.employeeName == unwrappedName
            }
        }
        else {
            self.data = source
        }
        for schedule in data {
            ekmanager.syncEvent(schedule)
        }
        self.data.sort { (lhs, rhs) -> Bool in
            compare(lhs, rhs)
        }
    }
    
    func compare(_ lhs:ScheduleItemData, _ rhs:ScheduleItemData) -> Bool {
        return lhs.startTime < rhs.startTime
    }
    
    func insert(_ item:ScheduleItemData) { // fucking slow when adding many values, sorry guys
        ekmanager.syncEvent(item)
        
        for i in 0..<data.count {
            if !compare(data[i], item ) {
                data.insert(item, at: i)
                return
            }
        }
        data.append(item)
        return
    }
    
    
    func update(target: ScheduleItemData, resort: Bool = true) {
        if let i = data.firstIndex(where: { $0.id == target.id }) {
            data[i] = target
            if resort {
                data.sort(by: { lhs, rhs in
                    compare(lhs, rhs)
                })
            }
            ekmanager.syncEvent(data[i])
        }
    }
    
    func remove(id: UUID) {
        if let i = data.firstIndex(where: { $0.id == id }) {
            ekmanager.removeEvent(data[i])
        }
        data.removeAll(where: { $0.id == id})
    }
    
    
    func saveToSwiftData() {
        let context = ModelManager.shared.mainContext
        let descriptor = FetchDescriptor<ScheduleItemData>()
        
        do {
            let allItems = try context.fetch(descriptor)
            for item in allItems {
                context.delete(item)
            }
            for item in data {
                context.insert(item)
            }
            try context.save()
        } catch {
            print("Failed to batch insert: \(error)")
        }
    }
}

