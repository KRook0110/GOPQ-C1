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
    var calendar: EKCalendar?
    
    let calendarIDKey = "calendar_id"
    
    init() { }
    
    // returns event identifier
    func syncEvent(_ schedule: ScheduleItemData) {
        requestAccess {
            if !self.permissionGranted {
                return
            }
            
            var targetevent: EKEvent
            if let event = self.store.event(withIdentifier: schedule.eventID), !schedule.eventID.isEmpty {
                targetevent = event
            }
            else { // create new event
                targetevent = EKEvent(eventStore: self.store)
            }
            
            targetevent.location = schedule.location
            targetevent.title = schedule.message
            targetevent.notes = "This is a gopq auto generated event"
            targetevent.startDate = schedule.startTime
            targetevent.endDate = schedule.endTime
            targetevent.calendar = self.calendar
            while let alarm = targetevent.alarms?.last {
                targetevent.removeAlarm(alarm)
            }
            if let offset = schedule.alertOffset{
                targetevent.addAlarm(EKAlarm(relativeOffset: Double( -offset * 60)))
            }
            //        print("before : ", targetevent.eventIdentifier ?? "nil")
            do {
                try self.store.save(targetevent, span: .thisEvent, commit: true)
            }
            catch {
                self.alertUser("Failed to save event: \(error.localizedDescription)")
                print("Failed to save event : \(error)")
            }
            //        print("after : ", targetevent.eventIdentifier ?? "nil")
            schedule.eventID = targetevent.eventIdentifier ?? ""
        }
    }
    
    
    
    func requestAccess(_ targetClosure: @escaping () -> Void) {
        if permissionGranted {
            targetClosure()
            return 
        }
        store.requestFullAccessToEvents { granted, err in
            if !granted {
                self.alertUser("Tolong kasih permissions untuk access calendar anda")
                return
            }
            self.permissionGranted = granted
            if self.calendar == nil {
                self.setCalendar()
            }
            targetClosure()
        }
    }
    func setCalendar() {
        do {
            calendar = try getCalendar() // saya bingung sendiri sama sourcenya
            print("connected calendar = \(calendar?.title ?? "nil" )")
        } catch CalendarError.CError(let errorMsg) {
            alertUser("\(errorMsg)")
            return
        }
        catch {
            print("error: \(error)" )
            return
        }
        
        if let unwrappedCalendar = calendar {
            do {
                try store.saveCalendar(unwrappedCalendar, commit: true) // crash if calendar is not present
            }
            catch {
                alertUser("Failed to save calendar")
                return
            }
        }
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
        if let defaultSource = store.defaultCalendarForNewEvents?.source {
            return defaultSource
        }
        if let iCloudSource  = store.sources.first(where: {$0.sourceType == .calDAV}) {
            return iCloudSource
        }
        if let local = store.sources.first(where: {$0.sourceType == .local}) {
            return local
        }
        if let firstSource = store.sources.first {
            return firstSource
        }
        alertUser("Calendar tidak ada source")
        return EKSource() // jujur ini kek jelek bgt cmn kek aku udah males hehe (this will def crash the app)
    }
    func alertUser(_ msg: String) {
        alertMessage  = msg
        showAlert = true
    }
    
    func removeEvent(_ schedule: ScheduleItemData) {
        requestAccess {
            if let event = self.store.event(withIdentifier: schedule.eventID), !schedule.eventID.isEmpty {
                do {
                    try self.store.remove(event, span: .thisEvent)
                    print("remove event successful \(event.title ?? "no title") ")
                }
                catch {
                    self.alertUser("failed to remove event : \(error.localizedDescription)")
                    print("failed to remove event : \(error.localizedDescription)")
                }
            }
            else {
                self.alertUser("no event found")
                print("no event found")
            }
        }
    }
    
}
