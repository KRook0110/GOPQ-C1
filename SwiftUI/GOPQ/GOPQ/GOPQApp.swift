//
//  GOPQApp.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import SwiftUI

@main
struct GOPQApp: App {
    
    @StateObject var userData = UserData()
    @StateObject var csvController = CSVController()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if userData.userName.isEmpty {
                    SplashScreen()
                } else if csvController.schedules.isEmpty {
                    dashboard()
                } else {
                    home()
                }
            }.environmentObject(userData)
            .environmentObject(csvController)
            .onReceive(csvController.$schedules) { _ in
                print("App detected schedules change: \(csvController.schedules.count)")
            }
        }
    }
}
