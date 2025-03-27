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

fileprivate struct NavigationBar: View {
    @Environment(ObservableScheduleList.self) var schedules
    @Binding var isPresented: Bool
    var buffer: ScheduleItemData
    var index: Int
    
    init (_ isPresented: Binding<Bool>, buffer: ScheduleItemData, index: Int) {
        self._isPresented = isPresented
        self.index = index
        self.buffer = buffer
    }
    
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
                schedules.replace(with: buffer, at: index)
                
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
    
    var index: Int
    @Binding var isPresented: Bool
    @State var tempSchedule: ScheduleItemData = ScheduleItemData(
                    startTimeHour: 8,
                    startTimeMin: 10,
                    endTimeHour: 15,
                    endTimeMin: 20,
                    location: "Lmao",
                    message: "Hello Hi",
                    soundName: "System.something"
                )

    
    @Environment(ObservableScheduleList.self ) var schedules
    
    @State private var pickerOption: PickerOptions = .start
    
    init (sheetControl isPresented: Binding<Bool>, index: Int) {
        self.index = index
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack {
            NavigationBar($isPresented, buffer: tempSchedule, index: index)
            
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
            Spacer()
        }
        .onAppear {
            tempSchedule = schedules.data[index]
        }
    }
}


fileprivate var schedules : [ScheduleItemData] = [
    ScheduleItemData(
        startTimeHour: 10,
        startTimeMin: 20,
        endTimeHour: 13,
        endTimeMin: 10,
        location: "Lobby 1",
        message: "Hi hello",
        soundName: "System.something"
    ),
    ScheduleItemData(
        startTimeHour: 15,
        startTimeMin: 20,
        endTimeHour: 19,
        endTimeMin: 20,
        location: "Pantry",
        message: "Hello Hi",
        soundName: "System.something"
    ),
    ScheduleItemData(
        startTimeHour: 8,
        startTimeMin: 10,
        endTimeHour: 15,
        endTimeMin: 20,
        location: "Pantry",
        message: "Hello Hi",
        soundName: "System.something"
    )
]

#Preview {
    ZStack {
        Rectangle()
            .fill(Color("DarkGray"))
            .ignoresSafeArea()
        ScheduleDetailBottomSheet(sheetControl: .constant(true), index: 0 )
            .environment(ObservableScheduleList(schedules))
    }
}
