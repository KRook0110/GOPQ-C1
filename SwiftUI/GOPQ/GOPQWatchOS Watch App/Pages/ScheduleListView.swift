//
//  ScheduleListView.swift
//  GOPQWatchOS Watch App
//
//  Created by Dicky Dharma Susanto on 13/05/25.
//

import SwiftUI

struct ScheduleListView: View {
    
    @Binding var schedules: [ScheduleItemData]
    let deleteSchedule: (IndexSet) -> Void
    var navigateToAddSchedule: () -> Void
    
    var body: some View {
        List {
            ForEach(schedules) { schedule in
                NavigationLink(destination: ScheduleDetailView(schedule: schedule)){
                    ScheduleItemRow(schedule: schedule)
                }
            }
            .onDelete { offsets in
                withAnimation {
                    deleteSchedule(offsets)
                }
            }
            AddScheduleButton(action: navigateToAddSchedule).listRowBackground(Color.clear)
        }
        .listStyle(.carousel)
    }
}
