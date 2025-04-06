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
    @Environment(UserDataController.self) var userData
    
    var body: some View {
        VStack {
    
            NavigationBar()
            
            VStack(alignment: .leading, spacing: 4){
                Text("Selamat pagi,")
                    .font(.title2)
                    .foregroundColor(.white)
                Text(userData.username)
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
    }
}

struct dashboard_Previews: PreviewProvider {
    static var previews: some View {
        
        dashboard()
    }
}
