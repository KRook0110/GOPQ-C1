//
//  StartTimePicker.swift
//  GOPQWatchOS Watch App
//
//  Created by Dicky Dharma Susanto on 17/05/25.
//

import SwiftUI

struct StartTimePicker: View {
    @Binding var startTime: Date
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Waktu Mulai")
                .font(.headline)
                .padding(.top)
            
            DatePicker(
                "",
                selection: $startTime,
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
