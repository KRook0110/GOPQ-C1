//
//  ScheduleRow.swift
//  GOPQWatchOS Watch App
//
//  Created by Dicky Dharma Susanto on 15/05/25.
//

import SwiftUI

struct ScheduleItemRow: View {
    let schedule: ScheduleItemData

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(schedule.getStartTimeFormat()) - \(schedule.getEndTimeFormat())")
                .font(.title3)
                .fontWeight(.bold)
            Text(schedule.location)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(height: 80)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(10)
        .padding(.vertical, 4)
        .listRowBackground(Color.clear)
    }
}

