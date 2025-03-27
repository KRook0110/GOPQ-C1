//
//  ScheduleItem.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import SwiftUI


struct ScheduleItem: View {
    
    var index: Int
    
    @Environment(ObservableScheduleList.self) var schedules
    
    let xPadding:CGFloat = 20;
    let spaceBetweenTimeAndLocation:CGFloat = 0;
    let lineThickness:CGFloat = 2;
    let spaceBetweenTimeAndLine:CGFloat = 2;
    
    @State private var showBottomSheet: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(schedules.data[index].getStartTimeFormat()) - \(schedules.data[index].getEndTimeFormat())")
                    .bold( )
                    .font(.largeTitle)
                    .padding(.bottom, spaceBetweenTimeAndLocation)
                    .foregroundStyle(.white)
                Text(schedules.data[index].location)
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
                ScheduleDetailBottomSheet(sheetControl: $showBottomSheet, index: index)
                    .presentationCornerRadius(10)
                    .background(Color("DarkGray"))
                
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
            .background(.black)
            .ignoresSafeArea()
        ScheduleItem(
            index: 0
        )
        .environment(ObservableScheduleList(schedules))
    }
}
