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

fileprivate struct BottomSheetNavigationBar: View {
    @Environment(ScheduleController.self) var schedules
    @Binding var isPresented: Bool
    @Binding var saveSchedule: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Button {
                isPresented = false
            } label: {
                Text("Cancel")
            }
            Spacer()
            Button {
                isPresented = false
                saveSchedule = true
            } label: {
                Text("Save")
            }
        }
        .padding(20)
    }
}

fileprivate struct TimePicker: View {
    @Binding var hour: Int
    @Binding var minute : Int
    
    private let  minHour = 0
    private let  maxHour = 23
    private let  minMinute = 0
    private let  maxMinute = 23
    
    var body: some View {
        HStack {
            Picker("Hour Picker",selection: $hour) {
                ForEach(minHour...maxHour, id: \.self) { hour in
                    Text("\(hour)")
                        .foregroundStyle(.white)
                }
            }
            Text(":")
                .foregroundStyle(.white)
            Picker("Minute Picker",selection: $minute) {
                ForEach(minHour...maxHour, id: \.self) { hour in
                    Text("\(hour)")
                        .foregroundStyle(.white)
                }
            }
        }
        .pickerStyle(.wheel)
        .frame(width: 200)
    }
}


struct ScheduleDetailBottomSheet: View {
    
    var schedule: ScheduleItemData
    @Binding var isPresented: Bool
    
    @State private var tempSchedule: ScheduleItemData
    @Environment(ScheduleController.self ) private var schedules
    @State private var pickerOption: PickerOptions = .start
    @State private var removeSchedule: Bool = false
    @State private var saveSchedule: Bool = false
    
    init (sheetControl isPresented: Binding<Bool>, schedule: ScheduleItemData) {
        self.schedule = schedule
        self._isPresented = isPresented
        self.tempSchedule = schedule
    }
    
    var body: some View {
        VStack {
            BottomSheetNavigationBar(isPresented: $isPresented, saveSchedule: $saveSchedule)
            Picker("Start or End", selection: $pickerOption) {
                Text("Start").tag(PickerOptions.start)
                Text("End").tag(PickerOptions.end)
            }
            .pickerStyle(.segmented)
            .frame(width: 200)
            .preferredColorScheme(.dark)
            
            switch pickerOption {
            case .start:
                TimePicker(hour: $tempSchedule.startTimeHour, minute: $tempSchedule.startTimeMin)
            case .end:
                TimePicker(hour: $tempSchedule.endTimeHour, minute: $tempSchedule.endTimeMin)
            }
            
            Form {
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
            }
            
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
        }
        .onDisappear {
            if removeSchedule {
                withAnimation(.easeInOut) {
                    schedules.remove(id: schedule.id)
                }
            }
            if saveSchedule {
                withAnimation(.easeInOut)  {
                    schedules.update(target: tempSchedule)
                }
            }
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
                startTimeHour: 10,
                startTimeMin: 20,
                endTimeHour: 13,
                endTimeMin: 10,
                location: "Lobby 1",
                message: "Hi hello",
                soundName: "System.something"
            ) )}
    }
}
