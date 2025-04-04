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
                    .frame(width: 35)

                Button { showMapSheet = true } label: {
                    Image(systemName: "map.fill")
                        .resizable()
                        .font(.system(size: 35))
                        .foregroundColor(.blue)
                        .frame(width: 30, height: 35)
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

struct ImportScheduleListButton: View {
    @State var showImportSheet: Bool = false
    @Environment(CSVController.self) var csvController
    @Environment(ScheduleController.self) var scheduleController
    
    var body: some View {
        Button {
            showImportSheet = true
        } label: {
            Image(systemName: "square.and.arrow.down")
                .resizable()
                .foregroundColor(.blue)
                .aspectRatio(contentMode: .fit)
        }
        .fileImporter(
            isPresented: $showImportSheet,
            allowedContentTypes: [
                UTType.commaSeparatedText,
                UTType(filenameExtension: "csv")!
            ]
        ) { result in
            scheduleController.set( csvController.handleFileImport(for: result))
        }
    }
}
