//
//  GOPQApp.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import SwiftUI
import UniformTypeIdentifiers
import SwiftData
import AppIntents

@Observable
class AppGlobal{
    var showImportSheet = false
    
    init() {
        
    }
}

@main
struct GOPQApp: App {
    
    init() {
        _ = WatchConnector.shared
    }
    
    @Environment(\.scenePhase) private var scenePhase // .background if close to termination
    @State var appGlobal = AppGlobal()
    @State var csvController = CSVController()
    @State var observableScheduleController = ScheduleController()
    @State var userdata = UserData()
    @State private var watchConnector = WatchConnector.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if userdata.username.isEmpty {
                    SplashScreen()
                }
                else {
                    home(schedule: .empty)
                        .alert("Peringatan", isPresented: $observableScheduleController.ekmanager.showAlert) { // jujur bgt keknya alert bisa dimasukin ke controller sendiri
                            Button("OK", role: .cancel) {}
                        } message: {
                            Text(observableScheduleController.ekmanager.alertMessage)
                        }
                        .fileImporter(
                            isPresented: $appGlobal.showImportSheet,
                            allowedContentTypes: [
                                UTType.commaSeparatedText,
                                UTType(filenameExtension: "csv")!
                            ]
                        ) { result in
                            observableScheduleController.set( csvController.handleFileImport(for: result), name: userdata.username)
                        }
                }
            }
        }
        .onChange(of: scenePhase, initial: false)  {
            if scenePhase == .background || scenePhase == .inactive {
                observableScheduleController.saveToSwiftData()
            } else if (scenePhase == .active) {
                Task {
                    await observableScheduleController.refreshData()
                    await WatchConnector.shared.updateLocalSchedules()
                    
                    if watchConnector.isReachable {
                        watchConnector.sendDataToWatch()
                    }
                }
            }
        }
        .environment(appGlobal)
        .environment(csvController)
        .environment(observableScheduleController)
        .environment(userdata)
        .modelContainer(for: [
            ScheduleItemData.self
        ])
    }
}

