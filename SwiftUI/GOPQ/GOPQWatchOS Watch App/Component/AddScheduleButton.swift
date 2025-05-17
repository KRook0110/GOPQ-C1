//
//  AddScheduleButton.swift
//  GOPQWatchOS Watch App
//
//  Created by Dicky Dharma Susanto on 15/05/25.
//

import SwiftUI

struct AddScheduleButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.blue))
                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}
