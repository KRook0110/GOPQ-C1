//
//  ScheduleDetailView.swift
//  GOPQWatchOS Watch App
//
//  Created by Dicky Dharma Susanto on 17/05/25.
//

import SwiftUI

struct ScheduleDetailView: View {
    let schedule: WatchScheduleItem
    
    var body: some View {
        List {
            Section {
                LabeledContent("Employee", value: schedule.employeeName)
                LabeledContent("Start", value: schedule.getStartTimeFormat())
                LabeledContent("End", value: schedule.getEndTimeFormat())
                LabeledContent("Location", value: schedule.location)
                
                if !schedule.message.isEmpty {
                    LabeledContent("Message", value: schedule.message)
                }
            }
        }
        .navigationTitle("Details")
    }
}
