//
//  SplashScreen.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 25/03/25.
//

import SwiftUI

struct SplashScreen: View {
    
    enum AlertType: Identifiable {
        case error(String)
        case confirmation(String)
        
        var id: String {
            switch self {
            case .error(let message):
                return "error-\(message)"
            case .confirmation(let message):
                return "confirmation-\(message)"
            }
        }
    }
    
    @Environment(UserData.self) var userdata
    @State private var usernameBuffer: String = ""
    @State private var activeAlert: AlertType? = nil
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            
            VStack {
                Image("gopq")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:50)
                Text("Silahkan Masukkan Nama Lengkap Anda!")
                    .foregroundStyle(.white).padding()
                
                
                TextField("Nama Lengkap", text: $usernameBuffer)
                    .padding(10)
                    .background(.gray)
                    .foregroundColor(.white)
                    .frame(width:200)
                    .cornerRadius(15)
                
                Button {
                    if usernameBuffer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        activeAlert = .error("Nama lengkap harus diisi.")
                    } else {
                        activeAlert = .confirmation("Apakah nama yang Anda masukkan: \(usernameBuffer) sudah benar?")
                    }
                } label: {
                    Text("Konfirmasi")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .frame(width:300)
                        .padding(.top)
                    
                }
            }
            .alert(item: $activeAlert) { alert in
                switch alert {
                case .error(let message):
                    return Alert(
                        title: Text("Peringatan"),
                        message: Text(message),
                        dismissButton: .default(Text("OK"))
                    )
                case .confirmation(let message):
                    return Alert(
                        title: Text("Konfirmasi"),
                        message: Text(message),
                        primaryButton: .default(Text("Simpan")) {
                            userdata.username = usernameBuffer
                        },
                        secondaryButton: .cancel(Text("Batal"))
                    )
                }
            }
        }
    }
}

#Preview {
    EnvironmentalTemp {
        SplashScreen()
    }
}
