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
    @State private var pickerOption: PickerOptions = .none
    @State private var removeSchedule: Bool = false
    @State private var saveSchedule: Bool = false
    @State private var scheduleDuration: Int = 120 * 60

    @State private var startHour: Int = 0
    @State private var startMinute: Int = 0
    @State private var endHour: Int = 0
    @State private var endMinute: Int = 0
    @State private var showAlert: Bool = false
    @State private var menuOption: MenuOption = .none
    @State private var errorMessage: String = ""
    private var startTimeList: [Int] = []
    private var endTimeList: [Int]  = []
    

    init(sheetControl isPresented: Binding<Bool>, schedule: ScheduleItemData) {
        self.schedule = schedule
        self._isPresented = isPresented
        self._tempSchedule = State(initialValue: schedule)
        
        let startTimeDate = makeTime(hour: startHour, min: startMinute)
        let endTimeDate = makeTime(hour: endHour, min: endMinute)
        scheduleDuration = Int(endTimeDate.timeIntervalSince(startTimeDate))
    }
    
    // yes I know moveEndAccordingToStart and change DurationAccordingToEnd will eventually create an infinite loop calling each other but now only god knows how it didn't
    func moveEndAccordingToStart() {
        let startTimeDate = makeTime(hour: startHour, min: startMinute)
        let endTimeDate = startTimeDate.addingTimeInterval(TimeInterval(scheduleDuration))
        
        let startcomponents = Calendar.current.dateComponents([.day, .hour, .minute], from: startTimeDate)
        let endcomponents = Calendar.current.dateComponents([.day, .hour, .minute], from: endTimeDate)
        if startcomponents.day != endcomponents.day {
            endHour = 23
            endMinute = 59
        }
        else {
            endHour = endcomponents.hour ?? 0
            endMinute = endcomponents.minute ?? 0
        }
    }
    
    func changeDurationAccordingToEnd() {
        let startTime = makeTime(hour: startHour, min: startMinute)
        let endTime = makeTime(hour: endHour, min: endMinute)
        scheduleDuration = Int( endTime.timeIntervalSince(startTime))
        if scheduleDuration < 60 {
            startHour = endHour
            startMinute = endMinute - 1
            scheduleDuration = 60
        }
    }


    var body: some View {
        VStack {
            HStack {
                Button { isPresented = false } label: {
                    Text("Batal")
                }
                Spacer()
                Button {
                    if startHour > endHour || startHour == endHour && startMinute > endMinute {
                        errorMessage = "Waktu mulai harus lebih awal dari waktu selesai."
                        showAlert = true
                    } else if tempSchedule.location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        errorMessage = "Lokasi harus diisi."
                        showAlert = true
                    }
                    else {
                        isPresented = false
                        saveSchedule = true
                    }
                } label: {
                    Text("Simpan")
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)

            ScrollView {
                VStack(spacing: 20) {
                    TimePicker(label: "Mulai", id: .start, activePicker: $pickerOption, hour: $startHour, minute: $startMinute)
                        .padding()
                        .background(.darkGray)
                        .onChange(of: [startHour, startMinute] ) {
                            moveEndAccordingToStart()
                        }
                       .cornerRadius(15)
                        .onChange(of: pickerOption) { oldValue, newValue in
                            if newValue == .start || newValue == .end {
                                isFocusedLocation = false
                                isFocusedMessage = false
                                focusInput = nil
                            }
                        }
//                    Divider().background(.darkGray)

                    TimePicker(label: "Berakhir", id: .end, activePicker: $pickerOption, hour: $endHour, minute: $endMinute)
                        .padding()
                        .background(.darkGray)
                        .cornerRadius(15)
                        .onChange(of: pickerOption) { oldValue, newValue in
                            if newValue == .start || newValue == .end {
                                isFocusedLocation = false
                                isFocusedMessage = false
                                focusInput = nil
                            }
                        }
                        .onChange(of: [endHour, endMinute]){
                            changeDurationAccordingToEnd()
                        }
//                    Divider().background(.darkGray)

                    VStack (spacing:0){
                        
                        LabeledContent {
                            TextField(text: $tempSchedule.location, prompt: Text("Kosong")) {
                                Text("Location")
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
                        }.onTapGesture {
                            isFocusedLocation = true
                            pickerOption = .none
                        }
                        .padding()
                        .background(.darkGray)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 15,
                                topTrailingRadius: 15
                            )
                        )
                        
                        Divider().background(.darkGray)
                        
                        LabeledContent {
                            TextField(text: $tempSchedule.message, prompt: Text("Kosong")) {
                                Text("Message")
                            }
                            .focused($isFocusedMessage)
                            .foregroundStyle(.white.opacity(0.7))
                            .multilineTextAlignment(.trailing)
                            .onChange(of: isFocusedMessage) { oldValue, newValue in
                                if newValue {
                                    pickerOption = .none
                                }
                            }
                        } label: {
                            Text("Pesan")
                        }
                        .onTapGesture {
                            isFocusedMessage = true
                            pickerOption = .none
                        }
                        .padding()
                        .background(.darkGray)
                        Divider().background(.darkGray)
                        
                        MenuPicker(label: "Pengingat", selectedOption: $menuOption)
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
                    }

                    Button(role: .destructive) {
                            isPresented = false
                            removeSchedule = true
                    } label: {
                        Text("Hapus Jadwal")
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
            withAnimation {
                if removeSchedule {
                    schedules.remove(id: schedule.id)
                }
                if saveSchedule {
                    tempSchedule.startTime = makeTime(hour: startHour, min: startMinute)
                    tempSchedule.endTime = makeTime(hour: endHour, min: endMinute)
                    schedules.update(target: tempSchedule)
                }
            }
        }
        .onAppear {
            withAnimation {
                let start = Calendar.current.dateComponents([.hour, .minute], from: schedule.startTime)
                let end = Calendar.current.dateComponents([.hour, .minute], from: schedule.endTime)
                
                startHour = start.hour ?? 0
                startMinute = start.minute ?? 0
                endHour = end.hour ?? 0
                endMinute = end.minute ?? 0
            }
        }
        .alert("Peringatan", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
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
