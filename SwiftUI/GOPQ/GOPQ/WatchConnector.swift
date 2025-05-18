//
//  WatchConnector.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 06/05/25.
//

import Foundation
import WatchConnectivity

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject {
    
    static let shared = WatchConnector()
    var session: WCSession
    
    @Published var schedules: [ScheduleItemData] = []
    @Published var isReachable = false
    @Published var isConnected = false
    
#if os(iOS)
    @Published var isAppInstalled = false
#endif
    
    private override init() {
        self.session = WCSession.default
        super.init()
        
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
            print("iOS: WCSession activation initiated")
        }
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isConnected = activationState == .activated
            self.isReachable = session.isReachable
#if os(iOS)
            self.isAppInstalled = session.isWatchAppInstalled
#endif
            if self.isReachable { self.sendDataToWatch() }
        }
    }
    
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {

    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
#endif
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
            if self.isReachable { self.sendDataToWatch() }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("iOS: Received message without reply handler: \(message)")
        handleMessage(message)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("iOS: Received message with reply handler: \(message)")
        handleMessage(message, replyHandler: replyHandler)
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        guard let type = userInfo["type"] as? String,
              type == "addCalendarEvent",
              let start = userInfo["startDate"] as? TimeInterval,
              let end   = userInfo["endDate"]   as? TimeInterval,
              let loc   = userInfo["location"]  as? String
        else { return }
        
        Task {
            let newShift = ScheduleItemData(
                employeeName:    userInfo["employeeName"] as? String ?? "Self",
                startTime:       Date(timeIntervalSince1970: start),
                endTime:         Date(timeIntervalSince1970: end),
                location:        loc,
                message:         userInfo["message"] as? String ?? "GOPQ Alert",
                soundName:       userInfo["soundName"] as? String ?? ""
            )
            newShift.alertOffset = userInfo["alertOffset"] as? Int ?? 5
            
            // 1) Save into SwiftData
            let ctx = await ModelManager.shared.mainContext
            ctx.insert(newShift)
            try await ctx.save()
            
            // 2) Sync calendar & notify UI
            await ScheduleController.shared.ekmanager.syncEvent(newShift)
            NotificationCenter.default.post(name: .init("ScheduleDataUpdated"), object: nil)
            
            // 3) Push updated schedule back to watch
            sendDataToWatch()
        }
    }
    
    private func handleMessage(_ message: [String : Any], replyHandler: (([String : Any]) -> Void)? = nil) {
        guard let type = message["type"] as? String else {
            replyHandler?(["status": "error", "message": "Invalid message"])
            return
        }
        
        print("iOS: Handling message of type: \(type)")
        
        switch type {
        case "requestSchedules":
            handleScheduleRequest(replyHandler: replyHandler)
        case "addCalendarEvent":
            handleCalendarEvent(message, replyHandler: replyHandler)
        case "deleteSchedule":
            handleDeleteSchedule(message, replyHandler: replyHandler)
        case "ping":
            print("iOS: Received ping, sending pong")
            replyHandler?(["type": "pong"])
        default:
            print("iOS: Unknown message type: \(type)")
            replyHandler?(["status": "error", "message": "Unknown message type"])
        }
    }
    
    private func updateSessionState(_ session: WCSession) {
        isConnected = session.activationState == .activated
        isReachable = session.isReachable
        
#if os(iOS)
        isAppInstalled = session.isWatchAppInstalled
#endif
    }
    
    @MainActor
    func updateLocalSchedules() async {
        await ScheduleController.shared.refreshData()
        schedules = ScheduleController.shared.data
        print("iOS: Updated \(schedules.count) schedules")
    }
    
    func sendDataToWatch() {
        guard isReachable else {
            print("iOS: Watch not reachable")
            return
        }
        
        Task {
            await updateLocalSchedules()
            let payload = ["type": "scheduleUpdate", "schedules": convertSchedulesToDict()]
            
            do {
                try session.updateApplicationContext(payload)
                print("iOS: Sent \(schedules.count) items via context")
            } catch {
                print("iOS: Failed to update context: \(error.localizedDescription)")
                session.sendMessage(payload, replyHandler: { reply in
                    print("iOS: Message sent successfully with reply: \(reply)")
                }, errorHandler: { error in
                    print("iOS: Failed to send message: \(error.localizedDescription)")
                })
            }
        }
    }
    
    private func convertSchedulesToDict() -> [[String: Any]] {
        schedules.map {
            [
                "id": $0.id.uuidString,
                "employeeName": $0.employeeName,
                "startTime": $0.startTime.timeIntervalSince1970,
                "endTime": $0.endTime.timeIntervalSince1970,
                "location": $0.location,
                "message": $0.message ?? "",
                "soundName": $0.soundName ?? "",
                "alertOffset": $0.alertOffset ?? 0
            ]
        }
    }
    
    private func handleScheduleRequest(replyHandler: (([String : Any]) -> Void)?) {
        print("iOS: Handling schedule request")
        Task {
            await updateLocalSchedules()
            let response = [
                "status": "success",
                "schedules": convertSchedulesToDict()
            ]
            print("iOS: Sending \(schedules.count) schedules in response")
            replyHandler?(response)
        }
    }
    
    private func handleCalendarEvent(_ message: [String: Any], replyHandler: (([String : Any]) -> Void)?) {
        print("iOS: Handling calendar event request")
        guard let start = message["startDate"] as? TimeInterval,
              let end = message["endDate"] as? TimeInterval,
              let location = message["location"] as? String else {
            print("iOS: Invalid calendar event data")
            replyHandler?(["status": "error", "message": "Invalid event data"])
            return
        }
        
        let employeeName = message["employeeName"] as? String ?? "Self"
        let eventMessage = message["message"] as? String ?? "GOPQ Alert"
        let soundName = message["soundName"] as? String ?? ""
        let alertOffset = message["alertOffset"] as? Int ?? 5
        
        Task {
            do {
                try await createCalendarEvent(
                    start: Date(timeIntervalSince1970: start),
                    end: Date(timeIntervalSince1970: end),
                    location: location,
                    employeeName: employeeName,
                    message: eventMessage,
                    soundName: soundName,
                    alertOffset: alertOffset
                )
                print("iOS: Calendar event created successfully")
                replyHandler?(["status": "success", "message": "Event created successfully"])
                sendDataToWatch()
            } catch {
                print("iOS: Failed to create calendar event: \(error.localizedDescription)")
                replyHandler?(["status": "error", "message": error.localizedDescription])
            }
        }
    }
    
    private func handleDeleteSchedule(_ message: [String: Any], replyHandler: (([String : Any]) -> Void)?) {
        print("iOS: Handling delete schedule request")
        guard let scheduleId = message["scheduleId"] as? String,
              let uuid = UUID(uuidString: scheduleId) else {
            print("iOS: Invalid schedule ID")
            replyHandler?(["status": "error", "message": "Invalid schedule ID"])
            return
        }
        
        Task {
            await MainActor.run {
                let context = ModelManager.shared.mainContext
                
                // Find and delete the schedule with matching ID
                if let scheduleToDelete = schedules.first(where: { $0.id == uuid }) {
                    print("iOS: Found schedule to delete")
                    
                    // Remove from EventKit calendar
                    ScheduleController.shared.ekmanager.removeEvent(scheduleToDelete)
                    
                    context.delete(scheduleToDelete)
                    try? context.save()
                    
                    // Notify that data has changed
                    NotificationCenter.default.post(name: Notification.Name("ScheduleDataUpdated"), object: nil)
                    
                    // Send updated schedules back to watch
                    self.sendDataToWatch()
                    
                    replyHandler?(["status": "success", "message": "Schedule deleted"])
                } else {
                    print("iOS: Schedule not found with ID: \(scheduleId)")
                    replyHandler?(["status": "error", "message": "Schedule not found"])
                }
            }
        }
    }
    
    private func createCalendarEvent(
        start: Date,
        end: Date,
        location: String,
        employeeName: String,
        message: String,
        soundName: String,
        alertOffset: Int
    ) async throws {
        let context = await ModelManager.shared.mainContext
        let newEvent = ScheduleItemData(
            employeeName: employeeName,
            startTime: start,
            endTime: end,
            location: location,
            message: message,
            soundName: soundName
        )
        
        newEvent.alertOffset = alertOffset
        
        do {
            context.insert(newEvent)
            try await context.save()
            await ScheduleController.shared.ekmanager.syncEvent(newEvent)
            
            // Refresh local data after adding
            await updateLocalSchedules()
            
            // Send notification for UI update
            await MainActor.run {
                NotificationCenter.default.post(name: Notification.Name("ScheduleDataUpdated"), object: nil)
            }
        } catch {
            context.delete(newEvent)
            throw error
        }
    }
}
