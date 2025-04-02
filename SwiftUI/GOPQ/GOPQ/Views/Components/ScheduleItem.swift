//
//  ScheduleItem.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import SwiftUI


struct ScheduleItem: View {
    
    var schedule: ScheduleItemData
    
    
    let xPadding:CGFloat = 20;
    let spaceBetweenTimeAndLocation:CGFloat = 0;
    let lineThickness:CGFloat = 2;
    let spaceBetweenTimeAndLine:CGFloat = 2;
    
    @State private var showBottomSheet: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(schedule.getStartTimeFormat()) - \(schedule.getEndTimeFormat())")
                    .bold( )
                    .font(.largeTitle)
                    .padding(.bottom, spaceBetweenTimeAndLocation)
                    .foregroundStyle(.white)
                Text(schedule.location)
                    .foregroundStyle(.gray)
            }
            .padding(.leading, xPadding)
            Spacer()
            Button {
                showBottomSheet = true
            } label: {
                Text("Edit")
                    .underline()
                    .padding(.trailing, xPadding)
            }
            .sheet(isPresented: $showBottomSheet) {
                ScheduleDetailBottomSheet(sheetControl: $showBottomSheet, schedule: schedule)
                    .presentationCornerRadius(10)
                    .background(Color("ModularBackground"))
                
            }
        }
    }
}

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

#Preview {
    ZStack {
        Rectangle()
            .background(.black)
            .ignoresSafeArea()
        ScheduleItem(
            schedule: schedules[0]
        )
        .environment(ObservableScheduleList(schedules))
    }
}
