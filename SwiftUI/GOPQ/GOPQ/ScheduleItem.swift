//
//  ScheduleItem.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import SwiftUI

struct ScheduleItem: View {
    var startTimeHour: Int
    var startTimeMin: Int
    var endTimeHour: Int
    var endTimeMint: Int
    var location: String
    
    let xPadding:CGFloat = 20;
    let spaceBetweenTimeAndLocation:CGFloat = 2;
    let lineThickness:CGFloat = 10;
    
    
    var body: some View {
        Rectangle()
            .frame(width: .infinity, height: lineThickness)
            .foregroundStyle(
                LinearGradient(
                    colors: [.gray, .white, .gray],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
        HStack {
            VStack(alignment: .leading) {
                Text("\(leadingZero(startTimeHour)):\(leadingZero(startTimeMin)) - \(leadingZero(endTimeHour)):\(leadingZero(endTimeMint))")
                    .bold()
                    .font(.largeTitle)
                    .padding(.bottom, spaceBetweenTimeAndLocation)
                Text(location)
            }
            .padding(.leading, xPadding)
            Spacer()
            Button {
                
            } label: {
                Text("Edit")
                    .underline()
            }
        }
    }
    func leadingZero(_ num: Int) -> String {
        return String(format: "%02d", num)
    }
}

#Preview {
    ZStack {
        Rectangle()
            .ignoresSafeArea()
        ScheduleItem(
            startTimeHour: 7,
            startTimeMin: 7,
            endTimeHour: 7,
            endTimeMint: 7,
            location: "Lobby 1"
        )
    }
}
