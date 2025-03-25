//
//  SplashScreen.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 25/03/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var nama:String = ""
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            
            VStack {
                Image("gopq")
                    .resizable()
                    .frame(width:90,height:150)
                    
                
                Text("Silahkan Masukkan Nama Lengkap Anda!")
                    .foregroundStyle(.white)
                
                TextField("Username", text: $nama)
                    .padding(10)
                    .background(.gray)
                    .foregroundColor(.white)
                    .frame(width:200)
                    .cornerRadius(15)
                
                Button(action: {
                    print("diklik")
                })
                {
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
    SplashScreen()
}
