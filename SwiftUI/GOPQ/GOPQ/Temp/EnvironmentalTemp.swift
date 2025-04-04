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
        employeeName: "Testing Person",
        startTimeHour: 10,
        startTimeMin: 20,
        endTimeHour: 13,
        endTimeMin: 10,
        location: "Lobby 1",
        message: "Hi hello",
        soundName: "System.something"
    ),
    ScheduleItemData(
        employeeName: "Testing Person",
        startTimeHour: 15,
        startTimeMin: 20,
        endTimeHour: 19,
        endTimeMin: 20,
        location: "Pantry",
        message: "Hello Hi",
        soundName: "System.something"
    ),
    ScheduleItemData(
        employeeName: "Testing Person",
        startTimeHour: 8,
        startTimeMin: 10,
        endTimeHour: 15,
        endTimeMin: 20,
        location: "Pantry",
        message: "Hello Hi",
        soundName: "System.something"
    )
]

struct EnvironmentalTemp<Content: View>: View  {
    let content: () -> Content
    @State var csvController: CSVController
    @State var observableScheduleList: ScheduleController
    @State var userData: UserDataController
    
    init(empty: Bool = false, @ViewBuilder content: @escaping () -> Content )  {
        self.content = content
        self.csvController = CSVController()
        self.userData = UserDataController()
        if empty {
            self.observableScheduleList = ScheduleController()
        }
        else {
            self.observableScheduleList = ScheduleController(schedules)
        }
    }
    
    var body: some View {
        HStack {
//            if(empty) {
//                content()
//                    .environment(ObservableScheduleList())
//                    .environment(CSVController())
//            }
//            else {
                content()
                    .environment(csvController)
                    .environment(observableScheduleList)
//            }
        }
    }
}

