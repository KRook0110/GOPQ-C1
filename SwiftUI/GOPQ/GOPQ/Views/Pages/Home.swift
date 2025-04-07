//
//  home.swift
//  test
//
//  Created by Yehezkiel Joseph Widianto on 26/03/25.
//

import SwiftUI


struct home: View {
    
    var schedule: ScheduleItemData
    @Environment(UserData.self) private var userdata
    @State var showAddScheduleSheets: Bool = false
    
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
                    Text(Date.now.formatted(date: .complete, time: .omitted))
                        .foregroundColor(.gray)
                }.padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    ScheduleList()
                
                Button {showAddScheduleSheets = true } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .font(.system(size: 35))
                        .foregroundColor(.blue)
                        .frame(width: 30, height: 35)
                        .padding()
                    
                }
                .sheet(isPresented: $showAddScheduleSheets) {
                    AddScheduleSheets(sheetControl: $showAddScheduleSheets, schedule: .empty)
                }
                    
                Spacer()
                
            }
        }
    }
}

struct home_Previews: PreviewProvider {
    
    static var previews: some View {
        EnvironmentalTemp {
            home(schedule: .empty)
        }
    }
}

