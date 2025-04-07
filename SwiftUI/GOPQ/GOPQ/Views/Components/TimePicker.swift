//
//  TimePicker.swift
//  GOPQ
//
//  Created by Shawn Andrew on 05/04/25.
//
import SwiftUI


//struct TimePicker: View {
//    @Binding var hour: Int;
//    @Binding var minute: Int
//    
//    private let  minHour = 0
//    private let  maxHour = 23
//    private let  minMinute = 0
//    private let  maxMinute = 59
//    
//    var body: some View {
//        HStack {
//            Picker("Hour Picker",selection: $hour) {
//                ForEach(minHour...maxHour, id: \.self) { hour in
//                    Text("\(hour)")
//                        .foregroundStyle(.white)
//                }
//            }
//            Text(":")
//                .foregroundStyle(.white)
//            Picker("Minute Picker",selection: $minute) {
//                ForEach(minMinute...maxMinute, id: \.self) { min in
//                    Text("\(min)")
//                        .foregroundStyle(.white)
//                }
//            }
//        }
//        .pickerStyle(.wheel)
//        .frame(width: 200)
//    }
//}

struct TimePicker: View {
    let label: String
    @Binding var hour: Int
    @Binding var minute: Int
    @State private var isPickerVisible: Bool = false
    
    var body: some View {
        VStack( spacing: 0) {
            LabeledContent {
                Button(action: {
                    withAnimation {
                        isPickerVisible.toggle()
                    }
                }) {
                    Text(String(format: "%02d:%02d", hour, minute))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.trailing)
                        .frame(minWidth: 60, alignment: .trailing)
                }
                .buttonStyle(.plain)
            } label: {
                Text(label)
            }
            
            if isPickerVisible {
                HStack(spacing: 0) {
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        HStack(spacing: 0) {
                            // Hour picker
                            Picker("", selection: $hour) {
                                ForEach(0..<24, id: \.self) { hour in
                                    Text(String(format: "%02d", hour)).tag(hour)
                                }
                            }
                            .pickerStyle(.wheel)
                            .clipped()
                            
                            Text(":")
                                .padding(.horizontal, 2)
                            
                            // Minute picker
                            Picker("", selection: $minute) {
                                ForEach(0..<60, id: \.self) { minute in
                                    Text(String(format: "%02d", minute)).tag(minute)
                                }
                            }
                            .pickerStyle(.wheel)
                            .clipped()
                        }
                        .background(.clear)
                        .cornerRadius(10)
                        
                        Button("Done") {
                            withAnimation {
                                isPickerVisible = false
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.vertical, 8)
                }
                .transition(.opacity)
            }
        }
    }
}
