//
//  GOPQApp.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import SwiftUI
import SwiftData

@main
struct GOPQApp: App {
    @Environment(\.scenePhase) private var scenePhase // .background if close to termination
    @State var csvController = CSVController()
    @State var observableScheduleController = ScheduleController()
    @State var userdata = UserData()
    var body: some Scene {
        WindowGroup {
            Group {
                if userdata.username.isEmpty {
                    SplashScreen()
                }
                else {
                    home(schedule: .empty)
//                        .alert("Error", isPresented: $observableScheduleController.ekmanager.showAlert) {
//                            Button("OK", role: .cancel) {}
//                        } message: {
//                            Text("Kami tidak bisa access kalender anda, kami tidak akan dapat membuat event di kalender anda.")
//                        }
                }
            }
        }
        .onChange(of: scenePhase, initial: false)  {
            if scenePhase == .background || scenePhase == .inactive {
                observableScheduleController.saveToSwiftData()
            }
        }
        .environment(csvController)
        .environment(observableScheduleController)
        .environment(userdata)
        .modelContainer(for: [
            ScheduleItemData.self
        ])
    }
}
