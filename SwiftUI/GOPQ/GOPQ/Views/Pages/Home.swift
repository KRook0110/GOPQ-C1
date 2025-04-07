//
//  home.swift
//  test
//
//  Created by Yehezkiel Joseph Widianto on 26/03/25.
//

import SwiftUI


struct home: View {
    
    @Environment(UserData.self) private var userdata
    var body: some View {
        ZStack{
            
            Color.black.ignoresSafeArea()
            VStack {
                NavigationBar()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Selamat pagi,")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text(userdata.username)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Text("Jumat, 21 Maret 2025")
                        .foregroundColor(.gray)
                }.padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    ScheduleList()
                
                Spacer()
                
            }
        }
    }
}

struct home_Previews: PreviewProvider {
    
    static var previews: some View {
        EnvironmentalTemp {
            home()
        }
    }
}

