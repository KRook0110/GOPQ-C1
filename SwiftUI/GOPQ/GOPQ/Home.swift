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
    
    @State private var showMapSheet = false
    
    
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
                        
                        Button{showMapSheet = true} label:{
                            Label("", systemImage: "map").foregroundColor(.blue)
                                .font(.system(size: 30))
                        }
                    }
                }.padding(EdgeInsets(top:0, leading:30, bottom:15, trailing: 30))
                
                BorderLine()
                
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
                }.padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScheduleList(schedules)
            }.sheet(isPresented: $showMapSheet) {
                MapSheet()
                    .presentationBackground(.clear)
                    .background(.clear)
            }
        }
    }
}
struct home_Previews: PreviewProvider {
    static var previews: some View {
        home()
    }
}
