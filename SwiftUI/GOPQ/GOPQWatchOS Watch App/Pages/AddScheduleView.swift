//
//  AddScheduleView.swift
//  GOPQWatchOS Watch App
//
//  Created by Dicky Dharma Susanto on 15/05/25.
//

import SwiftUI

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    return formatter
}()

struct AddScheduleView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(3600)
    @State private var location = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSuccess = false
    @State private var isLoading = false
    
    var viewModel: WatchScheduleViewModel
    
    var body: some View {
        NavigationStack{
            Form {
                Section {
                    TextField("Pesan", text: $title)
                        .textContentType(.name)
                }
                Section {
                    NavigationLink(destination: StartTimePicker(startTime: $startTime)) {
                        HStack {
                            Text("Waktu Mulai")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(timeFormatter.string(from: startTime))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    NavigationLink(destination: EndTimePicker(endTime: $endTime)) {
                        HStack {
                            Text("Waktu Selesai")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(timeFormatter.string(from: endTime))
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                // Location input
                Section {
                    TextField("Lokasi", text: $location)
                        .textContentType(.location)
                }
                
                // Add button
                Section{
                    Button(action: addSchedule) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else {
                            Text("Tambah")
                                .font(.headline)
                        }
                    }
                    .disabled(isLoading || location.isEmpty || endTime <= startTime)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Tambah Jadwal")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isSuccess ? "Success" : "Error", isPresented: $showAlert) {
                Button("OK") {
                    if isSuccess {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func addSchedule() {
        isLoading = true
        
        viewModel.addCalendarEvent(startTime: startTime, endTime: endTime, location: location) { success, message in
            isLoading = false
            isSuccess = success
            alertMessage = message
            showAlert = true
            
            if success {
                viewModel.refreshSchedules()
            }
        }
    }
}

