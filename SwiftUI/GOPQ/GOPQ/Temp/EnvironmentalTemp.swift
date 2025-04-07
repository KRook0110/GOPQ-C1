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
        startTime: makeTime(hour: 8, min: 20 ),
        endTime: makeTime(hour: 10, min: 40),
        location: "Lobby 1",
        message: "Hi hello",
        soundName: "System.something"
    ),
    ScheduleItemData(
        employeeName: "Testing Person",
        startTime: makeTime(hour: 20, min: 10 ),
        endTime: makeTime(hour: 24, min: 20),
        location: "Pantry",
        message: "Hello Hi",
        soundName: "System.something"
    ),
    ScheduleItemData(
        employeeName: "Testing Person",
        startTime: makeTime(hour: 15, min: 10 ),
        endTime: makeTime(hour: 18, min: 20),
        location: "Pantry",
        message: "Hello Hi",
        soundName: "System.something"
    )
]

struct EnvironmentalTemp<Content: View>: View  {
    let content: () -> Content
    @State var csvController: CSVController
    @State var observableScheduleList: ScheduleController
    @State var userData: UserData
    
    init(empty: Bool = false, @ViewBuilder content: @escaping () -> Content )  {
        self.content = content
        self.csvController = CSVController()
        self.userData = UserData()
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
                    .environment(userData) 
//            }
        }
    }
}

