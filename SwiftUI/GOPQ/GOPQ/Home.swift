//
//  home.swift
//  test
//
//  Created by Yehezkiel Joseph Widianto on 26/03/25.
//

import SwiftUI

struct home: View {
    var schedules : [ScheduleItemData] = [
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

    var body: some View {
        ZStack{
            
            Color.black.ignoresSafeArea()
            VStack {
                
                HStack {
                    Image("gopq")
                    Spacer()
                    HStack(spacing: 16) {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(.blue)
                            .font(.system(size: 30))
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.blue)
                            .font(.system(size: 30))
                    }
                }
               
                .padding(.bottom,15)
                .padding(.leading,30)
                .padding(.trailing,30)
                
                
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Selamat pagi,")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text("Dicky Dharma Susanto")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Text("Jumat, 21 Maret 2025")
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                //            List(schedules) { schedule in
                //                HStack {
                //                    VStack(alignment: .leading) {
                //                        Text(schedule.time)
                //                            .font(.headline)
                //                            .bold()
                //                            .foregroundColor(.white)
                //                        Text(schedule.location)
                //                            .foregroundColor(.gray)
                //                    }
                //                    Spacer()
                //                    Text("Edit")
                //                        .foregroundColor(.blue)
                //                        .underline()
                //                }
                //                .padding()
                //                .background(Color.black)
                //            }
                //            .scrollContentBackground(.hidden)
                //            .background(Color.black)
                //        }
                //        .background(Color.black.edgesIgnoringSafeArea(.all))
                VStack{
                    ScheduleList(schedules)
                    Spacer()
                }
            }
        }
    }
}


struct home_Previews: PreviewProvider {
    static var previews: some View {
        home()
    }
}
