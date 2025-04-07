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
}



struct ScheduleDetailBottomSheet: View {
    
    var schedule: ScheduleItemData
    @Binding var isPresented: Bool
    
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

    init (sheetControl isPresented: Binding<Bool>, schedule: ScheduleItemData) {
        self.schedule = schedule
        self._isPresented = isPresented
        self.tempSchedule = schedule
        
    
    }
    
    var body: some View {
        VStack {
            
            HStack(alignment: .top) {
                Button {
                    isPresented = false
                } label: {
                    Text("Cancel")
                }
                Spacer()
                Button {
                    if startHour < endHour || startHour == endHour && startMinute < endMinute {
                        isPresented = false
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
                        
            Form {
                TimePicker(label: "Starts", hour: $startHour, minute: $startMinute)
                    
                TimePicker(label: "Ends", hour: $endHour, minute: $endMinute)
                
                LabeledContent  {
                    TextField(text: $tempSchedule.location, prompt: Text("Empty")) {
                        Text("Location")
                    }
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.trailing)
                } label:  {
                    Text("Location")
                }
                
                LabeledContent  {
                    TextField(text: $tempSchedule.message, prompt: Text("Empty")) {
                        Text("Message")
                    }
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.trailing)
                } label:  {
                    Text("Message")
                }
                
                MenuPicker(label: "Alert", selectedOption: $menuOption)
                
            }.frame(minHeight: 550)
            
            Form {
                Button {
                    isPresented = false
                    removeSchedule = true
                } label: {
                    HStack{
                        Spacer()
                        Text("Delete Schedule")
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
                
            }
            Spacer()
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
                    schedules.update(target: tempSchedule)
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
        .alert("error", isPresented: $showAlert) {
        } message: {
            Text("Shift awal kamu lebih besar dari shift akhirnya")
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
