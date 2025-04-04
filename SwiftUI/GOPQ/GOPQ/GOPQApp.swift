//
//  GOPQApp.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import SwiftUI

@main
struct GOPQApp: App {
    @State var csvController = CSVController()
    @State var observableScheduleController = ScheduleController()
    @State var userData = UserDataController()
    var body: some Scene {
        WindowGroup {
            Group {
                if userData.username.isEmpty {
                    SplashScreen()
                }
                else {
                    home()
                }
            }
        }
        .environment(csvController)
        .environment(observableScheduleController)
        .environment(userData)
    }
}
