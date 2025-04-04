//
//  CSVController.swift
//  GOPQ
//
//  Created by Dicky Dharma Susanto on 31/03/25.
//

import SwiftUI

class CSVController:ObservableObject{
    
    @Published var content: String = ""
    
    func handleFileImport (for result: Result<URL, Error>){
        switch result {
        case .success(let url):
            print("File loaded: \(url.lastPathComponent)")
            readFile(url)
           
        case .failure(let error):
            print("Error loading file \(error)")
        }
    }
    
    func readFile(_ url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            print("Failed acces resources")
            return
        }
        
        defer { url.stopAccessingSecurityScopedResource() }
        
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            self.content = content
            print("File import suceed:")
            print(content)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
}
