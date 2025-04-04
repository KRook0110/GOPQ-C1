//
//  ScheduleList.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//


import SwiftUI

struct ScheduleList: View {
    @Environment(ObservableScheduleList.self) var schedules
    
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                BorderLine()
                ForEach(schedules.data, id:\.id) { schedule in
                    ScheduleItem(schedule: schedule)
                        .padding(18)
                    BorderLine()
                }
//                ForEach(schedules.data, id: \.self) {schedule in
//                    VStack {
//                        ScheduleItem(index: schedules.data.firstIndex(where: $0.id == schedule.id))
//                            .padding(18)
//                        BorderLine()
//                    }
//                }
            }
        }
    }
}

fileprivate var schedules : [ScheduleItemData] = [
    ScheduleItemData(
        startTimeHour: 10,
        startTimeMin: 20,
        endTimeHour: 13,
        endTimeMin: 10,
        location: "Lobby 1",
        message: "Hi hello",
        soundName: "System.something"
    ),
    ScheduleItemData(
        startTimeHour: 15,
        startTimeMin: 20,
        endTimeHour: 19,
        endTimeMin: 20,
        location: "Pantry",
        message: "Hello Hi",
        soundName: "System.something"
    ),
    ScheduleItemData(
        startTimeHour: 8,
        startTimeMin: 10,
        endTimeHour: 15,
        endTimeMin: 20,
        location: "Pantry",
        message: "Hello Hi",
        soundName: "System.something"
    )
]


#Preview {
    ZStack {
        Rectangle()
            .fill(.black)
            .ignoresSafeArea()
        ScheduleList()
            .environment(ObservableScheduleList(schedules))
    }
}
