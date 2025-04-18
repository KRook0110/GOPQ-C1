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
                        .font(.body)
                        .foregroundColor(.white)
                    Text(userdata.username)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Text(Date.now.formatted(date: .complete, time: .omitted))
                        .foregroundColor(.gray)
                        .font(.body)
                }.padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScheduleList()
                Spacer()
                HStack{
                    Spacer()
                    Button {showAddScheduleSheets = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 35))
                            .foregroundColor(.blue)
                            .padding(25)
                    }
                    .sheet(isPresented: $showAddScheduleSheets) {
                        AddScheduleSheets(sheetControl: $showAddScheduleSheets, schedule: .empty)
                    }
                }
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

