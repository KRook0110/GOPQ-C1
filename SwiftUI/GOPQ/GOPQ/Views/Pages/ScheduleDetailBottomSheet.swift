//
//  ScheduleDetailBottomSheet.swift
//  GOPQ
//
//  Created by Shawn Andrew on 26/03/25.
//

import SwiftUI

enum PickerOptions {
    case start
    case end
    case none
}

struct ScheduleDetailBottomSheet: View {
    var schedule: ScheduleItemData
    @Binding var isPresented: Bool

    enum Fields {
        case location
        case message
    }

    @FocusState private var focusInput: Fields?
    @FocusState private var isFocusedLocation: Bool
    @FocusState private var isFocusedMessage: Bool

    @State private var tempSchedule: ScheduleItemData
    @Environment(ScheduleController.self) private var schedules
    @State private var pickerOption: PickerOptions = .start
    @State private var removeSchedule: Bool = false
    @State private var saveSchedule: Bool = false

    @State private var startHour: Int = 0
    @State private var startMinute: Int = 0
    @State private var endHour: Int = 0
    @State private var endMinute: Int = 0
    @State private var showAlert: Bool = false
    @State private var menuOption: MenuOption = .none
    

    init(sheetControl isPresented: Binding<Bool>, schedule: ScheduleItemData) {
        self.schedule = schedule
        self._isPresented = isPresented
        self._tempSchedule = State(initialValue: schedule)
    }

    var body: some View {
        VStack {
            HStack {
                Button { isPresented = false } label: {
                    Text("Cancel")
                }
                Spacer()
                Button {
                    if startHour < endHour || (startHour == endHour && startMinute < endMinute) {
                        isPresented = false
                        saveSchedule = true
                    } else {
                        showAlert = true
                    }
                } label: {
                    Text("Save")
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)

            ScrollView {
                VStack(spacing: 0) {
                    TimePicker(label: "Starts", id: .start, activePicker: $pickerOption, hour: $startHour, minute: $startMinute)
                        .padding()
                        .background(.darkGray)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 15,
                                topTrailingRadius: 15
                            )
                        )
                    Divider().background(.darkGray)

                    TimePicker(label: "Ends", id: .end, activePicker: $pickerOption, hour: $endHour, minute: $endMinute)
                        .padding()
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
                    }.onTapGesture {
                        isFocusedLocation = true
                    }
                    .padding()
                    .background(.darkGray)
                    Divider().background(.darkGray)

                    LabeledContent {
                        TextField(text: $tempSchedule.message, prompt: Text("Empty")) {
                            Text("Message")
                        }
                        .focused($isFocusedMessage)
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.trailing)
                    } label: {
                        Text("Message")
                    }
                    .onTapGesture {
                        isFocusedMessage = true
                    }
                    .padding()
                    .background(.darkGray)
                    Divider().background(.darkGray)
                    
                    MenuPicker(label: "Alert", selectedOption: $menuOption)
                        .padding()
                        .background(.darkGray)
                        .clipShape(
                            .rect(
                                bottomLeadingRadius: 15,
                                bottomTrailingRadius: 15
                            )
                        )
                        .onChange(of: menuOption) {
                            tempSchedule.alertOffset = menuOption.minutes
                        }

                    Button(role: .destructive) {
                        isPresented = false
                        removeSchedule = true
                    } label: {
                        Text("Delete Schedule")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.red)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
            .simultaneousGesture(
                TapGesture().onEnded {
                    focusInput = nil
                }
            )

            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .onDisappear {
            if removeSchedule {
                schedules.remove(id: schedule.id)
            }
            if saveSchedule {
                tempSchedule.startTime = makeTime(hour: startHour, min: startMinute)
                tempSchedule.endTime = makeTime(hour: endHour, min: endMinute)
                schedules.update(target: tempSchedule)
            }
        }
        .onAppear {
            let start = Calendar.current.dateComponents([.hour, .minute], from: schedule.startTime)
            let end = Calendar.current.dateComponents([.hour, .minute], from: schedule.endTime)

            startHour = start.hour ?? 0
            startMinute = start.minute ?? 0
            endHour = end.hour ?? 0
            endMinute = end.minute ?? 0
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
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
            ScheduleDetailBottomSheet(sheetControl: .constant(true), schedule: ScheduleItemData(
                employeeName: "John Doe",
                startTime: makeTime(hour: 10, min: 20),
                endTime: makeTime(hour: 20, min: 30),
                location: "Lobby 1",
                message: "Hi hello",
                soundName: "System.something"
            ) )}
    }
}
