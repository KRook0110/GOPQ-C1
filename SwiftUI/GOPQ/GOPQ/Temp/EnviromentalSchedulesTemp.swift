//
//  EnviromentalSchedulesTemp.swift
//  GOPQ
//
//  Created by Shawn Andrew on 27/03/25.
//

import SwiftUI
import Foundation

fileprivate var schedules : [ScheduleItemData] = [
    ScheduleItemData(
        employeeName: "Dicky",
        startTimeHour: 10,
        startTimeMin: 20,
        endTimeHour: 13,
        endTimeMin: 10,
        location: "Lobby 1",
        message: "Hi hello",
        soundName: "System.something"
    ),
    ScheduleItemData(
        employeeName: "Dicky",
        startTimeHour: 15,
        startTimeMin: 20,
        endTimeHour: 19,
        endTimeMin: 20,
        location: "Pantry",
        message: "Hello Hi",
        soundName: "System.something"
    ),
    ScheduleItemData(
        employeeName: "Dicky",
        startTimeHour: 8,
        startTimeMin: 10,
        endTimeHour: 15,
        endTimeMin: 20,
        location: "Pantry",
        message: "Hello Hi",
        soundName: "System.something"
    )
]

struct EnviromentalSchedulesTemp<Content: View>: View  {
    let content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content )  {
        self.content = content
    }
    var body: some View {
        HStack {
            content()
                .environment(ObservableScheduleList(schedules))
            
        }
    }
}

#Preview {
    EnviromentalSchedulesTemp {
        Text("Yay")
    }
}
