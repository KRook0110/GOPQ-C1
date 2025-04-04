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

#Preview {
    ZStack {
        Rectangle()
            .background(.black)
            .ignoresSafeArea()
        EnvironmentalTemp {
            ScheduleItem(
                schedule: 
                    ScheduleItemData(
                        employeeName: "James",
                        startTimeHour: 10,
                        startTimeMin: 20,
                        endTimeHour: 13,
                        endTimeMin: 10,
                        location: "Lobby 1",
                        message: "Hi hello",
                        soundName: "System.something"
                    )
            )
        }
    }
}
