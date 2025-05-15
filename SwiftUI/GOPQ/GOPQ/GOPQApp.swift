//
//  GOPQApp.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import SwiftData
import SwiftUI
import UniformTypeIdentifiers

@Observable
class AppGlobal {
    var showImportSheet = false

    init() {}
}
// testing

@main
struct GOPQApp: App {
    @Environment(\.scenePhase) private var scenePhase  // .background if close to termination

    @State var appGlobal = AppGlobal()
    @State var csvController = CSVController()
    @State var observableScheduleController = ScheduleController()
    @State var userdata = UserData()

    @State var scheduleBuffer: [ScheduleItemData] = []
    @State var showDuplicateImportError: Bool = false

    var body: some Scene {

        WindowGroup {
            ZStack {
                Color.black.ignoresSafeArea()
                SplashScreen()
                    .environment(userdata)
                    .transition(.identity)
                if !userdata.username.isEmpty {
                    HomeSeperatedView
                }
            }
            .animation(.default, value: userdata.username.isEmpty)
            .modelContainer(for: [
                ScheduleItemData.self,
                HashedScheduleList.self,
            ])
        }
    }

    @ViewBuilder
    var HomeSeperatedView: some View {
        home(schedule: .empty)

            .onChange(of: scenePhase, initial: false) {
                if scenePhase == .background || scenePhase == .inactive {
                    observableScheduleController.saveToSwiftData()
                }
            }
            .environment(appGlobal)
            .environment(csvController)
            .environment(observableScheduleController)
            .environment(userdata)
            .alert(
                "Peringatan",
                isPresented: $observableScheduleController.ekmanager.showAlert
            ) {  // jujur bgt keknya alert bisa dimasukin ke controller sendiri
                Button("OK", role: .cancel) {}
            } message: {
                Text(observableScheduleController.ekmanager.alertMessage)
            }
            .fileImporter(
                isPresented: $appGlobal.showImportSheet,
                allowedContentTypes: [
                    UTType.commaSeparatedText,
                    UTType(filenameExtension: "csv")!,
                ]
            ) { result in

                let data = csvController.handleFileImport(for: result)
                csvController.checkForDuplicateImports(data) { isDuplicate, hash in
                    scheduleBuffer = data
                    let filteredData = data.filter {
                        $0.employeeName == userdata.username
                    }
                    if filteredData.isEmpty {
                        observableScheduleController.namesInFileImport.removeAll()
                        for schedule in data {
                            observableScheduleController.namesInFileImport.insert(
                                schedule.employeeName)
                        }
                    }
                    if isDuplicate {
                        showDuplicateImportError = true
                    } else {

                        if filteredData.isEmpty {
                            observableScheduleController.showPickName = true
                        }
                        print("INSERTING HASHED SCHEDULE LIST")
                        let context = ModelManager.shared.mainContext
                        context.insert(HashedScheduleList(value: hash))
                        print("hash : \(hash)")
                        let desc = FetchDescriptor<HashedScheduleList>()
                        do {
                            try context.save()
                        } catch {
                            print(" failed save: \(error.localizedDescription)")
                        }

                        do {
                            print("hashed lists : \(try context.fetch(desc))")
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            .alert("Duplicate Import", isPresented: $showDuplicateImportError) {
                Button {
                } label: {
                    Text("No")
                }

                Button {
                    let filteredData = scheduleBuffer.filter {
                        $0.employeeName == userdata.username
                    }
                    if filteredData.isEmpty {
                        observableScheduleController.showPickName = true
                    } else {
                        for schedule in scheduleBuffer {
                            observableScheduleController.insert(schedule)
                        }
                    }
                } label: {
                    Text("Yes")
                }
                .keyboardShortcut(.defaultAction)
            } message: {
                Text(
                    "You have imported this file before, are you sure you want to import this file again?"
                )
            }
            .transition(.move(edge: .trailing))
            .sheet(isPresented: $observableScheduleController.showPickName) {
                NamePicker(
                    showSheet: $observableScheduleController.showPickName,
                    names: observableScheduleController.namesInFileImport.sorted()
                ) { (pickedName: String) in
                    for schedule in scheduleBuffer {
                        if schedule.employeeName == pickedName {
                            schedule.employeeName = userdata.username
                            observableScheduleController.insert(schedule)
                        }
                    }
                    scheduleBuffer.removeAll()

                }
            }
    }
}

#Preview {
}
