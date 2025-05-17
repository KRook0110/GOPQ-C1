//
//  EmptyScheduleView.swift
//  GOPQWatchOS Watch App
//
//  Created by Dicky Dharma Susanto on 15/05/25.
//

import SwiftUI

struct EmptyScheduleView: View {
    
    var action: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Text("Jadwal Anda kosong")
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text("Ucapkan: “Hey Siri, buat shift baru di GOPQ”")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            AddScheduleButton(action: action).background(Color.clear)
            Spacer()
        }
        .padding(.top, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
    
}
