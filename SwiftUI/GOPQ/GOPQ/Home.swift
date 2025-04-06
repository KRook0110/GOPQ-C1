//
//  home.swift
//  test
//
//  Created by Yehezkiel Joseph Widianto on 26/03/25.
//

import SwiftUI

fileprivate let tempSchedules : [ScheduleItemData] = [
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

struct home: View {
    
    @Environment(UserDataController.self) var userData

    var body: some View {
        ZStack{
            
            Color.black.ignoresSafeArea()
            VStack {
                NavigationBar()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Selamat pagi,")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text(userData.username)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Text(Date.now.formatted(date: .complete, time: .omitted))
                        .foregroundColor(.gray)
                }.padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    ScheduleList()
                
                Spacer()
                
            }
        }
    }
}

struct home_Previews: PreviewProvider {
    
    static var previews: some View {
        EnvironmentalTemp {
            home()
        }
    }
}

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
