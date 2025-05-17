//
//  EndTimePicker.swift
//  GOPQWatchOS Watch App
//
//  Created by Dicky Dharma Susanto on 17/05/25.
//

import SwiftUI

struct EndTimePicker: View {
    @Binding var endTime: Date
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Waktu Selesai")
                .font(.headline)
                .padding(.top)
            
            DatePicker(
                "",
                selection: $endTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .frame(height: 100)
            
            Button("Konfirmasi") {
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationBarHidden(true)
    }
}

