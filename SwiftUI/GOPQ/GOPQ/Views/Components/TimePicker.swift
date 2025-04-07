//
//  TimePicker.swift
//  GOPQ
//
//  Created by Shawn Andrew on 05/04/25.
//
import SwiftUI

struct TimePicker: View {
    
    let label: String
    let id: PickerOptions
    @Binding var activePicker: PickerOptions
    @Binding var hour: Int
    @Binding var minute: Int
    
    var isPickerVisible: Bool {
        activePicker == id
    }

    var body: some View {
        VStack( spacing: 0) {
            LabeledContent {
                Button(action: {
                    withAnimation {
                        activePicker = (activePicker == id) ? .none : id
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
                        
                    }
                    .padding(.vertical, 8)
                }
                .transition(.opacity)
            }
        }
    }
}
