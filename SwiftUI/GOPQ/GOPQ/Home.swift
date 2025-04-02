//
//  home.swift
//  test
//
//  Created by Yehezkiel Joseph Widianto on 26/03/25.
//

import SwiftUI
//
//fileprivate let tempSchedules : [ScheduleItemData] = [
//    ScheduleItemData(
//        employeeName: "Dicky",
//        startTimeHour: 10,
//        startTimeMin: 20,
//        endTimeHour: 13,
//        endTimeMin: 10,
//        location: "Lobby 1",
//        message: "Hi hello",
//        soundName: "System.something"
//    ),
//    ScheduleItemData(
//        employeeName: "Dicky",
//        startTimeHour: 15,
//        startTimeMin: 20,
//        endTimeHour: 19,
//        endTimeMin: 20,
//        location: "Pantry",
//        message: "Hello Hi",
//        soundName: "System.something"
//    ),
//    ScheduleItemData(
//        employeeName: "Dicky",
//        startTimeHour: 8,
//        startTimeMin: 10,
//        endTimeHour: 15,
//        endTimeMin: 20,
//        location: "Pantry",
//        message: "Hello Hi",
//        soundName: "System.something"
//    )
//]

struct home: View {
    @State private var schedules = ObservableScheduleList()
    
    @State var showImportSheet: Bool = false
    @State var showMapSheet: Bool = false
    @EnvironmentObject var csvController: CSVController
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack{
            
            Color.black.ignoresSafeArea()
            VStack {
                NavigationBar(showMapSheet: $showMapSheet, showImportSheet: $showImportSheet)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Selamat pagi,")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text(userData.userName)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Text("Jumat, 21 Maret 2025")
                        .foregroundColor(.gray)
                }.padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                SchedulesList(
                    schedules: csvController.schedules.filter {
                        $0.employeeName.lowercased() == userData.userName.lowercased()
                    }
                )


//                ScheduleList(schedules: csvController.schedules)
////                    .environment(schedules)
                
            }
        }
    }
}

struct home_Previews: PreviewProvider {
    
    @State static var showMapSheet = false
    
    static var previews: some View {
        home( showMapSheet: showMapSheet)
    }
}

