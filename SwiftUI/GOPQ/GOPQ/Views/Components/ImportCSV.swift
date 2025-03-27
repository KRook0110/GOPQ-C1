//
//  ImportCSV.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 27/03/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ImportCSV: View {
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        Button{
            isPresented.toggle()
        } label: {
            Label("Import", systemImage: "square.and.arrow.down")
        }.fileImporter(isPresented: $isPresented, allowedContentTypes: [UTType.commaSeparatedText]) { result in switch result {
            case .success(let url):
                do {
                    let content = try String(contentsOf: url, encoding: .utf8)
                    print(content)
                } catch {
                    print(error)
                }
            case .failure(let error): print("error loading file \(error)")
            
            }
        }
    }
}

#Preview {
    ImportCSV()
}
