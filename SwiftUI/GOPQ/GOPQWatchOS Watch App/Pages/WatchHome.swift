//
//  WatchHome.swift
//  GOPQWatchOS Watch App
//
//  Created by Dicky Dharma Susanto on 03/05/25.
//

import SwiftUI

struct WatchHome: View {
    
    @StateObject private var viewModel = WatchScheduleViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @State private var isAddSchedulePresented = false
    
    var deleteSchedule: (IndexSet) -> Void
    
    var body: some View {
        NavigationStack {
            VStack{
                if !viewModel.isConnected {
                    Text(viewModel.connectionStatus)
                        .font(.caption2)
                        .padding(6)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange.opacity(0.3))
                        .cornerRadius(4)
                }
                if viewModel.schedules.isEmpty {
                    EmptyScheduleView {
                        isAddSchedulePresented = true
                    }
                } else {
                    ScheduleListView(
                        schedules: $viewModel.schedules,
                        deleteSchedule: { indexSet in
                            // Handle deletion if needed
                        },
                        navigateToAddSchedule: {
                            isAddSchedulePresented = true
                        }
                    )
                }
            }
            .navigationTitle("GOPQ")
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                viewModel.refreshSchedules()
            }
        }
        .fullScreenCover(isPresented: $isAddSchedulePresented) {
            AddScheduleView(viewModel: viewModel)
        }
    }
}
