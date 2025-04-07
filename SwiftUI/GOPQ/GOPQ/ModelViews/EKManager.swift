//
//  EKManager.swift
//  GOPQ
//
//  Created by Shawn Andrew on 07/04/25.
//

import Foundation
import EventKit

@Observable
class EKManager {
    
    var showAlert: Bool = false
    var permissionGranted = false
    let store = EKEventStore()
    var calendar: EKCalendar = EKCalendar()
    
    init() {
        store.requestFullAccessToEvents { granted, err in
            self.permissionGranted = granted
            if !granted {
                self.showAlert = true
                return
            }
        }
        
        let calendarID = UserDefaults.standard.string(forKey: "calendar") ?? ""
        if calendarID.isEmpty  {
            self.calendar = EKCalendar(for: .event, eventStore: store)
            guard (try? store.saveCalendar(calendar, commit: true)) != nil else {
                print("❌ Save Calendar Failed")
                return
            }
        }
        else {
            if let foundCalendar = store.calendar(withIdentifier: calendarID) {
                calendar = foundCalendar
            }
            else {
                guard (try? store.saveCalendar(calendar, commit: true)) != nil else {
                    print("❌ Save Calendar Failed")
                    return
                }
            }
        }
    }
    
    func publishToCalendar(_ schedules: [ScheduleItemData]) {
        
        for schedule in schedules {
            syncEventToSchedule(schedule)}
        
    }
    func syncEventToSchedule(_ schedule: ScheduleItemData)  {
        let newevent = EKEvent(eventStore: store)
        newevent.title = schedule.location
        newevent.notes = schedule.message
        newevent.startDate = schedule.startTime
        newevent.endDate = schedule.endTime
        newevent.calendar = store.defaultCalendarForNewEvents
        do {
            try store.save(newevent, span: .thisEvent, commit: true)
        }
        catch {
            print("Failed to save event : \(error)")
        }
    }
    
}
