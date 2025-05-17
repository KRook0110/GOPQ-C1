//
//  WatchConnector.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 06/05/25.
//

import Foundation
import WatchConnectivity

class WatchConnector: NSObject, WCSessionDelegate {
    
    static let shared = WatchConnector()
    var session: WCSession
    
    @Published var schedules: [ScheduleItemData] = []
    @Published var isReachable = false
    @Published var isConnected = false
    
    #if os(iOS)
    @Published var isAppInstalled = false
    #endif
    
    override init() {
        self.session = WCSession.default
        super.init()
        
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
            print("WCSession activation initiated")
        }
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session activation completed: \(activationState.rawValue)")
        DispatchQueue.main.async {
            self.updateSessionState(session)
            if self.isReachable {
                self.sendDataToWatch()
            }
        }
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Session deactivated - reactivating")
        session.activate()
    }
    #endif
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("Reachability changed: \(session.isReachable)")
        DispatchQueue.main.async {
            self.updateSessionState(session)
            if self.isReachable {
                self.sendDataToWatch()
            }
        }
    }
    
    // MARK: - Message Handling
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        handleMessage(message)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        handleMessage(message, replyHandler: replyHandler)
    }
    
    private func handleMessage(_ message: [String : Any], replyHandler: (([String : Any]) -> Void)? = nil) {
        guard let type = message["type"] as? String else {
            replyHandler?(["status": "error", "message": "Invalid message"])
            return
        }
        
        switch type {
        case "requestSchedules":
            handleScheduleRequest(replyHandler: replyHandler)
        case "addCalendarEvent":
            handleCalendarEvent(message, replyHandler: replyHandler)
        case "ping":
            replyHandler?(["type": "pong"])
        default:
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
        print("Updated \(schedules.count) schedules")
    }
    
    func sendDataToWatch() {
        guard isReachable else {
            print("Watch not reachable")
            return
        }
        
        Task {
            await updateLocalSchedules()
            let payload = ["schedules": convertSchedulesToDict()]
            
            do {
                try session.updateApplicationContext(payload)
                print("Sent \(payload.count) items via context")
            } catch {
                session.sendMessage(payload) { error in
                    error != nil ? print("Message failed") : print("Sent via message")
                }
            }
        }
    }
    
    private func convertSchedulesToDict() -> [[String: Any]] {
        schedules.map {
            [
                "id": $0.id.uuidString,
                "startTime": $0.startTime.timeIntervalSince1970,
                "endTime": $0.endTime.timeIntervalSince1970,
                "location": $0.location,
                "message": $0.message ?? "",
                "alertOffset": $0.alertOffset ?? 0
            ]
        }
    }
        
    private func handleScheduleRequest(replyHandler: (([String : Any]) -> Void)?) {
        Task {
            await updateLocalSchedules()
            replyHandler?([
                "status": "success",
                "schedules": convertSchedulesToDict()
            ])
        }
    }
    
    private func handleCalendarEvent(_ message: [String: Any], replyHandler: (([String : Any]) -> Void)?) {
        guard let start = message["startDate"] as? TimeInterval,
              let end = message["endDate"] as? TimeInterval,
              let location = message["location"] as? String else {
            replyHandler?(["status": "error", "message": "Invalid event data"])
            return
        }
        
        Task {
            do {
                try await createCalendarEvent(
                    start: Date(timeIntervalSince1970: start),
                    end: Date(timeIntervalSince1970: end),
                    location: location
                )
                replyHandler?(["status": "success"])
                sendDataToWatch()
            } catch {
                replyHandler?(["status": "error", "message": error.localizedDescription])
            }
        }
    }
        
    private func createCalendarEvent(start: Date, end: Date, location: String) async throws {
        let context = await ModelManager.shared.mainContext
        let newEvent = ScheduleItemData(
            employeeName: "Self",
            startTime: start,
            endTime: end,
            location: location,
            message: "GOPQ Alert",
            soundName: ""
        )
        
        newEvent.alertOffset = 5
        
        do {
            context.insert(newEvent)
            try await context.save()
            await ScheduleController.shared.ekmanager.syncEvent(newEvent)
        } catch {
            context.delete(newEvent)
            throw error
        }
    }
}
