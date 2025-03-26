//
//  home.swift
//  test
//
//  Created by Yehezkiel Joseph Widianto on 26/03/25.
//

import SwiftUI

struct Schedule: Identifiable {
    let id = UUID()
    let time: String
    let location: String
}

struct home: View {
    
    @State private var showMapSheet = false
    
    let schedules = [
        Schedule(time: "07:00 - 12:00", location: "Lobby 1"),
        Schedule(time: "13:00 - 15:00", location: "Lobby 2"),
        Schedule(time: "16:00 - 18:00", location: "Lobby 1")
    ]
    
    var body: some View {
        ZStack{
            
            Color.black.ignoresSafeArea()
            VStack {
                
                HStack {
                    Image("gopq")
                    Spacer()
                    HStack(spacing: 16) {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(.blue)
                            .font(.system(size: 30))
                        
                        Button{showMapSheet = true} label:{
                            Label("", systemImage: "map").foregroundColor(.blue)
                                .font(.system(size: 30))
                        }
                    }
                }.padding(EdgeInsets(top:0, leading:30, bottom:15, trailing: 30))
                    
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
                    }.padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack{
                        Divider().background()
                        ForEach(schedules){
                            schedule in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(schedule.time)
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.white)
                                    Text(schedule.location)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text("Edit")
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                            .padding()
                            .background(Color.black)
                            Divider().background()
                            
                        }
                        Spacer()
                    }
                }.sheet(isPresented: $showMapSheet) {
                    MapSheet()
                        .presentationBackground(.clear)
                        .background(.clear)
                }
            }
        }
    }

    
    
struct home_Previews: PreviewProvider {
    static var previews: some View {
        home()
    }
}
