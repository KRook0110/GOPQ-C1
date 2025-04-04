//
//  ScheduleList.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//


import SwiftUI

struct ScheduleList: View {
    @Environment(ScheduleController.self) var schedules
    
    
    var body: some View {
        if schedules.data.isEmpty {
            VStack {
                Text("Silahkan Masukkan Jadwal Anda")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(.bottom, 16)
                
                
                ImportScheduleListButton()
                    .frame(width: 100)
            }
            .padding(.top, 100)
        }
        else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    BorderLine()
                    ForEach(schedules.data, id:\.id) { schedule in
                        ScheduleItem(schedule: schedule)
                            .padding(18)
                        BorderLine()
                    }
                    //                ForEach(schedules.data, id: \.self) {schedule in
                    //                    VStack {
                    //                        ScheduleItem(index: schedules.data.firstIndex(where: $0.id == schedule.id))
                    //                            .padding(18)
                    //                        BorderLine()
                    //                    }
                    //                }
                }
            }
        }
    }
}



#Preview {
    ZStack {
        Rectangle()
            .fill(.black)
            .ignoresSafeArea()
        //        ScheduleList()
        //            .environment(ObservableScheduleList(schedules))
        EnvironmentalTemp() {
            ScheduleList()
        }
    }
}
