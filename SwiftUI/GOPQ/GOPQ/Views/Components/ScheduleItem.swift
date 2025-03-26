//
//  ScheduleItem.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import SwiftUI

struct ScheduleItem: View {
    
    let scheduleData: ScheduleItemData
    
    init(_ scheduleData: ScheduleItemData)  {
        self.scheduleData = scheduleData
    }
    
    let xPadding:CGFloat = 20;
    let spaceBetweenTimeAndLocation:CGFloat = 0;
    let lineThickness:CGFloat = 2;
    let spaceBetweenTimeAndLine:CGFloat = 2;
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(scheduleData.getStartTimeFormat()) - \(scheduleData.getEndTimeFormat())")
                    .bold()
                    .font(.largeTitle)
                    .padding(.bottom, spaceBetweenTimeAndLocation)
                    .foregroundStyle(.white)
                Text(scheduleData.location)
                    .foregroundStyle(.gray)
            }
            .padding(.leading, xPadding)
            Spacer()
            Button {
                
            } label: {
                Text("Edit")
                    .underline()
                    .padding(.trailing, xPadding)
            }
        }
    }
}

#Preview {
    ZStack {
        Rectangle()
            .background(.black)
            .ignoresSafeArea()
        ScheduleItem(
            ScheduleItemData(
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
