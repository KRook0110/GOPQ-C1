//
//  ScheduleListView.swift
//  GOPQWatchOS Watch App
//
//  Created by Dicky Dharma Susanto on 13/05/25.
//

import SwiftUI

struct ScheduleListView: View {
    
    @Binding var schedules: [WatchScheduleItem]
    let deleteSchedule: (IndexSet) -> Void
    var navigateToAddSchedule: () -> Void
    
    var body: some View {
        List {
            ForEach(schedules) { schedule in
                NavigationLink(destination: ScheduleDetailView(schedule: schedule)){
                    ScheduleItemRow(schedule: schedule)
                }
            }
            .onDelete(perform: deleteSchedule)
            
            AddScheduleButton(action: navigateToAddSchedule)
        }
        .listStyle(.carousel)
    }
}
