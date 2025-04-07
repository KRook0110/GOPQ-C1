//
//  TimePicker.swift
//  GOPQ
//
//  Created by Shawn Andrew on 05/04/25.
//
import SwiftUI


struct TimePicker: View {
    @Binding var hour: Int;
    @Binding var minute: Int
    
    private let  minHour = 0
    private let  maxHour = 23
    private let  minMinute = 0
    private let  maxMinute = 59
    
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
                ForEach(minMinute...maxMinute, id: \.self) { hour in
                    Text("\(hour)")
                        .foregroundStyle(.white)
                }
            }
        }
        .pickerStyle(.wheel)
        .frame(width: 200)
    }
}

