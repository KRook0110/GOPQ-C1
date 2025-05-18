//
//  WatchScheduleViewModel.swift
//  GOPQWatchOS Watch App
//
//  Created by Dicky Dharma Susanto on 15/05/25.
//

import Foundation

class WatchScheduleViewModel: ObservableObject {
    @Published var schedules: [ScheduleItemData] = []
    @Published var connectionStatus: String = "Initialize"
    @Published var isConnected: Bool = false
    
    private var connector = WatchToiOSConnector.shared
    private var statusUpdateTimer: Timer?
    
    init() {
        connector.$schedules
            .receive(on: RunLoop.main)
            .assign(to: &$schedules)
        
        connector.$isReachable
            .map { $0 ? "Connected" : "Disconnected" }
            .assign(to: &$connectionStatus)
        
        connector.$isConnected
            .assign(to: &$isConnected)
        
        // Kick off the first load
        connector.requestSchedulesFromPhone()
        
        
    }
    
    private func startConnectionMonitoring() {
        // Update connection status UI every second
        statusUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.connectionStatus = self.connector.connectionStatus
                self.isConnected = self.connector.isConnected && self.connector.isReachable
            }
        }
    }
    
    func refreshSchedules() {
        connector.requestSchedulesFromPhone()
    }
    
    func addCalendarEvent(startTime: Date, endTime: Date, location: String, completion: @escaping (Bool, String) -> Void) {
        connector.addCalendarEvent(startTime: startTime, endTime: endTime, location: location, completion: completion)
    }
    
    func deleteSchedules(at offsets: IndexSet) {
        let schedulesToDelete = offsets.map { schedules[$0] }
        
        for schedule in schedulesToDelete {
            connector.deleteSchedule(id: schedule.id.uuidString)
        }
        
        schedules.remove(atOffsets: offsets)
        
    }
    
    deinit {
        statusUpdateTimer?.invalidate()
    }
}
