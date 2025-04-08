//
//  SplashScreen.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 25/03/25.
//

import SwiftUI

struct SplashScreen: View {
    @Environment(UserData.self) var userdata
    @State private var usernameBuffer: String = ""
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            
            VStack {
                Image("gopq")
                 
                
                Text("Silahkan Masukkan Nama Lengkap Anda!")
                    .foregroundStyle(.white).padding()
                
                
                TextField("Nama Lengkap", text: $usernameBuffer)
                    .padding(10)
                    .background(.gray)
                    .foregroundColor(.white)
                    .frame(width:200)
                    .cornerRadius(15)
                
                Button {
                    userdata.username = usernameBuffer
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
        }
    }
}

#Preview {
    EnvironmentalTemp {
        SplashScreen()
    }
}
