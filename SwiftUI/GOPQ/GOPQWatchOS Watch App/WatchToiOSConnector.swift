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
    @Published var schedules: [WatchScheduleItem] = []
    @Published var lastUpdated: Date = Date()
    @Published var isLoading = false
    @Published var connectionStatus: String = "Initializing..."
    
    var onReceiveSchedules: (([WatchScheduleItem]) -> Void)?
    
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
            connectionStatus = "Watch Connectivity not supported"
        }
    }
    
    private func startActivationMonitoring() {
        // status aktivasi di cek per sec buat debug
        activationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let previousReachable = self.isReachable
                self.isReachable = self.session.isReachable
                self.isConnected = self.session.activationState == .activated
                
                self.updateConnectionStatusMessage()
                
                // setiap true fetch data
                if !previousReachable && self.isReachable {
                    print("Watch: Phone became reachable, requesting schedules")
                    self.requestSchedulesFromPhone()
                }
                
                // kalo gagal trs coba session restart
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
            connectionStatus = "Connecting to phone..."
        } else if !isReachable {
            connectionStatus = "Phone not reachable. Make sure your phone is nearby and unlocked."
        } else if isLoading {
            connectionStatus = "Loading schedules..."
        } else {
            connectionStatus = "Connected"
        }
    }
    
    // Send an empty message to try to establish reachability
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
            print("Watch: No schedules data in message")
            return
        }
        
        DispatchQueue.main.async {
            self.schedules = self.convertDictToSchedules(schedulesData)
            self.lastUpdated = Date()
            self.isLoading = false
            print("Watch: Received \(self.schedules.count) schedules from phone")
            
            self.onReceiveSchedules?(self.schedules)
            self.updateConnectionStatusMessage()
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
        
        // Try both methods to ensure data gets through
        
        // 1. Application context method
        do {
            try session.updateApplicationContext(["requestScheduleRefresh": true])
            print("Watch: Sent refresh request via application context")
        } catch {
            print("Watch: Failed to request refresh via context: \(error.localizedDescription)")
        }
        
        // 2. Direct message with reply handler
        session.sendMessage(
            ["type": "requestSchedules"],
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
    
    // Add new calendar event from Watch
    func addCalendarEvent(startTime: Date, endTime: Date, location: String, completion: @escaping (Bool, String) -> Void) {
        guard isReachable else {
            completion(false, "Phone is not reachable. Make sure your phone is nearby and unlocked.")
            return
        }
        
        let message: [String: Any] = [
            "type": "addCalendarEvent",
            "startDate": startTime.timeIntervalSince1970,
            "endDate": endTime.timeIntervalSince1970,
            "location": location
        ]
        
        session.sendMessage(
            message,
            replyHandler: { response in
                if let status = response["status"] as? String, status == "success" {
                    completion(true, response["message"] as? String ?? "Success")
                } else {
                    completion(false, response["message"] as? String ?? "Unknown error")
                }
            },
            errorHandler: { error in
                completion(false, "Error: \(error.localizedDescription)")
            }
        )
    }
    
    func deleteSchedule(id: String) {
        let message = [
            "type": "deleteSchedule",
            "scheduleId": id
        ]
        
        session.sendMessage(
            message,
            replyHandler: { response in
                print("Delete request for schedule \(id) sent successfully")
                // Process response if needed
            },
            errorHandler: { error in
                print("Failed to send delete request for schedule \(id): \(error.localizedDescription)")
            }
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.requestSchedulesFromPhone()
        }
    }
    
    private func convertDictToSchedules(_ dictArray: [[String: Any]]) -> [WatchScheduleItem] {
        return dictArray.map { dict -> WatchScheduleItem in
            let id = UUID(uuidString: dict["id"] as? String ?? UUID().uuidString) ?? UUID()
            let employeeName = dict["employeeName"] as? String ?? ""
            let startTimeInterval = dict["startTime"] as? TimeInterval ?? 0
            let endTimeInterval = dict["endTime"] as? TimeInterval ?? 0
            let location = dict["location"] as? String ?? ""
            let message = dict["message"] as? String ?? ""
            let soundName = dict["soundName"] as? String ?? ""
            let alertOffset = dict["alertOffset"] as? Int ?? 0
            
            return WatchScheduleItem(
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
