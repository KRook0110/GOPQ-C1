//
//  dashboard.swift
//  test
//
//  Created by Yehezkiel Joseph Widianto on 26/03/25.
//

import SwiftUI

struct dashboard: View {
    
    @State var showMapSheet: Bool = false
    @State var showImportSheet: Bool = false
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var csvController: CSVController
    
    var body: some View {
        VStack {
            
            NavigationBar(showMapSheet:$showMapSheet, showImportSheet: $showImportSheet)
            
            VStack(alignment: .leading, spacing: 4){
                Text("Selamat pagi,")
                    .font(.title2)
                    .foregroundColor(.white)
                Text(userData.userName)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                Text(Date.now.formatted(date: .complete, time: .omitted))
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
        .onChange(of: csvController.schedules) { [oldValue = csvController.schedules] newValue in
            print("Schedules updated: \(newValue.count) items")
            print("Changes: \(newValue.difference(from: oldValue))")
        }
    }
}
//
//struct dashboard_Previews: PreviewProvider {
//    static var previews: some View {
//        dashboard()
//    }
//}
