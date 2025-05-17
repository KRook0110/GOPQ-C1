//
//  ScheduleList.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ScheduleList: View {
    
    @Environment(CSVController.self) var csvController
    @Environment(ScheduleController.self) var schedules
    @Environment(UserData.self) var userdata
    @Environment(AppGlobal.self) var appGlobal
    
    @State private var selectionMode = false
    @State private var selectedItems = Set<UUID>()
    
    var body: some View {
        if schedules.data.isEmpty {
            Spacer()
            Button {
                appGlobal.showImportSheet = true
            } label: {
                VStack (spacing: 12){
                    ImportScheduleListButton()
                        .frame(width: 30)
                    Text("Silahkan Masukkan Jadwal Anda")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                        .frame(width: 200)
                        .multilineTextAlignment(.center)
                }.padding(.init(top: 16, leading: 16, bottom: 12, trailing: 16))
                    .background(.darkGray)
                    .cornerRadius(20)
            }
            Spacer()
        }
        else {
            VStack {
                HStack {
                    if selectionMode {
                        Button(action: {
                            selectionMode = false
                            selectedItems.removeAll()
                        }) {
                            Text("Batal")
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        Text("\(selectedItems.count) Terpilih")
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button(action: {
                            deleteSelectedItems()
                        }) {
                            Text("Hapus")
                                .foregroundColor(.red)
                        }
                        .disabled(selectedItems.isEmpty)
                    } else {
                        Spacer()
                        
                        Button(action: {
                            selectionMode = true
                        }) {
                            Text("Pilih")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
                
                List {
                    ForEach(schedules.data, id:\.id) { schedule in
                        ScheduleItemRow(
                            schedule: schedule,
                            isSelected: selectedItems.contains(schedule.id),
                            selectionMode: selectionMode,
                            onTap: {
                                toggleSelection(schedule.id)
                            }
                        )
                    }
                    .onDelete(perform: selectionMode ? nil : deleteSchedules)
                }
                .listStyle(.plain)
                
                if selectionMode {
                    HStack {
                        Button(action: {
                            if selectedItems.count == schedules.data.count {
                                // Deselect all
                                selectedItems.removeAll()
                            } else {
                                // Select all
                                selectedItems = Set(schedules.data.map { $0.id })
                            }
                        }) {
                            Text(selectedItems.count == schedules.data.count ? "Batal Pilih Semua" : "Pilih Semua")
                                .foregroundColor(.blue)
                                .padding()
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .background(Color.black)
                }
            }
        }
    }
    
    func toggleSelection(_ id: UUID) {
        if selectionMode {
            if selectedItems.contains(id) {
                selectedItems.remove(id)
            } else {
                selectedItems.insert(id)
            }
        }
    }
    
    func deleteSelectedItems() {
        for id in selectedItems {
            schedules.remove(id: id)
        }
        schedules.saveToSwiftData()
        selectedItems.removeAll()
        selectionMode = false
    }
    
    func deleteSchedules(at offsets: IndexSet) {
        for index in offsets {
            let scheduleToDelete = schedules.data[index]
            schedules.remove(id: scheduleToDelete.id)
        }
        schedules.saveToSwiftData()
    }
}

struct ScheduleItemRow: View {
    let schedule: ScheduleItemData
    let isSelected: Bool
    let selectionMode: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            if selectionMode {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                    .font(.system(size: 22))
                    .padding(.leading, 12)
                    .animation(.spring(), value: isSelected)
            }
            
            VStack(spacing: 0) {
                ScheduleItem(schedule: schedule)
                    .padding(16)
                
                BorderLine()
            }
            .contentShape(Rectangle())
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .listRowInsets(.init())
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}
