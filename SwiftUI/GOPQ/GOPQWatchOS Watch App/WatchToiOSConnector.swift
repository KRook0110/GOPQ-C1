//
//  WatchToiOSConnector.swift
//  GOPQWatchOS Watch App
//
//  Created by Dicky Dharma Susanto on 06/05/25.
//

import Foundation
import WatchConnectivity

class WatchToiOSConnector: NSObject, WCSessionDelegate, ObservableObject {
    
    static let shared = WatchToiOSConnector()
    
    @Published var isReachable = false
    @Published var isConnected = false
    @Published var schedules: [ScheduleItemData] = []
    @Published var lastUpdated: Date = Date()
    @Published var isLoading = false
    @Published var connectionStatus: String = "Initialize"
    
    var onReceiveSchedules: (([ScheduleItemData]) -> Void)?
    
    private var session: WCSession
    private var activationTimer: Timer?
    private var retryCount = 0
    private let maxRetries = 5
    
    override init() {
        self.session = WCSession.default
        super.init()
        
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
            startActivationMonitoring()
        } else {
            connectionStatus = "Connection not supported"
        }
    }
    
    private func startActivationMonitoring() {
        // Check status terus
        activationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let previousReachable = self.isReachable
                self.isReachable = self.session.isReachable
                self.isConnected = self.session.activationState == .activated
                
                self.updateConnectionStatusMessage()
                
                if !previousReachable && self.isReachable {
                    print("Watch: Phone connected, requesting schedules")
                    self.requestSchedulesFromPhone()
                }
                
                if self.isConnected && !self.isReachable && self.retryCount < self.maxRetries {
                    self.retryCount += 1
                    print("Watch: Attempting reachability fix, attempt \(self.retryCount)")
                    self.sendPingMessage()
                }
            }
        }
    }
    
    private func updateConnectionStatusMessage() {
        if !isConnected {
            connectionStatus = "Connecting to phone"
        } else if !isReachable {
            connectionStatus = "Phone not reachable. Make sure your phone is nearby and unlocked."
        } else if isLoading {
            connectionStatus = "Loading schedules"
        } else {
            connectionStatus = "Connected"
        }
    }
    
    // Reconnect reachability
    private func sendPingMessage() {
        session.sendMessage(
            ["type": "ping"],
            replyHandler: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.isReachable = true
                    self?.updateConnectionStatusMessage()
                    self?.requestSchedulesFromPhone()
                }
            },
            errorHandler: { error in
                print("Watch: Ping failed: \(error.localizedDescription)")
            }
        )
    }
    
    // Force ping with async/await pattern
    func forcePing() async -> Bool {
        return await withCheckedContinuation { continuation in
            session.sendMessage(
                ["type": "ping", "priority": "high", "source": "shortcut"],
                replyHandler: { _ in
                    DispatchQueue.main.async {
                        self.isReachable = true
                        self.updateConnectionStatusMessage()
                        continuation.resume(returning: true)
                    }
                },
                errorHandler: { error in
                    print("Watch: Force ping failed: \(error.localizedDescription)")
                    continuation.resume(returning: false)
                }
            )
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isConnected = activationState == .activated
            self.isReachable = session.isReachable
            
            print("Watch: Session activated with state: \(activationState.rawValue), isReachable: \(self.isReachable)")
            self.updateConnectionStatusMessage()
            
            if self.isConnected {
                // Wait a moment before requesting schedules to allow reachability to stabilize
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.sendPingMessage()
                }
            }
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
            print("Watch: Reachability changed to: \(self.isReachable)")
            self.updateConnectionStatusMessage()
            
            if self.isReachable {
                self.requestSchedulesFromPhone()
            }
        }
    }
    
    // Handle app context updates (background updates)
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Watch: Received application context")
        processReceivedSchedules(applicationContext)
    }
    
    // Handle direct messages
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let type = message["type"] as? String else { return }
        
        print("Watch: Received message of type: \(type)")
        if type == "scheduleUpdate" {
            processReceivedSchedules(message)
        } else if type == "pong" {
            DispatchQueue.main.async {
                self.isReachable = true
                self.updateConnectionStatusMessage()
            }
        }
    }
    
    // Process schedules received from phone
    private func processReceivedSchedules(_ data: [String: Any]) {
        guard let schedulesData = data["schedules"] as? [[String: Any]] else {
            return
        }
        
        let newSchedules = convertDictToSchedules(schedulesData)
        
        if newSchedules != self.schedules {
            DispatchQueue.main.async {
                        self.schedules = self.convertDictToSchedules(schedulesData)
                        self.lastUpdated = Date()
                        self.isLoading = false
                        print("Watch: Received \(self.schedules.count) schedules from phone")
                        
                        self.onReceiveSchedules?(self.schedules)
                        self.updateConnectionStatusMessage()
                    }
        }
        
    }
    
    // Request schedules when app becomes active
    func requestSchedulesFromPhone() {
        guard isConnected else {
            print("Watch: Session not activated yet")
            return
        }
        
        guard isReachable else {
            print("Watch: Phone is not reachable")
            // Try a ping to establish reachability
            sendPingMessage()
            return
        }
        
        print("Watch: Requesting schedules from phone")
        isLoading = true
        updateConnectionStatusMessage()
        
        do {
            try session.updateApplicationContext(["requestScheduleRefresh": true])
            print("Watch: Sent refresh request via application context")
        } catch {
            print("Watch: Failed to request refresh via context: \(error.localizedDescription)")
        }
        
        session.sendMessage(
            ["type": "requestSchedules", "source": "watchApp"],
            replyHandler: { response in
                print("Watch: Got direct response from phone")
                if let status = response["status"] as? String, status == "success",
                   let schedulesData = response["schedules"] as? [[String: Any]] {
                    
                    DispatchQueue.main.async {
                        self.schedules = self.convertDictToSchedules(schedulesData)
                        self.lastUpdated = Date()
                        self.isLoading = false
                        print("Watch: Received \(self.schedules.count) schedules via reply")
                        
                        self.onReceiveSchedules?(self.schedules)
                        self.updateConnectionStatusMessage()
                    }
                } else {
                    print("Watch: Invalid response from phone")
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.updateConnectionStatusMessage()
                    }
                }
            },
            errorHandler: { error in
                print("Watch: Failed to request schedules: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.updateConnectionStatusMessage()
                }
            }
        )
        
        // Set a timeout to prevent indefinite loading state
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [weak self] in
            if self?.isLoading == true {
                self?.isLoading = false
                self?.updateConnectionStatusMessage()
                print("Watch: Schedule request timed out")
            }
        }
    }
    
    // Added all parameters to match the iOS model
    func addCalendarEvent(
        startTime: Date,
        endTime: Date,
        location: String,
        employeeName: String = "Self",
        message: String = "GOPQ Alert",
        soundName: String = "",
        alertOffset: Int = 5,
        completion: @escaping (Bool, String) -> Void
    ) {
        guard isConnected else {
            print("Watch: Session not activated yet")
            completion(false, "Watch not connected to phone. Please try again.")
            return
        }
        
        // Special handling for Shortcuts - attempt to force session activation
        if !isReachable {
            print("Watch: Phone not reachable, trying to establish connection first")
            
            // First force a ping to see if we can establish connection
            session.sendMessage(
                ["type": "ping", "priority": "high", "source": "shortcut_calendarEvent"],
                replyHandler: { [weak self] _ in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        self.isReachable = true
                        self.updateConnectionStatusMessage()
                        
                        // Now send the event after establishing reachability
                        self.sendCalendarEventMessage(
                            startTime: startTime,
                            endTime: endTime,
                            location: location,
                            employeeName: employeeName,
                            message: message,
                            soundName: soundName,
                            alertOffset: alertOffset,
                            completion: completion
                        )
                    }
                },
                errorHandler: { error in
                    print("Watch: Force ping before calendar event failed: \(error.localizedDescription)")
                    completion(false, "Phone is not reachable. Make sure your phone is nearby and unlocked.")
                }
            )
            return
        }
        
        // If already reachable, send directly
        sendCalendarEventMessage(
            startTime: startTime,
            endTime: endTime,
            location: location,
            employeeName: employeeName,
            message: message,
            soundName: soundName,
            alertOffset: alertOffset,
            completion: completion
        )
    }
    
    private func sendCalendarEventMessage(
        startTime: Date,
        endTime: Date,
        location: String,
        employeeName: String,
        message: String,
        soundName: String,
        alertOffset: Int,
        completion: @escaping (Bool, String) -> Void
    ) {
        let message: [String: Any] = [
            "type": "addCalendarEvent",
            "startDate": startTime.timeIntervalSince1970,
            "endDate": endTime.timeIntervalSince1970,
            "location": location,
            "employeeName": employeeName,
            "message": message,
            "soundName": soundName,
            "alertOffset": alertOffset,
            "source": "watchOS", // Identify source for debugging
            "timestamp": Date().timeIntervalSince1970 // Add timestamp to make messages unique
        ]
        
        print("Watch: Sending calendar event request to phone: \(message)")
        
        session.sendMessage(
            message,
            replyHandler: { response in
                print("Watch: Received response for calendar event: \(response)")
                if let status = response["status"] as? String, status == "success" {
                    completion(true, response["message"] as? String ?? "Success")
                } else {
                    completion(false, response["message"] as? String ?? "Unknown error")
                }
            },
            errorHandler: { error in
                print("Watch: Error sending calendar event: \(error.localizedDescription)")
                completion(false, "Error: \(error.localizedDescription)")
            }
        )
    }
    
    func deleteSchedule(id: String) {
        let message = [
            "type": "deleteSchedule",
            "scheduleId": id,
            "requestId": UUID().uuidString
        ]
        
        session.sendMessage(
            message,
            replyHandler: { [weak self] response in
                guard let self else { return }
                
                if let success = response["status"] as? Bool, success {
                    DispatchQueue.main.async {
                        self.schedules.removeAll { $0.id.uuidString == id }
                    }
                }
                self.requestSchedulesFromPhone()
            },
            errorHandler: { error in
                print("Failed to send delete request: \(error.localizedDescription)")
                self.requestSchedulesFromPhone() // Force refresh
            }
        )
    }
    
    private func convertDictToSchedules(_ dictArray: [[String: Any]]) -> [ScheduleItemData] {
        return dictArray.map { dict -> ScheduleItemData in
            let id = UUID(uuidString: dict["id"] as? String ?? UUID().uuidString) ?? UUID()
            let employeeName = dict["employeeName"] as? String ?? ""
            let startTimeInterval = dict["startTime"] as? TimeInterval ?? 0
            let endTimeInterval = dict["endTime"] as? TimeInterval ?? 0
            let location = dict["location"] as? String ?? ""
            let message = dict["message"] as? String ?? ""
            let soundName = dict["soundName"] as? String ?? ""
            let alertOffset = dict["alertOffset"] as? Int ?? 0
            
            return ScheduleItemData(
                id: id,
                employeeName: employeeName,
                startTime: Date(timeIntervalSince1970: startTimeInterval),
                endTime: Date(timeIntervalSince1970: endTimeInterval),
                location: location,
                message: message,
                soundName: soundName,
                alertOffset: alertOffset
            )
        }
    }
    
    deinit {
        activationTimer?.invalidate()
    }
}
