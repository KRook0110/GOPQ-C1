//
//  ScheduleList.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 02/04/25.
//

import SwiftUI

struct SchedulesList: View {
    var schedules: [ScheduleItemData]

    var body: some View {
        List(schedules) { schedule in
            VStack(alignment: .leading) {
                Text("\(schedule.getStartTimeFormat()) - \(schedule.getEndTimeFormat())")
                    .foregroundColor(.white)
                Text(schedule.location)
                    .foregroundColor(.gray)
                Text(schedule.message)
                    .foregroundColor(.gray)
            }
        }
    }
}
