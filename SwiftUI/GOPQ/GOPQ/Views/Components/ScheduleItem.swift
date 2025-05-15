//
//  ScheduleItem.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import SwiftUI

struct ScheduleItem: View {

    let schedule: ScheduleItemData

    let xPadding: CGFloat = 20
    let spaceBetweenTimeAndLocation: CGFloat = 0
    let lineThickness: CGFloat = 2
    let spaceBetweenTimeAndLine: CGFloat = 2

    @State private var showBottomSheet: Bool = false

    var body: some View {
        Button {
            showBottomSheet = true
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(schedule.message) di \(schedule.location)")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                    Text("\(schedule.getStartTimeFormat()) - \(schedule.getEndTimeFormat())")
                        .font(.system(size: 36))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white)
            }
            .padding()
            .background(Color("Neutral2"))
            .cornerRadius(8)
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        }
        .sheet(isPresented: $showBottomSheet) {
            ScheduleDetailBottomSheet(sheetControl: $showBottomSheet, schedule: schedule)
                .presentationCornerRadius(10)
                .background(Color("ModularBackground"))

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
                        startTime: makeTime(hour: 10, min: 20),
                        endTime: makeTime(hour: 11, min: 30),
                        location: "Lobby 1",
                        message: "Hi hello",
                        soundName: "System.something"
                    )
            )
        }
    }
}
