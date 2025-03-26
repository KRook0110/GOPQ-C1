//
//  dashboard.swift
//  test
//
//  Created by Yehezkiel Joseph Widianto on 26/03/25.
//

import SwiftUI

struct dashboard: View {
    var body: some View {
        VStack {
    
            HStack {
                Image("gopq")
                Spacer()
                HStack(spacing: 16) {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(.blue)
                        .font(.system(size: 30))
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.blue)
                        .font(.system(size: 30))
                }
            }
            .padding()
            .background(Color.black)
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Selamat pagi,")
                    .font(.title2)
                    .foregroundColor(.white)
                Text("Dicky Dharma Susanto")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                Text("Jumat, 21 Maret 2025")
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom,100)

            
            Text("Silahkan masukkan jadwal anda")
                .font(.title3)
                .foregroundColor(.white)
                
            
            Image(systemName: "square.and.arrow.down")
                .font(.system(size: 85))
                .foregroundColor(.blue)
                
            
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct dashboard_Previews: PreviewProvider {
    static var previews: some View {
        dashboard()
    }
}
