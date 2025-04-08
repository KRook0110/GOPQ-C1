//
//  ImportScheduleListButton.swift
//  GOPQ
//
//  Created by Shawn Andrew on 05/04/25.
//


import SwiftUI
import UniformTypeIdentifiers

struct ImportScheduleListButton: View {
    @State var showImportSheet: Bool = false
    @Environment(CSVController.self) var csvController
    @Environment(ScheduleController.self) var scheduleController
    @Environment(UserData.self) var userdata
    
    var body: some View {
        Button {
            showImportSheet = true
        } label: {
            Image(systemName: "square.and.arrow.down")
                .resizable()
                .font(.system(size: 35))
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
            scheduleController.set( csvController.handleFileImport(for: result), name: userdata.username)
        }
    }
}
