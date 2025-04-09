//
//  AddScheduleSheets.swift
//  GOPQ
//
//  Created by Yehezkiel Joseph Widianto on 07/04/25.
//

import SwiftUI

struct AddScheduleSheets: View {
    
    enum Fields {
        case location
        case message
    }
    
    var schedule: ScheduleItemData
    @Binding var showAddScheduleSheets: Bool
    
    @State private var tempSchedule: ScheduleItemData
    @Environment(ScheduleController.self ) private var schedules
    @State private var pickerOption: PickerOptions = .none
    @State private var removeSchedule: Bool = false
    @State private var saveSchedule: Bool = false
    
    @State private var startHour: Int = 0
    @State private var startMinute: Int = 0
    @State private var endHour: Int = 0
    @State private var endMinute: Int = 0
    @State private var showAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var selectedTime: Date = Date()
    @State private var menuOption: MenuOption = .none
    @State private var activePicker: PickerOptions = .none
    
    @FocusState private var isFocusedLocation: Bool
    @FocusState private var isFocusedMessage: Bool
    @FocusState private var focusInput: Fields?
    
    init (sheetControl showAddScheduleSheets: Binding<Bool>, schedule: ScheduleItemData) {
        self.schedule = .empty
        self._showAddScheduleSheets = showAddScheduleSheets
        self.tempSchedule = .empty
        
    }
    
    var body: some View {
        VStack {
            
            HStack(alignment: .top) {
                Button {
                    showAddScheduleSheets = false
                } label: {
                    Text("Batal")
                }
                Spacer()
                Button {
                    if startHour > endHour || startHour == endHour && startMinute >= endMinute {
                        errorMessage = "Waktu mulai harus lebih awal dari waktu selesai."
                        showAlert = true
                    } else if tempSchedule.location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        errorMessage = "Lokasi harus diisi."
                        showAlert = true
                    }
                    else {
                        showAddScheduleSheets = false
                        saveSchedule = true
                    }
                } label: {
                    Text("Simpan")
                }
            }
            .padding(20)
            
            ScrollView {
                VStack(spacing: 20) {
                    TimePicker(label: "Mulai", id: .start, activePicker: $pickerOption, hour: $startHour, minute: $startMinute).padding()
                        .background(.darkGray)
                        .contentShape(Rectangle())
                        .cornerRadius(15)
                        .onChange(of: pickerOption) { oldValue, newValue in
                            if newValue == .start || newValue == .end {
                                isFocusedLocation = false
                                isFocusedMessage = false
                                focusInput = nil
                            }
                        }
                    //                    Divider().background(.darkGray)
                    
                    
                    TimePicker(label: "Berakhir", id: .end, activePicker: $pickerOption, hour: $endHour, minute: $endMinute).padding()
                        .background(.darkGray).contentShape(Rectangle())
                        .cornerRadius(15)
                        .onChange(of: pickerOption) { oldValue, newValue in
                            if newValue == .start || newValue == .end {
                                isFocusedLocation = false
                                isFocusedMessage = false
                                focusInput = nil
                            }
                        }
                    //                    Divider().background(.darkGray)
                    
                    
                    VStack (spacing: 0){
                        LabeledContent {
                            TextField(text: $tempSchedule.location, prompt: Text("Kosong")) {
                                Text("Lokasi")
                            }
                            .focused($isFocusedLocation)
                            .foregroundStyle(.white.opacity(0.7))
                            .multilineTextAlignment(.trailing)
                            .onChange(of: isFocusedLocation) { oldValue, newValue in
                                if newValue {
                                    pickerOption = .none
                                }
                            }
                        } label: {
                            Text("Lokasi")
                        }.padding()
                            .contentShape(Rectangle())
                            .background(.darkGray)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 15,
                                    topTrailingRadius: 15
                                )
                            )
                            .onTapGesture {
                                isFocusedLocation = true
                                pickerOption = .none
                            }
                        
                        Divider().background(.darkGray)
                        
                        
                        LabeledContent {
                            TextField(text: $tempSchedule.message, prompt: Text("Kosong")) {
                                Text("Pesan")
                            }.focused($isFocusedMessage)
                                .foregroundStyle(.white.opacity(0.7))
                                .multilineTextAlignment(.trailing)
                        } label: {
                            Text("Pesan")
                        }.contentShape(Rectangle())
                            .onTapGesture{
                                isFocusedMessage = true
                            }
                            .padding()
                            .background(.darkGray)
                        Divider().background(.darkGray)
                        
                        
                        MenuPicker(label: "Pengingat", selectedOption: $menuOption).padding()
                            .background(.darkGray)
                            .clipShape(
                                .rect(
                                    bottomLeadingRadius: 15,
                                    bottomTrailingRadius: 15
                                )
                            )
                    }
                }
                .padding()
            }.simultaneousGesture(
                TapGesture().onEnded {
                    focusInput = nil
                }
            )
        }.preferredColorScheme(.dark)
            .onDisappear {
                if removeSchedule {
                    withAnimation(.easeInOut) {
                        schedules.remove(id: schedule.id)
                    }
                }
                if saveSchedule {
                    tempSchedule.startTime = makeTime(hour: startHour, min: startMinute)
                    tempSchedule.endTime = makeTime(hour: endHour, min: endMinute)
                    withAnimation(.easeInOut)  {
                        schedules.insert(tempSchedule)
                    }
                }
            }
            .onAppear {
                let startTimeCompnents = Calendar.current.dateComponents([.hour, .minute], from: schedule.startTime )
                let endTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: schedule.endTime )
                
                startHour = startTimeCompnents.hour ?? 0
                startMinute = startTimeCompnents.minute ?? 0
                endHour = endTimeComponents.hour ?? 0
                endMinute = endTimeComponents.minute ?? 0
            }
            .alert("Peringatan", isPresented: $showAlert) {
            } message: {
                Text(errorMessage)
            }
        
    }
}

#Preview {
    ZStack {
        Rectangle()
            .fill(Color("ModularBackground"))
            .ignoresSafeArea()
        EnvironmentalTemp {
            AddScheduleSheets(sheetControl: .constant(true), schedule: ScheduleItemData(
                employeeName: "John Doe",
                startTime: makeTime(hour: 10, min: 20),
                endTime: makeTime(hour: 20, min: 30),
                location: "Lobby 1",
                message: "Hi hello",
                soundName: "System.something"
            ) )}
    }
}

