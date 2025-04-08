//
//  EKManager.swift
//  GOPQ
//
//  Created by Shawn Andrew on 07/04/25.
//

import Foundation
import EventKit
import UIKit

enum CalendarError: Error {
    case CError(String)
}

@Observable
class EKManager {
    
    var showAlert: Bool = false
    var alertMessage: String = ""
    var permissionGranted = false
    let store = EKEventStore()
    var calendar: EKCalendar! // this will crash T-T tapi udah keburu buru sorry ges
    
    let calendarIDKey = "calendar_id"
    
    init() {
        
        do {
            calendar = try getCalendar() // saya bingung sendiri sama sourcenya
        } catch CalendarError.CError(let errorMsg) {
            alertMessage = "\(errorMsg)"
            showAlert = true
        }
        catch {
            print("error: \(error)" )
        }
        // belom handle kalau tidak ada default Calendar, saat membuat calendar bingung pilih sourcenya...
        store.requestFullAccessToEvents { granted, err in
            self.permissionGranted = granted
            if !granted {
                self.alertMessage = "Tolong kasih permissions untuk access calendar anda"
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
        while let alarm = targetevent.alarms?.last {
            targetevent.removeAlarm(alarm)
        }
        targetevent.addAlarm(EKAlarm(relativeOffset: Double(schedule.alertOffset * 60)))
//        print("before : ", targetevent.eventIdentifier ?? "nil")
        do {
            try store.save(targetevent, span: .thisEvent, commit: true)
        }
        catch {
            alertMessage = "Failed to save event: \(error)"
            showAlert = true
            print("Failed to save event : \(error)")
        }
//        print("after : ", targetevent.eventIdentifier ?? "nil")
        schedule.eventID = targetevent.eventIdentifier ?? ""
    }
    
    
    func createGOPQCalendar() -> EKCalendar {
        let newCalendar = EKCalendar(for: .event, eventStore: store)
        let source = findBestSource()
        newCalendar.title = "GOPQ Calendar"
        newCalendar.source = source
        newCalendar.cgColor = CGColor(gray: 0.5, alpha: 1.0)
        
        return newCalendar
    }
    func getCalendar() throws -> EKCalendar {
        if let unwrappedCalendar = store.defaultCalendarForNewEvents {
            return unwrappedCalendar
        }
        
        if let foundCalendarID = UserDefaults.standard.string(forKey: calendarIDKey) {
            if let foundCalendar = store.calendar(withIdentifier: foundCalendarID)  {
                return foundCalendar
            }
            UserDefaults.standard.removeObject(forKey : calendarIDKey)
        }
        
        let newCalendar = createGOPQCalendar()
        do {
            try store.saveCalendar(newCalendar, commit : true)
        } catch {
            throw CalendarError.CError("couldn't make calendar \(error.localizedDescription)")
        }
        return  newCalendar
    }
    
    func findBestSource()-> EKSource {
        if let iCloudSource  = store.sources.first(where: {$0.sourceType == .calDAV}) {
            return iCloudSource
        }
        if let local = store.sources.first(where: {$0.sourceType == .local}) {
            return local
        }
        if let firstSource = store.sources.first {
            
        }
        alertMessage = "Calendar tidak ada source"
        showAlert = true
        return EKSource() // jujur ini kek jelek bgt cmn kek aku udah males hehe (this will def crash the app)
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
