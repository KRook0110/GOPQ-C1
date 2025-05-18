//
//  home.swift
//  test
//
//  Created by Yehezkiel Joseph Widianto on 26/03/25.
//
import SwiftUI

enum HomepageActiveSheet: Int, Identifiable {
    case manualAddSheet
    case newShiftSheet
    case textImportSheet

    var id: Int {
        return self.rawValue
    }
}

struct home: View {

    var schedule: ScheduleItemData
    @Environment(UserData.self) private var userdata
    @Environment(AppGlobal.self) private var appGlobal
    @Environment(ScheduleController.self) private var scheduleController
    @State var activeSheet: HomepageActiveSheet? = nil
    @State var contentHeight: CGFloat = 200
    @State var textImportText: String = ""
    @Binding var scheduleBuffer: [ScheduleItemData]

    var body: some View {
        ZStack {

            Color("Neutral0").ignoresSafeArea()
            VStack {
                NavigationBar()

                VStack(alignment: .leading, spacing: 4) {
                    Text(userdata.username)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Text(Date.now.formatted(date: .complete, time: .omitted))
                        .foregroundColor(.white)
                        .font(.body)
                }
                .padding(EdgeInsets(top: 16, leading: 32, bottom: 0, trailing: 0))
                .frame(maxWidth: .infinity, alignment: .leading)

                ScheduleList()
                Spacer()
                Button {
                    activeSheet = .newShiftSheet
                } label: {
                    HStack {
                        Spacer()
                        Text("Tambah Jadwal")
                            .foregroundStyle(.white)
                            .bold()
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(16)
                    .padding()
                }
                .sheet(item: $activeSheet) { (sheet: HomepageActiveSheet) in
                    switch sheet {
                    case .newShiftSheet:
                        addScheduleSheet
                    case .manualAddSheet:
                        AddScheduleSheets(sheetControl: $activeSheet, schedule: schedule)
                    case .textImportSheet:
                        textImportSheet
                    }
                }
            }
        }
    }

    @ViewBuilder
    var addScheduleSheet: some View {
        NavigationStack {
            List {
                Group {
                    Button {
                        activeSheet = .textImportSheet
                    } label: {
                        Label("Impor Teks", systemImage: "character")
                    }
                    Button {
                        activeSheet = nil
                        appGlobal.showImportSheet = true
                    } label: {
                        Label("Impor File", systemImage: "text.document")
                    }
                    Button {
                        activeSheet = .manualAddSheet
                    } label: {
                        Label("Manual", systemImage: "plus.circle")
                    }
                }
                .foregroundStyle(.white)
            }
            .navigationTitle("New Shift")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, -36)  // this is cancer I know
        }
        .presentationDetents([.height(contentHeight)])
        .presentationDragIndicator(.visible)
    }

    @ViewBuilder
    private var textImportSheet: some View {
        NavigationView {
            VStack {
                Form {
                    TextEditor(text: $textImportText)
                        .onAppear {
                            textImportText.removeAll()
                        }
                }
            }
            .navigationBarTitle("Impor Teks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Batal") {
                        activeSheet = nil
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Selesai") {
                        activeSheet = nil
                        let temp = TextToScheduleItemsParser(textImportText)
                        let res = temp.parse()
                        let filteredSchedules = res.filter { $0.employeeName == userdata.username }
                        if filteredSchedules.isEmpty {
                            scheduleBuffer = res
                            scheduleController.namesInFileImport = Set(
                                res.map {
                                    return $0.employeeName
                                })
                            scheduleController.showPickName = true
                            return
                        }
                        for schedule in filteredSchedules {
                            schedule.employeeName = userdata.username
                            scheduleController.insert(schedule)
                        }
                    }
                }
            }
        }
    }

}

struct home_Previews: PreviewProvider {

    static var previews: some View {
        EnvironmentalTemp {
            home(schedule: .empty, scheduleBuffer: .constant([]))
        }
    }
}
