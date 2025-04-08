//
//  EKManager.swift
//  GOPQ
//
//  Created by Shawn Andrew on 07/04/25.
//

import Foundation
import EventKit
import UIKit

@Observable
class EKManager {
    
    var showAlert: Bool = false
    var permissionGranted = false
    let store = EKEventStore()
    var calendar: EKCalendar
    
    init() {
        
        calendar = store.defaultCalendarForNewEvents! // saya bingung sendiri sama sourcenya
        // belom handle kalau tidak ada default Calendar, saat membuat calendar bingung pilih sourcenya...
        store.requestFullAccessToEvents { granted, err in
            self.permissionGranted = granted
            if !granted {
                self.showAlert = true
                return
            }
        }
        
        
    }
    
    // returns event identifier
    func syncEvent(_ schedule: ScheduleItemData) {
        
        var targetevent: EKEvent
        if let event = store.event(withIdentifier: schedule.eventID), !schedule.eventID.isEmpty {
            targetevent = event
        }
        else { // create new event
            targetevent = EKEvent(eventStore: store)
        }
        
        targetevent.location = schedule.location
        targetevent.title = schedule.message
        targetevent.notes = "This is a gopq auto generated event"
        targetevent.startDate = schedule.startTime
        targetevent.endDate = schedule.endTime
        targetevent.calendar = store.defaultCalendarForNewEvents
//        print("before : ", targetevent.eventIdentifier ?? "nil")
        do {
            try store.save(targetevent, span: .thisEvent, commit: true)
        }
        catch {
            print("Failed to save event : \(error)")
        }
//        print("after : ", targetevent.eventIdentifier ?? "nil")
        schedule.eventID = targetevent.eventIdentifier ?? ""
    }
    
    func removeEvent(_ schedule: ScheduleItemData) {
        if let event = store.event(withIdentifier: schedule.eventID), !schedule.eventID.isEmpty {
            do {
                try store.remove(event, span: .thisEvent)
                print("remove event successful \(event.title ?? "no title") ")
            }
            catch {
                print("failed to remove event : \(error)")
            }
        }
        else {
            print("no event found")
        }
    }
    
}
