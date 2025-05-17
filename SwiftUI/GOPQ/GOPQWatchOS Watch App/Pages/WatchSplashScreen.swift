//
//  WatchSplashScreen.swift
//  GOPQWatchOS Watch App
//
//  Created by Dicky Dharma Susanto on 03/05/25.
//

import SwiftUI

struct WatchSplashScreen: View {
        @Environment(\.modelContext) private var modelContext
        @Environment(UserData.self) private var userData
        
        @State private var username: String = ""
        
        var body: some View {
            VStack {
                Text("GOPQ")
                    .font(.headline)
                
                TextField("Nama Lengkap", text: $username)
                    .textContentType(.username)
                
                Button("Konfirmasi") {
                    if !username.isEmpty {
                        userData.username = username
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }

}
