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
    @State private var pickerOption: PickerOptions = .start
    @State private var removeSchedule: Bool = false
    @State private var saveSchedule: Bool = false
    
    @State private var startHour: Int = 0
    @State private var startMinute: Int = 0
    @State private var endHour: Int = 0
    @State private var endMinute: Int = 0
    @State private var showAlert: Bool = false
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
                    Text("Cancel")
                }
                Spacer()
                Button {
                    if startHour < endHour || startHour == endHour && startMinute < endMinute {
                        showAddScheduleSheets = false
                        saveSchedule = true
                    }
                    else {
                        showAlert = true
                    }
                } label: {
                    Text("Save")
                }
            }
            .padding(20)

            ScrollView {
                VStack(spacing: 0) {
                    TimePicker(label: "Starts", id: .start, activePicker: $pickerOption, hour: $startHour, minute: $startMinute).padding()
                        .background(.darkGray)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 15,
                                topTrailingRadius: 15
                            )
                        )
                    Divider().background(.darkGray)

                    
                    TimePicker(label: "Ends", id: .end, activePicker: $pickerOption, hour: $endHour, minute: $endMinute).padding()
                        .background(.darkGray)
                    Divider().background(.darkGray)

                    
                    LabeledContent {
                        TextField(text: $tempSchedule.location, prompt: Text("Empty")) {
                            Text("Location")
                        }
                        .focused($isFocusedLocation)
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.trailing)
                    } label: {
                        Text("Location")
                    }.padding()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isFocusedLocation = true
                        }
                        .background(.darkGray)
                    Divider().background(.darkGray)

                    
                    LabeledContent {
                        TextField(text: $tempSchedule.message, prompt: Text("Empty")) {
                            Text("Message")
                        }.focused($isFocusedMessage)
                            .foregroundStyle(.white.opacity(0.7))
                            .multilineTextAlignment(.trailing)
                    } label: {
                        Text("Message")
                    }.contentShape(Rectangle())
                        .onTapGesture{
                            isFocusedMessage = true
                        }
                    .padding()
                    .background(.darkGray)
                    Divider().background(.darkGray)

                    
                    MenuPicker(label: "Alert", selectedOption: $menuOption).padding()
                        .background(.darkGray)
                        .clipShape(
                            .rect(
                                bottomLeadingRadius: 15,
                                bottomTrailingRadius: 15
                            )
                        )
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
            .alert("Error", isPresented: $showAlert) {
            } message: {
                Text("Waktu mulai harus lebih awal dari waktu selesai.")
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

