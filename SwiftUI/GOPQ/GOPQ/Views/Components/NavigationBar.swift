//
//  Navbar.swift
//  GOPQ
//
//  Created by Yehezkiel Joseph Widianto on 27/03/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct NavigationBar: View {
    
    @State var showMapSheet: Bool = false
    
    
    var body: some View {
        HStack {
            Image("gopq")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 45)
                .padding(.leading, 15)
                .padding(.trailing, 30)
            
            Spacer()
            
            HStack(spacing: 16) {
                
                ImportScheduleListButton()
                    .frame(width: 28)

                Button { showMapSheet = true } label: {
                    Image(systemName: "map.fill")
                        .resizable()
                        .font(.system(size: 35))
                        .foregroundColor(.blue)
                        .frame(width: 25, height: 30)
                }
                .sheet(isPresented: $showMapSheet) {
                    MapSheet()
                        .presentationBackground(.clear)
                        .background(.clear)
                }
            }
        }
        .padding()
        .background(Color.black)
    }
}

#Preview {
    let csvController = CSVController()
    
    EnvironmentalTemp {
        NavigationBar()
    }
}

