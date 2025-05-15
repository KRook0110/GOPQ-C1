//
//  home.swift
//  test
//
//  Created by Yehezkiel Joseph Widianto on 26/03/25.
//
import SwiftUI

struct home: View {

    var schedule: ScheduleItemData
    @Environment(UserData.self) private var userdata
    @Environment(AppGlobal.self) private var appGlobal
    @State var showManualAddSheets: Bool = false
    @State var showNewShiftSheet: Bool = false
    @State var contentHeight: CGFloat = 200

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
                    showNewShiftSheet = true
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
                .sheet(isPresented: $showManualAddSheets) {
                    AddScheduleSheets(sheetControl: $showManualAddSheets, schedule: .empty)
                }
                .sheet(isPresented: $showNewShiftSheet) {
                    addScheduleSheet
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
                        showNewShiftSheet = false
                    } label: {
                        Label("Text Import", systemImage: "character")
                    }
                    Button {
                        showNewShiftSheet = false
                        appGlobal.showImportSheet = true
                    } label: {
                        Label("File Import", systemImage: "text.document")
                    }
                    Button {
                        showNewShiftSheet = false
                        showManualAddSheets = true
                    } label: {
                        Label("Custom Add", systemImage: "plus.circle")
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
}

struct home_Previews: PreviewProvider {

    static var previews: some View {
        EnvironmentalTemp {
            home(schedule: .empty)
        }
    }
}
