//
//  ScheduleList.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//


import SwiftUI

struct BorderLine: View {
    var body: some View {
        Rectangle()
            .fill( LinearGradient(
                    colors: [
                        .gray.opacity(0.1),
                        .gray.opacity(0.4),
                        .gray.opacity(0.1)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
            ) )
            .frame(width: .infinity, height: 2)
    }
}

struct ScheduleList: View {
    let schedules: [ScheduleItemData]
    
    private var sortedSchedules: [ScheduleItemData] {
        schedules.sorted { lhs, rhs -> Bool in
            if(lhs.startTimeHour != rhs.startTimeHour)  {
                return lhs.startTimeHour < rhs.startTimeHour
            }
            return lhs.startTimeMin < rhs.startTimeMin
        }
    }
    
    init(_ schedules: [ScheduleItemData]) {
        var schedulesCopy = schedules
        schedulesCopy.sort(by: { lhs, rhs -> Bool in
            if(lhs.startTimeHour != rhs.startTimeHour)  {
                return lhs.startTimeHour < rhs.startTimeHour
            }
            return lhs.startTimeMin < rhs.startTimeMin
        })
        self.schedules  = schedules
        
    }
    
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                BorderLine()
                ForEach(sortedSchedules) {schedule in
                    VStack {
                        ScheduleItem(schedule)
                            .padding(18)
                        BorderLine()
                    }
                }
            }
        }
    }
}

var schedules : [ScheduleItemData] = [
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
        ScheduleList(schedules)
    }
}
