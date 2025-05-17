//
//  GOPQWatchOSApp.swift
//  GOPQWatchOS Watch App
//
//  Created by Dicky Dharma Susanto on 03/05/25.
//

import SwiftUI
import SwiftData

@main
struct GOPQWatchOS_Watch_AppApp: App {
    @StateObject private var viewModel = WatchScheduleViewModel()
    @State private var userdata = UserData()
    @StateObject private var connector = WatchToiOSConnector.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                if userdata.username.isEmpty {
                    WatchSplashScreen()
                } else {
                    WatchHome(
                        deleteSchedule: { indexSet in
                            viewModel.schedules.remove(atOffsets: indexSet)
                        }
                    )
                }
            }
            .environment(userdata)
            .onAppear {
                connector.requestSchedulesFromPhone()
            }
        }
    }
}
